Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2028 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab1HLSzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 14:55:39 -0400
Message-ID: <4E45771C.7090400@broadcom.com> (sfid-20110812_205545_370176_D626E9A4)
Date: Fri, 12 Aug 2011 20:55:24 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 01/14] staging: brcm80211: use wait queues instead
 of semaphores in wl_cfg80211.c
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
 <1313156101-16817-2-git-send-email-arend@broadcom.com>
 <CACna6rzmaxzezN-OPTLvXyFOZOsoq6XCds4P-FOEz27FzJz+Jg@mail.gmail.com>
 <4E455877.6090901@broadcom.com>
In-Reply-To: <4E455877.6090901@broadcom.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 06:44 PM, Arend van Spriel wrote:
> On 08/12/2011 04:07 PM, Rafał Miłecki wrote:
>> 2011/8/12 Arend van Spriel<arend@broadcom.com>:
>>> @@ -3537,27 +3544,39 @@ static s32 brcmf_event_handler(void *data)
>>>                          (struct brcmf_cfg80211_priv *)data;
>>>          struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
>>>          struct brcmf_cfg80211_event_q *e;
>>> +       DECLARE_WAITQUEUE(wait, current);
>>>
>>>          sched_setscheduler(current, SCHED_FIFO,&param);
>>>          allow_signal(SIGTERM);
>>> -       while (likely(!down_interruptible(&cfg_priv->event_sync))) {
>>> +       add_wait_queue(&cfg_priv->event_waitq,&wait);
>>> +       while (1) {
>>> +               prepare_to_wait(&cfg_priv->event_waitq,&wait,
>>> +                               TASK_INTERRUPTIBLE);
>>> +
>>> +               schedule();
>>> +
>>>                  if (kthread_should_stop())
>>>                          break;
>>> +
>>>                  e = brcmf_deq_event(cfg_priv);
>>>                  if (unlikely(!e)) {
>>>                          WL_ERR("event queue empty...\n");
>>> -                       BUG();
>>> +                       continue;
>>>                  }
>>> -               WL_INFO("event type (%d)\n", e->etype);
>>> -               if (cfg_priv->el.handler[e->etype])
>>> -                       cfg_priv->el.handler[e->etype](cfg_priv,
>>> -                                                      cfg_to_ndev(cfg_priv),
>>> -&e->emsg, e->edata);
>>> -               else
>>> -                       WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
>>>
>>> -               brcmf_put_event(e);
>>> +               do {
>>> +                       WL_INFO("event type (%d)\n", e->etype);
>>> +                       if (cfg_priv->el.handler[e->etype])
>>> +                               cfg_priv->el.handler[e->etype](cfg_priv,
>>> +                                       cfg_to_ndev(cfg_priv),
>>> +&e->emsg, e->edata);
>>> +                       else
>>> +                               WL_INFO("Unknown Event (%d): ignoring\n",
>>> +                                       e->etype);
>>> +                       brcmf_put_event(e);
>>> +               } while ((e = brcmf_deq_event(cfg_priv)));
>> if (((((care_coding_style)))))
>> fix();
>>
>> :-)
>>
> I assume you refer to the indents above. Not sure what exactly happened
> there, but the patch email as I received it looks. Could it be a mail
> reader issue?
>
> Gr. AvS

A colleague pointed out you probably meant the while condition. The 
extra braces may be there because an assignment is done, but in this 
case it does not make much sense.

I will fix it.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


