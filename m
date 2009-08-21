Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:34978 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbZHUSDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 14:03:46 -0400
Message-ID: <4A8EE182.6040709@cs.ucla.edu>
Date: Fri, 21 Aug 2009 11:03:46 -0700
From: Rafael Laufer <rlaufer@cs.ucla.edu>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
References: <4A8DED03.2050502@cs.ucla.edu> <1250842695.13872.5.camel@johannes.local> <69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>
In-Reply-To: <69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 
> Maybe a new IEEE80211_TX_CTL_ or IEEE80211_TX_RC_ flag will also be
> needed, so Radiotap can indicate whether rate_control_get_rate needs
> to be called.

ok, I am resending the patch. I included a new flag called 
IEEE80211_TX_CTL_RATE_RADIOTAP to indicate if the rate has
been set in the radiotap header. If not, then the rate control
algorithm is called.

Note that in the future there must be other flags like this to 
indicate if other parameters, such as power, was also set in
the radiotap header.


Signed-off-by: Rafael Laufer <rlaufer@cs.ucla.edu>
---
 Implementation of the IEEE80211_RADIOTAP_RATE
 option when parsing radiotap headers to allow
 rate selection on a per-packet basis. A new
 flag IEEE80211_TX_CTL_RATE_RADIOTAP is also
 included to indicate that the rate was set in
 the radiotap header and therefore the rate
 control algorithm should not change it.

 include/net/mac80211.h |    4 ++++
 net/mac80211/tx.c      |   22 +++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index aac84d7..819b01e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -272,6 +272,9 @@ struct ieee80211_bss_conf {
  *	transmit function after the current frame, this can be used
  *	by drivers to kick the DMA queue only if unset or when the
  *	queue gets full.
+ * @IEEE80211_TX_CTL_RATE_RADIOTAP: completely internal to mac80211,
+ *	used to indicate that the rate was defined in the received radiotap
+ *	header and therefore the rate control algorithm should not change it.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -293,6 +296,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
 	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
+	IEEE80211_TX_CTL_RATE_RADIOTAP 		= BIT(19),
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 10a1099..f675844 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -549,7 +549,12 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	 * If we're associated with the sta at this point we know we can at
 	 * least send the frame at the lowest bit rate.
 	 */
-	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
+
+	/* In monitor mode, if the IEEE80211_RADIOTAP_RATE option is set in 
+	 * the received radiotap header, do not call the rate control algorithm.
+	 */
+	if (likely(!(info->flags & IEEE80211_TX_CTL_RATE_RADIOTAP)))
+		rate_control_get_rate(tx->sdata, tx->sta, &txrc);
 
 	if (unlikely(info->control.rates[0].idx < 0))
 		return TX_DROP;
@@ -972,6 +977,21 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
 
+		/* Get the rate parameter from the radiotap header, 
+		 * allowing rate selection on a per-packet basis 
+		 */
+		case IEEE80211_RADIOTAP_RATE:
+			bitrate = (*iterator.this_arg) * 5;
+			for (i = 0; i < sband->n_bitrates; i++) {
+				if (sband->bitrates[i].bitrate == bitrate)
+					break;
+			}
+			if (i != sband->n_bitrates) {
+				info->control.rates[0].idx = i;
+				info->flags |= IEEE80211_TX_CTL_RATE_RADIOTAP;
+			}
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
-- 
1.6.0.4

