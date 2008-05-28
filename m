Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:51987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYE1Rx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 13:53:59 -0400
Message-ID: <483D9C34.2020908@scherping.de> (sfid-20080528_195402_514712_500CF103)
Date: Wed, 28 May 2008 19:53:56 +0200
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath5k: 10 MHz channels?
References: <483B181F.3010802@scherping.de> <40f31dec0805280336r40b102ffx11cbd0c0d465c9f8@mail.gmail.com>
In-Reply-To: <40f31dec0805280336r40b102ffx11cbd0c0d465c9f8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis schrieb:

> No work has been done for such features yet, other more important
> things are missing right now. If you want to rev. engineer
> half/quarter rate channels, i think you should start from nic_wakeup
> and reset functions (also check out rx/tx descriptors for the rate
> code). Mmiotrace is your friend ;-)

Thanks very much for your reply, Nick!

In fact I found the piece of code needed to get 10 MHz channels working with the Ubiquity cards today.
I do not have the full code at hand ATM, but it was not more than adding

clock |= 0x100

to hw.c:ath5k_hw_nic_wakeup.

madwifi-trace helped to find that single, but important bit ;-)

ath5k performance still is somewhat limited in ad-hoc mode, but I will try to work on that, too. Are there any ideas yet, that are not already implemented? I refer to the effect that a simple ping between two ath5k ad-hoc stations has only about 80 % success rate...

Thanks for your great work! With the full frequency range and free choice of channelwidths ath5k is about to exceed even specially modified MadWifi versions in functionality.

Richard
