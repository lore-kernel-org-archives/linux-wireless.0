Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbbIGBlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 21:41:06 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440968574-29490-2-git-send-email-Jes.Sorensen@redhat.com>
	<87twr7fvbb.fsf@kamboji.qca.qualcomm.com>
	<55EC72AF.2050803@lwfinger.net>
Date: Sun, 06 Sep 2015 21:41:05 -0400
In-Reply-To: <55EC72AF.2050803@lwfinger.net> (Larry Finger's message of "Sun,
	6 Sep 2015 12:06:55 -0500")
Message-ID: <wrfjk2s3f1la.fsf@redhat.com> (sfid-20150907_034110_083933_C7C40332)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 09/06/2015 09:59 AM, Kalle Valo wrote:
>> Jes.Sorensen@redhat.com writes:
>>
>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>
>>> This is an alternate driver for a number of Realtek WiFi USB devices,
>>> including RTL8723AU, RTL8188CU, RTL8188RU, RTL8191CU, and RTL8192CU.
>>> It was written from scratch utilizing the Linux mac80211 stack.
>>>
>>> After spending months cleaning up the vendor provided rtl8723au
>>> driver, which comes with it's own 802.11 stack included, I decided to
>>> rewrite this driver from the bottom up.
>>>
>>> Many thanks to Johannes Berg for 802.11 insights and help and Larry
>>> Finger for help with the vendor driver.
>>>
>>> The full git log for the development of this driver can be found here:
>>> git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>>>      branch rtl8723au-mac80211
>>>
>>> This driver is still under development, but has proven to be very
>>> stable for me. It currently supports station mode only. It has support
>>> for OFDM and CCK rates, as well as AMPDU. It does lack certain
>>> features found in the staging driver, such as power management and
>>> 40MHz channel support. In addition it does not support AD-HOC, AP, and
>>> monitor mode support at this point.
>>>
>>> The driver is known to work with the following devices:
>>> Lenovo Yoga (rtl8723au)
>>> TP-Link TL-WN823N (rtl8192cu)
>>> Etekcity 6R (rtl8188cu)
>>> Daffodil LAN03 (rtl8188cu)
>>> Alfa AWUS036NHR (rtl8188ru)
>
> One other comment is that using lower case such as rtl8723au indicates
> a driver, whereas RTL8723AU is a device. There are no drivers
> rtl8188cu or rtl8188ru.

I don't see this in general - I had upper case in some places in the
driver but it was awful to look at, especially in the dmesg output.

Cheers,
Jes
