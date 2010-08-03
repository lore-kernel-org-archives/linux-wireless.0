Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48579 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0HCDcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 23:32:00 -0400
Received: by gwb20 with SMTP id 20so1472124gwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 20:31:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C5783AD.4060405@gmail.com>
References: <1280799971-7091-1-git-send-email-justinmattock@gmail.com>
	<AANLkTimmiraT1wV_=zxUmfKPz7D78uOdY4s67pVXOntA@mail.gmail.com>
	<4C577DB3.4050902@gmail.com> <AANLkTi=ZEKts2eW8KjvkNN0h5ogPkEwjfjbMYHjcjx+s@mail.gmail.com>
	<4C5783AD.4060405@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 3 Aug 2010 13:31:39 +1000
Message-ID: <AANLkTinbSvn=kjkvf1VceH3oLsScT5KxtwhSdfGuy5_a@mail.gmail.com>
Subject: Re: [PATCH v3]hostap:hostap_ioctl.c Fix variable 'ret' set but not
	used
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, linville@tuxdriver.com,
	mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 3, 2010 at 12:49, Justin P. Mattock <justinmattock@gmail.com> wrote:
> On 08/02/2010 07:31 PM, Julian Calaby wrote:
>>
>> On Tue, Aug 3, 2010 at 12:23, Justin P. Mattock<justinmattock@gmail.com>
>>  wrote:
>>>
>>> wait im lost.. looking at your patch looks the same(number wise) except I
>>> see different parts of code in there:
>>>
>>> hostap_set_word(dev, HFA384X_RID_CNFROAMINGMODE,
>>>                                HFA384X_ROAMING_FIRMWARE);
>>>
>>> -       return 0;
>>> +       return ret;
>>>
>>>
>>>
>>> mine is:
>>>
>>> printk(KERN_DEBUG "SCANREQUEST failed\n");
>>> -               ret = -EINVAL;
>>> +               return ret;
>>>
>>>
>>> The tree Im using is Linus's tree.
>>
>> I'm using wireless-testing, and the line you're changing is #1692, I'm
>> changing #1699.
>>
>> Thanks,
>>
>
>
> ahh.. so there's two return ret's that need to be added then..
> (if so then go ahead and take my patch and add it to yours.. I'm off to
> other things)

No.

The function works like this:

1. set up scan_req
2. if local->host_roaming is not set, set host roaming on the hardware
3. set scan_req on the hardware
4. if local->host_roaming is not set, set the hardware to do firmware roaming
5. If set_req could not be set on the hardware, return -EINVAL,
otherwise return 0.

The significant bits are steps 2 and 4. These must *both* be executed,
regardless of whether setting scan_req on the hardware succeeds or
not.

As such, the return value is stored in the ret variable, which is
initialised to 0 initially, then set to -EINVAL if setting scan_req on
the hardware fails. Hence, step 5 can be performed by returning ret.

As such, all of your patches are wrong as they are either returning
the wrong value when setting scan_req on the hardware fails, or
failing to execute step 4. The *only* correct place to return a value
is once the roaming status of the hardware has been set properly -
i.e. at the end of the function.

I hope this has cleared up your confusion.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
