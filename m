Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39157 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab2AUNnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 08:43:45 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: use skb_get_queue_mapping() in b43 and b43legacy
Date: Sat, 21 Jan 2012 14:43:35 +0100
Message-Id: <1327153416-27834-2-git-send-email-hauke@hauke-m.de> (sfid-20120121_144349_242198_06C41786)
In-Reply-To: <1327153416-27834-1-git-send-email-hauke@hauke-m.de>
References: <1327153416-27834-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use skb_get_queue_mapping() for getting the queue_mapping member of
skb. Some old kernels do not have the member queue_mapping with all
configuration options, but this function always returns something.

This should also go into compat-wireless-stable-3.3.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/48-use_skb_get_queue_mapping.patch |   38 ++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 patches/48-use_skb_get_queue_mapping.patch

diff --git a/patches/48-use_skb_get_queue_mapping.patch b/patches/48-use_skb_get_queue_mapping.patch
new file mode 100644
index 0000000..6f172bd
--- /dev/null
+++ b/patches/48-use_skb_get_queue_mapping.patch
@@ -0,0 +1,38 @@
+Use skb_get_queue_mapping() for getting the queue_mapping member of 
+skb. Some old kernels do not have the member queue_mapping, but this 
+function always returns something.
+
+--- a/drivers/net/wireless/b43/main.c
++++ b/drivers/net/wireless/b43/main.c
+@@ -3430,11 +3430,11 @@ static void b43_op_tx(struct ieee80211_h
+ 	}
+ 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
+ 
+-	skb_queue_tail(&wl->tx_queue[skb->queue_mapping], skb);
+-	if (!wl->tx_queue_stopped[skb->queue_mapping]) {
++	skb_queue_tail(&wl->tx_queue[skb_get_queue_mapping(skb)], skb);
++	if (!wl->tx_queue_stopped[skb_get_queue_mapping(skb)]) {
+ 		ieee80211_queue_work(wl->hw, &wl->tx_work);
+ 	} else {
+-		ieee80211_stop_queue(wl->hw, skb->queue_mapping);
++		ieee80211_stop_queue(wl->hw, skb_get_queue_mapping(skb));
+ 	}
+ }
+ 
+--- a/drivers/net/wireless/b43legacy/main.c
++++ b/drivers/net/wireless/b43legacy/main.c
+@@ -2493,11 +2493,11 @@ static void b43legacy_op_tx(struct ieee8
+ 	}
+ 	B43legacy_WARN_ON(skb_shinfo(skb)->nr_frags);
+ 
+-	skb_queue_tail(&wl->tx_queue[skb->queue_mapping], skb);
+-	if (!wl->tx_queue_stopped[skb->queue_mapping])
++	skb_queue_tail(&wl->tx_queue[skb_get_queue_mapping(skb)], skb);
++	if (!wl->tx_queue_stopped[skb_get_queue_mapping(skb)])
+ 		ieee80211_queue_work(wl->hw, &wl->tx_work);
+ 	else
+-		ieee80211_stop_queue(wl->hw, skb->queue_mapping);
++		ieee80211_stop_queue(wl->hw, skb_get_queue_mapping(skb));
+ }
+ 
+ static int b43legacy_op_conf_tx(struct ieee80211_hw *hw,
-- 
1.7.5.4

