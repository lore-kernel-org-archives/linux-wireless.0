Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35992 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0LHIMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 03:12:48 -0500
Received: by pwj3 with SMTP id 3so215593pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 00:12:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012081706.54459.br1@einfach.org>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
 <AANLkTiky-Q6DLxXSKf-+UU6avpaVikRgtt5078+Ui7Uh@mail.gmail.com>
 <AANLkTimS03cqqG8TCN1MTGF0DRQ51hrFkSPrbah2Z4gO@mail.gmail.com> <201012081706.54459.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 8 Dec 2010 18:12:33 +1000
Message-ID: <AANLkTim+pOE1pCszaRWvzNmZ9e7RtdVbY7jPquby5OHV@mail.gmail.com>
Subject: Re: [ath5k-devel] ath5k: Weird Retransmission Behaviour
To: Bruno Randolf <br1@einfach.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bjorn.smedman@venatech.se, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 8, 2010 at 6:06 PM, Bruno Randolf <br1@einfach.org> wrote:
>> > When ath5k doesn't get retry limits from above it uses the following
>> > defaults on dcu.
>> > For now i don't think we use local->hw.conf.short_frame_max_tx_count
>> > for that so the
>> > default is ah_limit_tx_retries (AR5K_INIT_TX_RETRY) but seems it's
>> > wrong and we should
>> > fix it...
>> >
>> > /* Tx retry limits */
>> > #define AR5K_INIT_SH_RETRY                      10
>> > #define AR5K_INIT_LG_RETRY                      AR5K_INIT_SH_RETRY
>> > /* For station mode */
>> > #define AR5K_INIT_SSH_RETRY                     32
>> > #define AR5K_INIT_SLG_RETRY                     AR5K_INIT_SSH_RETRY
>> > #define AR5K_INIT_TX_RETRY                      10
>
> I just sent a patch cleaning up this mess. Could you please check it?
> Unfortunately i didn't find way to really test re-transmissions, yet.
> Jonathan, could you give it a try in your test setup with my patch, and play
> with the numbers (just hardcode them in ath5k_hw_set_tx_retry_limits) to see
> if they actually have an effect?

Added to my todo for tomorrow - I'll try to do it if I have some spare time!

Cheers,

Jonathan

>
> As noted in my patch, this does not change the high number of retries we get
> from the rate control. That's a separate issue.
>
> bruno
>
