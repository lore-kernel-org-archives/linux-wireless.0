Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35158 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754016AbcITGW6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 02:22:58 -0400
Received: by mail-wm0-f67.google.com with SMTP id 133so1526521wmq.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 23:22:57 -0700 (PDT)
Subject: Re: Problem with 40Mhz on 2.5GHz with Intel 8260
References: <24d0d9c5-7695-9364-c5fa-97e9d52712dc@gmail.com>
 <CANUX_P1cFXTFk8c7iMZuVwoySMwVKPkLBOTr=sVC+t6xioPa=w@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
From: Volker Mische <volker.mische@gmail.com>
Message-ID: <e22cedce-354f-cd41-f89c-8167f7063cfb@gmail.com> (sfid-20160920_082301_981496_F37C77A9)
Date: Tue, 20 Sep 2016 08:22:54 +0200
MIME-Version: 1.0
In-Reply-To: <CANUX_P1cFXTFk8c7iMZuVwoySMwVKPkLBOTr=sVC+t6xioPa=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 09/20/2016 07:39 AM, Emmanuel Grumbach wrote:
> On Mon, Sep 19, 2016 at 5:00 PM, Volker Mische <volker.mische@gmail.com> wrote:
>> I'm having connectivity issues with an Intel 8260 on a 2.5GHz network
>> when using 40Mhz. I'm getting errors like
>>
>>     Queue 2 stuck for 10000 ms.
>>
>> I've upgrade my system to the firmware version 21 (21.373438.0) and
>> Kernel 4.8.0-rc6 in hope that it fixes the issue and to be able to debug
>> the problem.
>>
>> I then found the page about platform noise [1]. I don't have any issue
>> for several hours now (normally I was hitting the issue every few
>> minutes) as I've set the cfg80211_disable_40mhz_24ghz parameter.
>>
>> Now I wonder, is it worth debugging the issue with being on 40MHz or is
>> disabling the proper solution and I should bother.
> 
> Well... depends whom you ask and how much time you have :)

I really want to get this sorted out.


> We tried a few times to debug those, but they take a very long time to debug
> since typically we need lots of reproductions and the firmware team
> doesn't always
> the time to look at the data immediately so in the end, the people who
> reported this
> originally went away.
> Note that 40MHz on 2.4GHz is not an optimal configuration in crowded
> environment,
> but if you live in a place where you are pretty much the only one using those
> frequencies, then, it can be beneficial.

It's at home. I normally see only one other wifi (I need to check which
frequency that one is using).


> What you can try is to disable low power states (by using power_scheme
> in iwlmvm) and see if it helps.

I will try that.

> This setting has a bigger impact than cfg80211_disable_40mhz_24ghz
> but it can give a hint as where the problem is coming from.

I'll report back.

Should I open a bug report (or use an existing one) or should we keep
the discussion on the mailing list?


Cheers,
  Volker


>> [1]:
>> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#about_platform_noise
