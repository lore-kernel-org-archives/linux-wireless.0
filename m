Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab2DPReO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 13:34:14 -0400
Message-ID: <4F8C5816.8070402@sipsolutions.net> (sfid-20120416_193417_729714_402FC428)
Date: Mon, 16 Apr 2012 10:34:14 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Matt Chen <machen@suse.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, ath9k-devel@lists.ath9k.org,
	Takashi Iwai <tiwai@suse.de>
Subject: Re: About rfkill racing issue.
References: <CALx5=V_5XzAqddWRGzS4d-9MoHLV=abN2DOA-X7EtQ+78DBdzg@mail.gmail.com> (sfid-20120412_081533_107871_65FBA849)
In-Reply-To: <CALx5=V_5XzAqddWRGzS4d-9MoHLV=abN2DOA-X7EtQ+78DBdzg@mail.gmail.com> (sfid-20120412_081533_107871_65FBA849)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/11/2012 11:15 PM, Matt Chen wrote:
> Hi list,
> It is found by notebook that rfkill doesn't work very right. I don't
> know where to post this discussion, so I choose here to start the
> talk.
> Basically we found the input handler in net/rfkill/input.c , because
> the nature of stateless key events, it can only toggle the saved
> state.  This screws up when started as blocked at
> boot, as already suspected.
> Now we thought Synchronizing to the
> hard block state looks as if working, but it's also dangerous because
> the operation is racy. The hard block check on ath9k driver is done
> in a poll basis, for example. Thus, the polling might happen just
> before the key event is handled, and it might happen after the key
> event.
> Another option would be to get synchronize the soft block state at the
> driver initialization time.  But, this doesn't work always because we
> never know whether ther rfkill key event is generated.  The rfkill key
> event depends on BIOS. Thus, if we set the soft block as same as the
> hard block at the init time (and set as blocked), the soft block will
> be never unblocked if some BIOS version doesn't emit a key event.
>
> So we would like to discuss with the all experts here for this issue.
> Do you have a good idea to fix the rfkill for the issue ?

How is hard rfkill related to input handling? It shouldn't be.

I don't understand what you're saying I think.

johannes
