Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:20800 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYGVLdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 07:33:06 -0400
Received: by an-out-0708.google.com with SMTP id d40so434097and.103
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 04:33:05 -0700 (PDT)
Message-ID: <bc64b4640807220433i3cfbefbfjac6570c55852c59c@mail.gmail.com> (sfid-20080722_133311_440081_97C9DF25)
Date: Tue, 22 Jul 2008 15:33:05 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/2] RFKILL: set the status of the leds on activation.
Cc: linux-wireless@vger.kernel.org,
	"Ivo van Doorn" <IvDoorn@gmail.com>, akpm@linux-foundation.org,
	"Richard Purdie" <rpurdie@rpsys.net>
In-Reply-To: <20080722112245.GC15136@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080722102159.GA32682@doriath.ww600.siemens.net>
	 <20080722112245.GC15136@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2008/7/22 Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> On Tue, 22 Jul 2008, Dmitry Baryshkov wrote:
>> Provide default activate function to set the state of the led
>> when the led becomes bound to the trigger
>
> I think I understand what this is for, but I better ask to be sure...
> What does it do, what is the use case?

Register rfkill-> registers led trigger
Register led with rfkill trigger.

However as rfkill doesn't provide the led_trigger->activate callback,
the led won't be in the proper state till the next rfkill state change.
With this patch, when led_trigger_set calls led_trigger->activate,
leds is set up with correct brightness.

>>  This patch depends on the patch "leds: make sure led->trigger is set
>>  earlier" which was staged in -mm for some time and recently got merged
>>  into leds tree.
>
> Will it get in mainline for 2.6.27-rc?

I hope so. It actually depends on Richard Purdie (cc'ed)

>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
>



-- 
With best wishes
Dmitry
