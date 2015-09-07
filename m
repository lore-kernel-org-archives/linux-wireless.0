Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbbIGEYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 00:24:42 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<87y4gjfw10.fsf@kamboji.qca.qualcomm.com>
	<wrfjfv2rf1e1.fsf@redhat.com>
Date: Mon, 07 Sep 2015 00:24:38 -0400
In-Reply-To: <wrfjfv2rf1e1.fsf@redhat.com> (Jes Sorensen's message of "Sun, 06
	Sep 2015 21:45:26 -0400")
Message-ID: <wrfj37yqg8l5.fsf@redhat.com> (sfid-20150907_062445_605072_229861AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Kalle Valo <kvalo@codeaurora.org> writes:
>> Jes.Sorensen@redhat.com writes:
>>
>>> Per default only devices I have actually tested will be enabled. If
>>> you are interested in trying it out with other 8188cu/8188ru/819[12]cu
>>> dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
>>> test results back to me.
>>>
>>> Note if you enable this driver, it may clash with CONFIG_RTL8192U,
>>> CONFIG_R8723AU, and CONFIG_RTL8192CU (rtlwifi). Please pay attention
>>> to which module you load and/or use modprobe blacklists.
>>
>> May clash? So how does this work in practise? Is the clash referring
>> CONFIG_RTL8XXXU_UNTESTED enabled or disabled?
>>
>> I think we should only have one driver automatically supporting certain
>> hardware, and not have a driver randomly chosen and forcing users to use
>> a blacklist.
>
> We already have the clash, if you enable CONFIG_RTL8192U in staging it
> clashes with rtlwifi's CONFIG_RTL8192CU. Ripping out the above two
> drivers at this point isn't going to do users any good.
>
>> Also how do we make sure that distros don't enable
>> CONFIG_RTL8XXXU_UNTESTED? They are notarious of enabling kconfig options
>> without thinking.
>
> Some distros enable staging whether you ask them or not. I think
> CONFIG_RTL8XXXYU_UNTESTED is pretty safe and will most likely just work
> for the devices on that list, but the driver will spit out a warning
> asking the person to report test results to me.

Just one more note - we could put UNTESTED under EXPERIMENTAL

Cheers,
Jes
