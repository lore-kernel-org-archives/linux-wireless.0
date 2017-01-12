Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36000 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdALVCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 16:02:46 -0500
Received: by mail-pf0-f172.google.com with SMTP id 189so18655705pfu.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 13:02:45 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 2/2] mwifiex: pcie: don't delay for sleep cookie when not required
Date: Thu, 12 Jan 2017 13:02:32 -0800
Message-Id: <20170112210232.18554-2-briannorris@chromium.org> (sfid-20170112_220252_258361_D32839A9)
In-Reply-To: <20170112210232.18554-1-briannorris@chromium.org>
References: <20170112210232.18554-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wifi modules like 8997 don't support the "sleep cookie", and so most of
the time, we just time out in the mwifiex_delay_for_sleep_cookie()
function ("max count reached while accessing sleep cookie"). This is a
waste of time, and we should skip it for modules without the sleep
cookie flag.

Additionally, this delay is sometimes counterproductive. For instance,
when PCIe ASPM is enabled, this extra delay can leave the link idle for
long enough to re-enter a low-power state even while we are trying to
wake the module, compounding an additional delay when it comes time to
read the next register (e.g., the interrupt status). On some systems,
this is detrimental to overall system latency.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
Tested on Marvell 8997, but would be good to get confirmation from Marvell.

 drivers/net/wireless/marvell/mwifiex/pcie.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 435ba879ef29..11e0673617c7 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1712,11 +1712,13 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 					    "Write register failed\n");
 				return -1;
 			}
-			mwifiex_delay_for_sleep_cookie(adapter,
-						       MWIFIEX_MAX_DELAY_COUNT);
-			while (reg->sleep_cookie && (count++ < 10) &&
-			       mwifiex_pcie_ok_to_access_hw(adapter))
-				usleep_range(50, 60);
+			if (reg->sleep_cookie) {
+				mwifiex_delay_for_sleep_cookie(adapter,
+							       MWIFIEX_MAX_DELAY_COUNT);
+				while ((count++ < 10) &&
+				       mwifiex_pcie_ok_to_access_hw(adapter))
+					usleep_range(50, 60);
+			}
 			mwifiex_pcie_enable_host_int(adapter);
 			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
 							   skb->len);
-- 
2.11.0.390.gc69c2f50cf-goog
