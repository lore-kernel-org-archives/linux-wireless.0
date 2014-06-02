Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:51331 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaFBUPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 16:15:37 -0400
Received: by mail-ob0-f176.google.com with SMTP id wo20so5041000obc.7
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2014 13:15:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrXLcOoXp33-y+M4PQfL7nf9G_wpfTRJiD26vsqCYD-v2Q@mail.gmail.com>
References: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com>
	<CANUX_P3NrA2GgZ-Nqgvk7do7Kzqa9kgjtpn4t9TuLKzhmqTqjQ@mail.gmail.com>
	<CALCETrX1s504Ej7sQV292NfHgrKrV-Wigk0GP7wo6GyALaM9xA@mail.gmail.com>
	<CANUX_P3jMcV=7stRtPAFZBJVG9bE10iTC0sRK_o-7vTxpy9+9w@mail.gmail.com>
	<CALCETrVPXwedhPGtDJQDSK5Kxa4NpeSDck4-nHyox_xriPBcZQ@mail.gmail.com>
	<CALCETrW0NQ6aW06WD6ZAi8-o7fZSiKPOf0xYCSEw2egYBfqyQQ@mail.gmail.com>
	<CALCETrUTsKCw_G7V=YDeP-v_GF8cK8ezY-wqcpxeuw3dzBQhQg@mail.gmail.com>
	<CANUX_P2_GZGhd7X4Ntzi5Jeng52i9Jam22DQTTU2akESPL1ffQ@mail.gmail.com>
	<CALCETrWdQwvMcgC=PESyECzkyMD8-vzjNEHOCkm5z=ENH7coHg@mail.gmail.com>
	<CANUX_P2AKnUvUyddsGC5JST51bbjpavG3X-VbJhS1Mf7fDNPcw@mail.gmail.com>
	<CALCETrX8Km4dc-XM4Ga8T7spDJzN00jx162A3iuTo5+NWhGTZg@mail.gmail.com>
	<CALCETrUHX3XB2+j5=3ULd9zMpDUisj3ZtK5JVuVS8Dh6088TTw@mail.gmail.com>
	<538CC508.3070707@gmail.com>
	<CALCETrVrPt4uKNC43nNB08iMA=vK7pM0choHNdB3ctT7RQuepQ@mail.gmail.com>
	<538CC827.6090408@gmail.com>
	<CALCETrXkhfvOGTo_31k-d9wkMW782aoz3YsJmzS-ApTePJH=Kg@mail.gmail.com>
	<CANUX_P0LV05kBRcjmfsJxFP6bSJ5Ge4Mr8ihzE_WD0nY9mxdAA@mail.gmail.com>
	<CALCETrXLcOoXp33-y+M4PQfL7nf9G_wpfTRJiD26vsqCYD-v2Q@mail.gmail.com>
Date: Mon, 2 Jun 2014 23:15:36 +0300
Message-ID: <CANUX_P17cDPvR0-NvhoHR4uVmay9DCX6++U6hZ-rQ3Wq=L0Mng@mail.gmail.com> (sfid-20140602_221541_846611_6A7A76E1)
Subject: Re: Help debugging iwldvm / ath10k stalls
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> If that's queue 4 in the debugfs tx_queues file, then I think that
>>> that's the queue that keeps moving when the card is dead.  I'll see if
>>> I can improve the tx_queues file to show pending updates.
>>>
>>> Yay troubleshooting old hardware.
>>>
>> If you plan to spend some time hacking on the code, please take into
>> account this code has been changed in 3.14 (mostly cleanups by
>> Johannes and myself).
>> Also note that long ago, I disabled shadow registers (you'll see ifs
>> all over the code). Shadow registers makes the whole wakup thing much
>> easier since it is handled internally in the HW. BUT we had tons of
>> issues with it so we disabled it. Most of the issues should have gone
>> away with the cmd_in_flight thing. So I would recommend you to give it
>> a try with shadow register enabled. Just check the relevant iwl-XXXX.c
>> file.
>
> Will do.
>
> FWIW, I looked at the cmd_in_flight thing and, unless there's a bunch
> of locking magic going on, it looks racy.  It seems like some code
> expects it to be protected by reg_lock, and other code expects it to
> be protected by txq_lock (and there are multiple txq->lock instances,
> I think).

:)
Yeah - there is lockdep magic there.
In any case, we set it when we enqueue and host command and clear it
when the last command is being responded.
When we set it, we request access, and vice versa.

>
> Also, what stops the card from going to sleep while processing a
> wakeup interrupt?  For example, what prevents this chain of events?
> The only thing I can see is that the only thing that clears ACCESS_REQ
> is the rx interrupt processing, which happens after wakeup processing,
> but this seems rather fragile.
>

As long as ACCESS_REQ isn't cleared, the NIC is awake. We set it when
we we want to wakeup the NIC.
I can't really find where we clear it right now, but I am half sleeping :)
