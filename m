Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46660 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZDYKaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 06:30:13 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] ar9170: handle otus' A-MPDU density definitions
Date: Sat, 25 Apr 2009 12:30:10 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <200904242135.57861.chunkeey@web.de> <1240645349.18031.52.camel@johannes.local>
In-Reply-To: <1240645349.18031.52.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200904251230.10689.chunkeey@web.de> (sfid-20090425_123030_446057_10C48021)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 April 2009 09:42:29 Johannes Berg wrote:
> On Fri, 2009-04-24 at 21:35 +0200, Christian Lamparter wrote:
> > +	.ampdu_factor	= 3,						\
> > +	.ampdu_density	= 6,						\
> 
> FWIW, I also tried some varying values. This should indicate what you're
> able to receive though, not what you're able to transmit since you
> control that anyway.
yeah... in fact the _correct_ value according to otus is 0 (unrestricted),
however that's a bit hard to believe... and ath9k's (not the same
mac... I know) default works rather well.
[I see about 65 Mbits sustainable throughput and peaks in the lower 80.]

> I think we currently don't have a setting though for what to transmit with...
> this might need to be added somewhere depending on the RA.
well, there should be a table or some bits in phy_control for this purpose...
But it looks like otus only has this single MAC knob and the safest setting
otus allows is 7 = 8us... 

of course it would be nice if ieee80211_bss_ht_conf in bss_conf, could be
replaced by ieee80211_sta_ht_cap which has the necessary elements.

after all this chip was designed as a client adapter, so there's no need 
to handle multiple a-mpdu density at the same time... 

Regards,
	Chr
