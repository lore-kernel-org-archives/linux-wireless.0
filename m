Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C58C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 09:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECF30214DA
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 09:27:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECF30214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbeJJQsy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 12:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbeJJQsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 12:48:54 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E53630013B9;
        Wed, 10 Oct 2018 09:27:36 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C403B79A19;
        Wed, 10 Oct 2018 09:27:20 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] brcmfmac: Fix ccode from EFI nvram when necessary
Date:   Wed, 10 Oct 2018 11:27:19 +0200
Message-Id: <20181010092719.368-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 10 Oct 2018 09:27:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In some cases the EFI-var stored nvram contains "ccode=ALL" or "ccode=XV"
to specify "worldwide" compatible settings, but these 2 ccode-s do not work
properly.

I've tested the different known "worldwide" ccode-s used in various nvram
sources with the latest firmwares from linux-firmware for various brcmfmac
models, here is a simplified (*) table with what each setting results in:

ALL: 12-14 disab, U-NII-1, U-NII-2 no-IR/radar, U-NII-3
XV:  12-14 no-IR, disables all 5G channels
XY:  12-13 enab, 14 disab, U-NII-1 enab, U-NII-2 no-IR/radar, U-NII-3 disab
X2:  12-13 no-IR, 14 dis, U-NII-1 no-IR, U-NII-2 no-IR/radar, U-NII-3 no-IR

Where 12,13,14 are 2.4G channels 12-14 and U-NII-1/2/3 are the 3 different
5G channel groups. no-IR is no-Initiate-Radiation, we will never send on
these channels without first having received valid wifi traffic there.

This immediately shows that both ALL and XV are not as worldwide as we want
them to be. ALL causes channels 12 and 13 to not be available and XV causes
all 5GHz channels to not be available. Also ALL unconditionally enables the
U-NII-1 and U-NII-3 5G groups, while we really should be using no-IR for
these.

This commit replace XV and ALL with X2, which allows usage of chan 12-13
and 5G channels, but only after receiving valid wifi traffic there first.

Note that this configure the firmware's channel limits, the kernels own
regulatory restrictions based on e.g. regulatory info received from the
access-point, will be applied on top of this.

This fixes channels 12+13 not working on the Asus T200TA and the Lenovo
Mixx 2 8 and 5G channels not working on the Asus T100HA.

This has been tested on the following models: Acer Iconia Tab8 w1-810,
Acer One 10, Asus T100CHI, Asus T100HA, Asus T100TA, Asus T200TA and a
Lenovo Mixx 2 8.

*) There are some exceptions to this table:
1) On really old firmware e.g. linux-firmware's 2011 brcmfmac4330-sdio.bin
   ALL really means all, unconditionally enabling everything
2) The exact meaning might be influenced by setting the regrev nvram var.
   Specifically using ccode=XV + regrev=1 on brcmfmac43241b4 leads to:
   12-14 no-ir, U-NII-1 no-ir, U-NII-2 no-ir/radar, U-NII-3 no-ir
   But only on the brcmfmac43241b4 and not on e.g. the brcmfmac43340

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index a1dfe75c835f..d1db8874aaa9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -447,6 +447,29 @@ struct brcmf_fw {
 static void brcmf_fw_request_done(const struct firmware *fw, void *ctx);
 
 #ifdef CONFIG_EFI
+/* In some cases the EFI-var stored nvram contains "ccode=ALL" or "ccode=XV"
+ * to specify "worldwide" compatible settings, but these 2 ccode-s do not work
+ * properly. "ccode=ALL" causes channels 12 and 13 to not be available,
+ * "ccode=XV" causes all 5GHz channels to not be available. So we replace both
+ * with "ccode=X2" which allows channels 12+13 and 5Ghz channels in
+ * no-Initiate-Radiation mode. This means that we will never send on these
+ * channels without first having received valid wifi traffic on the channel.
+ */
+static void brcmf_fw_fix_efi_nvram_ccode(char *data, unsigned long data_len)
+{
+	char *ccode;
+
+	ccode = strnstr((char *)data, "ccode=ALL", data_len);
+	if (!ccode)
+		ccode = strnstr((char *)data, "ccode=XV\r", data_len);
+	if (!ccode)
+		return;
+
+	ccode[6] = 'X';
+	ccode[7] = '2';
+	ccode[8] = '\r';
+}
+
 static u8 *brcmf_fw_nvram_from_efi(const char *path, size_t *data_len_ret)
 {
 	const u16 name[] = { 'n', 'v', 'r', 'a', 'm', 0 };
@@ -476,6 +499,7 @@ static u8 *brcmf_fw_nvram_from_efi(const char *path, size_t *data_len_ret)
 	if (err)
 		goto fail;
 
+	brcmf_fw_fix_efi_nvram_ccode(data, data_len);
 	brcmf_info("Using nvram EFI variable\n");
 
 	kfree(nvram_efivar);
-- 
2.19.0

