Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33702 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbcDFQqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 12:46:48 -0400
Received: by mail-lf0-f48.google.com with SMTP id e190so36450733lfe.0
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 09:46:47 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: Re: [Make-wifi-fast] [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <CA+BoTQmTviPfR-xsKB2gNa_epVJJ1JO4Ke=sKt27Xefn=OAQuw@mail.gmail.com>
Date: Wed, 6 Apr 2016 19:46:11 +0300
Cc: Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	codel@lists.bufferbloat.net
Message-Id: <F3D2A3B0-0BFB-4907-8B3C-9FA7A76CE6B9@gmail.com> (sfid-20160406_184652_080835_9D6DB365)
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com> <1459420104-31554-1-git-send-email-michal.kazior@tieto.com> <1459420104-31554-2-git-send-email-michal.kazior@tieto.com> <1459864656.18188.60.camel@sipsolutions.net> <CA+BoTQmkGhyPGRuT8GJOfdYyGGckZZA0JMZF+G3uk8KGAwLKvg@mail.gmail.com> <2233FCEB-7412-4F22-B262-068AFBB2FDCB@gmail.com> <CA+BoTQmTviPfR-xsKB2gNa_epVJJ1JO4Ke=sKt27Xefn=OAQuw@mail.gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On 6 Apr, 2016, at 10:16, Michal Kazior <michal.kazior@tieto.com> wrote:
> 
> When a driver asks mac80211 to dequeue given txq it implies a
> destination station as well. This is important because 802.11
> aggregation can be performed only on groups of packets going to a
> single station on a single tid.
> 
> Cake - as I understand it - doesn't really *guarantee* maintaining
> this. Keep in mind you can run with hundreds of stations connected.
> 
> You don't really want to burden drivers with sorting this grouping up
> themselves (and hence coerce them into introducing another level of
> intermediate queues, bis).

Well, no.  Cake isn’t designed to maintain per-station queues explicitly, though it does have support for stochastic fairness between hosts.  It is also blissfuly unaware of the requirements of wifi aggregation, largely because the standard qdisc interface is likewise ignorant.  I’m therefore not suggesting that you use Cake as-is.

What I’m pointing at instead is the set-associative hash, which could easily be tweaked to put greater emphasis on avoiding putting multiple stations’ traffic in one queue, while maintaining the performance benefits of a fixed queue pool indexed by a hash table, and an extended operating region in which flow isolation is maintained.  You can then have a linked-list of queues assigned to a particular station, so that when a packet for a particular station is requested, you can easily locate one.

I hadn’t appreciated, though, that the TXQ struct was station-specific.  This wasn’t obvious from the code fragments posted, so it looked like packets that incurred hash collisions would be dumped into a single overflow queue.

 - Jonathan Morton

