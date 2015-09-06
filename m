Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34584 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbIFRDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 13:03:25 -0400
Received: by obbda8 with SMTP id da8so19997055obb.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2015 10:03:24 -0700 (PDT)
Subject: Re: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for
 rtl8188[cr]u/rtl8192cu/rtl8723au
To: Kalle Valo <kvalo@codeaurora.org>, Jes.Sorensen@redhat.com
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
 <87y4gjfw10.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55EC71DB.7060007@lwfinger.net> (sfid-20150906_190343_123734_E972B5F5)
Date: Sun, 6 Sep 2015 12:03:23 -0500
MIME-Version: 1.0
In-Reply-To: <87y4gjfw10.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2015 09:43 AM, Kalle Valo wrote:
> Jes.Sorensen@redhat.com writes:
>
>> Per default only devices I have actually tested will be enabled. If
>> you are interested in trying it out with other 8188cu/8188ru/819[12]cu
>> dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
>> test results back to me.
>>
>> Note if you enable this driver, it may clash with CONFIG_RTL8192U,
>> CONFIG_R8723AU, and CONFIG_RTL8192CU (rtlwifi). Please pay attention
>> to which module you load and/or use modprobe blacklists.
>
> May clash? So how does this work in practise? Is the clash referring
> CONFIG_RTL8XXXU_UNTESTED enabled or disabled?
>
> I think we should only have one driver automatically supporting certain
> hardware, and not have a driver randomly chosen and forcing users to use
> a blacklist.

I agree, in principle, but there will be difficulties in the implementation, at 
least in the short term.

At the moment, the only driver that has a conflict with rtl8xxxu is rtl8192cu. 
Although rtl8xxxu is surprisingly more stable that rtl8192cu, the latter has 
more features, which is may be the reason for better stability. Driver rtl8xxxu 
does not handle any 40 MHz channels, nor can it become an AP either with hostapd 
or with NetworkManager. For those reasons, rtl819cu has to remain the standard 
driver for RTL81{88,92}CU devices until rtl8xxxu is improved. Anyone that wants 
to try the new driver will need to use blacklists.

We can make changes in the Kconfig help texts that clarify the situation, but 
that will not help the user of kernels built by the distros.

> Also how do we make sure that distros don't enable
> CONFIG_RTL8XXXU_UNTESTED? They are notarious of enabling kconfig options
> without thinking.

It will not necessarily depend on whether CONFIG_RTL8XXXU_UNTESTED is enabled or 
not. Some of the affected devices are in the tested category.

Larry

