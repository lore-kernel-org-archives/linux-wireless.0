Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50600 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab1AKUwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 15:52:42 -0500
Received: by fxm20 with SMTP id 20so20350525fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 12:52:40 -0800 (PST)
Message-ID: <4D2CC310.5060003@lwfinger.net>
Date: Tue, 11 Jan 2011 14:52:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Locking problem reported for mainline
References: <4D2A9309.7000500@lwfinger.net>	<201101101913.17311.chunkeey@googlemail.com>	<4D2B59EA.4000200@lwfinger.net>	<201101102018.35232.chunkeey@googlemail.com>	<4D2C85FE.4030709@lwfinger.net> <AANLkTikPoEjHRXjqVkSopCjUcyp7AauvFAfaVN_8T0qG@mail.gmail.com>
In-Reply-To: <AANLkTikPoEjHRXjqVkSopCjUcyp7AauvFAfaVN_8T0qG@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2011 01:45 PM, Bob Copeland wrote:
> On Tue, Jan 11, 2011 at 11:31 AM, Larry Finger
> <Larry.Finger@lwfinger.net> wrote:
>> Is there a document that explains what the meaning of these semantics?
>>
>> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>> kdostartupconfi/3502 [HC1[1]:SC0[0]:HE0:SE1] takes:
>>  (&(&list->lock)->rlock#5){?.-...}, at: [<ffffffff812995c6>]
>> skb_queue_tail+0x26/0x60
>> {HARDIRQ-ON-W} state was registered at:
> 
> I'm not sure about all the HC1[1]:SC0[0] etc stuff, but check out
> Documentation/lockdep-design.txt for the basics.

That one I had read.

> In this case, someone took a lock with interrupts enabled (HARDIRQ-ON-W)
> while someone else took it in a hard IRQ context (IN-HARDIRQ-W) where
> they are normally disabled.  The problem of course is:
> 
> cpu0:
> spin_lock(&foo);
> do some stuff protected by foo;
> 
> ----> interrupt happens here
>    spin_lock(&foo);  /* darn, deadlock! */
>    other stuff;
>    spin_unlock(&foo);
> <----
> 
> spin_unlock(&foo);
> 
> Could be a missing _irqsave() if it's not, as Stanislaw suggested, a false
> positive.

I suspected the message meant mixed interrupts disabled/enabled, but thanks for
the confirmation.

Thanks,

Larry
