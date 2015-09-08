Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbbIHVBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 17:01:33 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<87y4gjfw10.fsf@kamboji.qca.qualcomm.com>
	<55EC71DB.7060007@lwfinger.net>
Date: Tue, 08 Sep 2015 17:01:31 -0400
In-Reply-To: <55EC71DB.7060007@lwfinger.net> (Larry Finger's message of "Sun,
	6 Sep 2015 12:03:23 -0500")
Message-ID: <wrfjvbbkaams.fsf@redhat.com> (sfid-20150908_230136_579262_E54F5FA0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 09/06/2015 09:43 AM, Kalle Valo wrote:
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
> I agree, in principle, but there will be difficulties in the
> implementation, at least in the short term.
>
> At the moment, the only driver that has a conflict with rtl8xxxu is
> rtl8192cu. Although rtl8xxxu is surprisingly more stable that
> rtl8192cu, the latter has more features, which is may be the reason
> for better stability. Driver rtl8xxxu does not handle any 40 MHz
> channels, nor can it become an AP either with hostapd or with
> NetworkManager. For those reasons, rtl819cu has to remain the standard
> driver for RTL81{88,92}CU devices until rtl8xxxu is improved. Anyone
> that wants to try the new driver will need to use blacklists.

I do not fully agree on this. In my testing I found rtl8192cu rather
unstable, to the point of not being usable. It would lock up for me
after a short while. I have seen this happen with mulitple different
adapters. I suspect this is the reason why drivers/staging/rtl8192u is
still sitting in the kernel tree.

It is true the rtl8xxxu doesn't support 40MHz channels, but reality is
few people actually use them since it's almost impossible to get free
channel access without clashes these days. Now I still intend to add
support for 40MHz, it has just not been on the top of the priority list
so far. Finding a place to test it is kinda hard when you live in the
middle of a city like New York :)

My take is that the majority of users mostly care about station support
and for them rtl8xxxu will be much preferred to rtl8192cu.

Basically I don't think there is a one solution fits all to this.
Whether we like it, we will have to accept that there are going to be
multiple drivers around for these chips for a while.

Cheers,
Jes
