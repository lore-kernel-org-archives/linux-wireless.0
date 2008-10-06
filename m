Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:33902 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbYJFTrU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 15:47:20 -0400
Date: Mon, 6 Oct 2008 21:47:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <87d4id3jmr.fsf@denkblock.local>
Message-ID: <alpine.LFD.2.00.0810061614490.3166@apollo> (sfid-20081006_214726_367375_495AF2F3)
References: <87k5cm3ee2.fsf@denkblock.local> <alpine.LFD.2.00.0810052354000.3398@apollo> <87d4id3jmr.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 6 Oct 2008, Elias Oltmanns wrote:
> Make sure that event1 is the right device. chktimer usually reports
> several premature timer expiries in less than a minute.

Which is not surprising. You measure the delta of the reads. Your
process can be scheduled away and when it comes back two events can be
available, so they are read right after each other and trigger your
check.

Your measuring method is wrong. You really want to measure the delta
of the timer events in the kernel via ktime_get(), not the delta of
something else in userspace.

Thanks,

	tglx







