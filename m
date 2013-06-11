Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3FKPOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 11:14:17 -0400
Message-ID: <1370963652.8356.51.camel@jlt4.sipsolutions.net> (sfid-20130611_171420_869279_68F7C4E1)
Subject: Re: [RFC 4/5] mac80211: enforce address verification on monitors
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub =?UTF-8?Q?Kici=C5=84ski?= <moorray3@wp.pl>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	nietrywialneprzejscie@gmail.com
Date: Tue, 11 Jun 2013 17:14:12 +0200
In-Reply-To: <20130611150129.0413f67d@north>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
	 <1370612179-24385-5-git-send-email-moorray3@wp.pl>
	 <51B1E4F3.9020509@openwrt.org> <20130607160402.49ea16c3@north>
	 <51B1EDA8.10406@openwrt.org> <20130607184210.200dbb52@north>
	 <1370951175.8356.17.camel@jlt4.sipsolutions.net>
	 <20130611150129.0413f67d@north>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I think we should "just" move ieee80211_verify_mac() into do_open().
> > Semantically anyway, I'm clearly handwaving a bit. But I would argue
> > that you can set any MAC address that you like, as long as you don't
> > bring the interface up, hence the verification really shouldn't be done
> > when you assign the address but when you bring it up.
> 
> I've considered this initially. Two reasons that made me
> think the current approach is cleaner are:
>  - it's nice when user gets the error during the action that
>    puts system in inconsistent state not some time later. I
>    personally hate to get vague EBUSY and have to figure out
>    what's wrong.
>  - suppose there are two interfaces, both down with
>    incompatible addresses. User adds third ifc, what address
>    should we assign to it?

Right now you can assign the same addresses to multiple interfaces and
then you can't bring them up. This happens for example if there are no
more addresses to assign.

> Besides who would care what address does passive monitor
> have? ;)

Well those obviously don't matter, which is really the problem here, no?

> > address mask: 00:00:00:00:00:03
> > wlan0: 02:00:00:00:00:00
> > wlan1: 02:00:00:00:00:01
> >
> > Now you want to change to
> > wlan0: 03:00:00:00:00:00
> > wlan1: 03:00:00:00:00:01
> >
> > It seems that right now you can't do this at all, which also seems
> > wrong.
> 
> Right but I believe user would understand what is the problem
> here and just remove and recreate one of the interfaces. They
> have to be down to change MAC addr anyway.

Dunno, you could also argue the other way around, that since they're
down the MAC address really shouldn't matter at all...

johannes

