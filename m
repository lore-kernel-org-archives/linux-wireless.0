Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f193.google.com ([209.85.217.193]:36811 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbbFKEL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 00:11:58 -0400
Received: by lbiv13 with SMTP id v13so7281069lbi.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 21:11:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKr4uszh5g2KURj4tVG_vKNrNFaz4JyhCK4FuaRzdvhpQ@mail.gmail.com>
References: <CAAVw_ZFi3Q1hi+uoeO_V=XUMNhZCViVq5iPrrJL9UakKB46Mag@mail.gmail.com>
	<CAAnMG+Oeps87PaxV4DAqyOokz9T6ikf3Xv0vA_EC+impRM5Fxg@mail.gmail.com>
	<CABPxzYKr4uszh5g2KURj4tVG_vKNrNFaz4JyhCK4FuaRzdvhpQ@mail.gmail.com>
Date: Thu, 11 Jun 2015 11:11:56 +0700
Message-ID: <CAAVw_ZFnj4dbPUqTu5hUtM7YQdHw=RCz7SSL7X-WdKorvMepKQ@mail.gmail.com> (sfid-20150611_061202_306291_EF0C2E13)
Subject: Re: mac80211 modification
From: Duy Tai Nguyen <duytai.cse@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Alexis Green <agreen@cococorp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank @Chaitanya, @Green for your useful information :D
Best,
 Duy Tai Nguyen

2015-06-09 2:34 GMT+07:00 Krishna Chaitanya <chaitanya.mgit@gmail.com>:
> On Mon, Jun 8, 2015 at 10:40 PM, Alexis Green <agreen@cococorp.com> wrote:
>>
>> You should build mac80211 as module instead of built-in driver and
>> "make modules" instead of full make. This way you'll be just
>> rebuilding mac80211.ko instead of the whole thing.
>>
>> On Mon, Jun 8, 2015 at 2:39 AM, Duy Tai Nguyen <duytai.cse@gmail.com> wrote:
>> > Hi,
>> >
>> > I want to inject particular data into beacon frame in Android device.
>> > I found two approaches:
>> > 1. Write loadable kernel module.
>> > 2. Modify MAC80211 subsystem
>> > In the first approach, I found that I could not include directly
>> > source code from MAC80211 sub system in folder /net/mac80211/. Thus, I
>> > used the second approach, but, every time I change any line of source
>> > code, it takes 30 minutes to build zImage  then install new kernel in
>> > my Android device. Finally, I was stuck.
>> > Therefore, my questions are:
>> > 1. Is it right approach to modify MAC80211 subsystem?
>> > 2. Are there any faster approach to modify MAC80211 and test source code?
>> > 3. I am curious about the way you write code and test MAC80211. Could
>> > you explain in details?
>
> The way i do it is, as below:
>
> 1) First time compile the full kernel. With mac80211=m
> 2) Next time: after changing source :
>        make modules M=net/mac80211
>        make modules_install M=net/mac80211
>
>        modprobe -v mac80211 -r
>        modprobe -v mac80211
> 3) I normally use mac80211_hwsim to test the mac80211 code.
>  Refer: https://wireless.wiki.kernel.org/en/users/drivers/mac80211_hwsim
> In that case:
>
>        modprobe -v mac80211_hwsim -r
>        modprobe -v mac80211_hwsim



-- 
-----------------------------------------------------------------------------------------------------------------
Nguyen Duy Tai
Ym: kimjiwoo741
Phone: +841676919422
Faculty of Computer Science and Engineering.
University of Technology HCMC.
-----------------------------------------------------------------------------------------------------------------
