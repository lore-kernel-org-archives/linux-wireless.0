Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:47693 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbYJEMqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 08:46:21 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "Bob Copeland" <me@bobcopeland.com>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
References: <200808101401.03339.toralf.foerster@gmx.de>
	<200810012055.58085.toralf.foerster@gmx.de>
	<87ej30m376.fsf@denkblock.local>
	<b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
	<87ljx8ndw1.fsf@denkblock.local>
	<b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
	<87od23mo08.fsf@denkblock.local>
	<b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	<20081002144600.M31352@bobcopeland.com>
	<87bpy32c1w.fsf@denkblock.local>
	<b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	<20081003134648.M45120@bobcopeland.com>
	<87fxnd2112.fsf@denkblock.local>
	<20081003193739.M19356@bobcopeland.com>
Date: Sun, 05 Oct 2008 14:45:54 +0200
In-Reply-To: <20081003193739.M19356@bobcopeland.com> (Bob Copeland's message
	of "Fri, 3 Oct 2008 15:43:33 -0400")
Message-ID: <877i8nky65.fsf@denkblock.local> (sfid-20081005_144625_756420_ABE8E090)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <me@bobcopeland.com> wrote:
> On Fri, 03 Oct 2008 16:42:17 +0200, Elias Oltmanns wrote
>> I still feel uneasy about this. Granted, I haven't thought this through
>
>> too carefully, but I'd rather not rely on the fact that ath5k_stop_hw()
>> will not get called between the check for ATH_STAT_STARTED and the call
>> to ath5k_init if I can help it. Perhaps you can add an argument `reinit'
>> to ath5k_init() and do something like this under the mutex:
>> 
>> 	if (reinit && !test_bit(ATH_STAT_STARTED, sc->status)) {
>> 		mutex_unlock(...);
>> 		return;
>> 	}
>
> Shouldn't the freezer take care of this?  If userspace is suspended until
> after devices are resumed, then, in a hand-wavy argument, I don't believe
> ->stop() could be called.  

Well, I'm just not too sure about that. Please note that I'm not
concerned about user space interfering too early in the resume process,
which is indeed prevented by the freezer. It's rather that user space
may initiate iface shutdown immediately before tasks are frozen and due
to heavy load or other unfortunate circumstances the kernel doesn't get
round to serve the request before suspend. When the system rsumes, the
kernel completes the iface shutdown procedure by calling ath5k_init().

>
> Adding a flag to ath5k_init to make sure we do everything in the mutex
>would
> certainly ensure that there's no issues.  On the other hand, I don't want to
> cruft up the code too much since we know at some point mac80211 is going to
> take down the interfaces in its suspend/resume callbacks, at which time the
> flags can probably get tossed.

ath5k_init() is declared statically, so I don't see why adding an
argument which may well be dropped again later should be too much
trouble.

Regards,

Elias
