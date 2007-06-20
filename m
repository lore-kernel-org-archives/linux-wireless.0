Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321AbXFTCNU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 22:13:20 -0400
Subject: Re: [patch]mac80211: add support for iwlist channel
From: Hong Liu <hong.liu@intel.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070619105024.3c6c68e3@griffin.suse.cz>
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>
	 <20070619105024.3c6c68e3@griffin.suse.cz>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 10:10:25 +0800
Message-Id: <1182305425.19178.12.camel@napa-sdv1.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-06-19 at 10:50 +0200, Jiri Benc wrote:
> On Mon, 18 Jun 2007 16:47:05 +0800, Hong Liu wrote:
> > +static void ieee80211_get_supp_channels(struct ieee80211_local *local,
> > +				struct iw_range *range)
> > +{
> > +	struct ieee80211_hw_mode *mode = NULL;
> > +	int c = 0, j;
> > +
> > +	list_for_each_entry(mode, &local->modes_list, list) {
> > +		for (j = 0;
> > +		     j < mode->num_channels && c < IW_MAX_FREQUENCIES; j++) {
> > +			struct ieee80211_channel *chan = &mode->channels[j];
> > +
> > +			if (is_duplicate_channel(chan, range->freq, c))
> > +				continue;
> > +			range->freq[c].i = chan->chan;
> > +			range->freq[c].m = chan->freq * 100000;
> > +			range->freq[c].e = 1;
> > +			c++;
> > +		}
> 
> I don't know exactly what results are supposed to be returned by this
> ioctl, but given the fact SIOCSIWFREQ allows only channels with
> the IEEE80211_CHAN_W_SCAN flag set, shouldn't only channels with this
> flag be returned here?

> Thanks,
> 
>  Jiri
> 


What is the meaning of IEEE80211_CHAN_W_SCAN flag? I can't find any
description of this flag.

Thanks,
Hong
