Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:34083 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaFBT5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 15:57:55 -0400
Received: by mail-vc0-f169.google.com with SMTP id il7so2016804vcb.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2014 12:57:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0LV05kBRcjmfsJxFP6bSJ5Ge4Mr8ihzE_WD0nY9mxdAA@mail.gmail.com>
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
 <538CC508.3070707@gmail.com> <CALCETrVrPt4uKNC43nNB08iMA=vK7pM0choHNdB3ctT7RQuepQ@mail.gmail.com>
 <538CC827.6090408@gmail.com> <CALCETrXkhfvOGTo_31k-d9wkMW782aoz3YsJmzS-ApTePJH=Kg@mail.gmail.com>
 <CANUX_P0LV05kBRcjmfsJxFP6bSJ5Ge4Mr8ihzE_WD0nY9mxdAA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 2 Jun 2014 12:57:34 -0700
Message-ID: <CALCETrXLcOoXp33-y+M4PQfL7nf9G_wpfTRJiD26vsqCYD-v2Q@mail.gmail.com> (sfid-20140602_215759_245668_6E1DC878)
Subject: Re: Help debugging iwldvm / ath10k stalls
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 2, 2014 at 12:32 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> Note that the CMD queue (9 or 4 depending on your configuration) - uses another mechanism that is safer but consumes more power. This queue is intended for commands and not for real Tx packets.
>>
>> If that's queue 4 in the debugfs tx_queues file, then I think that
>> that's the queue that keeps moving when the card is dead.  I'll see if
>> I can improve the tx_queues file to show pending updates.
>>
>> Yay troubleshooting old hardware.
>>
> If you plan to spend some time hacking on the code, please take into
> account this code has been changed in 3.14 (mostly cleanups by
> Johannes and myself).
> Also note that long ago, I disabled shadow registers (you'll see ifs
> all over the code). Shadow registers makes the whole wakup thing much
> easier since it is handled internally in the HW. BUT we had tons of
> issues with it so we disabled it. Most of the issues should have gone
> away with the cmd_in_flight thing. So I would recommend you to give it
> a try with shadow register enabled. Just check the relevant iwl-XXXX.c
> file.

Will do.

FWIW, I looked at the cmd_in_flight thing and, unless there's a bunch
of locking magic going on, it looks racy.  It seems like some code
expects it to be protected by reg_lock, and other code expects it to
be protected by txq_lock (and there are multiple txq->lock instances,
I think).

Also, what stops the card from going to sleep while processing a
wakeup interrupt?  For example, what prevents this chain of events?
The only thing I can see is that the only thing that clears ACCESS_REQ
is the rx interrupt processing, which happens after wakeup processing,
but this seems rather fragile.

--Andy
