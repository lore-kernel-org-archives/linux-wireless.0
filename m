Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38974 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3EHWpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 18:45:11 -0400
Received: by mail-wi0-f178.google.com with SMTP id hm14so2466742wib.17
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 15:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518A784A.6040704@candelatech.com>
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de>
	<517D1B45.9020302@openwrt.org>
	<517D3840.2060000@candelatech.com>
	<517D3B50.6070806@openwrt.org>
	<20873.58246.410990.985421@gargle.gargle.HOWL>
	<518A784A.6040704@candelatech.com>
Date: Wed, 8 May 2013 15:45:10 -0700
Message-ID: <CAJ-VmomWu2LD253YQ9Xy9bZzXCHNSAw27oahoi5tY_DyjGcpxQ@mail.gmail.com> (sfid-20130509_004518_028008_2BD8C40A)
Subject: Re: [ath9k-devel] [PATCH RFC] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 May 2013 09:07, Ben Greear <greearb@candelatech.com> wrote:

> I think it's good to keep global counters too..otherwise it is going to be
> a lot of work to gather per NIC stats, and since you would have to read for
> each
> station, your stats might not be quite as atomic as they used to be.
>
> But, I'm fine with adding per-station counters on top of the global
> stats.

As a reference point, one of my in-progress hacks in FreeBSD is to add
some macros to the ath(4) driver to keep per-state and global stats,
using the same sample pointers.

So, a macro would look like this:

ATH_STAT_INC(sc, ath_node, stat_name, 1);

* if I've enabled global stat counting, the sc->sc_stats.sc_stat_name
stat would be bumped.
* if I've enabled node stat counting, the
ath_node->an_stats.an_stat_name would be bumped.

I have similar ideas with net80211 - right now there's some per-node
stats, but lots of stats are per-VAP. I'm going to do the same thing -
take the vap and the node as part of the stat macro, and bump the
per-node and per-VAP stats. Again, leaving it as a build-time option.

I've found both global device / VAP stats _and_ per-node stats equally
useful for debugging. They're good for debugging different sets of
issues - I use the global stats for figuring out what is breaking
things, and I use the per-node stats to try and understand how the AP
is "viewing" a particular station, separate from all the other
stations currently chatting.

Stats are hard. Let's go shopping. :-)



Adrian



Adrian
