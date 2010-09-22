Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0IVSuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 14:50:11 -0400
Received: by iwn5 with SMTP id 5so716889iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 11:50:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100922123953.67a4fc5e@danmob>
References: <20100922123953.67a4fc5e@danmob>
Date: Wed, 22 Sep 2010 21:50:10 +0300
Message-ID: <AANLkTinh+NbGxUpKZ_Ad9zV4z9=jhnvrim1pjxYUHQHE@mail.gmail.com>
Subject: Re: Manual Control about Sending ACKs
From: Nick Kossifidis <mickflemm@gmail.com>
To: Daniel Berger <daniel@dat-berger.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/22 Daniel Berger <daniel@dat-berger.de>:
> Hi,
>
> im a Student in Germany currently working on a project concerning
> wireless security.
> For testing purposes we would like to send ACKs to packets, which
> weren't adressed to us, or suppress sending normal ACKs.
> I've looked through mac80211's code and found there much, what looks
> like the ACK-sending-action is triggered in rx.c (we're checking CRC,
> length, adressed to us, ...). But, one the other hand, tx.c states in a
> comment
> /* TODO: These control frames are not currently sent by
> * mac80211, but should they be implemented, this function
> * needs to be updated to support duration field calculation. *
> [...]
> * ACK: 0 if immediately previous directed data/mgmt had
> *    more=0, with more=1 duration in ACK frame is duration
> *    from previous frame minus time needed to transmit ACK
> *    and its SIFS
> */
> Furthermore ath9k e.g. write parameters for configuring the sending of
> ACKs directly into hw's memory... and doesn't do much more.
>
> Thus I deduce ACK sending is completely done in hardware.
> Is my conclusion and understanding right? Is there any possible solution
> to my problem of sending ACKs manually? Would that be fast enough for
> the SIFS and other stations' ACK timeout?
>
> I would appreciate a short message to help me out.
> Greetings from sunny Germany
> Daniel Berger
>

On ath5k (and i think also ath9k) you can disable hw ACKS using the
SW_DIAG register on PCU but i haven't tested it.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
