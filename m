Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51628 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbbCKQA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 12:00:27 -0400
Message-ID: <5500669A.2070105@candelatech.com> (sfid-20150311_170031_483887_296DEE93)
Date: Wed, 11 Mar 2015 09:00:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix PMG by using AES-CMAC/IGTK software crypto
References: <1425994339-15864-1-git-send-email-bartosz.markowski@tieto.com> <54FF157C.7090208@candelatech.com> <CACKGw+FhOsfLX1ZLw0Y17xrrVPEXgQkaUQzjJqA-CHwpD72v-Q@mail.gmail.com>
In-Reply-To: <CACKGw+FhOsfLX1ZLw0Y17xrrVPEXgQkaUQzjJqA-CHwpD72v-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2015 02:17 AM, Bartosz Markowski wrote:
> On 10 March 2015 at 17:02, Ben Greear <greearb@candelatech.com> wrote:
>> On 03/10/2015 06:32 AM, Bartosz Markowski wrote:
>>> While testing with older supplicant, .drv_set_key() was failing due to
>>> higher than ath10k firmware could handle key_index (WMI_MAX_KEY_INDEX == 3).
>>>
>>> --
>>> wpa_driver_nl80211_set_key: ifindex=15 alg=4 addr=0x7f02b129fbe3 key_idx=4 set_tx=0 seq_len=6 key_len=16
>>>     broadcast key
>>> nl80211: set_key failed; err=-22 Invalid argument)
>>> wlan0: WPA: Failed to configure IGTK to the driver
>>> wlan0: RSN: Failed to configure IGTK
>>> --
>>>
>>> In order to fix this case (PMF: AES-CMAC/IGTK) force the AES_CMAC cipher to
>>> be handled by software.
>>
>> How did you get firmware to allow the host to do the encryption?
> :
>> Every time I've tried such a thing I end up with either nothing or garbage on
>> the air.
>>
>> Or this this particular type of encryption treated differently by the
>> firmware?
> 
> I would suspect so, but it's just my gut feeling. I did not check this
> on a firmware level, as the PMF (AES_CMAC) encryption was done this
> way from the very beggining in ath10k.
> This patch only address the key_idx exceeded case, where
> ath10k_set_key() was returning -ENOSPC, so we could inform mac80211
> explicitly (by returning '1') it shall do the encryption in software.

One of my very early patches when trying to use ath10k was to ask
the firmware for one extra key slot.  Maybe I hit the same problem
you did.  I'll have to try reverting my patch and try yours instead
some day.

Thanks,
Ben

> 
> -Bartosz
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

