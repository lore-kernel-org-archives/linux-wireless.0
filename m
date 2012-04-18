Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2DRB2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:28:42 -0400
Message-ID: <1334712476.3725.5.camel@jlt3.sipsolutions.net> (sfid-20120418_032844_750703_49C5B985)
Subject: Re: About rfkill racing issue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matt Chen <machen@suse.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, ath9k-devel@lists.ath9k.org
Date: Tue, 17 Apr 2012 18:27:56 -0700
In-Reply-To: <s5h7gxfpjjh.wl%tiwai@suse.de>
References: <CALx5=V_5XzAqddWRGzS4d-9MoHLV=abN2DOA-X7EtQ+78DBdzg@mail.gmail.com>
	 <4F8C5816.8070402@sipsolutions.net> <s5h7gxfpjjh.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The probblem we faced was that the hardware changes the hard rfkill
> _and_ sends the WLAN key at the same time.  Since the rfkill input
> handler toggles the soft rfkill at each WLAN key, if the rfkill
> state at boot is like
> 	hard: block
> 	soft: unblock
> then it'll change like
> 	hard: unblock
> 	soft: block
> so the WLAN is never activated.

Heh, funky.

> In the end, we fixed the problem by disabling the keymap for WLAN
> key.  But this is also assuming that BIOS does always rfkill.  If BIOS
> behavior suddenly changes, you'll loose the rfkill behavior.

Yeah, this is kinda dumb. But really it needs to be encapsulated in the
rfkill platform driver I think? Or is the WLAN key just a regular key on
the keyboard? Maybe the platform driver on this platform could bind it
and eat it?

> Also, another drawback is that now rfkill isn't triggered immediately
> with WLAN key but it waits for some seconds until hard block is
> polled.  Ideally, it'd be good if the rfkill hard state can be checked
> immediately when WLAN key is issued (but without touching soft
> block).

This has been talked about before I think, but I'm not sure it'd be good
generic behaviour?

johannes

