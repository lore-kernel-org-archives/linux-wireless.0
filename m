Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2002 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYJCTn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 15:43:58 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Date: Fri, 3 Oct 2008 15:43:33 -0400
Message-Id: <20081003193739.M19356@bobcopeland.com> (sfid-20081003_214403_081595_129160A6)
In-Reply-To: <87fxnd2112.fsf@denkblock.local>
References: <200808101401.03339.toralf.foerster@gmx.de> <200810012055.58085.toralf.foerster@gmx.de> <87ej30m376.fsf@denkblock.local> <b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com> <87ljx8ndw1.fsf@denkblock.local> <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com> <87od23mo08.fsf@denkblock.local> <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com> <20081002144600.M31352@bobcopeland.com> <87bpy32c1w.fsf@denkblock.local> <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com> <20081003134648.M45120@bobcopeland.com> <87fxnd2112.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 03 Oct 2008 16:42:17 +0200, Elias Oltmanns wrote
> I still feel uneasy about this. Granted, I haven't thought this through
> too carefully, but I'd rather not rely on the fact that ath5k_stop_hw()
> will not get called between the check for ATH_STAT_STARTED and the call
> to ath5k_init if I can help it. Perhaps you can add an argument `reinit'
> to ath5k_init() and do something like this under the mutex:
> 
> 	if (reinit && !test_bit(ATH_STAT_STARTED, sc->status)) {
> 		mutex_unlock(...);
> 		return;
> 	}

Shouldn't the freezer take care of this?  If userspace is suspended until
after devices are resumed, then, in a hand-wavy argument, I don't believe
->stop() could be called.  

Adding a flag to ath5k_init to make sure we do everything in the mutex would
certainly ensure that there's no issues.  On the other hand, I don't want to
cruft up the code too much since we know at some point mac80211 is going to
take down the interfaces in its suspend/resume callbacks, at which time the
flags can probably get tossed.

-- 
Bob Copeland %% www.bobcopeland.com


