Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36130 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030559AbbD1PPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 11:15:15 -0400
Received: by oift201 with SMTP id t201so118745759oif.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2015 08:15:14 -0700 (PDT)
Message-ID: <553FA3FF.7040001@lwfinger.net> (sfid-20150428_171521_272934_37E29463)
Date: Tue, 28 Apr 2015 10:15:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>	<87383kps0o.fsf@kamboji.qca.qualcomm.com> <wrfjvbggfhuj.fsf@redhat.com>
In-Reply-To: <wrfjvbggfhuj.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/28/2015 09:27 AM, Jes Sorensen wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>> Jes.Sorensen@redhat.com writes:
>>
>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>
>>> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
>>> from scratch utilizing the mac80211 stack.
>>>
>>> After spending months cleaning up the vendor provided rtl8723au
>>> driver, which comes with it's own 802.11 stack included, I decided to
>>> rewrite this driver from the bottom up.
>>
>> Where is the vendor driver available, in staging or somewhere else? It
>> would be good to mention that in the commit log.
>
> Hi Kalle,
>
> Thanks for the feedback, the vendor driver is drivers/staging/rtl8723au/
>
>>> Many thanks to Johannes Berg for 802.11 insights and help and Larry
>>> Finger for help with the vendor driver.
>>>
>>> The full git log for the development of this driver can be found here:
>>> git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>>>      branch rtl8723au-mac80211
>>>
>>> This driver is still experimental, but has proven to be rather stable
>>> for me. It lacks some features found in the staging driver, such as
>>> power management, AMPDU, and 40MHz channel support. In addition there
>>> is no AP and monitor support at this point.
>>
>> It's nice to document in the commit log what features are verified to be
>> working.
>>
>> Also I see incosistencies with driver naming, in some places I see
>> RTL8723au and elsewhere rtl8xxxu. And commit log title could be
>> improved, for example something like "rtl8xxxu: new wireless mac80211
>> driver for rtl8723au chipsets"
>
> The reason for the inconsistencies is that I anticipate adding support
> for more chips in the future, so the 8723au named functions are ones
> that are more likely to be chip specific.
>
>> And I would like to understand the relationship with rtlwifi, can you
>> describe that a bit more? Why a separate driver instead of extending
>> rtlwifi? When I look at the directory drivers/net/wireless/rtlwifi/rtl8723ae
>> I'm confused what's the bigger plan here. Larry?
>
> I looked at rtlwifi and while it has changed a lot from the vendor
> driver, it still has a strong legacy of the vendor codebase. I could
> have opted to do a smaller mini-driver for rtlwifi, but I felt it was
> better to start from scratch and write the driver from the bottom up for
> Linux.
>
>>>   MAINTAINERS                          |    8 +
>>>   drivers/net/wireless/Kconfig         |   19 +
>>>   drivers/net/wireless/Makefile        |    2 +
>>>   drivers/net/wireless/rtl8xxxu.c | 4500
>>> ++++++++++++++++++++++++++++++++++
>>>   drivers/net/wireless/rtl8xxxu.h      |  497 ++++
>>>   drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
>>
>> I think someone else already mentioned, but it would be better that has
>> it's own directory. Or should this actually be under rtlwifi
>> directory?
>
> I didn't see the need here - it's just 3 files, as long as it doesn't
> have a huge hierachy of files, a new directory doesn't add much
> value. If it becomes an issue later, we can move it into a subdirectory.
>
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -8297,6 +8297,14 @@ S:	Maintained
>>>   F:	drivers/net/wireless/rtlwifi/
>>>   F:	drivers/net/wireless/rtlwifi/rtl8192ce/
>>>
>>> +RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
>>> +M:	Jes Sorensen <Jes.Sorensen@redhat.com>
>>> +L:	linux-wireless@vger.kernel.org
>>> +W:	http://intellinuxwireless.org
>>
>> The link cannot be right.
>
> That is a mistake for sure, I must have copied an entry as a template
> and forgotten to remove that one.
>
>>> +T: git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>>> rtl8723au-mac80211
>>
>> I doubt that this will be in active enough development that a separate
>> git tree is needed. wireless-drivers trees should be enough and this
>> line can be removed.
>
> I would like to keep this line, it points to my development tree, which
> allows users to go back and look through my full development logs, as
> well as see ongoing work before it's pushed upstream.
>
>> I'll do more detailed code review later, but my first impression was
>> that there was a lot of #if 0 code which is frowned upon.
>
> Johannes already brought up the #if 0 pieces. I left those in because I
> am not done with the driver, and this helps me map the flow of the
> vendor driver codebase. Those #if 0 lines are not there to sit and rot,
> but to help future development.
>
>> And I pushed this to wireless-drivers-next.git pending branch so that
>> kbuild will run it's tests with this driver.
>
> I saw the kbuild warning, it was a false positive, which I do plan to
> address down the line.

Kalle,

Jes has covered most of the points very well. I will add just a little 
explanation from my point of view.

There are two major software groups that write the original drivers for the 
Realtek chips. The PCI group, which is located in China, has worked very hard at 
their Linux drivers and have written the mac80211 versions found in rtlwifi. I 
have contributed to cleaning up their code and fixing kernel crashes, but the 
code is largely theirs. The USB group, which is located in Taiwan, also provide 
Linux drivers, but their drivers contain their own software 802.11 stack. The 
only exception is the driver for the RTL8192CU, which is in rtlwifi.

The distributed USB drivers come with conditional code that can build drivers 
for Linux, Windows, and FreeBSD. This leads to a lot of dead code in each of the 
drivers. In addition, they release new versions somewhat infrequently and can be 
quite slow to update their drivers for new kernel APIs. Some time ago, I started 
getting requests for a driver for the RTL8723AU, which was only found in the 
Lenovo Yoga 13 tablet. As I have no budget to purchase a $1000 machine only for 
testing a new driver, I did the best I could by creating a public GitHub repo 
and posted the code after modifying it to build on all kernel versions. I also 
did some cleanup of dead code and some cosmetic changes to make the code easier 
to read. That chip is now more widely used.

Jes, who owns the Yoga 13, contacted me about adding this driver to staging, 
which lack of test equipment prevented me from doing. I helped him with part of 
that step, but he soon was reworking the code in more advanced ways. From the 
feedback I get from users, the staging driver is extremely stable. From that 
start, Jes has now written this version. Rather than modifying the staging 
driver to use mac80211 instead of its own stack, he started fresh. That avoids a 
lot of crufty code, and I am very impressed with the result.

The points about extensibility are very important. At present, I have 7 other 
drivers for Realtek USB devices at GitHub that are in various stages of 
development; however, all use the Realtek 802.11 stack. These could be pushed 
into staging, but now that there is an option of converting these into the 
framework that Jes has provided, why not go all the way with quality code? As I 
only have the hardware for 2 of these devices, a lot of help from the community 
will be needed for testing. In addition, some of the devices will likely be 
available as inexpensive USB plugins, and can be added to my available devices.

I will be happy to answer any questions.

Larry


