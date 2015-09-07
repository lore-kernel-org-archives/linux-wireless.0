Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56752 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbbIGJRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 05:17:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<87y4gjfw10.fsf@kamboji.qca.qualcomm.com>
	<wrfjfv2rf1e1.fsf@redhat.com>
Date: Mon, 07 Sep 2015 12:17:07 +0300
In-Reply-To: <wrfjfv2rf1e1.fsf@redhat.com> (Jes Sorensen's message of "Sun, 06
	Sep 2015 21:45:26 -0400")
Message-ID: <878u8ifv1o.fsf@kamboji.qca.qualcomm.com> (sfid-20150907_111717_269998_981E287E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I'm not saying about we should remove drivers, my worry is only that we
don't have two drivers competing about same devices in a normal distro
kernel. We should _by default_ not have two drivers claiming support for
the same device, developer's can of course enable this via experimental
options etc.

>> Also how do we make sure that distros don't enable
>> CONFIG_RTL8XXXU_UNTESTED? They are notarious of enabling kconfig options
>> without thinking.
>
> Some distros enable staging whether you ask them or not.

Sure, that's up to them. I don't care what's in staging so I can't
really comment about that, this is only in context of
drivers/net/wireless/.

> I think CONFIG_RTL8XXXYU_UNTESTED is pretty safe and will most likely
> just work for the devices on that list, but the driver will spit out a
> warning asking the person to report test results to me.

That sounds good. Let's just make it as obvious as possible that distros
and normal users should enable that option.

-- 
Kalle Valo
