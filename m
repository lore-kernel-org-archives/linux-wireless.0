Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47743 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0HCDn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 23:43:58 -0400
Received: by pwi5 with SMTP id 5so1525079pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 20:43:57 -0700 (PDT)
Message-ID: <4C57908D.2010904@gmail.com>
Date: Mon, 02 Aug 2010 20:44:13 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, j@w1.fi, linville@tuxdriver.com,
	mcgrof@gmail.com
Subject: Re: [PATCH v3]hostap:hostap_ioctl.c Fix variable 'ret' set but not
 	used
References: <1280799971-7091-1-git-send-email-justinmattock@gmail.com> 	<AANLkTimmiraT1wV_=zxUmfKPz7D78uOdY4s67pVXOntA@mail.gmail.com> 	<4C577DB3.4050902@gmail.com> <AANLkTi=ZEKts2eW8KjvkNN0h5ogPkEwjfjbMYHjcjx+s@mail.gmail.com> 	<4C5783AD.4060405@gmail.com> <AANLkTinbSvn=kjkvf1VceH3oLsScT5KxtwhSdfGuy5_a@mail.gmail.com>
In-Reply-To: <AANLkTinbSvn=kjkvf1VceH3oLsScT5KxtwhSdfGuy5_a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2010 08:31 PM, Julian Calaby wrote:
> On Tue, Aug 3, 2010 at 12:49, Justin P. Mattock<justinmattock@gmail.com>  wrote:
>> On 08/02/2010 07:31 PM, Julian Calaby wrote:
>>>
>>> On Tue, Aug 3, 2010 at 12:23, Justin P. Mattock<justinmattock@gmail.com>
>>>   wrote:
>>>>
>>>> wait im lost.. looking at your patch looks the same(number wise) except I
>>>> see different parts of code in there:
>>>>
>>>> hostap_set_word(dev, HFA384X_RID_CNFROAMINGMODE,
>>>>                                 HFA384X_ROAMING_FIRMWARE);
>>>>
>>>> -       return 0;
>>>> +       return ret;
>>>>
>>>>
>>>>
>>>> mine is:
>>>>
>>>> printk(KERN_DEBUG "SCANREQUEST failed\n");
>>>> -               ret = -EINVAL;
>>>> +               return ret;
>>>>
>>>>
>>>> The tree Im using is Linus's tree.
>>>
>>> I'm using wireless-testing, and the line you're changing is #1692, I'm
>>> changing #1699.
>>>
>>> Thanks,
>>>
>>
>>
>> ahh.. so there's two return ret's that need to be added then..
>> (if so then go ahead and take my patch and add it to yours.. I'm off to
>> other things)
>
> No.
>
> The function works like this:
>
> 1. set up scan_req
> 2. if local->host_roaming is not set, set host roaming on the hardware
> 3. set scan_req on the hardware
> 4. if local->host_roaming is not set, set the hardware to do firmware roaming
> 5. If set_req could not be set on the hardware, return -EINVAL,
> otherwise return 0.
>
> The significant bits are steps 2 and 4. These must *both* be executed,
> regardless of whether setting scan_req on the hardware succeeds or
> not.
>
> As such, the return value is stored in the ret variable, which is
> initialised to 0 initially, then set to -EINVAL if setting scan_req on
> the hardware fails. Hence, step 5 can be performed by returning ret.
>
> As such, all of your patches are wrong as they are either returning
> the wrong value when setting scan_req on the hardware fails, or
> failing to execute step 4. The *only* correct place to return a value
> is once the roaming status of the hardware has been set properly -
> i.e. at the end of the function.
>
> I hope this has cleared up your confusion.
>
> Thanks,
>


cleared it up perfectly... didnt think that using ret down more would 
work..(was stuck a few lines up)  but it does.. just tested your version 
out and no warning messages..

cheers,

Justin P. Mattock
