Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18984 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935Ab1IJJ5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 05:57:04 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath6kl: Fix random reconnect failures
Date: Sat, 10 Sep 2011 15:26:37 +0530
Message-ID: <1315648597-17999-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110910_115707_442930_A94040C5)
In-Reply-To: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes connect events are received after disconnect
events from target, this puts host and target in different
states. When receiving a connect event in a wrong state,
make sure to send disconnect event to target to maintain
state consistency.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0ad458b..2e4bea3 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -460,6 +460,14 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
 				   "%s: ath6k not in station mode\n", __func__);
 			return;
 		}
+
+		if ((ar->sme_state != SME_CONNECTING) &&
+		    (ar->sme_state != SME_CONNECTED)) {
+			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
+				   "Connect event at inappropriate state, sending disconnect cmd\n");
+			ath6kl_wmi_disconnect_cmd(ar->wmi);
+			return;
+		}
 	}
 
 	/*
-- 
1.7.0.4

