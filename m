Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbbJWN7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 09:59:12 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: overlap of devices in rtl8xxxu and rtl8192cu
References: <562A2711.9040700@gmail.com>
Date: Fri, 23 Oct 2015 09:59:10 -0400
In-Reply-To: <562A2711.9040700@gmail.com> (Xose Vazquez Perez's message of
	"Fri, 23 Oct 2015 14:24:49 +0200")
Message-ID: <wrfj7fmdit3l.fsf@redhat.com> (sfid-20151023_155915_629241_E4022B60)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
> Kalle Valo wrote:
>
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
>>>     branch rtl8723au-mac80211
>>> 
>>> This driver is still under development, but has proven to be very
>>> stable for me. It currently supports station mode only. It has support
>>> for OFDM and CCK rates. It does lack certain features found in the
>>> staging driver, such as power management, AMPDU, and 40MHz channel
>>> support. In addition it does not support AD-HOC, AP, and monitor mode
>>> support at this point.
>>> 
>>> The driver is known to work with the following devices:
>>> Lenovo Yoga (rtl8723au)
>>> TP-Link TL-WN823N (rtl8192cu)
>>> Etekcity 6R (rtl8188cu)
>>> Daffodil LAN03 (rtl8188cu)
>>> Alfa AWUS036NHR (rtl8188ru)
>>> 
>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Thanks, applied to wireless-drivers-next.git.
>
> There is overlap of devices between rtl8xxxu and rtl8192cu:
> USB_VENDER_ID_REALTEK, 0x8176
> USB_VENDER_ID_REALTEK, 0x8178
> USB_VENDER_ID_REALTEK, 0x817f
> 0x7392, 0x7811

Yes, and there is also a clash with USB IDs between
drivers/staging/rtl8192u and drivers/net/wireless/realtek/rtlwifi - this
is nothing new.

Jes
