Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbXFQPZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2007 11:25:59 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
In-Reply-To: <1182019869.9058.57.camel@johannes.berg>
References: <20070611085950.GA5540@mail.intel.com>
	 <200706140935.50779.flamingice@sourmilk.net>
	 <1181996855.9058.39.camel@johannes.berg>
	 <200706161129.13782.flamingice@sourmilk.net>
	 <1182019869.9058.57.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 11:29:23 -0400
Message-Id: <1182094164.14209.18.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-06-16 at 20:51 +0200, Johannes Berg wrote:
> On Sat, 2007-06-16 at 11:29 -0700, Michael Wu wrote:
> 
> > I think that decision was made without much consideration to the 
> > implementation details. 
> 
> I don't think the implementation details are much of a problem. It's
> just a bit of message bouncing which is trivial. Except of course when
> you consider wext, but hey, no need to consider that for this discussion
> since you're proposing ditching wext completely. Not that I don't want
> to ditch it, but people still use it and probably will. Heck, people
> still use 'ifconfig'...
> 
> > I thought it was a good idea then, but passing 
> > messages from userspace to the kernel and then to userspace again is really a 
> > waste of time.
> 
> It's not happening a lot so it's not a waste of *much* time ;)
> 
> > NetworkManager already uses wpa_supplicant to avoid all the 
> > nasty details of dealing with wireless configuration, so why not keep using 
> > it for everything instead of hiding wpa_supplicant behind nl80211?
> 
> I hope that nm would start using nl80211 instead of talking to
> wpa_supplicant and just start wpa_supplicant if necessary. Or maybe some
> startup scripts start the userspace MLME (wpa_supplicant) for the
> interfaces during boot/hotplug.

NM uses wpa_supplicant for 3 basic things:

1) configuration of an 802.11 connection
2) getting scan results
3) WPA/802.1x

wpa_supplicant doesn't separate the configuration/setup of an interface
from the 802.1x stuff, mainly because it has to do things like derive
keys and push them down to the driver at specific times.  These two
functions are pretty intimately related.  And since NM needs WPA
support, it uses wpa_supplicant for the 802.1x/WPA stuff.  The only
stuff left is open & static WEP, which wpa_supplicant also handles.  So
it was a no-brainer to push all the wireless config to wpa_supplicant
and have NM just feed wpa_supplicant the config info.

NM now gets its scan results from wpa_supplicant because drivers used to
get (and some still do) very confused when multiple processes would
request scans and get results.  There was a nice race between
wpa_supplicant and NM in some drivers (airo in particular) where
wpa_supplicant would request a scan, and the driver would signal
results, but by the time NM saw the event and requested the results,
wpa_supplicant had already consumed them.  This was "fixed" by making
drivers age scan results like ipw2x00 over a number of scans and not
erasing them right away after the scan was done.

I like pushing most of the config stuff to wpa_supplicant, because that
basically means that all of that is in _one_ project.  When
nl80211/cfg80211 land and start getting adopted, that means that only
_one_ of {NM, wpa_supplicant} needs to get ported over, instead of two.

Dan

> > This is 
> > more simple and direct and allows the kernel to expose exactly what the 
> > hardware/kernel can do. Userspace won't have to change much and nl80211 won't 
> > have to support every possible thing a userspace MLME would want.
> 
> It's not that the kernel will have to support everything that a
> userspace MLME would want, but rather that the kernel needs to support
> everything the MLME would want, to support fullmac drivers.
> 
> Another counter: when you have a tool like 'iw' that David wrote, then
> it'll need to look for the userspace MLME every time you invoke it and
> start communicating with it instead of the kernel. That's likely a waste
> of much more time than just bouncing the messages.
> 
> johannes

