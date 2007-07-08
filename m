Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:53393 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646AbXGHWia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 18:38:30 -0400
Date: Mon, 9 Jul 2007 00:38:29 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Andy Green <andy@warmcat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jon Smirl <jonsmirl@gmail.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
Message-ID: <20070708223829.GA18217@deine-taler.de>
References: <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de> <46910F3F.8010201@warmcat.com> <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com> <469130E8.1010608@warmcat.com> <9e4733910707081204l490e99fcm6b8780f36ef8b9a8@mail.gmail.com> <46913846.9000007@warmcat.com> <20070708203717.GA15957@deine-taler.de> <1183929814.3771.5.camel@johannes.berg> <46915B3C.6030609@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46915B3C.6030609@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-08 22:46 Andy Green wrote:

> > This isn't going to work properly when you add a sta interface and then
> > a monitor interface, which afaict the driver doesn't prevent in
> > zd_mac_open. Basically, it has the phy always follow the last-added
> > virtual interface which doesn't seem right. Also, I might be missing
> > something, but it shouldn't allow multiple sta interfaces, afaict it
> > does now.
> 
> This is a bit of a general issue that has been discussed a couple of
> times, not really to a resolution: how to deal with conflicting demands
> of multiple interfaces on the same rx hardware.  I guess it wants it to
> be that if any interface is in Monitor then the hardware promisc is
> enabled.  IFF_PROMISC was discussed to be another way to select genuine
> promisc rx as well.

> FWIW my script looks like this:
> 
>  modprobe -r zd1211rw-mac80211
>  modprobe -r rc80211_simple
>  modprobe -r mac80211
>  modprobe zd1211rw-mac80211
>  sleep 2s
>  ifconfig wlan0 up
>  echo -n mon0 >/sys/class/ieee80211/phy0/add_iface
>  iwconfig mon0 mode monitor
>  iwconfig mon0 channel 6
>  ifconfig mon0 up

I forgot to mention that the monitor support doesn't work with
additonal interfaces right now. Additional interfaces are broken
currently for zd1211rw. I cannot fix all the problems with
mac80211 interface of the driver at the same time.

Try

iwconfig wlan0 mode monitor
ifconfig wlan0 up
iwconfig wlan0 channel 6

for now.

The problem with the STA + MNTR interface is, that mac80211 must
do the FCS checking for the STA interface or the driver has to
filter them before forwarding them to the upper layer.

-- 
Uli Kunitz
