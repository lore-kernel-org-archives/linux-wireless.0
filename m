Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34257 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755084AbcKETJE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Nov 2016 15:09:04 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] ssb: Fix error routine when fallback SPROM fails
Date: Sat,  5 Nov 2016 14:08:57 -0500
Message-Id: <20161105190857.19386-1-Larry.Finger@lwfinger.net> (sfid-20161105_200913_658908_813E1B01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When there is a CRC error in the SPROM read from the device, the code
attempts to handle a fallback SPROM. When this also fails, the driver
returns zero rather than an error code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/ssb/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 0f28c08..77b551d 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -909,6 +909,7 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 			if (err) {
 				ssb_warn("WARNING: Using fallback SPROM failed (err %d)\n",
 					 err);
+				goto out_free;
 			} else {
 				ssb_dbg("Using SPROM revision %d provided by platform\n",
 					sprom->revision);
-- 
2.10.0
