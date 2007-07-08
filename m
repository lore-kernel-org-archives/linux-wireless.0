Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:52042 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757111AbXGHVqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 17:46:40 -0400
Message-ID: <46915B3C.6030609@warmcat.com>
Date: Sun, 08 Jul 2007 22:46:36 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ulrich Kunitz <kune@deine-taler.de>,
	Jon Smirl <jonsmirl@gmail.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org>	 <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de>	 <46910F3F.8010201@warmcat.com>	 <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com>	 <469130E8.1010608@warmcat.com>	 <9e4733910707081204l490e99fcm6b8780f36ef8b9a8@mail.gmail.com>	 <46913846.9000007@warmcat.com>  <20070708203717.GA15957@deine-taler.de> <1183929814.3771.5.camel@johannes.berg>
In-Reply-To: <1183929814.3771.5.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2007-07-08 at 22:37 +0200, Ulrich Kunitz wrote:
> 
>> I just wrote a patch, which forwards now all the received packets
>> on ZD1211. Right now no FCS checks are done, so you will see
>> suspicous packets with strange packets in Wireshark. However you
>> can see now also packets going to other devices.

Thanks for the work Uli, but I couldn't get it to act any differently.
I didn't have the git-fu to magic your patchset on to wireless-dev, so I
tried it three ways, first trying to git clone your whole thing and
moving to the zd1211rw-dev branch ... but even when I was on that
branch, there was no drivers/net/wireless/mac80211 dir.

Then I tried taking a snapshot of the
drivers/net/wireless/mac80211/zd1211rw dir from the gitweb interface and
replacing it by hand using quilt, and lastly saving raw copies of your
17 patches and using quilt to put them on top of wireless-dev one by
one.  The last two methods worked okay but the resulting module didn't
act any differently in terms of what it picked up on Monitor mode.  I
confirmed it was the new module with md5sum.

> This isn't going to work properly when you add a sta interface and then
> a monitor interface, which afaict the driver doesn't prevent in
> zd_mac_open. Basically, it has the phy always follow the last-added
> virtual interface which doesn't seem right. Also, I might be missing
> something, but it shouldn't allow multiple sta interfaces, afaict it
> does now.

This is a bit of a general issue that has been discussed a couple of
times, not really to a resolution: how to deal with conflicting demands
of multiple interfaces on the same rx hardware.  I guess it wants it to
be that if any interface is in Monitor then the hardware promisc is
enabled.  IFF_PROMISC was discussed to be another way to select genuine
promisc rx as well.

FWIW my script looks like this:

 modprobe -r zd1211rw-mac80211
 modprobe -r rc80211_simple
 modprobe -r mac80211
 modprobe zd1211rw-mac80211
 sleep 2s
 ifconfig wlan0 up
 echo -n mon0 >/sys/class/ieee80211/phy0/add_iface
 iwconfig mon0 mode monitor
 iwconfig mon0 channel 6
 ifconfig mon0 up

-Andy
