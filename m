Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58450 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab1ITIe1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 04:34:27 -0400
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
	<CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 20 Sep 2011 11:34:25 +0300
In-Reply-To: <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com> (Eliad Peller's message of "Mon\, 19 Sep 2011 19\:30\:57 +0300")
Message-ID: <87litjipda.fsf@purkki.adurom.net> (sfid-20110920_103432_031693_41DE84FA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eliad Peller <eliad@wizery.com> writes:

> AFAIU from the coex guys, the scenario is something like this: upon
> coex activity, the fw might delay its rx and tx paths. this means
> that the fw might get a frame within the 100ms of the dyn ps, but
> delay its processing and pass it up to the driver only later. this
> will cause redundant psm enter (after 100ms) and psm exit (after the
> fw passed the packet). i'm not sure about the exact effect during
> coex operation, but eventually these psm enter/exit affect the
> throughput.
>
> another point here, is that during a specific period (during auto_mode
> on), there might or might not be coex activity. thus, we can't just
> disable dyn_ps, as it will hurt throughput (when there is no coex
> activity).

IIRC Juuso added ieee80211_enable/disable_dyn_ps() to make it possible
use BT COEX with wl12xx. Now you are saying that you actually want the
opposite? I'm confused now. 

But nevertheless I'm not still convinced that doing all this in
mac80211 is the right thing. Especially that this seems to be very
wl12xx specific, right?

> bottom line - i'm not sure about all the details, but according to
> their tests - it does improve the throughput.

Firmware engineers are notarious in making quick hacks to improve one
special case and not thinking about the big picture ;)

-- 
Kalle Valo
