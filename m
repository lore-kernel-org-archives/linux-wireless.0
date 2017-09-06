Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48210 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751675AbdIFH3n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 03:29:43 -0400
Message-ID: <1504682981.12380.28.camel@sipsolutions.net> (sfid-20170906_092950_317159_D68E1A08)
Subject: Re: [PATCH 06/10] cfg80211: honor NL80211_RRF_NO_HT40{MINUS,PLUS}
From: Johannes Berg <johannes@sipsolutions.net>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "luca@coelho.fi" <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Date: Wed, 06 Sep 2017 09:29:41 +0200
In-Reply-To: <1504630175.23076.5.camel@intel.com>
References: <20170805084438.12550-1-luca@coelho.fi>
         <20170805084438.12550-7-luca@coelho.fi>
         <1504621814.12380.23.camel@sipsolutions.net>
         <1504630175.23076.5.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-09-05 at 16:49 +0000, Grumbach, Emmanuel wrote:
> On Tue, 2017-09-05 at 16:30 +0200, Johannes Berg wrote:
> > On Sat, 2017-08-05 at 11:44 +0300, Luca Coelho wrote:
> > 
> > > +	regd = get_wiphy_regdom(wiphy);
> > > +	if (regd) {
> > > +		const struct ieee80211_reg_rule *reg_rule =
> > > +			freq_reg_info_regd(MHZ_TO_KHZ(channel-
> > > > center_freq),
> > > 
> > > +					   regd,
> > > MHZ_TO_KHZ(20));
> > > 
> > 
> > This could return an error, how can you be sure it doesn't?
> > 
> 
> Hm... so I guess I could check that it didn't return any error and if
> it did, then flags = 0?
> 
> Something like this? (on top of this patch):
> [snip]

yeah that's obviously the easy thing to do - I just wasn't sure that
you didn't have a reason to believe it could never be an ERR_PTR :)

johannes
