Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:55030 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbXGHUhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 16:37:19 -0400
Date: Sun, 8 Jul 2007 22:37:17 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Andy Green <andy@warmcat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
Message-ID: <20070708203717.GA15957@deine-taler.de>
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org> <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de> <46910F3F.8010201@warmcat.com> <9e4733910707081142t43a85fb1y383ee8e1835c2842@mail.gmail.com> <469130E8.1010608@warmcat.com> <9e4733910707081204l490e99fcm6b8780f36ef8b9a8@mail.gmail.com> <46913846.9000007@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46913846.9000007@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-08 20:17 Andy Green wrote:

> Jon Smirl wrote:
> 
> >> It's not quite the same path Jon, I don't use wireshark at all just
> >> tcpdump.  Maybe it is zd1211rw-mac80211 -specific.
> > 
> > I can confirm. My BCM4318 is seeing all the packets.
> > My zd1211 is only seeing the directed/broadcast ones.
> > My rt2x00 is seeing all the packets.
> > 
> > All three devices are in the same machine and using the same mac80211
> > stack so it must be a driver issue with zd1211.
> 
> I can add iwl3945 to "sees all the expected stuff" (after a battle) list
> as well.
> 
> -Andy

I just wrote a patch, which forwards now all the received packets
on ZD1211. Right now no FCS checks are done, so you will see
suspicous packets with strange packets in Wireshark. However you
can see now also packets going to other devices.

I put the NULL pointer access on my TODO list.

Just look at:

http://deine-taler.de/git-bin/gitweb.cgi?p=zd1211rw.git;a=shortlog;h=zd1211rw-dev

or

git://deine-taler.de/git/zd1211rw.git -- branch zd1211rw-dev

-- 
Uli Kunitz
