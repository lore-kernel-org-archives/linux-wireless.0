Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:50318 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaDQN16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 09:27:58 -0400
Received: by mail-pa0-f50.google.com with SMTP id kq14so379526pab.23
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 06:27:57 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH 4/6] mwl8k: replace wiphy_debug() with wiphy_dbg()
Date: Thu, 17 Apr 2014 21:27:12 +0800
Message-Id: <739c076c117c39064b509d3fad4220062a8f3e1a.1397741141.git.gamerh2o@gmail.com> (sfid-20140417_152801_347678_825C9021)
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dynamic debug function wiphy_dbg() is more convenient for debugging,
and if user doesn't enable CONFIG_DYNAMIC_DEBUG, it will fall back to
normal static debug, just as what wiphy_debug() does.

When all the users of wiphy_debug() are gone, wiphy_debug() can be
removed.

Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/mwl8k.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3c0a0a8..2e17f3d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1792,8 +1792,8 @@ mwl8k_add_stream(struct ieee80211_hw *hw, struct ieee80211_sta *sta, u8 tid)
 			stream->state = AMPDU_STREAM_NEW;
 			stream->tid = tid;
 			stream->idx = i;
-			wiphy_debug(hw->wiphy, "Added a new stream for %pM %d",
-				    sta->addr, tid);
+			wiphy_dbg(hw->wiphy, "Added a new stream for %pM %d",
+				  sta->addr, tid);
 			return stream;
 		}
 	}
@@ -1810,19 +1810,19 @@ mwl8k_start_stream(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream)
 		return 0;
 	ret = ieee80211_start_tx_ba_session(stream->sta, stream->tid, 0);
 	if (ret)
-		wiphy_debug(hw->wiphy, "Failed to start stream for %pM %d: "
-			    "%d\n", stream->sta->addr, stream->tid, ret);
+		wiphy_dbg(hw->wiphy, "Failed to start stream for %pM %d: "
+			  "%d\n", stream->sta->addr, stream->tid, ret);
 	else
-		wiphy_debug(hw->wiphy, "Started stream for %pM %d\n",
-			    stream->sta->addr, stream->tid);
+		wiphy_dbg(hw->wiphy, "Started stream for %pM %d\n",
+			  stream->sta->addr, stream->tid);
 	return ret;
 }
 
 static void
 mwl8k_remove_stream(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream)
 {
-	wiphy_debug(hw->wiphy, "Remove stream for %pM %d\n", stream->sta->addr,
-		    stream->tid);
+	wiphy_dbg(hw->wiphy, "Remove stream for %pM %d\n", stream->sta->addr,
+		  stream->tid);
 	memset(stream, 0, sizeof(*stream));
 }
 
@@ -2042,8 +2042,8 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 				skb->len, PCI_DMA_TODEVICE);
 
 	if (pci_dma_mapping_error(priv->pdev, dma)) {
-		wiphy_debug(hw->wiphy,
-			    "failed to dma map skb, dropping TX frame.\n");
+		wiphy_dbg(hw->wiphy,
+			  "failed to dma map skb, dropping TX frame.\n");
 		if (start_ba_session) {
 			spin_lock(&priv->stream_lock);
 			mwl8k_remove_stream(hw, stream);
@@ -4027,8 +4027,8 @@ mwl8k_create_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream,
 
 	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
 
-	wiphy_debug(hw->wiphy, "Created a BA stream for %pM : tid %d\n",
-		stream->sta->addr, stream->tid);
+	wiphy_dbg(hw->wiphy, "Created a BA stream for %pM : tid %d\n",
+		  stream->sta->addr, stream->tid);
 	kfree(cmd);
 
 	return rc;
@@ -4050,7 +4050,7 @@ static void mwl8k_destroy_ba(struct ieee80211_hw *hw,
 	cmd->destroy_params.ba_context = cpu_to_le32(idx);
 	mwl8k_post_cmd(hw, &cmd->header);
 
-	wiphy_debug(hw->wiphy, "Deleted BA stream index %d\n", idx);
+	wiphy_dbg(hw->wiphy, "Deleted BA stream index %d\n", idx);
 
 	kfree(cmd);
 }
@@ -4683,8 +4683,8 @@ static void mwl8k_tx(struct ieee80211_hw *hw,
 	int index = skb_get_queue_mapping(skb);
 
 	if (!priv->radio_on) {
-		wiphy_debug(hw->wiphy,
-			    "dropped TX frame since radio disabled\n");
+		wiphy_dbg(hw->wiphy,
+			  "dropped TX frame since radio disabled\n");
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -5470,7 +5470,7 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			stream = mwl8k_add_stream(hw, sta, tid);
 		}
 		if (stream == NULL) {
-			wiphy_debug(hw->wiphy, "no free AMPDU streams\n");
+			wiphy_dbg(hw->wiphy, "no free AMPDU streams\n");
 			rc = -EBUSY;
 			break;
 		}
@@ -5540,9 +5540,9 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			spin_unlock(&priv->stream_lock);
 			mwl8k_destroy_ba(hw, idx);
 			spin_lock(&priv->stream_lock);
-			wiphy_debug(hw->wiphy,
-				"Failed adding stream for sta %pM tid %d\n",
-				addr, tid);
+			wiphy_dbg(hw->wiphy,
+				  "Failed adding stream for sta %pM tid %d\n",
+				  addr, tid);
 			mwl8k_remove_stream(hw, stream);
 		}
 		break;
-- 
1.9.0

