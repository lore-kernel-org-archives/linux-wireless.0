Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2855 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZGGDHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 23:07:36 -0400
Date: Mon, 6 Jul 2009 23:07:19 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jasin Colegrove <j.wholesalesupply@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
Message-ID: <20090707030719.GC7199@hash.localnet>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com> <6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com> <b6c5339f0907020836n6162e8b8k3c1a7a24c335ac41@mail.gmail.com> <6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com> <6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Colegrove<j.wholesalesupply@gmail.com> wrote:
> > Thanks bob for the reply. I did not mean to shout, but someone else
> > told me that I should make it very clear that I was not subscribed.
> > But, now I am so it doesn't matter :)

No worries, but whoever said that is wrong as far as vger.kernel.org
mailing lists go, as everyone just does reply-all.  (Also, top-posting
is frowned upon.)

> I have found the bad commit.

> $ git bisect good
> 1e3e6e8fe2f422f75619b1110f78bb638ae905b9 is first bad commit
> commit 1e3e6e8fe2f422f75619b1110f78bb638ae905b9
> Author: Nick Kossifidis <mick@madwifi-project.org>
> Date:   Mon Feb 9 06:15:42 2009 +0200
> 
>     ath5k: Disable BMISS interrupts

Hmm, so that's a pretty weird commit to end up with.  Can you
now try whatever your baseline kernel was, with just this patch
reverted and see if it works for you?

We don't actually do anything with BMISS yet so the only thing it
could do is slow down your computer.

Another possibility is that something happened between that
commit and your last good ath5k commit, elsewhere in the tree,
so a bisect would need to be done over the whole tree instead of
just the ath5k directory.

A third possibility is the issue comes and goes, or is timing
related, in which case bisection really isn't useful.

> Do you still think it would be wise to file a bug report for this
> issue. I have yet to try the latest compat-wireless.

Give 2.6.30.1 a shot as it includes a couple of fixes, otherwise
bugzilla is probably the best bet.

-- 
Bob Copeland %% www.bobcopeland.com

