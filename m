Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:50359 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYKVSV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 13:21:57 -0500
Date: Sat, 22 Nov 2008 20:20:51 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Report max TX power in NL80211_BAND_ATTR_FREQS
Message-ID: <20081122182051.GE4887@jm.kir.nu> (sfid-20081122_192205_648801_7254E6E3)
References: <20081121170130.GA4887@jm.kir.nu> <1227376464.3599.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227376464.3599.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 22, 2008 at 06:54:24PM +0100, Johannes Berg wrote:
> On Fri, 2008-11-21 at 19:01 +0200, Jouni Malinen wrote:
> >  
> > +			NLA_PUT_U8(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
> > +				   chan->max_power);
> > +
> 
> I think for consistency we should use the same format that the
> regulatory stuff has for NL80211_ATTR_POWER_RULE_MAX_EIRP, i.e. a u32
> value with mBm (I think)

Well.. Maximum TX power is stored as dBm and it is used as dBm in
Country IE. Some of the current uses of EIRP seem to be converting the
values between dBm and mBm, so it does not look like the extra accuracy
would be needed there. Why was mBm used in the first place? It does not
seem to be used anywhere outside Linux regulatory code as a standard
unit which makes it quite a bit less obvious than dBm..

I kind of agree with consistency being a good reason for a change here,
but I just find the mBm a bit odd choice as a unit unless there is need
for greater accuracy than 1 dBm (and in that case, the chan->max_power
value should likely be changed to use mBm, too).

-- 
Jouni Malinen                                            PGP id EFC895FA
