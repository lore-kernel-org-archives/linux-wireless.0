Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54481 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2ITGVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 02:21:40 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 2/3] ath6kl: Check for valid rate table index
Date: Thu, 20 Sep 2012 11:51:07 +0530
Message-ID: <1348122068-24648-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20120920_082152_178660_F6E0B369)
In-Reply-To: <1348122068-24648-1-git-send-email-rmani@qca.qualcomm.com>
References: <1348122068-24648-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

There are 28 items defined in rate table array 'wmi_rate_tbl'.
The rate table index (reply->rate_index) in ath6kl_wmi_bitrate_reply_rx()
func is not checked for the valid max limit index before accessing
rate table array. There may be some incidents to get memory crashes
without safe max check. Fix this.

Found this on code review.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d5263ff..666f56d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1171,6 +1171,9 @@ static int ath6kl_wmi_bitrate_reply_rx(struct wmi *wmi, u8 *datap, int len)
 		rate = RATE_AUTO;
 	} else {
 		index = reply->rate_index & 0x7f;
+		if (index > (RATE_MCS_7_40 + 1))
+			return -EINVAL;
+
 		sgi = (reply->rate_index & 0x80) ? 1 : 0;
 		rate = wmi_rate_tbl[index][sgi];
 	}
-- 
1.7.1

