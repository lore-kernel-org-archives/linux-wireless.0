Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:52523 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbcCJAgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 19:36:21 -0500
Subject: Re: [PATCH] staging: wilc1000: fix check of kthread_run() return
 value
To: Julian Calaby <julian.calaby@gmail.com>
References: <1457565194-31533-1-git-send-email-vz@mleia.com>
 <CAGRGNgUMViiR+ruvLHnwMLHUxOK3+uW7634Hpgn9gN+djCOtbw@mail.gmail.com>
 <56E0B21D.1010503@mleia.com>
 <CAGRGNgVsmTPpiu4twUnvk_3GEFMiU2VuuSj5=M+4y6qJYiDZhA@mail.gmail.com>
 <56E0B9AD.3050806@mleia.com>
 <CAGRGNgWKUTeP-BPUX92VW-Cnm+BOA+-pivsjZECqpdnaxZbn8A@mail.gmail.com>
Cc: Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
From: Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <56E0C17F.40909@mleia.com> (sfid-20160310_013625_024650_B2F5C94C)
Date: Thu, 10 Mar 2016 02:36:15 +0200
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWKUTeP-BPUX92VW-Cnm+BOA+-pivsjZECqpdnaxZbn8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On 10.03.2016 02:24, Julian Calaby wrote:
> Hi Vladimir,
> 
> On Thu, Mar 10, 2016 at 11:02 AM, Vladimir Zapolskiy <vz@mleia.com> wrote:
>> Hi Julian,
>>
>> On 10.03.2016 01:42, Julian Calaby wrote:
>>> Hi Vladimir,
>>>
>>> On Thu, Mar 10, 2016 at 10:30 AM, Vladimir Zapolskiy <vz@mleia.com> wrote:
>>>> Hi Julian,
>>>>
>>>> On 10.03.2016 01:27, Julian Calaby wrote:
>>>>> Hi Vladimir,
>>>>>
>>>>> On Thu, Mar 10, 2016 at 10:13 AM, Vladimir Zapolskiy <vz@mleia.com> wrote:
>>>>>> The kthread_run() function returns either a valid task_struct or
>>>>>> ERR_PTR() value, check for NULL is invalid. The change fixes potential
>>>>>> oops, e.g. in OOM situation.
>>>>>>
>>>>>> Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
>>>>>> ---
>>>>>>  drivers/staging/wilc1000/linux_wlan.c | 4 ++--
>>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
>>>>>> index 54fe9d7..5077c30 100644
>>>>>> --- a/drivers/staging/wilc1000/linux_wlan.c
>>>>>> +++ b/drivers/staging/wilc1000/linux_wlan.c
>>>>>> @@ -849,10 +849,10 @@ static int wlan_initialize_threads(struct net_device *dev)
>>>>>>         PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
>>>>>>         wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
>>>>>>                                      "K_TXQ_TASK");
>>>>>> -       if (!wilc->txq_thread) {
>>>>>> +       if (IS_ERR(wilc->txq_thread)) {
>>>>>>                 PRINT_ER("couldn't create TXQ thread\n");
>>>>>>                 wilc->close = 0;
>>>>>> -               return -ENOBUFS;
>>>>>> +               return PTR_ERR(wilc->txq_thread);
>>>>>
>>>>> Are you sure changing the error returned is correct? Do all the
>>>>> callers of wlan_initialize_threads() handle the full range of errors
>>>>> from kthread_run()?
>>>>
>>>> Have you checked the driver?
>>>
>>> I'm making sure you have. It's possible that there's a good reason why
>>> this returns -ENOBUFS I want to know that you've at least considered
>>> that possibility.
>>
>> You have my confirmation, I've checked the call stack before publishing
>> this fix.
> 
> Awesome.
> 
>>>> This function is called once on initialization, the check on the upper layer
>>>> has "if (ret < 0) goto exit_badly;" form.
>>>
>>> And practically everything in the chain up to net_device_ops uses the
>>> same error handling scheme so it's probably fine.
>>
>> dev_open()
>>   __dev_open()
>>     wilc_mac_open()
>>       wilc1000_wlan_init()
>>         wlan_initialize_threads()
>>
>> Oh, why kernel threads within a driver are init'ed/destroyed on
>> each device up/down state transition?
> 
> You'll have to ask the driver developers. I believe this was a cross
> platform driver that is currently being Linux-ised, so I'm guessing
> this is some artefact of that.
> 
>>> You should also document this change in the commit message.
>>
>> The change is documented in the commit message, take a look. But I didn't
>> add "I swear it does not break anything" ;)
> 
> You
> 1. corrected the test in the if statement
> 2. changed the return value from -ENOBUFS
> in your patch, however you only documented the first part.

Agree, it makes sense.

> I would have expected a commit message along the lines of:
> 
> ---->8----
> 
> The kthread_run() function returns either a valid task_struct or
> ERR_PTR() value, so the check for NULL is invalid.
> 
> Also return the error from kthread_run() instead of -ENOBUFS.
> 
> ----8<----
> 

Before publishing v2 let see if driver maintainers have something else
to add, or may be it is better to preserve -ENOBUFS, or may be they are
so kind to update the commit message on patch application.

Julian, thanks for review.

--
With best wishes,
Vladimir
