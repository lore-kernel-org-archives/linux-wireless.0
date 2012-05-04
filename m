Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63880 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab2EDOgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 10:36:00 -0400
Received: by vbbff1 with SMTP id ff1so2065969vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 May 2012 07:35:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA3DD87.7030004@lwfinger.net>
References: <4F83A6DE.7070109@lwfinger.net>
	<1334201497.3788.1.camel@jlt3.sipsolutions.net>
	<4F865155.2000202@lwfinger.net>
	<1334202842.3788.10.camel@jlt3.sipsolutions.net>
	<4F86FA05.5080404@lwfinger.net>
	<1334246145.4062.0.camel@jlt3.sipsolutions.net>
	<CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
	<4FA0371E.9040704@lwfinger.net>
	<20120502100012.GA8492@arm.com>
	<1335978471.4295.3.camel@jlt3.sipsolutions.net>
	<20120502200955.GI2450@linux.vnet.ibm.com>
	<1336070304.5167.4.camel@jlt3.sipsolutions.net>
	<4FA37461.6050304@lwfinger.net>
	<CAD2nsn2kgk9P3zTNP0zVRb-tx3A2p3Nb+FLsTC=TGy9MoXMwtw@mail.gmail.com>
	<CAD2nsn1s32uTOf7PQrzuskvQaLOnwpSLghHyJN8m7QJL2DyxNQ@mail.gmail.com>
	<4FA3DD87.7030004@lwfinger.net>
Date: Fri, 4 May 2012 20:05:59 +0530
Message-ID: <CAD2nsn2xMg0oUwtzYbLTv1vjJSnyHnrvhvNSCQL-4qRJ4cLPUg@mail.gmail.com> (sfid-20120504_163604_862166_C5A1DCA9)
Subject: Re: Suspicious RCU usage in mac80211
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 4, 2012 at 7:15 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/04/2012 01:48 AM, Mohammed Shafi wrote:
>>
>> On Fri, May 4, 2012 at 12:10 PM, Mohammed Shafi
>> <shafi.wireless@gmail.com>  wrote:
>>>
>>> Hi Larry,
>>>
>>> On Fri, May 4, 2012 at 11:47 AM, Larry Finger<Larry.Finger@lwfinger.net>
>>>  wrote:
>>>>
>>>> On 05/03/2012 01:38 PM, Johannes Berg wrote:
>>>>>
>>>>>
>>>>> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
>>>>> index 5b7053c..40d3ff4 100644
>>>>> --- a/net/mac80211/agg-tx.c
>>>>> +++ b/net/mac80211/agg-tx.c
>>>>> @@ -421,16 +421,22 @@ static void
>>>>> sta_tx_agg_session_timer_expired(unsigned long data)
>>>>>        struct tid_ampdu_tx *tid_tx;
>>>>>        unsigned long timeout;
>>>>>
>>>>> -       tid_tx = rcu_dereference_protected_tid_tx(sta, *ptid);
>>>>> -       if (!tid_tx)
>>>>> +       rcu_read_lock();
>>>>> +       tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[*ptid]);
>>
>>
>> Larry, Johannes seems to use rcu_dereference straight way just like in
>> 'sta_addba_resp_timer_expired'
>> and have it protected by rcu_read_locks
>
>
> Sorry. I missed that subtle difference. Submitted "from Johannes".

no problem thanks! yeah but it seems my gmail seems to be identify those
changes!!

-- 
thanks,
shafi
