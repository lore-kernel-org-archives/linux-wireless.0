Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.solarflare.com ([216.237.3.220]:56205 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754788Ab2DLTa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 15:30:57 -0400
Message-ID: <1334259053.2497.18.camel@bwh-desktop.uk.solarflarecom.com> (sfid-20120412_213102_078282_0434059F)
Subject: Re: [PATCH 4/5] mac80211: Add more ethtools stats: survey, rates,
 etc
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ben Greear <greearb@candelatech.com>
CC: Florian Fainelli <florian@openwrt.org>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Date: Thu, 12 Apr 2012 20:30:53 +0100
In-Reply-To: <4F870828.4020708@candelatech.com>
References: <1334248375-22967-1-git-send-email-greearb@candelatech.com>
	 <1334248375-22967-5-git-send-email-greearb@candelatech.com>
	 <4F8705E3.2010902@openwrt.org> <4F870828.4020708@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-12 at 09:51 -0700, Ben Greear wrote:
> On 04/12/2012 09:42 AM, Florian Fainelli wrote:
> > Hi,
> >
> > Le 04/12/12 18:32, greearb@candelatech.com a écrit :
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> The signal and noise are forced to be positive since ethtool
> >> deals in unsigned 64-bit values and this number should be human
> >> readable. This gives easy access to some of the data formerly
> >> exposed in the deprecated /proc/net/wireless file.
> >
> > Uh, that's misleading, the signal and noise values are typically negative, so one needs to think about mentally adding a minus sign if he/she wants to
> > understand it. Does not ethtool know about 32-bits signed integers?
> 
> Ethtool stats only supports u64.  I think it's easy enough for
> humans or programs to add the negative sign.  Can signal or noise
> ever be > 0?  If so, that could actually break something that depends
> on flipping the value to negative....

So far as I can see, the ethtool stats were expected to be counters,
which obviously cannot become negative (or fractional).  Maybe it's time
to define another command and string-set to cover other types of status
information.  The ethtool utility could ask for those typed statistics
as well, so 'ethtool -S' would get all of them.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

