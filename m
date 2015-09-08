Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbbIHVNI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 17:13:08 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<87y4gjfw10.fsf@kamboji.qca.qualcomm.com>
	<55EC71DB.7060007@lwfinger.net>
	<87d1xufvio.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 08 Sep 2015 17:13:07 -0400
In-Reply-To: <87d1xufvio.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 07 Sep 2015 12:06:55 +0300")
Message-ID: <wrfjmvwwaa3g.fsf@redhat.com> (sfid-20150908_231313_652889_83EAAA05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> On 09/06/2015 09:43 AM, Kalle Valo wrote:
>>> Jes.Sorensen@redhat.com writes:
>>>
>>>> Per default only devices I have actually tested will be enabled. If
>>>> you are interested in trying it out with other 8188cu/8188ru/819[12]cu
>>>> dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
>>>> test results back to me.
>>>>
>>>> Note if you enable this driver, it may clash with CONFIG_RTL8192U,
>>>> CONFIG_R8723AU, and CONFIG_RTL8192CU (rtlwifi). Please pay attention
>>>> to which module you load and/or use modprobe blacklists.
>>>
>>> May clash? So how does this work in practise? Is the clash referring
>>> CONFIG_RTL8XXXU_UNTESTED enabled or disabled?
>>>
>>> I think we should only have one driver automatically supporting certain
>>> hardware, and not have a driver randomly chosen and forcing users to use
>>> a blacklist.
>>
>> I agree, in principle, but there will be difficulties in the
>> implementation, at least in the short term.
>>
>> At the moment, the only driver that has a conflict with rtl8xxxu is
>> rtl8192cu. Although rtl8xxxu is surprisingly more stable that
>> rtl8192cu, the latter has more features, which is may be the reason
>> for better stability. Driver rtl8xxxu does not handle any 40 MHz
>> channels, nor can it become an AP either with hostapd or with
>> NetworkManager. For those reasons, rtl819cu has to remain the standard
>> driver for RTL81{88,92}CU devices until rtl8xxxu is improved. Anyone
>> that wants to try the new driver will need to use blacklists.
>
> But how do we make sure that for normal users rtl8192cu is always loaded
> and not rtl8xxxu (until we decide to make the switch)? What I'm worried
> is that normal distro users would use rtl8xxxu before it's ready for
> their device.

It's a bit of a chicken and egg situation. We could default it to only
enable 8723au support, but then nobody would really test it. Right now I
believe rtlwifi and r8723au will auto-load first, at least I had to
blacklist them here to not have them get in the way.

>> We can make changes in the Kconfig help texts that clarify the
>> situation, but that will not help the user of kernels built by the
>> distros.
>
> Exactly. We should not create any regressions to existing setups,
> everything should work as they did before. Kconfig options or blacklist
> tweaking is not an acceptable way to handle that, it should be
> automatic.

Problem for me is that the current default driver is unstable to the
point of being unusable.

>>> Also how do we make sure that distros don't enable
>>> CONFIG_RTL8XXXU_UNTESTED? They are notarious of enabling kconfig options
>>> without thinking.
>>
>> It will not necessarily depend on whether CONFIG_RTL8XXXU_UNTESTED is
>> enabled or not. Some of the affected devices are in the tested
>> category.
>
> Ok. Can't we start just rtl8xxxu having just devices NOT supported by
> rtlwifi drivers? All other devices would be under
> CONFIG_RTL8XXXU_UNTESTED until we think the support is ready and we can
> make the switch by moving from untested to tested category. And at the
> same time disable/remove those devices from rtlwifi.

I don't like this idea very much. We want people to actually test those
devices, and if they keep getting rtl8192cu they won't get to it. A lot
of the users who have problems with these devices are not the ones who
will build their own kernels all the time. Maybe if it could be done
with a module parameter?

The real question here is how big a percentage of users really rely on
AP and mesh mode compared to station mode.

Jes
