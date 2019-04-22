Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091C1C10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 20:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D217020859
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 20:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbfDVUl1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:41:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbfDVUl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 16:41:26 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 809DE3082A49;
        Mon, 22 Apr 2019 20:41:26 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-58.ams2.redhat.com [10.36.116.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEF03600CC;
        Mon, 22 Apr 2019 20:41:24 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, stable@vger.kernel.org
Subject: [PATCH] brcmfmac: Add DMI nvram filename quirk for ACEPC T8 and T11 mini PCs
Date:   Mon, 22 Apr 2019 22:41:23 +0200
Message-Id: <20190422204123.6123-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 22 Apr 2019 20:41:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The ACEPC T8 and T11 mini PCs contain quite generic names in the sys_vendor
and product_name DMI strings, without this patch brcmfmac will try to load:
"brcmfmac43455-sdio.Default string-Default string.txt" as nvram file which
is way too generic.

The DMI strings on which we are matching are somewhat generic too, but
"To be filled by O.E.M." is less common then "Default string" and the
system-sku and bios-version strings are pretty unique. Beside the DMI
strings we also check the wifi-module chip-id and revision. I'm confident
that the combination of all this is unique.

Both the T8 and T11 use the same wifi-module, this commit adds DMI
quirks for both mini PCs pointing to brcmfmac43455-sdio.acepc-t8.txt .

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1690852
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../broadcom/brcm80211/brcmfmac/dmi.c         | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 7535cb0d4ac0..9f1417e00073 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -31,6 +31,10 @@ struct brcmf_dmi_data {
 
 /* NOTE: Please keep all entries sorted alphabetically */
 
+static const struct brcmf_dmi_data acepc_t8_data = {
+	BRCM_CC_4345_CHIP_ID, 6, "acepc-t8"
+};
+
 static const struct brcmf_dmi_data gpd_win_pocket_data = {
 	BRCM_CC_4356_CHIP_ID, 2, "gpd-win-pocket"
 };
@@ -48,6 +52,28 @@ static const struct brcmf_dmi_data pov_tab_p1006w_data = {
 };
 
 static const struct dmi_system_id dmi_platform_data[] = {
+	{
+		/* ACEPC T8 Cherry Trail Z8350 mini PC */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "To be filled by O.E.M."),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "T8"),
+			/* also match on somewhat unique bios-version */
+			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
+		},
+		.driver_data = (void *)&acepc_t8_data,
+	},
+	{
+		/* ACEPC T11 Cherry Trail Z8350 mini PC, same wifi as the T8 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "To be filled by O.E.M."),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "T11"),
+			/* also match on somewhat unique bios-version */
+			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
+		},
+		.driver_data = (void *)&acepc_t8_data,
+	},
 	{
 		/* Match for the GPDwin which unfortunately uses somewhat
 		 * generic dmi strings, which is why we test for 4 strings.
-- 
2.21.0

