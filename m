Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55268 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbbIWL11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 07:27:27 -0400
Date: Wed, 23 Sep 2015 13:27:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: ath5k filling logs (was Re: Low latency communication over wifi)
Message-ID: <20150923112724.GA22525@amd> (sfid-20150923_132735_273421_335499A0)
References: <20150923110343.GA19160@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150923110343.GA19160@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> I hacked qcu.c to limit latencies:
> 
>   	  qi->tqi_cw_min = ath5k_cw_validate(0);
>           qi->tqi_cw_max = ath5k_cw_validate(20);
> 
> ...but I don't think it did what I wanted. What am I missing?
> 
> (I could use Intel 3945ABG-based card instead, but I figured out ath5k
> might be easier to hack?)

Speaking of ath5k... it fills logs with lots of messages:

[   53.486222] ath5k: ath5k_hw_get_isr: ISR: 0x00000400 IMR: 0x80081035
[   61.217713] ath5k: ath5k_hw_get_isr: ISR: 0x00000400 IMR: 0x80081035

Should I just delete the print from kernel, or is there something I
should debug?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
