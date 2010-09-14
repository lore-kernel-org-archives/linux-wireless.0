Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41601 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0INXIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 19:08:21 -0400
Received: by mail-ww0-f44.google.com with SMTP id 20so363384wwd.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 16:08:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik+KjxZSbaShYKq91WN7niZYvtETXbpgDPgj84L@mail.gmail.com>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com> <AANLkTik+KjxZSbaShYKq91WN7niZYvtETXbpgDPgj84L@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 09:07:59 +1000
Message-ID: <AANLkTi=8p2umy+m4emdqKMb=eTYiLTsR3ZENwFaJyoe8@mail.gmail.com>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 3:39 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Sep 14, 2010 at 1:51 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
>> as well as 1360 frames which came in with a negative CONTENTION_TIME.
>>
>> Ignoring the fact that some frames are coming up with a negative
>> CONTENTION_TIME (which potentially points to another problem)
>
> How negative are these?  Are you subtracting more for, say, txtime
> than you should be?

Actually, I've found that they were exactly one slot time negative
(give or take 1us). That said, I was doing these calculations using
the 802.11a OFDM spec timings. I looked at the driver and realised
that SIFS is actually being initialised to 14us, whereas it should be
set to 16us. This will also affect DIFS. Once I take these into
consideration, they come up as approximately 4-5us out. Now that I
think about it, it could make sense.

With regards to the tx_time, I'm using the OFDM tx_time formula from
the 802.11-2007 spec. I'm trying to lock down enough aspects of the
timing in order to verify it. From what I've seen now, my txtime is
almost always 4us short, but I can't work out why. I will get the code
for the txtime when I get into my office, I don't have it on this PC.

>
> --
> Bob Copeland %% www.bobcopeland.com
>

Thanks,

Jonathan
