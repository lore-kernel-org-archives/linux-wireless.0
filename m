Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50293 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbbAUQrB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2015 11:47:01 -0500
Message-ID: <1421858816.1900.24.camel@sipsolutions.net> (sfid-20150121_174712_818975_B4D92BCE)
Subject: Re: [PATCH] mac80211: tell drivers the user TX power restriction
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, Avri Altman <avri.altman@intel.com>
Date: Wed, 21 Jan 2015 17:46:56 +0100
In-Reply-To: <54BEDBBA.2060305@broadcom.com>
References: <1421784945-7815-1-git-send-email-emmanuel.grumbach@intel.com>
	 <54BEDBBA.2060305@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-20 at 23:50 +0100, Arend van Spriel wrote:
> On 01/20/15 21:15, Emmanuel Grumbach wrote:
> > From: Avri Altman<avri.altman@intel.com>
> >
> > When a tx power restriction is set, mac80211 protects its downstream
> > stack by taking min(user, regulatory, 11h ap). However, we should allow
> > drivers to use that value as it is - on their own risk.
> > This might come handy, when tx power is set per phy. As mac80211 has
> > only a concept of "per-vif" tx power, it iterates over the active vifs,
> > and sets their tx power limit accordingly. Allowing this value to
> > proliferate downstream unchanged, the driver might use this legacy
> > api differently, e.g. to set tx power for the whole device.
> 
> Not sure if this really a good idea as default behaviour. Can't we do 
> this kind of stuff under some Kconfig. In cfg80211 we have the 
> CFG80211_CERTIFICATION_ONUS.

I don't think this is necessary. After all, it's added in a special
separate field that the driver author must evaluate how to use it.

In our case, it'll be used (by the driver and firmware) to limit scan TX
power appropriately, for example. Since scanning is done by the firmware
the TX power for the channel cannot be set by the driver, and if we
limit it to the calculated power limit for the (associated) vif then it
might be too low since you might be associated on a low channel.

But it doesn't have a direct effect on any driver not using it, so I
don't really see why it should be configurable?

johannes

