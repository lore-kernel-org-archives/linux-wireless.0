Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46097 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161219Ab2KNMcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 07:32:45 -0500
Message-ID: <50A38F68.1020506@tieto.com> (sfid-20121114_133248_251116_0DA2FCBE)
Date: Wed, 14 Nov 2012 13:32:40 +0100
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Victor Goldenshtein <victorg@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"adrian.chadd@gmail.com" <adrian.chadd@gmail.com>,
	"j@w1.fi" <j@w1.fi>, "coelho@ti.com" <coelho@ti.com>,
	"igalc@ti.com" <igalc@ti.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>    <1350226137-13704-2-git-send-email-victorg@ti.com>   <1350414099.10177.13.camel@jlt4.sipsolutions.net>  <50842569.5000602@ti.com> <1350910543.10166.3.camel@jlt4.sipsolutions.net>  <50922A9D.2060409@ti.com> <1352128887.9466.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352128887.9466.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/12 16:21, Johannes Berg wrote:
> On Thu, 2012-11-01 at 09:54 +0200, Victor Goldenshtein wrote:
>> On 22/10/2012 14:55, Johannes Berg wrote:
>>>> 2. In __nl80211_set_channel() - to cover the case when the CAC was
>>>> initiated on a "preset_chan" (during AP init phase) and the IF was
>>>> removed before the AP was even started (local->oper_channel wasn't set yet).
>>>
>>> Hmm, I'm not sure I get it. How is "local->oper_channel" (a mac80211
>>> variable) related to this cfg80211 code?
>>
>> It's not, just saying that its not set at this point.
>>
>>> start_ap() isn't expected to be able to succeed until CAC passed
>>> successfully, but OTOH the channel isn't configured until then?
>>
>> right, the initial CAC performed before start_ap(), only by setting the
>> channel with __nl80211_set_channel() + radar detection command.
>
> Hmm. Maybe then the channel should be passed to the radar detection
> command instead? That way, it can be passed through, you can allocate a
> channel context, etc. Much easier?

I was thinking if putting the radar detection parameter in start_ap() is 
an option (and thus removing the explicit radar cmd)? We could defer 
`netif_carrier_on()` to be done after the initial radar detection is done.

This way the whole thing would be atomic and channel accounting would be 
fine.


-- Pozdrawiam / Best regards, Michal Kazior.
