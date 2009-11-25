Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51273 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZKYQpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 11:45:33 -0500
Date: Wed, 25 Nov 2009 11:43:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: RFC: mac80211: add ethtool support
Message-ID: <20091125164313.GE7800@tuxdriver.com>
References: <4B0D58EA.8060304@trash.net> <1259166692.32372.13.camel@johannes.local> <4B0D5C8F.3040005@trash.net> <1259167010.32372.14.camel@johannes.local> <4B0D5E8D.2070408@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B0D5E8D.2070408@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2009 at 05:42:53PM +0100, Patrick McHardy wrote:
> Johannes Berg wrote:
> > On Wed, 2009-11-25 at 17:34 +0100, Patrick McHardy wrote:
> >> Johannes Berg wrote:
> >>> On Wed, 2009-11-25 at 17:18 +0100, Patrick McHardy wrote:
> >>>>     mac80211: add ethtool support
> >>>>     
> >>>>     Add ethtool support and add a drvname field to struct ieee80211_ops, which is
> >>>>     used for ethtool driver information. This is useful with multiple different
> >>>>     wireless cards to find out which device is using which driver.
> >>>>     
> >>> I thought we _had_ ethtool support via cfg80211?!
> >> Mhh good point :) For some reason it didn't show any information, but
> >> that might have been a mistake on my part. I'll give it another shot :)
> > 
> > It probably won't show the driver name because we haven't pushed that
> > through in any way?
> 
> Its actually showing:
> 
> # ethtool -i wlan0
> Cannot get driver information: Operation not supported
> 
> which shouldn't happen, since the callback is defined. I'll
> have a closer look at this.

What kernel are you using?

[linville-t400.local]:> ethtool -i wlan0
driver: iwlagn
version: 2.6.32-rc8-wl
firmware-version: 8.24.2.12
bus-info: 0000:03:00.0

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
