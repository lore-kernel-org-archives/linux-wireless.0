Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:50428 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbYJBQcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 12:32:21 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "Bob Copeland" <me@bobcopeland.com>
Cc: jirislaby@gmail.com, mickflemm@gmail.com,
	johannes@sipsolutions.net, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
In-Reply-To: <20081002144600.M31352@bobcopeland.com> (Bob Copeland's message
	of "Thu, 2 Oct 2008 11:02:02 -0400")
References: <200808101401.03339.toralf.foerster@gmx.de>
	<b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	<200810012055.58085.toralf.foerster@gmx.de>
	<87ej30m376.fsf@denkblock.local>
	<b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
	<87ljx8ndw1.fsf@denkblock.local>
	<b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
	<87od23mo08.fsf@denkblock.local>
	<b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	<20081002144600.M31352@bobcopeland.com>
Date: Thu, 02 Oct 2008 18:31:55 +0200
Message-ID: <87bpy32c1w.fsf@denkblock.local> (sfid-20081002_183226_225680_7E94C27C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <me@bobcopeland.com> wrote:
> On Thu, 2 Oct 2008 08:52:58 -0400, Bob Copeland wrote
>> > Not sure I agree there. Why should calibration take place regularly even
>
>> > though the interface appears to be shut down from user-space's point of
>> > view? It simply doesn't make sense  to start the interface if nobody
>> > intends to use it.
>> 
>> Hmm, yeah, you're right.  So, I guess we can just do your patch except
>> with another status bit that says it's active instead of changing
>> mac80211 (b43 does something along those lines).
>
> Something like this?  It's kind of ugly, but the state bit needs
> to be in the _init/_stop critical section to avoid the race there.
> This makes it match other drivers' suspend methods, but is only a 
> stop-gap until we have mac80211 suspend callbacks.
>
> Jiri, Nick, any comments?  
>
> Based on a patch by Elias Oltmanns.  We call ath5k_init in resume even
> if we didn't previously open the device.  Besides starting up the
> device unnecessarily, this also causes an OOPS on rmmod because
> mac80211 will not invoke ath5k_stop and softirqs are left running after
> the module has been unloaded.  Add a new state bit, ATH5K_STAT_STARTED,
> to indicate that we have been started up.

Sorry, but I don't think this is safe. Checking and restoring the
started flag has to be protected too, otherwise there can be races
against ->stop().

Regards,

Elias
