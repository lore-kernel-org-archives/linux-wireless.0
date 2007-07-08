Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58910
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXGHW5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 18:57:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: Arrested Development
Date: Mon, 9 Jul 2007 00:55:55 +0200
Cc: Andy Green <andy@warmcat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jon Smirl <jonsmirl@gmail.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <468E5C33.2000102@warmcat.com> <46915B3C.6030609@warmcat.com> <20070708223829.GA18217@deine-taler.de>
In-Reply-To: <20070708223829.GA18217@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707090055.55974.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 July 2007 00:38:29 Ulrich Kunitz wrote:
> On 07-07-08 22:46 Andy Green wrote:
> 
> > > This isn't going to work properly when you add a sta interface and then
> > > a monitor interface, which afaict the driver doesn't prevent in
> > > zd_mac_open. Basically, it has the phy always follow the last-added
> > > virtual interface which doesn't seem right. Also, I might be missing
> > > something, but it shouldn't allow multiple sta interfaces, afaict it
> > > does now.
> > 
> > This is a bit of a general issue that has been discussed a couple of
> > times, not really to a resolution: how to deal with conflicting demands
> > of multiple interfaces on the same rx hardware.  I guess it wants it to
> > be that if any interface is in Monitor then the hardware promisc is
> > enabled.  IFF_PROMISC was discussed to be another way to select genuine
> > promisc rx as well.
> 
> > FWIW my script looks like this:
> > 
> >  modprobe -r zd1211rw-mac80211
> >  modprobe -r rc80211_simple
> >  modprobe -r mac80211
> >  modprobe zd1211rw-mac80211
> >  sleep 2s
> >  ifconfig wlan0 up
> >  echo -n mon0 >/sys/class/ieee80211/phy0/add_iface
> >  iwconfig mon0 mode monitor
> >  iwconfig mon0 channel 6
> >  ifconfig mon0 up
> 
> I forgot to mention that the monitor support doesn't work with
> additonal interfaces right now. Additional interfaces are broken
> currently for zd1211rw. I cannot fix all the problems with
> mac80211 interface of the driver at the same time.

What do you mean by "additional interface"?
Do you mean multiple STA interfaces? Does the zd hardware support
this? I'd say this is unlikely.

> The problem with the STA + MNTR interface is, that mac80211 must
> do the FCS checking for the STA interface or the driver has to
> filter them before forwarding them to the upper layer.

Well, it's not _that_ bad to forward frames with bad FCS in
monitor mode. Hey, it's monitor mode. We want to see what's
going on. ;) I'd say just push the corrupt frames upstream
and implement the FCS checking later.

-- 
Greetings Michael.
