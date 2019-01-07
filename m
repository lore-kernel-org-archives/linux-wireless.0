Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180BAC43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A62206B6
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfAGNdb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:33:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726886AbfAGNdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 08:33:31 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2BC8A457A;
        Mon,  7 Jan 2019 13:33:30 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-151.ams2.redhat.com [10.36.116.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21A5C600C5;
        Mon,  7 Jan 2019 13:33:28 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2] brcmfmac: Use firmware_request_nowarn for the clm_blob
Date:   Mon,  7 Jan 2019 14:33:27 +0100
Message-Id: <20190107133327.9297-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 07 Jan 2019 13:33:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The linux-firmware brcmfmac firmware files contain an embedded table with
per country allowed channels and strength info.

For recent hardware these versions of the firmware are specially build for
linux-firmware, the firmware files directly available from Cypress rely on
a separate clm_blob file for this info.

For some unknown reason Cypress refuses to provide the standard firmware
files + clm_blob files it uses elsewhere for inclusion into linux-firmware,
instead relying on these special builds with the clm_blob info embedded.
This means that the linux-firmware firmware versions often lag behind,
but I digress.

The brcmfmac driver does support the separate clm_blob file and always
tries to load this. Currently we use request_firmware for this. This means
that on any standard install, using the standard combo of linux-kernel +
linux-firmware, we will get a warning:
"Direct firmware load for ... failed with error -2"

On top of this, brcmfmac itself prints: "no clm_blob available (err=-2),
device may have limited channels available".

This commit switches to firmware_request_nowarn, fixing almost any brcmfmac
device logging the warning (it leaves the brcmfmac info message in place).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Use firmware_request_nowarn instead of request_firmware_direct
-Reword commit message a bit to match (and fix a typo)
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 0bb16bf574e3..e29f56888761 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -149,7 +149,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 		return err;
 	}
 
-	err = request_firmware(&clm, clm_name, bus->dev);
+	err = firmware_request_nowarn(&clm, clm_name, bus->dev);
 	if (err) {
 		brcmf_info("no clm_blob available (err=%d), device may have limited channels available\n",
 			   err);
-- 
2.20.1

