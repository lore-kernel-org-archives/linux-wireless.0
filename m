Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1606 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0CCD4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 22:56:31 -0500
Subject: [RFC PATCH] mac80211: support rate and retry settings in injected
 frames
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Cc: rootkit85@yahoo.it, Andrew Watts <systemstalker@gmail.com>
Content-Type: text/plain
Date: Tue, 02 Mar 2010 22:56:02 -0500
Message-Id: <1267588562.30055.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add and document support for IEEE80211_RADIOTAP_RATE and
IEEE80211_RADIOTAP_DATA_RETRIES in mac80211.  Only allow
IEEE80211_RADIOTAP_DATA_RETRIES together with IEEE80211_RADIOTAP_RATE.

Introduce IEEE80211_TX_CTL_RC_BYPASS to allow bypassing rate control for
specific frames.  Document that IEEE80211_RADIOTAP_RATE is supported.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

The patch was inspired by a bigger patch by rootkit85@yahoo.it, but it's
a complete rewrite that only deals with the rates and retries, and it
actually works for injection from the userspace.

I don't really like the rc bypassing and the limitation on the retry
count parsing.  We could consider sending "hints" to the rate control,
or overriding the rate and the retry count after the rate control has
been called.

 Documentation/networking/mac80211-injection.txt |    7 ++++
 include/net/mac80211.h                          |    2 +
 net/mac80211/tx.c                               |   36 ++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/mac80211-injection.txt b/Documentation/networking/mac80211-injection.txt
index b30e81a..80a3860 100644
--- a/Documentation/networking/mac80211-injection.txt
+++ b/Documentation/networking/mac80211-injection.txt
@@ -23,6 +23,13 @@ radiotap headers and used to control injection:
    IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
 			      current fragmentation threshold.
 
+ * IEEE80211_RADIOTAP_RATE: Transmit rate will be set to the requested value if
+			    it's available.  Rate control will not be used for
+			    the frame.
+
+ * IEEE80211_RADIOTAP_DATA_RETRIES: Retry count will be set to the requested
+				    value.  This parameter can only be used in
+				    conjunction with IEEE80211_RADIOTAP_RATE.
 
 The injection code can also skip all other currently defined radiotap fields
 facilitating replay of captured radiotap headers directly.
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 80eb7cc..f296b6e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -267,6 +267,7 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_NL80211_FRAME_TX: Frame was requested through nl80211
  *	MLME command (internal to mac80211 to figure out whether to send TX
  *	status to user space)
+ * @IEEE80211_TX_CTL_RC_BYPASS: Don't use rate control on the frame.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -290,6 +291,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
 	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
+	IEEE80211_TX_CTL_RC_BYPASS		= BIT(22),
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cbe53ed..986ee52 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1058,6 +1058,39 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
 
+		case IEEE80211_RADIOTAP_RATE: {
+			int i, idx = -1;
+			int rate = *iterator.this_arg * 5;
+
+			for (i = 0; i < sband->n_bitrates; i++)
+				if (sband->bitrates[i].bitrate == rate) {
+					idx = i;
+					break;
+				}
+
+			/* Rate not available - rejecting */
+			if (idx < 0)
+				return false;
+
+			info->flags |= IEEE80211_TX_CTL_RC_BYPASS;
+			info->control.rates[0].idx = idx;
+			info->control.rates[0].count = 1;
+			for (i = 1; i < IEEE80211_TX_MAX_RATES; i++)
+				info->control.rates[i].idx = -1;
+			break;
+		}
+
+		case IEEE80211_RADIOTAP_DATA_RETRIES:
+			/*
+			 * Only allow setting the number of retries in
+			 * conjunction with the rates, when the rate control
+			 * is bypassed.
+			 */
+			if (info->flags & IEEE80211_TX_CTL_RC_BYPASS)
+				info->control.rates[0].count =
+					*iterator.this_arg;
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
@@ -1305,7 +1338,8 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_select_key);
 	CALL_TXH(ieee80211_tx_h_sta);
-	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+	    !(info->flags & IEEE80211_TX_CTL_RC_BYPASS))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION))

