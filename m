Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45370 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3AYWWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 17:22:44 -0500
Received: by mail-wi0-f174.google.com with SMTP id hq7so6763wib.7
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 14:22:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51030260.2040004@candelatech.com>
References: <5102CADE.2010900@candelatech.com>
	<CA+yqC4b2_q5Nn2t7C-5JdAfxR-QA8KtBgqE_sw91ZfNwt-k+LQ@mail.gmail.com>
	<5102D0C7.50907@candelatech.com>
	<CAJ-VmonmYNGK42DuCLStjvSswdvkzeHUAwH+fsZQL5BdxwGgjA@mail.gmail.com>
	<51030260.2040004@candelatech.com>
Date: Fri, 25 Jan 2013 14:22:42 -0800
Message-ID: <CAJ-Vmo=0+cKJQR9-0LCJynsgG2OyOwCuyLmqtqmUzBFoB=5oxg@mail.gmail.com> (sfid-20130125_232248_078030_AD8D5F3F)
Subject: Re: Increasing throughput on 3-radio system?
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sam Leffler <sleffler@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 January 2013 14:08, Ben Greear <greearb@canelatech.com> wrote:

> Could you point me to which registers/vars/keywords in (ath9k) ani
> do this?  I'd like to play around with them a bit.

Just look at the ANI code and the ANI patent. It covers what the
registers do. There are obviously more PHY register nowdays, but those
are a good starting point.

> As for transmitting at the same time, is that even possible
> using multiple ath9k NICs in a PC?  It would seem to me that you'd
> need some kind of low-level communication between the hardware/firmware
> on the NICs themselves to accomplish that?

No, you just need a cute hack to un-gate the TX queues at the same
time. You'd also probably have to disable CCA (hah!) so they all
transmit at the same time, and configure the TXQ backoff to be linear
exponential, rather than random exponential backoff.


Adrian
