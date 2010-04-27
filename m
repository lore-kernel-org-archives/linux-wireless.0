Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0D0GWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 02:22:50 -0400
Subject: Re: [PATCH 1/2] cfg80211: add ap isolation support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <x2i43e72e891004261853p751a5d5bt9cbb99846b2eb1fb@mail.gmail.com>
References: <1272324216-73349-1-git-send-email-nbd@openwrt.org>
	 <20100426232332.GA2079@tuxdriver.com> <4BD621FA.1000405@openwrt.org>
	 <20100427001233.GB2079@tuxdriver.com>
	 <t2i43e72e891004261725kdd3c1388jc2758db8a0b7e82@mail.gmail.com>
	 <k2y43e72e891004261834w1eb604d0q83f9cd80820e3d8@mail.gmail.com>
	 <4BD640F5.8010206@openwrt.org>
	 <x2i43e72e891004261853p751a5d5bt9cbb99846b2eb1fb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 08:22:41 +0200
Message-ID: <1272349361.3549.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 18:53 -0700, Luis R. Rodriguez wrote:

> >>>>> Yes, if you have an AP with lots of users that aren't expected to
> >>>>> communicate with each other (e.g. only for internet access), it can save
> >>>>> a lot of airtime by not forwarding every broadcast message emitted from
> >>>>> any station.
> >>>>> I'm sure there are a more situations where this can be useful.


> So the other way for an AP to forward traffic from STAs on the BSS to
> others is to transmit broadcast frames and the purpose of this patch
> is to disable that? If so can the description of the command be a
> little more descriptive about this? Perhaps annotating that other
> communication would not be done unless DLS links are created ?

The broadcast thing is a red herring. This applies also to unicast
frames sent between stations.

Basically what this patch does is restrict the network segment to each
station. You can send and receive multicast frames to/from the wired
network, but you would typically attach an AP like this to its own
network segment. And you can send/receive unicast frames, but not to
other stations on the AP. Or think of it as restricting the broadcast
domain. Or, another more expensive way to implement this would be to put
each station into its own VLAN (which should actually be feasible in
practice too).

johannes

