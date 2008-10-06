Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:5705 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYJFOMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 10:12:42 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2975063rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 07:12:39 -0700 (PDT)
Message-ID: <b6c5339f0810060712r24b0dfd8s6236e65304749572@mail.gmail.com> (sfid-20081006_161255_444381_9D467440)
Date: Mon, 6 Oct 2008 10:12:38 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Cc: toralf.foerster@gmx.de, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com
In-Reply-To: <877i8nky65.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <87od23mo08.fsf@denkblock.local>
	 <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	 <20081002144600.M31352@bobcopeland.com>
	 <87bpy32c1w.fsf@denkblock.local>
	 <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	 <20081003134648.M45120@bobcopeland.com>
	 <87fxnd2112.fsf@denkblock.local>
	 <20081003193739.M19356@bobcopeland.com>
	 <877i8nky65.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 5, 2008 at 8:45 AM, Elias Oltmanns <eo@nebensachen.de> wrote:
> "Bob Copeland" <me@bobcopeland.com> wrote:
> Well, I'm just not too sure about that. Please note that I'm not
> concerned about user space interfering too early in the resume process,
> which is indeed prevented by the freezer. It's rather that user space
> may initiate iface shutdown immediately before tasks are frozen and due
> to heavy load or other unfortunate circumstances the kernel doesn't get
> round to serve the request before suspend. When the system rsumes, the
> kernel completes the iface shutdown procedure by calling ath5k_init().

>From my reading of the code - kernel/power/process.c and kernel/power/main.c,
all the processes on the run queue (except PF_NOFREEZE tasks) should be
stopped before suspend_devices_and_enter is called, so even in your scenario,
it shouldn't be rescheduled until thaw_processes() in suspend_finish() is
called, at which point ->resume() has already happened.

Nonetheless, I admit not being expert in this area, nor do I know if relying
on the freezer is acceptable, so someone more clueful, please chime in.

Anyway, I don't really have any strong feelings either way, so I can post
an update that adds the reinit flag, then Jiri or Nick can take their pick :)
I probably won't get around to it until tonight, so if you want to go ahead
and prepare a patch, feel free.  I think the boolean arguments to _init and
_hw_stop should be symmetric though, so it's probably worth inverting the
sense of the boolean passed to _hw_stop in my previous patch.

-- 
Bob Copeland %% www.bobcopeland.com
