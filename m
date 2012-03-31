Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:28197 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2CaXfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 19:35:54 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	b43-dev@lists.infradead.org, Jo-Philipp Wich <jow@openwrt.org>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] b43: claim support for IBSS RSN
Date: Sun,  1 Apr 2012 00:35:40 +0300
Message-Id: <1333229740-5182-1-git-send-email-ordex@autistici.org> (sfid-20120401_013629_729280_7C0BB8C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver now claims to support IBSS/RSN. Group key configuration in hardware
is skipped. Software encryption is used for multicast communications.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 drivers/net/wireless/b43/main.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c79e663..05ea95b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4010,6 +4010,20 @@ static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (modparam_nohwcrypt)
 		return -ENOSPC; /* User disabled HW-crypto */
 
+	if ((vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
+	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		/*
+		 * For now, disable hw crypto for the RSN IBSS group keys. This
+		 * could be optimized in the future, but until that gets
+		 * implemented, use of software crypto for group addressed
+		 * frames is a acceptable to allow RSN IBSS to be used.
+		 */
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&wl->mutex);
 
 	dev = wl->current_dev;
@@ -5275,6 +5289,8 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 		BIT(NL80211_IFTYPE_WDS) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
+	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+
 	hw->queues = modparam_qos ? B43_QOS_QUEUE_NUM : 1;
 	wl->mac80211_initially_registered_queues = hw->queues;
 	hw->max_rates = 2;
-- 
1.7.9.4

