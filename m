Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56843 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbYGVLix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 07:38:53 -0400
Date: Tue, 22 Jul 2008 08:38:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 2/2] RFKILL: set the status of the leds on activation.
Message-ID: <20080722113848.GF15136@khazad-dum.debian.net> (sfid-20080722_133906_393258_3A1D4ECB)
References: <20080722102159.GA32682@doriath.ww600.siemens.net> <20080722112245.GC15136@khazad-dum.debian.net> <bc64b4640807220433i3cfbefbfjac6570c55852c59c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bc64b4640807220433i3cfbefbfjac6570c55852c59c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oi Tue Jul 2008, Dmitry wrote:
> 2008/7/22 Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> > On Tue, 22 Jul 2008, Dmitry Baryshkov wrote:
> >> Provide default activate function to set the state of the led
> >> when the led becomes bound to the trigger
> >
> > I think I understand what this is for, but I better ask to be sure...
> > What does it do, what is the use case?
> 
> Register rfkill-> registers led trigger
> Register led with rfkill trigger.
> 
> However as rfkill doesn't provide the led_trigger->activate callback,
> the led won't be in the proper state till the next rfkill state change.
> With this patch, when led_trigger_set calls led_trigger->activate,
> leds is set up with correct brightness.

Thought as much.  Please add that to the patch description...

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Now you just need Ivo's ACKs, since mine don't mean much :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
