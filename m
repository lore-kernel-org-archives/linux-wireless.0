Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:37195 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757559Ab3EGCwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 22:52:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.10] mwifiex: clear is_suspended flag when interrupt is received early
Date: Mon, 6 May 2013 19:46:53 -0700
Message-ID: <1367894814-6677-1-git-send-email-bzhao@marvell.com> (sfid-20130507_045248_571661_7614D6F2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the XO-4 with 8787 wireless is woken up due to wake-on-WLAN
mwifiex is often flooded with "not allowed while suspended" messages
and the interface is unusable.

[  202.171609] int: sdio_ireg = 0x1
[  202.180700] info: mwifiex_process_hs_config: auto cancelling host
               sleep since there is interrupt from the firmware
[  202.201880] event: wakeup device...
[  202.211452] event: hs_deactivated
[  202.514638] info: --- Rx: Data packet ---
[  202.514753] data: 4294957544 BSS(0-0): Data <= kernel
[  202.514825] PREP_CMD: device in suspended state
[  202.514839] data: dequeuing the packet ec7248c0 ec4869c0
[  202.514886] mwifiex_write_data_sync: not allowed while suspended
[  202.514886] host_to_card, write iomem (1) failed: -1
[  202.514917] mwifiex_write_data_sync: not allowed while suspended
[  202.514936] host_to_card, write iomem (2) failed: -1
[  202.514949] mwifiex_write_data_sync: not allowed while suspended
[  202.514965] host_to_card, write iomem (3) failed: -1
[  202.514976] mwifiex_write_data_async failed: 0xFFFFFFFF

This can be readily reproduced when putting the XO-4 in a loop where
it goes to sleep due to inactivity, but then wakes up due to an
incoming ping. The error is hit within an hour or two.

This issue happens when an interrupt comes in early while host sleep
is still activated. Driver handles this case by auto cancelling host
sleep. However is_suspended flag is still set which prevents any cmd
or data from being sent to firmware. Fix it by clearing is_suspended
flag in this path.

Cc: <stable@vger.kernel.org>
Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 74db0d2..26755d9 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1191,6 +1191,7 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 	adapter->if_ops.wakeup(adapter);
 	adapter->hs_activated = false;
 	adapter->is_hs_configured = false;
+	adapter->is_suspended = false;
 	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
 						    MWIFIEX_BSS_ROLE_ANY),
 				   false);
-- 
1.7.0.2

