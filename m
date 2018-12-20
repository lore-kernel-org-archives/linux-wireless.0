Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11991C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDD3721773
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbeLTQlD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 11:41:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbeLTQlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 11:41:03 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C562DC05D3EC;
        Thu, 20 Dec 2018 16:41:02 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-196.ams2.redhat.com [10.36.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B14D17F5C;
        Thu, 20 Dec 2018 16:40:59 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] brcmfmac: Add DMI nvram filename quirk for PoV TAB-P1006W-232 tablet
Date:   Thu, 20 Dec 2018 17:40:58 +0100
Message-Id: <20181220164058.19203-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 20 Dec 2018 16:41:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The Point of View TAB-P1006W-232 tablet contains quite generic names in
the sys_vendor and product_name DMI strings, without this patch brcmfmac
will try to load: brcmfmac43340-sdio.Insyde-BayTrail.txt as nvram file
which is a bit too generic.

Add a DMI quirk so that a unique and clearly identifiable nvram file
name is used on the PoV TAB-P1006W-232 tablet.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/dmi.c    | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 51d76ac45075..7535cb0d4ac0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -43,6 +43,10 @@ static const struct brcmf_dmi_data meegopad_t08_data = {
 	BRCM_CC_43340_CHIP_ID, 2, "meegopad-t08"
 };
 
+static const struct brcmf_dmi_data pov_tab_p1006w_data = {
+	BRCM_CC_43340_CHIP_ID, 2, "pov-tab-p1006w-data"
+};
+
 static const struct dmi_system_id dmi_platform_data[] = {
 	{
 		/* Match for the GPDwin which unfortunately uses somewhat
@@ -81,6 +85,17 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&meegopad_t08_data,
 	},
+	{
+		/* Point of View TAB-P1006W-232 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "BayTrail"),
+			/* Note 105b is Foxcon's USB/PCI vendor id */
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "105B"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "0E57"),
+		},
+		.driver_data = (void *)&pov_tab_p1006w_data,
+	},
 	{}
 };
 
-- 
2.20.1

