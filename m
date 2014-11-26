Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbaKZOcX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 09:32:23 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 4/4] Revert "rt2x00: Endless loop on hub port power down"
Date: Wed, 26 Nov 2014 15:29:16 +0100
Message-Id: <1417012156-26197-4-git-send-email-sgruszka@redhat.com> (sfid-20141126_153231_102698_BDBC0057)
In-Reply-To: <1417012156-26197-1-git-send-email-sgruszka@redhat.com>
References: <1417012156-26197-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 2ad69ac5976191e9bb7dc4044204a504653ad1bb. It
causes wireless device disappear when we get -EPROTO error form USB
request. I encounter such situation occasionally when resume form
suspend with RT3070 adapter:

[  289.619985] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0404 with error -71
[  289.639368] ieee80211 phy0: rt2800_wait_bbp_ready: Error - BBP register access failed, aborting
[  289.639374] ieee80211 phy0: rt2800usb_set_device_state: Error - Device failed to enter state 4 (-5)

Without the patch, except printing error, device works just fine after
resume.

Currently after timeouts and REGISTER_BUSY_COUNT tuning, we should
not have any "endless loop", though we can wait quite long when driver
is trying to communicate with the device through non functioning USB
connection. Generally the problem that commit 2ad69ac597619 solves
is kinda artificial.

Cc: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index c2346f8..892270d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -64,12 +64,6 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 		}
 	} while (time_before(jiffies, expire));
 
-	/* If the port is powered down, we get a -EPROTO error, and this
-	 * leads to a endless loop. So just say that the device is gone.
-	 */
-	if (status == -EPROTO)
-		clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
-
 	rt2x00_err(rt2x00dev,
 		   "Vendor Request 0x%02x failed for offset 0x%04x with error %d\n",
 		   request, offset, status);
-- 
1.8.3.1

