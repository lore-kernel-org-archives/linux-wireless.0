Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-relay-02-9.dondominio.net ([31.214.176.42]:46883 "EHLO
        smtp-relay-02-9.dondominio.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753158AbdGXK4E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 06:56:04 -0400
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Ignacio_N=c3=ba=c3=b1ez_Hernanz?=
        <nacho.nunez@aoifes.com>
From: =?UTF-8?Q?Ignacio_N=c3=ba=c3=b1ez_Hernanz?=
        <nacho.nunez@aoifes.com>
Subject: [PATCH] ath10k: Make ath10k report discarded packets to mac80211
Message-ID: <863ed21f-d2fe-f1e1-6f3c-b4061c777f59@aoifes.com> (sfid-20170724_125618_463888_2F353D2C)
Date: Mon, 24 Jul 2017 12:49:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 From 2caef0e851a23cc9e979a3f36a2ae0d964cfeba7 Mon Sep 17 00:00:00 2001
From: Ignacio Nunez Hernanz <nacho.nunez@aoifes.com>
Date: Mon, 24 Jul 2017 11:52:48 +0200
Subject: [PATCH] ath10k: Make ath10k report discarded packets to mac80211

Whenever ath10k firmware discards a packet (HTT_TX_COMPL_STATE_DISCARD
flag), the skb is freed and mac80211 does not get feedback through
ieee80211_tx_status().

Instead, make sure that the IEEE80211_TX_STAT_ACK flag is disabled and
let the packet go through, like ath9k does.

Signed-off-by: Ignacio Nunez Hernanz <nacho.nunez@aoifes.com>
---
  drivers/net/wireless/ath/ath10k/txrx.c | 12 +++++++-----
  1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c 
b/drivers/net/wireless/ath/ath10k/txrx.c
index d4986f626c35..37537530de76 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -102,11 +102,6 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
      memset(&info->status, 0, sizeof(info->status));
      trace_ath10k_txrx_tx_unref(ar, tx_done->msdu_id);

-    if (tx_done->status == HTT_TX_COMPL_STATE_DISCARD) {
-        ieee80211_free_txskb(htt->ar->hw, msdu);
-        return 0;
-    }
-
      if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
          info->flags |= IEEE80211_TX_STAT_ACK;

@@ -117,6 +112,13 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
          (info->flags & IEEE80211_TX_CTL_NO_ACK))
          info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;

+    if (tx_done->status == HTT_TX_COMPL_STATE_DISCARD) {
+          if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+            info->flags &= ~IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+          else
+            info->flags &= ~IEEE80211_TX_STAT_ACK;
+    }
+
      ieee80211_tx_status(htt->ar->hw, msdu);
      /* we do not own the msdu anymore */

-- 
2.13.1
