Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:48935 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933956AbaEFGex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 02:34:53 -0400
Received: by mail-ee0-f44.google.com with SMTP id c41so5951526eek.31
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2014 23:34:52 -0700 (PDT)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, ath9k-devel@venema.h4ckr.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 1/2] mac80211: add no update durationId bit in radiotap
Date: Tue,  6 May 2014 08:32:46 +0200
Message-Id: <1399357967-6541-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140506_083457_221549_F6232838)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds a new bit in radiotap_tx flags, which allows injections
frames without changing durationId filed. The intention is
a NAV update testing.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 include/net/ieee80211_radiotap.h |   14 +++++++++-----
 include/net/mac80211.h           |    3 +++
 net/mac80211/tx.c                |    4 ++++
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index b0fd947..b00b7dd 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -261,11 +261,15 @@ enum ieee80211_radiotap_type {
 
 /* For IEEE80211_RADIOTAP_TX_FLAGS */
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001	/* failed due to excessive
-						 * retries */
-#define IEEE80211_RADIOTAP_F_TX_CTS	0x0002	/* used cts 'protection' */
-#define IEEE80211_RADIOTAP_F_TX_RTS	0x0004	/* used rts/cts handshake */
-#define IEEE80211_RADIOTAP_F_TX_NOACK	0x0008	/* don't expect an ack */
-
+							 * retries */
+#define IEEE80211_RADIOTAP_F_TX_CTS		0x0002	/* used cts
+							 * 'protection' */
+#define IEEE80211_RADIOTAP_F_TX_RTS		0x0004	/* used rts/cts
+							 * handshake */
+#define IEEE80211_RADIOTAP_F_TX_NOACK		0x0008	/* don't expect an
+							 * ack */
+#define IEEE80211_RADIOTAP_F_TX_NO_DUR_UPDATE	0x0010  /* don't touch
+							 * durationId field */
 
 /* For IEEE80211_RADIOTAP_MCS */
 #define IEEE80211_RADIOTAP_MCS_HAVE_BW		0x01
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2de7ff4..8c55eb9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -512,11 +512,14 @@ enum mac80211_tx_info_flags {
  *
  * @IEEE80211_TX_CTRL_PORT_CTRL_PROTO: this frame is a port control
  *	protocol frame (e.g. EAP)
+ * @IEEE80211_TX_CTRL_NO_DUR_UPDATE: This frame should be send without
+ *	changing durationID field.
  *
  * These flags are used in tx_info->control.flags.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
+	IEEE80211_TX_CTRL_NO_DUR_UPDATE		= BIT(1),
 };
 
 /*
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 19d36d4..3b8087e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -104,6 +104,10 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		 *    and its SIFS
 		 * PS Poll: BIT(15) | BIT(14) | aid
 		 */
+		/* Don't touch durationId field */
+		if (info->flags & IEEE80211_TX_CTRL_NO_DUR_UPDATE)
+			return hdr->duration_id;
+
 		return 0;
 	}
 
-- 
1.7.9.5

