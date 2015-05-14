Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58708 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836AbbENVQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 17:16:18 -0400
Message-ID: <555510A1.2040607@candelatech.com> (sfid-20150514_231622_557579_DFBD7C9A)
Date: Thu, 14 May 2015 14:16:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Liu CF/TW <cfliu.tw@gmail.com>, Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param
 for raw tx injection, sw crypto support.
References: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com> <873837qo6l.fsf@kamboji.qca.qualcomm.com> <554CE438.5000208@candelatech.com> <CAG5N3qFB=yZJYSokUqF2=eNcS5SoCOntOyan6_OuahtFF5r=Bw@mail.gmail.com> <871tinjosq.fsf@kamboji.qca.qualcomm.com> <5550D629.2090501@candelatech.com> <CAG5N3qE6nA2oEhR5Zk8sS331-ycM+jZLBy2BeGPX0ueHqvJ6Kg@mail.gmail.com> <87oalnchwb.fsf@kamboji.qca.qualcomm.com> <CAG5N3qGJ9jREnNaLF6ik+Z6xOjQTnZ3dZXUW_ODV8iapMWE5mg@mail.gmail.com>
In-Reply-To: <CAG5N3qGJ9jREnNaLF6ik+Z6xOjQTnZ3dZXUW_ODV8iapMWE5mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2015 12:35 PM, Liu CF/TW wrote:
> On Thu, May 14, 2015 at 8:12 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> "Liu CF/TW" <cfliu.tw@gmail.com> writes:
>>
>>> I am going to propose just one single module parameter control: enc_mode
>>>
>>> - enc_mode = 0: Use HW crypto (default),
>>>
>>>    Driver behavior:
>>>       - ath10k driver uses native WiFi mode for both Tx/Rx.
>>>       - ath10k driver configures key to HW.
>>>       Given HW key descriptor is configured, mac80211 would offload Tx
>>> encryption to HW and only do Rx decryption (by mac80211) if HW failed
>>> to do it.
>>
>> But isn't the point here to use 802.11 frames ("raw mode")? Then why
>> name the module paramater as enc_mode? I think that's confusing.
>>
>> And to me enc_mode doesn't tell much, my first thought was "encoding
>> mode". Wouldn't cryptmode tell more to the user?
>>
>>
>
> Thanks for the suggestion. Yes, crypt_mode is better. I didn't mean
> "enc({ap, oding})_mode" but "enc(ryption)_mode"
>
> IMO, the new use cases enabled by the change are sw crypto support and
> raw Tx frame injection (to bypass hw crypto if already encrypted).
> Therefore I suggest use "crypt_mode" as module param so it's clear one
> only needs to set it if sw crypto is desired.
>
> "raw_mode" itself as a module param doesn't mean much to user, it
> doesn't say what new use cases are supported. After all, both native
> wifi and raw mode supports HW crypto.
>
> In Ben's use case, driver that loads CT firmware can continue to run
> without setting anything (default crypt_mode=0 means use HW crypto)
> and FW continues its magic to enable Rx SW crypto fallback.  At some
> point when CT firmware implements the FW feature
> TX_RAW_ENCAP_SUPPORTED, all the crypt_modes=0,1,2 also works there.

This fine for me.  I'll just keep using my patch that enables nohwcrypt
module option to enable my own rx-sw-crypt feature.  If I ever
get raw-tx working for encrypted packets I'll set that flag in
my firmware as you suggest.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

