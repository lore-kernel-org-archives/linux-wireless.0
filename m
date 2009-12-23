Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13562 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300AbZLWQZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 11:25:49 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 08:25:49 -0800
Date: Wed, 23 Dec 2009 08:25:47 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith Manoharan <Sujith.Manoharan@Atheros.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner
 case
Message-ID: <20091223162547.GA2609@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
 <19248.19829.293087.367661@gargle.gargle.HOWL>
 <20091222155005.GA4385@tux>
 <20091222162055.GC4385@tux>
 <20091222165528.GE4385@tux>
 <20091222175939.GF4385@tux>
 <19249.32885.877602.60242@gargle.gargle.HOWL>
 <43e72e890912221840g7840cfafj559b1919e4dd5f19@mail.gmail.com>
 <19249.37602.503319.979981@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19249.37602.503319.979981@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 07:47:46PM -0800, Sujith Manoharan wrote:
> Luis R. Rodriguez wrote:
> > On Tue, Dec 22, 2009 at 6:29 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> > > Luis Rodriguez wrote:
> > >> I just tried adding the PM stuff over ath9k_remove_interface and I still get the
> > >> issue. The patch is below.
> > >
> > > The HW is not accessed in ->remove_interface(), so this patch is not necessary.
> >
> > How about when remove_interface calls ath9k_hw_stoptxdma() ?
> 
> Yep, that is correct - but it should not affect here since we are in managed
> mode.

Yeah good point, but its still correct to add that then.

  Luis
