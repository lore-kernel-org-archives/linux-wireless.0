Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60442 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab1J0Qfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 12:35:52 -0400
From: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH] Fix missing copy of frame contents to local buffer
Date: Thu, 27 Oct 2011 09:35:56 -0700
Message-ID: <1319733356-31320-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> (sfid-20111027_183556_859458_CF12DAD1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wpa_supplicant was receiving incorrect frame contents in the
callback function that indicates the status of the frame transmitted.
This patch fixes a missing copy of the frame contents to a local
buffer. The local buffer keeps track of the last sent management frame.

Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index e6b0960..6a1916a 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2837,6 +2837,7 @@ int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id, u32 freq,
 	}
 
 	kfree(wmi->last_mgmt_tx_frame);
+	memcpy(buf, data, data_len);
 	wmi->last_mgmt_tx_frame = buf;
 	wmi->last_mgmt_tx_frame_len = data_len;
 
-- 
1.7.0.4

