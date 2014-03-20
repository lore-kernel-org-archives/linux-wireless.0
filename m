Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25587 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759160AbaCTXYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 19:24:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: use timeout variant for wait_event_interruptible
Date: Thu, 20 Mar 2014 16:23:50 -0700
Message-ID: <1395357830-15722-3-git-send-email-bzhao@marvell.com> (sfid-20140321_002419_191652_2A82DD43)
In-Reply-To: <1395357830-15722-1-git-send-email-bzhao@marvell.com>
References: <1395357830-15722-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It has been observed that system hangs during suspend, if host
sleep activation fails due to a missing interrupt from firmware.
Use timeout variant, so that the thread will be woken up when
timer expires.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 95abaf4..fcb791c 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -517,8 +517,9 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 		return false;
 	}
 
-	if (wait_event_interruptible(adapter->hs_activate_wait_q,
-				     adapter->hs_activate_wait_q_woken)) {
+	if (wait_event_interruptible_timeout(adapter->hs_activate_wait_q,
+					     adapter->hs_activate_wait_q_woken,
+					     (10 * HZ)) <= 0) {
 		dev_err(adapter->dev, "hs_activate_wait_q terminated\n");
 		return false;
 	}
-- 
1.8.2.3

