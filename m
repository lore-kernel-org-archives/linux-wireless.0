Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965596AbbD1O16 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 10:27:58 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
	<87383kps0o.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 28 Apr 2015 10:27:48 -0400
In-Reply-To: <87383kps0o.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 28 Apr 2015 11:37:59 +0300")
Message-ID: <wrfjvbggfhuj.fsf@redhat.com> (sfid-20150428_162801_399115_53C3D51B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
>> from scratch utilizing the mac80211 stack.
>>
>> After spending months cleaning up the vendor provided rtl8723au
>> driver, which comes with it's own 802.11 stack included, I decided to
>> rewrite this driver from the bottom up.
>
> Where is the vendor driver available, in staging or somewhere else? It
> would be good to mention that in the commit log.

Hi Kalle,

Thanks for the feedback, the vendor driver is drivers/staging/rtl8723au/

>> Many thanks to Johannes Berg for 802.11 insights and help and Larry
>> Finger for help with the vendor driver.
>>
>> The full git log for the development of this driver can be found here:
>> git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>>     branch rtl8723au-mac80211
>>
>> This driver is still experimental, but has proven to be rather stable
>> for me. It lacks some features found in the staging driver, such as
>> power management, AMPDU, and 40MHz channel support. In addition there
>> is no AP and monitor support at this point.
>
> It's nice to document in the commit log what features are verified to be
> working.
>
> Also I see incosistencies with driver naming, in some places I see
> RTL8723au and elsewhere rtl8xxxu. And commit log title could be
> improved, for example something like "rtl8xxxu: new wireless mac80211
> driver for rtl8723au chipsets"

The reason for the inconsistencies is that I anticipate adding support
for more chips in the future, so the 8723au named functions are ones
that are more likely to be chip specific.

> And I would like to understand the relationship with rtlwifi, can you
> describe that a bit more? Why a separate driver instead of extending
> rtlwifi? When I look at the directory drivers/net/wireless/rtlwifi/rtl8723ae 
> I'm confused what's the bigger plan here. Larry?

I looked at rtlwifi and while it has changed a lot from the vendor
driver, it still has a strong legacy of the vendor codebase. I could
have opted to do a smaller mini-driver for rtlwifi, but I felt it was
better to start from scratch and write the driver from the bottom up for
Linux.

>>  MAINTAINERS                          |    8 +
>>  drivers/net/wireless/Kconfig         |   19 +
>>  drivers/net/wireless/Makefile        |    2 +
>>  drivers/net/wireless/rtl8xxxu.c | 4500
>> ++++++++++++++++++++++++++++++++++
>>  drivers/net/wireless/rtl8xxxu.h      |  497 ++++
>>  drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
>
> I think someone else already mentioned, but it would be better that has
> it's own directory. Or should this actually be under rtlwifi
> directory?

I didn't see the need here - it's just 3 files, as long as it doesn't
have a huge hierachy of files, a new directory doesn't add much
value. If it becomes an issue later, we can move it into a subdirectory.

>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -8297,6 +8297,14 @@ S:	Maintained
>>  F:	drivers/net/wireless/rtlwifi/
>>  F:	drivers/net/wireless/rtlwifi/rtl8192ce/
>>  
>> +RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
>> +M:	Jes Sorensen <Jes.Sorensen@redhat.com>
>> +L:	linux-wireless@vger.kernel.org
>> +W:	http://intellinuxwireless.org
>
> The link cannot be right.

That is a mistake for sure, I must have copied an entry as a template
and forgotten to remove that one.

>> +T: git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>> rtl8723au-mac80211
>
> I doubt that this will be in active enough development that a separate
> git tree is needed. wireless-drivers trees should be enough and this
> line can be removed.

I would like to keep this line, it points to my development tree, which
allows users to go back and look through my full development logs, as
well as see ongoing work before it's pushed upstream.

> I'll do more detailed code review later, but my first impression was
> that there was a lot of #if 0 code which is frowned upon.

Johannes already brought up the #if 0 pieces. I left those in because I
am not done with the driver, and this helps me map the flow of the
vendor driver codebase. Those #if 0 lines are not there to sit and rot,
but to help future development.

> And I pushed this to wireless-drivers-next.git pending branch so that
> kbuild will run it's tests with this driver.

I saw the kbuild warning, it was a false positive, which I do plan to
address down the line.

Cheers,
Jes
