Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbXFUBqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 21:46:32 -0400
Subject: Re: [patch]mac80211: add support for iwlist channel
From: Hong Liu <hong.liu@intel.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <200706200008.47770.flamingice@sourmilk.net>
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>
	 <200706182212.55862.flamingice@sourmilk.net>
	 <1182308588.19178.17.camel@napa-sdv1.sh.intel.com>
	 <200706200008.47770.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 09:43:31 +0800
Message-Id: <1182390211.27548.3.camel@napa-sdv1.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-06-20 at 00:08 -0700, Michael Wu wrote:
> On Tuesday 19 June 2007 20:03, Hong Liu wrote:
> > +	struct ieee80211_hw_mode *mode = NULL;
> > +	int c = 0;
> > +
> Shouldn't add an extra empty line here.
> 
> > +			if (chan->flag & IEEE80211_CHAN_W_SCAN) {
> > +				range->freq[c].i = chan->chan;
> > +				range->freq[c].m = chan->freq * 100000;
> > +				range->freq[c].e = 1;
> > +			}
> > +			++j; ++c;
> c shouldn't be incremented if the channel is being skipped.
> 

Oh, silly mistake. Thanks for pointing it out.

Thanks,
Hong

> Also, two minor comments on the style since this patch needs to be revised 
> anyway - using ++x instead of x++ looks a bit odd, and using 'int j' 
> when 'int i' is available is also a little strange.
> 
> Patch looks good otherwise.
> 
> -Michael Wu
