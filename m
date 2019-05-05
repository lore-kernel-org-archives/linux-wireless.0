Return-Path: <SRS0=ua54=TF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BF1C04AAC
	for <linux-wireless@archiver.kernel.org>; Sun,  5 May 2019 15:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3830208C2
	for <linux-wireless@archiver.kernel.org>; Sun,  5 May 2019 15:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfEEPEB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 5 May 2019 11:04:01 -0400
Received: from 0.ictbs.com ([203.137.112.168]:51601 "EHLO 0.ictbs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbfEEPEB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 May 2019 11:04:01 -0400
Received: by hq.local (Postfix, from userid 1000)
        id EDFD06641B; Sun,  5 May 2019 17:03:55 +0200 (CEST)
Date:   Sun, 5 May 2019 17:03:55 +0200
From:   Victor Bravo <1905@spmblk.com>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH RFC] brcmfmac: sanitize DMI strings v2
Message-ID: <20190505150355.3fbng4ny34x255vk@localhost>
References: <20190504162633.ldrz2nqfocg55grb@localhost>
 <cce7604e-2b02-80ed-1df5-6f304cada0cb@broadcom.com>
 <20190504194440.4zcxjrtj2aft3ka4@localhost>
 <16a87149068.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16a87149068.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sanitize DMI strings in brcmfmac driver to make resulting filenames
contain only safe characters. This version replaces all non-printable
characters incl. delete (0-31, 127-255), spaces and slashes with
underscores.

This change breaks backward compatibility, but adds control over strings
passed to firmware loader and compatibility with CONFIG_EXTRA_FIRMWARE
which doesn't support spaces in filenames.

Changes from v1: don't revert fresh commit by someone else

Signed-off-by: Victor Bravo <1905@spmblk.com>

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 7535cb0d4ac0..84571e09b465 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -23,6 +23,14 @@
 /* The DMI data never changes so we can use a static buf for this */
 static char dmi_board_type[128];
 
+/* Array of 128 bits representing 7-bit characters allowed in DMI strings. */
+static unsigned char brcmf_dmi_allowed_chars[] = {
+	0x00, 0x00, 0x00, 0x00, 0xfe, 0x7f, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f
+};
+
+#define BRCMF_DMI_SAFE_CHAR '_'
+
 struct brcmf_dmi_data {
 	u32 chip;
 	u32 chiprev;
@@ -99,6 +107,15 @@ static const struct dmi_system_id dmi_platform_data[] = {
 	{}
 };
 
+void brcmf_dmi_sanitize(char *dst, const unsigned char *allowed, char safe)
+{
+	while (*dst) {
+		if ((*dst < 0) || !(allowed[*dst / 8] & (1 << (*dst % 8))))
+			*dst = safe;
+		dst++;
+	}
+}
+
 void brcmf_dmi_probe(struct brcmf_mp_device *settings, u32 chip, u32 chiprev)
 {
 	const struct dmi_system_id *match;
@@ -126,6 +143,9 @@ void brcmf_dmi_probe(struct brcmf_mp_device *settings, u32 chip, u32 chiprev)
 	if (sys_vendor && product_name) {
 		snprintf(dmi_board_type, sizeof(dmi_board_type), "%s-%s",
 			 sys_vendor, product_name);
+		brcmf_dmi_sanitize(dmi_board_type,
+				   brcmf_dmi_allowed_chars,
+				   BRCMF_DMI_SAFE_CHAR);
 		settings->board_type = dmi_board_type;
 	}
 }
