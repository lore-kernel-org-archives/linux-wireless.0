Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2463 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1KISGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 13:06:45 -0500
From: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Fix target minimum length requirement for WMI_SEND_PROBE_RESPONSE_CMDID
Date: Wed, 9 Nov 2011 10:05:56 -0800
Message-ID: <1320861956-15533-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> (sfid-20111109_190649_757018_08B04A2A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware expects the minimum length of
WMI_SEND_PROBE_RESPONSE_CMDID to be 13. However, when the device is a
P2P GO and it needs to send a probe response to a non-P2P client,
there are no P2P IEs to be added, and therefore the length of the WMI
command is 12. This command gets rejected by the firmware. To fix
this, add an extra byte to satisfy the minimum length requirement.

Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

---
 drivers/net/wireless/ath/ath6kl/wmi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 922344d..4b7856d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3024,8 +3024,12 @@ int ath6kl_wmi_send_probe_response_cmd(struct wmi *wmi, u8 if_idx, u32 freq,
 {
 	struct sk_buff *skb;
 	struct wmi_p2p_probe_response_cmd *p;
+	size_t cmd_len = sizeof(*p) + data_len;
 
-	skb = ath6kl_wmi_get_new_buf(sizeof(*p) + data_len);
+	if (data_len == 0)
+		cmd_len++; /* work around target minimum length requirement */
+
+	skb = ath6kl_wmi_get_new_buf(cmd_len);
 	if (!skb)
 		return -ENOMEM;
 
-- 
1.7.0.4

