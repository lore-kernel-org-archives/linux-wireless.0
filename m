Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43490 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab2KTPQe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 10:16:34 -0500
Message-ID: <50AB9E73.3090802@ti.com> (sfid-20121120_161638_405644_3290EEE0)
Date: Tue, 20 Nov 2012 17:14:59 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<victorgld@gmail.com>
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com> <1350226137-13704-2-git-send-email-victorg@ti.com> <1350414099.10177.13.camel@jlt4.sipsolutions.net> <50842569.5000602@ti.com> <1350910543.10166.3.camel@jlt4.sipsolutions.net> <50922A9D.2060409@ti.com> <1352128887.9466.17.camel@jlt4.sipsolutions.net> <50A26163.10300@ti.com> <20121113180505.GB19223@pandem0nium>
In-Reply-To: <20121113180505.GB19223@pandem0nium>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13/11/2012 20:05, Simon Wunderlich wrote:
> On Tue, Nov 13, 2012 at 05:04:03PM +0200, Victor Goldenshtein wrote:
>> On 05/11/2012 17:21, Johannes Berg wrote:
>>> On Thu, 2012-11-01 at 09:54 +0200, Victor Goldenshtein wrote:
>>>> On 22/10/2012 14:55, Johannes Berg wrote:
>>>>>> 2. In __nl80211_set_channel() - to cover the case when the CAC was
>>>>>> initiated on a "preset_chan" (during AP init phase) and the IF was
>>>>>> removed before the AP was even started (local->oper_channel wasn't set yet).
>>>>>
>>>>> Hmm, I'm not sure I get it. How is "local->oper_channel" (a mac80211
>>>>> variable) related to this cfg80211 code?
>>>>
>>>> It's not, just saying that its not set at this point.
>>>>
>>>>> start_ap() isn't expected to be able to succeed until CAC passed
>>>>> successfully, but OTOH the channel isn't configured until then?
>>>>
>>>> right, the initial CAC performed before start_ap(), only by setting the
>>>> channel with __nl80211_set_channel() + radar detection command.
>>>
>>> Hmm. Maybe then the channel should be passed to the radar detection
>>> command instead? That way, it can be passed through, you can allocate a
>>> channel context, etc. Much easier?
>>
>> We already pass the frequency in the radar detection command, the
>> set channel operation comes during hostapd init flow regardless DFS
>> implementation.
>
> Just for clarification for the API: Is the driver required to (re)set the channel
> itself in the radar detection command, or do we expect that the channel was already
> set via __nl80211_set_channel() (or other means) before?
>
> This would be important for other DFS modes like IBSS later.
>

Already discussed this privately, still maybe someone else also interested.

The set channel operation is relevant only during initial CAC test,
it set and re-set (if necessary - e.g. radar detected on the first
channel) by the hostapd it self, so the driver doesn't required to set 
the channel in the radar detection command.


-- 
Thanks,
Victor.
