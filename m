Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbbIGBkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 21:40:25 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440968574-29490-2-git-send-email-Jes.Sorensen@redhat.com>
	<87twr7fvbb.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 06 Sep 2015 21:40:23 -0400
In-Reply-To: <87twr7fvbb.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Sun, 06 Sep 2015 17:59:04 +0300")
Message-ID: <wrfjoahff1mg.fsf@redhat.com> (sfid-20150907_034044_601790_9556E757)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> This is an alternate driver for a number of Realtek WiFi USB devices,
>> including RTL8723AU, RTL8188CU, RTL8188RU, RTL8191CU, and RTL8192CU.
>> It was written from scratch utilizing the Linux mac80211 stack.
>>
>> After spending months cleaning up the vendor provided rtl8723au
>> driver, which comes with it's own 802.11 stack included, I decided to
>> rewrite this driver from the bottom up.
>>
>> Many thanks to Johannes Berg for 802.11 insights and help and Larry
>> Finger for help with the vendor driver.
>>
>> The full git log for the development of this driver can be found here:
>> git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>>     branch rtl8723au-mac80211
>>
>> This driver is still under development, but has proven to be very
>> stable for me. It currently supports station mode only. It has support
>> for OFDM and CCK rates, as well as AMPDU. It does lack certain
>> features found in the staging driver, such as power management and
>> 40MHz channel support. In addition it does not support AD-HOC, AP, and
>> monitor mode support at this point.
>>
>> The driver is known to work with the following devices:
>> Lenovo Yoga (rtl8723au)
>> TP-Link TL-WN823N (rtl8192cu)
>> Etekcity 6R (rtl8188cu)
>> Daffodil LAN03 (rtl8188cu)
>> Alfa AWUS036NHR (rtl8188ru)
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> You forgot v2 from the subject.

I'llk send a v3 later fixing up some of the problems people have
reported.

>> v2: Contains fixes for problems reported by Larry Finger
>> ---
>
> Changelog should be under "---" line.
>
>> +static int rtl8xxxu_debug /* = 0 */; /* Avoid pointless checkpatch noise */
>
> Either assign it to zero or ignore the checkpatch warning, but please
> don't do this.

Problem is if I leave the = 0 some people will send pointless patches to
change it. The above gets checkpatch to shut up while leaving the
indication in place.

Jes
