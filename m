Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34692 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYLOQYE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 11:24:04 -0500
Subject: Re: [PATCH] ath5k: set mac address in add_interface
From: Dan Williams <dcbw@redhat.com>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, maximlevitsky@gmail.com,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com>
References: <20081118044037.GA18983@hash.localnet>
	 <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com>
	 <1229357080.12163.47.camel@localhost.localdomain>
	 <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 15 Dec 2008 11:22:32 -0500
Message-Id: <1229358152.12163.64.camel@localhost.localdomain> (sfid-20081215_172407_494748_6BCE477C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-15 at 17:12 +0100, Stefanik G=C3=A1bor wrote:
> On Mon, Dec 15, 2008 at 5:04 PM, Dan Williams <dcbw@redhat.com> wrote=
:
> > On Mon, 2008-12-15 at 16:47 +0100, Stefanik G=C3=A1bor wrote:
> >> This patch regressed support for aireplay-ng's "fragmentation atta=
ck" feature!
> >>
> >> Prior to the landing of this patch (as commit
> >> caeb36d73b23b52a0ea2a8368502ef8230fa67b3), applying the patch @
> >> http://patches.aircrack-ng.org/mac80211_2.6.28-rc4-wl_frag+ack_v2.=
patch
> >> allowed aireplay-ng's fragmentation attack to work with almost all
> >> mac80211 drivers, including ath5k. After the landing of this patch=
,
> >> the attack fails with "No answer, repeating...". (Regression found
> >> using git bisect, and verified by local backout of commit
> >> caeb36d73b23b52a0ea2a8368502ef8230fa67b3.)
> >
> > Unless I misunderstand...  but not all drivers will report their MA=
C
> > address until they have opened the device (ie, add_interface time),
> > because not all devices load firmware until the interface is opened=
, and
> > thus some cannot read their MAC address until that time.
> >
> > So aireplay-ng is broken if it relies on the device having a valid =
mac
> > address before the device is opened.
> >
> > Dan
> >
>=20
> That is not the problem - aireplay-ng operates on a monitor interface
> that is already up. Likely this patch somehow misses monitor
> interfaces.

Ah, ok.  Ignore my mail then :)

dan


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
