Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYAPPqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 10:46:03 -0500
Subject: [RFC] nl80211: export frequencies/bitrates
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 00:32:01 +0100
Message-Id: <1200439921.5887.148.camel@johannes.berg> (sfid-20080116_154610_863653_7F395C26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the user-space complement of the cfg80211 frequency/bitrate
patch and exports all the information via nl80211.

It obviously depends on the cfg80211 patch I've posted previously. I've
also committed support for printing this information to my 'iw' tool (I
still hope somebody will rewrite it some day and I don't have to
maintain it... the netlink code in it is really quite wrong too...).
Yell at me if I forget to push that changeset
(79f99b9ad89494fc81d5c966a32dcebe9742f12c "add wiphy dump capability")
to the git tree on git.sipsolutions.net (i.e. you don't see it shortly
after this mail.)

Luis, can you work with these attributes? I think they should be
sufficient for SET support as well for the regulatory daemon.

johannes

---
 include/linux/nl80211.h |   64 +++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+)

--- everything.orig/include/linux/nl80211.h	2008-01-10 16:32:44.315704861 +0100
+++ everything/include/linux/nl80211.h	2008-01-16 00:14:29.629294271 +0100
@@ -161,6 +161,9 @@ enum nl80211_commands {
  *	given for %NL80211_CMD_GET_STATION, nested attribute containing
  *	info as possible, see &enum nl80211_sta_stats.
  *
+ * @NL80211_ATTR_WIPHY_BANDS: Information about an operating bands,
+ *	consisting of a nested array.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -195,6 +198,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_STA_VLAN,
 	NL80211_ATTR_STA_STATS,
 
+	NL80211_ATTR_WIPHY_BANDS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -280,4 +285,63 @@ enum nl80211_sta_stats {
 	NL80211_STA_STAT_MAX = __NL80211_STA_STAT_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_band_attr - band attributes
+ * @__NL80211_BAND_ATTR_INVALID: attribute number 0 is reserved
+ * @NL80211_BAND_ATTR_FREQS: supported frequencies in this band,
+ *	an array of nested frequency attributes
+ * @NL80211_BAND_ATTR_RATES: supported bitrates in this band,
+ *	an array of nested bitrate attributes
+ */
+enum nl80211_band_attr {
+	__NL80211_BAND_ATTR_INVALID,
+	NL80211_BAND_ATTR_FREQS,
+	NL80211_BAND_ATTR_RATES,
+
+	/* keep last */
+	__NL80211_BAND_ATTR_AFTER_LAST,
+	NL80211_BAND_ATTR_MAX = __NL80211_BAND_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_frequency_attr - frequency attributes
+ * @NL80211_FREQUENCY_ATTR_FREQ: Frequency in MHz
+ * @NL80211_FREQUENCY_ATTR_DISABLED: Channel is disabled in current
+ *	regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_PASSIVE_SCAN: Only passive scanning is
+ *	permitted on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_NO_IBSS: IBSS networks are not permitted
+ *	on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_RADAR: Radar detection is mandatory
+ *	on this channel in current regulatory domain.
+ */
+enum nl80211_frequency_attr {
+	__NL80211_FREQUENCY_ATTR_INVALID,
+	NL80211_FREQUENCY_ATTR_FREQ,
+	NL80211_FREQUENCY_ATTR_DISABLED,
+	NL80211_FREQUENCY_ATTR_PASSIVE_SCAN,
+	NL80211_FREQUENCY_ATTR_NO_IBSS,
+	NL80211_FREQUENCY_ATTR_RADAR,
+
+	/* keep last */
+	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
+	NL80211_FREQUENCY_ATTR_MAX = __NL80211_FREQUENCY_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_bitrate_attr - bitrate attributes
+ * @NL80211_BITRATE_ATTR_RATE: Bitrate in units of 100 kbps
+ * @NL80211_BITRATE_ATTR_2GHZ_SHORTPREAMBLE: Short preamble supported
+ *	in 2.4 GHz band.
+ */
+enum nl80211_bitrate_attr {
+	__NL80211_BITRATE_ATTR_INVALID,
+	NL80211_BITRATE_ATTR_RATE,
+	NL80211_BITRATE_ATTR_2GHZ_SHORTPREAMBLE,
+
+	/* keep last */
+	__NL80211_BITRATE_ATTR_AFTER_LAST,
+	NL80211_BITRATE_ATTR_MAX = __NL80211_BITRATE_ATTR_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- everything.orig/net/wireless/nl80211.c	2008-01-15 23:25:02.119299425 +0100
+++ everything/net/wireless/nl80211.c	2008-01-16 00:17:36.069294434 +0100
@@ -98,6 +98,13 @@ static int nl80211_send_wiphy(struct sk_
 			      struct cfg80211_registered_device *dev)
 {
 	void *hdr;
+	struct nlattr *nl_bands, *nl_band;
+	struct nlattr *nl_freqs, *nl_freq;
+	struct nlattr *nl_rates, *nl_rate;
+	enum ieee80211_band band;
+	struct ieee80211_channel *chan;
+	struct ieee80211_rate *rate;
+	int i;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
@@ -105,6 +112,73 @@ static int nl80211_send_wiphy(struct sk_
 
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, dev->idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&dev->wiphy));
+
+	nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
+	if (!nl_bands)
+		goto nla_put_failure;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (!dev->wiphy.bands[band])
+			continue;
+
+		nl_band = nla_nest_start(msg, band);
+		if (!nl_band)
+			goto nla_put_failure;
+
+		/* add frequencies */
+		nl_freqs = nla_nest_start(msg, NL80211_BAND_ATTR_FREQS);
+		if (!nl_freqs)
+			goto nla_put_failure;
+
+		for (i = 0; i < dev->wiphy.bands[band]->n_channels; i++) {
+			nl_freq = nla_nest_start(msg, i);
+			if (!nl_freq)
+				goto nla_put_failure;
+
+			chan = &dev->wiphy.bands[band]->channels[i];
+			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,
+				    chan->center_freq);
+
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_DISABLED);
+			if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
+			if (chan->flags & IEEE80211_CHAN_NO_IBSS)
+				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
+			if (chan->flags & IEEE80211_CHAN_RADAR)
+				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
+
+			nla_nest_end(msg, nl_freq);
+		}
+
+		nla_nest_end(msg, nl_freqs);
+
+		/* add bitrates */
+		nl_rates = nla_nest_start(msg, NL80211_BAND_ATTR_RATES);
+		if (!nl_rates)
+			goto nla_put_failure;
+
+		for (i = 0; i < dev->wiphy.bands[band]->n_bitrates; i++) {
+			nl_rate = nla_nest_start(msg, i);
+			if (!nl_rate)
+				goto nla_put_failure;
+
+			rate = &dev->wiphy.bands[band]->bitrates[i];
+			NLA_PUT_U32(msg, NL80211_BITRATE_ATTR_RATE,
+				    rate->bitrate);
+			if (rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+				NLA_PUT_FLAG(msg,
+					NL80211_BITRATE_ATTR_2GHZ_SHORTPREAMBLE);
+
+			nla_nest_end(msg, nl_rate);
+		}
+
+		nla_nest_end(msg, nl_rates);
+
+		nla_nest_end(msg, nl_band);
+	}
+	nla_nest_end(msg, nl_bands);
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:


