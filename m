Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46023 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab1IHXwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 19:52:20 -0400
Message-ID: <4E68ECE2.7060504@qca.qualcomm.com> (sfid-20110909_015232_825562_1578CDAB)
Date: Thu, 8 Sep 2011 19:27:14 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Question: ath6kl (driver/net/wireless/ath/ath6kl) with debug_mask
 value
References: <CADPsn1bsUJqcuwZrW+e92aGms+t+TKRasnGb=ujzzgvz+S1Maw@mail.gmail.com>
In-Reply-To: <CADPsn1bsUJqcuwZrW+e92aGms+t+TKRasnGb=ujzzgvz+S1Maw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sangwook,

On 09/07/2011 04:32 PM, Sangwook Lee wrote:
> I am running ath6kl-cleanup git.

BTW, ath6kl-cleanup.git is not updated anymore. Instead there's now
ath6kl.git which follows wireless-testing. You can find it from
git.kernel.org (when it's up again) or from github.

> If I add debug_mask values with ath6kl.ko as like followings, I get
> the success full results,
> but without this, "iwlist wlan0 scan" fails.
> 
> ath6kl: hw 2.0 fw 3.1.1.149

Hmm, I'm not sure if I have hw 2.0. I try to find one from my "stash" :)

> 1) SCAN success with debug values: ( 0xc44,c40,40)
> $ insmod ath.ko
> $ insmod ath6kl.ko debug_mask=0x40
> $ ifconfig wlan0 up
> $ iwlist wlan0 scan
> 
> 2) SCAN failure
> $ insmod ath.ko
> $ insmod ath6kl.ko
> $ ifconfig wlan0 up
> $ iwlist wlan0 scan
> With this case, there is no coming event "WMI_SCAN_COMPLETE_EVENTID".
> After receiving  "ath6kl: WMI_EXTENSION_EVENTID"
> iwlist shows error message:
>       wlan0     Failed to read scan data : Resource temporarily unavailable

0x40 is ATH6KL_DBG_HTC_RECV. I guess the debug prints slow down the
execution and papers over the bug. At least I can't think of any other
explonation right now.

Before I'm able to find a hw 2.0 device, can you try to debug this more?
When scanning fails can check if ath6kldev_intr_bh_handler() is called
or not? When scanning fails it usually happens because irqs are failing.

Can you share any details about your setup? From linaro.org I assume you
are using an arm board of some sort ;)

Kalle
