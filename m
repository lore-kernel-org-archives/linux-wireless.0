Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54459 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab1IJJ4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 05:56:50 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath6kl: Set the sme_state to disconnected in disconnect() callback
Date: Sat, 10 Sep 2011 15:26:35 +0530
Message-ID: <1315648597-17999-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110910_115655_490654_8E6CC8E1)
In-Reply-To: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a successful completion of disconnect() driver needs to set
it's sme_state to SME_DISCONNECTED to be in sync with cfg80211
state.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fcef417..17bb8e2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -589,6 +589,8 @@ static int ath6kl_cfg80211_disconnect(struct wiphy *wiphy,
 
 	up(&ar->sem);
 
+	ar->sme_state = SME_DISCONNECTED;
+
 	return 0;
 }
 
-- 
1.7.0.4

