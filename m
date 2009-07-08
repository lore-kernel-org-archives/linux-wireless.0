Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3450 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbZGHLnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 07:43:14 -0400
Date: Wed, 8 Jul 2009 07:42:52 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jasin Colegrove <j.wholesalesupply@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
Message-ID: <20090708114252.GG7199@hash.localnet>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com> <6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com> <b6c5339f0907020836n6162e8b8k3c1a7a24c335ac41@mail.gmail.com> <6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com> <6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com> <20090707030719.GC7199@hash.localnet> <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 08, 2009 at 02:58:11AM -0400, Jasin Colegrove wrote:
> I haven't tried this yet, but I started up gitk and realized that the
> last good commit was the one previous to the bad commit. They where
> made 3 minutes apart in the ath5k dir. So I am assuming that the
> "Disable BMISS interrupts was not actually at fault. It just doesn't
> seem logical now that i look at it.

Yeah, that commit is near some changes that might cause what you
are seeing though, so maybe you made a wrong turn along the way?
E.g. "ath5k: Update reset code" introduced a bug for RF 5413 chips,
maybe others.  Another possible change is the txpower rework.

BTW, can you (re?)post the "Atheros AR5212 chip found (MAC xxx,
PHY xxxx)?"

> So I started another bisect of drivers/net/. Is this the main tree you
> where talking about or do you think I need to go further into the main
> tree? If so, how far?

Also at least /net (you can add multiple paths to git bisect).  If 
you can narrow it down to a small range then a bisect over the entire
tree would eliminate any doubt, but in that case it's easier to make a
bisect mistake.  As you say, it does sound like a driver issue though.

> stellar results. Once again, downgrading to kernel .29 fixes
> everything without changing any of my other settings. I am still 110%
> positive this is a kernel module/driver issue. It does make sense, no?

Yeah, unfortunately I don't really have any good ideas, but I've seen
a trickle of similar reports so it would be good to nail it down.  Thanks
for testing, it really helps a lot.

-- 
Bob Copeland %% www.bobcopeland.com

