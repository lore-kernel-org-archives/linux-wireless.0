Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:35500 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753091AbcIUGys (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 02:54:48 -0400
Received: by mail-it0-f47.google.com with SMTP id r192so119499022ita.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 23:54:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <79ad55e3-d7f7-0605-3499-a6b289dfb4f6@gmail.com>
References: <24d0d9c5-7695-9364-c5fa-97e9d52712dc@gmail.com>
 <CANUX_P1cFXTFk8c7iMZuVwoySMwVKPkLBOTr=sVC+t6xioPa=w@mail.gmail.com>
 <e22cedce-354f-cd41-f89c-8167f7063cfb@gmail.com> <79ad55e3-d7f7-0605-3499-a6b289dfb4f6@gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Wed, 21 Sep 2016 09:54:42 +0300
Message-ID: <CANUX_P1n3aVC=95q1=dJFU=7WYof=adm=P1anyhG0nnr9vKGKA@mail.gmail.com> (sfid-20160921_085458_736476_6676B1FB)
Subject: Re: Problem with 40Mhz on 2.5GHz with Intel 8260
To: Volker Mische <volker.mische@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
>
> On 09/20/2016 08:22 AM, Volker Mische wrote:
>> On 09/20/2016 07:39 AM, Emmanuel Grumbach wrote:
>>> On Mon, Sep 19, 2016 at 5:00 PM, Volker Mische <volker.mische@gmail.com> wrote:
>>>> I'm having connectivity issues with an Intel 8260 on a 2.5GHz network
>>>> when using 40Mhz. I'm getting errors like
>>>>
>>>>     Queue 2 stuck for 10000 ms.
>>>>
>>>> I've upgrade my system to the firmware version 21 (21.373438.0) and
>>>> Kernel 4.8.0-rc6 in hope that it fixes the issue and to be able to debug
>>>> the problem.
>>>>
>>>> I then found the page about platform noise [1]. I don't have any issue
>>>> for several hours now (normally I was hitting the issue every few
>>>> minutes) as I've set the cfg80211_disable_40mhz_24ghz parameter.
>
>>> We tried a few times to debug those, but they take a very long time to debug
>>> since typically we need lots of reproductions and the firmware team
>>> doesn't always
>>> the time to look at the data immediately so in the end, the people who
>>> reported this
>>> originally went away.
>>> Note that 40MHz on 2.4GHz is not an optimal configuration in crowded
>>> environment,
>>> but if you live in a place where you are pretty much the only one using those
>>> frequencies, then, it can be beneficial.
>>
>> It's at home. I normally see only one other wifi (I need to check which
>> frequency that one is using).
>>
>>
>>> What you can try is to disable low power states (by using power_scheme
>>> in iwlmvm) and see if it helps.
>>
>> I will try that.
>
> I've set the iwlmvm power_scheme to 1 (and allowed the 40Mhz
> connection). First I thought it's good, but after a while the queue
> still got stuck. Especially after waking up from a suspend (not sure if
> that matters).

Ok - good to know.

>
> What are the next steps?

can you try to unplug the power cord? I had reports that said that
this can help. Again, just a debug step to give us a hint of what you
can be experiencing.
Besides this, we need to go for firmware debugging. But as I said,
don't expect this to be fast and easy. Please open a bug in
bugzilla.kernel.org. CC linuxwifi@intel.com and we will guide you
there on how to provide the information we need.
