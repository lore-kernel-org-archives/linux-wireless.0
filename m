Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbZFIVoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 17:44:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ME97G-0000Ad-Ne
	for linux-wireless@vger.kernel.org; Tue, 09 Jun 2009 23:44:22 +0200
Subject: [RFC] mac80211: disconnect when user changes channel
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 23:43:53 +0200
Message-Id: <1244583833.18481.44.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we do not disconnect when a channel switch is requested,
we end up eventually detection beacon loss from the AP and
then disconnecting, without ever really telling the AP, so
we might just as well disconnect right away.

Additionally, this fixes a problem with iwlwifi where the
driver will clear some internal state on channel changes
like this and then get confused when we actually go clear
that state from mac80211.

It may look like this patch drops the no-IBSS check, but
that is already handled by cfg80211 in the wext handler it
provides for IBSS (cfg80211_ibss_wext_siwfreq).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/mlme.c        |    5 ++++-
 net/mac80211/util.c        |   25 -------------------------
 net/mac80211/wext.c        |   28 ++++++++++++++++++++++++----
 4 files changed, 28 insertions(+), 31 deletions(-)

--- wireless-testing.orig/net/mac80211/util.c	2009-06-09 23:14:10.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-06-09 23:23:04.000000000 +0200
@@ -774,31 +774,6 @@ void ieee80211_tx_skb(struct ieee80211_s
 	dev_queue_xmit(skb);
 }
 
-int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
-{
-	int ret = -EINVAL;
-	struct ieee80211_channel *chan;
-	struct ieee80211_local *local = sdata->local;
-
-	chan = ieee80211_get_channel(local->hw.wiphy, freqMHz);
-
-	if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
-		if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-		    chan->flags & IEEE80211_CHAN_NO_IBSS)
-			return ret;
-		local->oper_channel = chan;
-		local->oper_channel_type = NL80211_CHAN_NO_HT;
-
-		if (local->sw_scanning || local->hw_scanning)
-			ret = 0;
-		else
-			ret = ieee80211_hw_config(
-				local, IEEE80211_CONF_CHANGE_CHANNEL);
-	}
-
-	return ret;
-}
-
 u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band)
 {
--- wireless-testing.orig/net/mac80211/wext.c	2009-06-09 23:14:00.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-06-09 23:42:11.000000000 +0200
@@ -55,6 +55,8 @@ static int ieee80211_ioctl_siwfreq(struc
 				   struct iw_freq *freq, char *extra)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel *chan;
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
@@ -69,17 +71,35 @@ static int ieee80211_ioctl_siwfreq(struc
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;
 		} else
-			return ieee80211_set_freq(sdata,
+			chan = ieee80211_get_channel(local->hw.wiphy,
 				ieee80211_channel_to_frequency(freq->m));
 	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)
 			div /= 10;
-		if (div > 0)
-			return ieee80211_set_freq(sdata, freq->m / div);
-		else
+		if (div <= 0)
 			return -EINVAL;
+		chan = ieee80211_get_channel(local->hw.wiphy, freq->m / div);
 	}
+
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		return -EINVAL;
+
+	/*
+	 * no change except maybe auto -> fixed, ignore the HT
+	 * setting so you can fix a channel you're on already
+	 */
+	if (local->oper_channel == chan)
+		return 0;
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		ieee80211_sta_req_auth(sdata);
+
+	local->oper_channel = chan;
+	local->oper_channel_type = NL80211_CHAN_NO_HT;
+	ieee80211_hw_config(local, 0);
+
+	return 0;
 }
 
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-06-09 23:23:09.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-06-09 23:23:13.000000000 +0200
@@ -1100,7 +1100,6 @@ void ieee802_11_parse_elems(u8 *start, s
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
-int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band);
 
--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-09 23:22:24.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-06-09 23:22:59.000000000 +0200
@@ -2204,7 +2204,10 @@ static int ieee80211_sta_config_auth(str
 				       capa_mask, capa_val);
 
 	if (bss) {
-		ieee80211_set_freq(sdata, bss->cbss.channel->center_freq);
+		local->oper_channel = bss->cbss.channel;
+		local->oper_channel_type = NL80211_CHAN_NO_HT;
+		ieee80211_hw_config(local, 0);
+
 		if (!(ifmgd->flags & IEEE80211_STA_SSID_SET))
 			ieee80211_sta_set_ssid(sdata, bss->ssid,
 					       bss->ssid_len);


