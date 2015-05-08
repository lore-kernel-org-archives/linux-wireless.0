Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59024 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbbEHRwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 13:52:08 -0400
Message-ID: <554CF7C7.8000009@candelatech.com> (sfid-20150508_195230_966358_473F26B2)
Date: Fri, 08 May 2015 10:52:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Liu CF/TW <cfliu.tw@gmail.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param
 for raw tx injection, sw crypto support.
References: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com> <873837qo6l.fsf@kamboji.qca.qualcomm.com> <554CE438.5000208@candelatech.com> <CAG5N3qFB=yZJYSokUqF2=eNcS5SoCOntOyan6_OuahtFF5r=Bw@mail.gmail.com>
In-Reply-To: <CAG5N3qFB=yZJYSokUqF2=eNcS5SoCOntOyan6_OuahtFF5r=Bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2015 10:35 AM, Liu CF/TW wrote:

>> In my CT firmware, I end up using native tx and raw rx to enable rx-sw-crypt.
>>
>> (I could not figure out how to do raw-tx with encrypted frames, though since
>>  10.2 FW can do it, I guess it must be possible...)
>>
>> Maybe we could have a way to specify both rx and rx mode independently of
>> each other to support that use case as well?
>>
>> Maybe:
>>
>>
>> txmode=x;  // 0 == native, 1 == raw (and maybe support other tx modes in the future as desired)
>> rxmode=x;  // 0 == native, 1 == raw
>> nohwcrypt=x; // 0 == standard hw crypt, 0x1 == rx-sw-crypt, 0x2 == tx-sw-crypt, 0x3 == tx/rx-sw-crypt
>>
>> If any limits are placed, please do use feature flags instead of firmware version comparisons
>> ..that way I might can support at least some of this in CT firmware.
>>
>> Thanks,
>> Ben
>>
> 
> 
> I'd assume it's more desirable to have sw crypto supported using the
> same encapsulation mode for both rx/tx, right? Did you see use cases
> that only rx-sw-crypt or only tx-sw-crypt is needed? I prefer Kalle's
> suggestion to use only 1 flag instead of 3.

My own need for sw-crypt is to work around firmware/hardware limitations
that will not allow two station vdevs to be connected to same AP using
encryption (because peer is same for both vdevs, and the key hash collides).

In this case, I can still use hardware tx encryption, I just need to
disable the rx-decryption.  I do this by passing a flag to my
firmware to purposefully mis-configure the rx-decrypt logic so that it
can never find the peer entry when receiving frames.  I also enable raw
rx mode, which lets these un-decrypted frames be received as raw frames.

I still use native tx mode.

The nice thing about this is that I still get CPU offload for tx encryption.

I am glad you have found a way to make 10.2 do full sw-tx-crypt as well,
but at least in my case, that may not be something I want to use for
most scenarios.


> FYI, in my case, I got Tx & Rx working in raw mode for both SW & HW crypto.
> - With FW 10.2, for (injected) encrypted Tx frames from monitor
> interface, there isn't much SW needs to do. Mianly set
> ATH10K_HW_TXRX_RAW + HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT on the HTT Tx
> descriptor is sufficient.
> I found setting raw Tx encap mode on VDEV actually isn't really
> necessary. Per frame control anyway is finer grained control than per
> VDEV.

I think there must be fixes in the 10.2 firmware that are not in stock 10.1
and not in my modified 10.1 that allows this to work.  I was never able to get
my 10.1 based firmware to do a raw tx of an already-encrypted frame.  Stock
10.1 firmware has the same limitation as far as I know.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

