Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:58793 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbYKZIHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 03:07:42 -0500
Received: by rv-out-0506.google.com with SMTP id k40so354997rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 00:07:41 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18733.827.276925.863029@localhost.localdomain> (sfid-20081126_090749_063637_D9F7208C)
Date: Wed, 26 Nov 2008 13:35:15 +0530
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Add frequency configuration (including HT40)
In-Reply-To: <20081126075507.GB31499@jm.kir.nu>
References: <20081125190533.GA27879@jm.kir.nu>
	<18732.54720.739365.435163@localhost.localdomain>
	<20081126075507.GB31499@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Wed, Nov 26, 2008 at 10:21:12AM +0530, Sujith wrote:
> > Jouni Malinen wrote:
> > > + * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
> > > + * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY_FREQ
> > > + *	if HT40 (40 MHz channels) are allowed:
> > > + *	NL80211_SEC_CHAN_BELOW = secondary channel is below the primary channel
> > > + *	NL80211_SEC_CHAN_ABOVE = secondary channel is above the primary channel
> > 
> > The driver needs to know if the selected channel is HT or not.
> > It receives only HT20/HT40+/HT40- flags, but a HT/non-HT flag is required too.
> 
> Yes, indeed. I added a new enum value for that:
> NL82011_SEC_CHAN_NO_HT = no HT (this is the default if
> 	NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET is not included)
> NL80211_SEC_CHAN_DISABLED = HT20 only
> NL80211_SEC_CHAN_BELOW = HT40-
> NL80211_SEC_CHAN_ABOVE = HT40+
> 
> The driver will then get hw.conf.ht.{enabled,sec_chan_offset} with the
> needed information.

That will work, thanks.

Sujith
