Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYERNkl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 09:40:41 -0400
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	netdev <netdev@vger.kernel.org>, Jean Tourrilhes <jt@hpl.hp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1211032475.6252.2.camel@johannes.berg>
References: <1211026337.3827.25.camel@johannes.berg>
	 <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org>
	 (sfid-20080517_154639_384202_6D3479C2)  <1211032475.6252.2.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 18 May 2008 09:36:35 -0400
Message-Id: <1211117795.686.15.camel@localhost.localdomain> (sfid-20080518_154119_284851_552B3A25)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-17 at 15:54 +0200, Johannes Berg wrote:
> On Sat, 2008-05-17 at 15:45 +0200, Marcel Holtmann wrote:
> > Hi Johannes,
> > 
> > > The /sys/class/net/*/wireless/ direcory is, as far as I know, not
> > > used by anyone. Additionally, the same data is available via wext
> > > ioctls. Hence the sysfs files are pretty much useless. This patch
> > > makes them optional and schedules them for removal.
> > 
> > it is used by HAL to classify WiFi network cards as net.80211 instead  
> > of net.80203 and so we do have an actual user. However HAL only tests  
> > for the existence of the directory wireless/.
> 
> Oh, ok, I didn't know that, thanks.
> 
> > Please fix HAL first before submitting such a patch.
> 
> Sure, I'll take a look at that.

Instead of testing for wireless/, best thing would probably be to call
SIOCGIWRANGE on the device and if it returns EOPNOTSUP then it's not
wireless.  Some drivers may have to load firmware to figure out
supported rates and encryption capabilities, but to be honest, NM does
this to detect wireless devices and I haven't run into any issues in 4
years using it.  If there are issues with drivers, then we need to fix
the driver too.

dan

