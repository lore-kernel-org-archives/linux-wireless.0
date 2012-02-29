Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:46684 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031084Ab2B2RTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:50 -0500
Subject: [PATCH 09/12] ath6kl: fix open paranthesis alignment in
	ath6kl_cfg80211_connect()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:19:46 +0200
Message-ID: <20120229171946.24264.32281.stgit@localhost6.localdomain6> (sfid-20120229_182018_378382_36C4B6B2)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl/cfg80211.c:462: CHECK: Alignment should match open parenthesis

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6aa4c71..45cf4f4 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -416,6 +416,12 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
 	return false;
 }
 
+static bool ath6kl_is_tx_pending(struct ath6kl *ar)
+{
+	return ar->tx_pending[ath6kl_wmi_get_control_ep(ar->wmi)] == 0;
+}
+
+
 static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_connect_params *sme)
 {
@@ -459,8 +465,8 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		 * sleep until the command queue drains
 		 */
 		wait_event_interruptible_timeout(ar->event_wq,
-			ar->tx_pending[ath6kl_wmi_get_control_ep(ar->wmi)] == 0,
-			WMI_TIMEOUT);
+						 ath6kl_is_tx_pending(ar),
+						 WMI_TIMEOUT);
 		if (signal_pending(current)) {
 			ath6kl_err("cmd queue drain timeout\n");
 			up(&ar->sem);

