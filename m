Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55947 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab1KWPlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:41:16 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so572756vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:41:15 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 4/5] ath6kl: add support for NL80211_TX_POWER_REG
Date: Wed, 23 Nov 2011 10:40:57 -0500
Message-Id: <1322062858-15276-5-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_164120_432672_2877B6EB)
In-Reply-To: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322062858-15276-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 9f3d3f0..983c3e9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1187,6 +1187,7 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 	struct ath6kl_vif *vif;
 	u8 ath6kl_dbm;
 	int dbm = MBM_TO_DBM(mbm);
+	struct ieee80211_channel *chan;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type 0x%x, dbm %d\n", __func__,
 		   type, dbm);
@@ -1204,6 +1205,11 @@ static int ath6kl_cfg80211_set_txpower(struct wiphy *wiphy,
 	case NL80211_TX_POWER_LIMITED:
 		ar->tx_pwr = ath6kl_dbm = dbm;
 		break;
+	case NL80211_TX_POWER_REG:
+		chan = ieee80211_get_channel(wiphy, vif->next_chan);
+		if (!chan)
+			return -EIO;
+		ar->tx_pwr = ath6kl_dbm = chan->max_power;
 	default:
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: type 0x%x not supported\n",
 			   __func__, type);
-- 
1.7.4.15.g7811d

