Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58166 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab1I2J1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 05:27:20 -0400
Received: by fxe4 with SMTP id 4so1514655fxe.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 02:27:19 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Allow NO_ACK flag overwrite for injected frames
Date: Thu, 29 Sep 2011 11:27:12 +0200
Message-Id: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110929_112735_235412_5356BF0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow injected unicast frames to be sent without having to wait
for an ACK.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Just in case you're interested in what's the intended purpose of this:

Some clients are staying on scanned channels for a very short period of
time. hostapd sends out probe responses for each configured BSSID. Under
some circumstances I can see that the client already left the channel
while some probe responses are still sent out and thus retried. This 
consumes quite some airtime. Commercial wireless APs (Aruba for example)
seem to disable retries for probe responses to mitigate such issues.

 include/net/ieee80211_radiotap.h |    1 +
 net/mac80211/tx.c                |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index b0be5fb..7e2c4d4 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -251,6 +251,7 @@ enum ieee80211_radiotap_type {
 						 * retries */
 #define IEEE80211_RADIOTAP_F_TX_CTS	0x0002	/* used cts 'protection' */
 #define IEEE80211_RADIOTAP_F_TX_RTS	0x0004	/* used rts/cts handshake */
+#define IEEE80211_RADIOTAP_F_TX_NOACK	0x0008	/* don't expect an ack */
 
 
 /* For IEEE80211_RADIOTAP_MCS */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0107263..8b55465 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1047,6 +1047,7 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
+	u16 txflags;
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
@@ -1095,6 +1096,13 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
 
+		case IEEE80211_RADIOTAP_TX_FLAGS:
+			txflags = le16_to_cpu(get_unaligned((__le16*)
+						iterator.this_arg));
+			if (txflags & IEEE80211_RADIOTAP_F_TX_NOACK)
+				info->flags |= IEEE80211_TX_CTL_NO_ACK;
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
@@ -1257,7 +1265,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->flags |= IEEE80211_TX_UNICAST;
 		if (unlikely(local->wifi_wme_noack_test))
 			info->flags |= IEEE80211_TX_CTL_NO_ACK;
-		else
+		else if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 			info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
 	}
 
-- 
1.7.3.4

