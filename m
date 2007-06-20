Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5226 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758927AbXFTDGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 23:06:05 -0400
Subject: Re: [patch]mac80211: add support for iwlist channel
From: Hong Liu <hong.liu@intel.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <200706182212.55862.flamingice@sourmilk.net>
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>
	 <200706182212.55862.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 11:03:08 +0800
Message-Id: <1182308588.19178.17.camel@napa-sdv1.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2nd try!

Add supported channels info in SIOCGIWRANGE implementation.

Signed-off-by: Hong Liu <hong.liu@intel.com>

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index fcea8b2..3c09a93 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1500,6 +1500,9 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iw_range *range = (struct iw_range *) extra;
+	struct ieee80211_hw_mode *mode = NULL;
+	int c = 0;
+
 
 	data->length = sizeof(struct iw_range);
 	memset(range, 0, sizeof(struct iw_range));
@@ -1533,6 +1536,28 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
+	list_for_each_entry(mode, &local->modes_list, list) {
+		int j = 0;
+
+		if (!(local->enabled_modes & (1 << mode->mode)) ||
+		     (local->hw_modes & local->enabled_modes &
+		      (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
+			continue;
+
+		while (j < mode->num_channels && c < IW_MAX_FREQUENCIES) {
+			struct ieee80211_channel *chan = &mode->channels[j];
+
+			if (chan->flag & IEEE80211_CHAN_W_SCAN) {
+				range->freq[c].i = chan->chan;
+				range->freq[c].m = chan->freq * 100000;
+				range->freq[c].e = 1;
+			}
+			++j; ++c;
+		}
+	}
+	range->num_channels = c;
+	range->num_frequency = c;
+
 	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWTHRSPY);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);



On Mon, 2007-06-18 at 22:12 -0700, Michael Wu wrote:
> On Monday 18 June 2007 01:47, Hong Liu wrote:
> > +static int is_duplicate_channel(struct ieee80211_channel *chan,
> > +				struct iw_freq *freq, int count)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < count; i++, freq++)
> > +		if (chan->chan == freq->i)
> > +			return 1;
> > +
> > +	return 0;
> > +}
> > +
> Currently, the only situation in which channels are duplicated is when there's 
> an 11g mode registered. The scanning code in ieee80211_sta.c 
> (ieee80211_sta_scan_work) checks for this specifically:
> 
> (local->hw_modes & local->enabled_modes & (1 << MODE_IEEE80211G) &&
>  mode->mode == MODE_IEEE80211B)
> 
> MODE_IEEE80211B is skipped if MODE_IEEE80211G is enabled. Modes should be 
> skipped instead of channels.
> 
> > +static void ieee80211_get_supp_channels(struct ieee80211_local *local,
> > +				struct iw_range *range)
> > +{
> > +	struct ieee80211_hw_mode *mode = NULL;
> > +	int c = 0, j;
> > +
> > +	list_for_each_entry(mode, &local->modes_list, list) {
> > +		for (j = 0;
> > +		     j < mode->num_channels && c < IW_MAX_FREQUENCIES; j++) {
> This looks somewhat awkward. How about something like:
> 
> int j = 0;
> (check if this mode is disabled or duplicates channels here)
> while (j++ < mode->num_channels && c++ < IW_MAX_FREQUENCIES) {
> 
> > +			struct ieee80211_channel *chan = &mode->channels[j];
> > +
> > +			if (is_duplicate_channel(chan, range->freq, c))
> > +				continue;
> > +			range->freq[c].i = chan->chan;
> > +			range->freq[c].m = chan->freq * 100000;
> > +			range->freq[c].e = 1;
> > +			c++;
> > +		}
> > +	}
> > +	range->num_channels = c;
> > +	range->num_frequency = c;
> > +}
> >
> >  static int ieee80211_ioctl_giwrange(struct net_device *dev,
> >  				 struct iw_request_info *info,
> > @@ -1533,6 +1567,8 @@ static int ieee80211_ioctl_giwrange(struct net_device
> > *dev, range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
> >  			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
> >
> > +	ieee80211_get_supp_channels(local, range);
> > +
> Should be fine to just put all the logic here. No other code will use that 
> function.
> 
> -Michael Wu
