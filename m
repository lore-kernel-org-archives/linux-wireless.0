Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:51290 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915AbaD2TYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 15:24:00 -0400
Received: by mail-qa0-f54.google.com with SMTP id s7so660515qap.27
        for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2014 12:23:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398122097-23544-2-git-send-email-tharvey@gateworks.com>
References: <1398122097-23544-1-git-send-email-tharvey@gateworks.com>
	<1398122097-23544-2-git-send-email-tharvey@gateworks.com>
Date: Tue, 29 Apr 2014 12:23:58 -0700
Message-ID: <CAJ-VmonGFPF8Z4G1WFPVhWBJQYsW3oJ91xz4XNf2EGqrcX300Q@mail.gmail.com> (sfid-20140429_212404_441578_F5DB1E04)
Subject: Re: [PATCH 2/2] ath9k: add a recv budget
From: Adrian Chadd <adrian@freebsd.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 April 2014 16:14, Tim Harvey <tharvey@gateworks.com> wrote:
> Implement a recv budget so that in cases of high traffic we still allow other
> taskets to get processed.
>
> Without this, we can encounter a host of issues during high wireless traffic
> reception depending on system load including rcu stall's detected (ARM),
> soft lockups, failure to service critical tasks such as watchdog resets,
> and triggering of the tx stuck tasklet.

Are you also force rescheduling the Rx tasklet if you break?

You can definitely hit a race condition where you get RXEOL and RXDESC
before you run the scheduled RX tasklet. In that instance you may not
get any further interrupts until you re-poke the RX DMA engine. Adding
a FIFO entry may be enough, but it certainly isn't enough (ie, no
FIFOs) on pre-AR93xx chips.

(I've done the same thing in FreeBSD for the same reasons. It's ..
delicate to get right.)


-a
