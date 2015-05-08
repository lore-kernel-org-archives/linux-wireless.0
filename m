Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57566 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbbEHQ2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 12:28:41 -0400
Message-ID: <554CE438.5000208@candelatech.com> (sfid-20150508_182850_267267_6D81490F)
Date: Fri, 08 May 2015 09:28:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Liu CF/TW <cfliu.tw@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k/mac80211: add rawtxrx, nohwcrypt module param
 for raw tx injection, sw crypto support.
References: <CAG5N3qG7090vB6XoUaQSHvQw7GpE+gXvJAbKrv7def3nV0OFJw@mail.gmail.com> <873837qo6l.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <873837qo6l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2015 04:54 AM, Kalle Valo wrote:
> Hi David,
> 
> "Liu CF/TW" <cfliu.tw@gmail.com> writes:
> 
>>  - ath10k:   add rawtxrx param for 10.2+ firmware to support sw, hw crypto
>>              engine and raw Tx injection.
>>  - mac80211: Add IEEE80211_KEY_FLAG_RESERVE_TAILROOM support for TKIP and
>>              CCMP required by ath10k and add per BSS(vif) based sw_crypto
>>              control.
> 
> This patch has few major problems. First of all, ath10k and mac80211
> changes should be in separate patches. Secondly the patch is whitespace
> damaged, I recommend using git-send-email to avoid that.
> 
> And there's just too much feature changes in one patch, it's usually
> better to split the features into separate patches. For example, you
> could first add a simple raw mode support to ath10k (ie. the bare
> minimum needed to get the feature) and then adding more advanced
> features per patch.
> 
>> This change enables the raw Tx/Rx feature in ath10k 10.2+ firmware with a
>> module parameter 'rawtxrx'. With rawtxrx=1, the ath10k hardware crypto
>> engine could be optionally skipped to support use cases such as enabling
>> mac80211 sw crypto engine, user level crypto engine, raw Tx frame
>> injection.
> 
> Lots of people, especially in Qualcomm, seem to call this feature as
> "raw mode". Would it be more descriptive to name the module paramer as
> 'rawmode'?
> 
>> Testing: used QCA988x hw 2.0 with 10.2 firmware.
>>
>> ath10k    ath10k     nl80211
>> rawtxrx   nohwcrypt  SW_CRYPTO
>> param     param      attribute    Testing Status
>> -------   ---------  ---------    ---------------------------------
>>    0          0           -         HW CCMP/TKIP tested ok.
>>    0          1           -         Not supported by ath10k hw.
>>    1          0           -         HW CCMP/TKIP tested ok.
>>    1          0           0         BSS 1 tested HW CCMP/TKIP ok.
>>    1          0           1         BSS 2 can bypass HW engine.
>>                                     - mac80211 SW crypto tested ok.
>>                                     - raw Tx frame injection tested ok.
>>    1          1           -         HW crypto globally disabled.
>>                                     - mac80211 SW crypto tested ok.
>>                                     - raw Tx frame injection tested ok.
> 
> I wonder does it make any sense to have nohwcrypt parameter? Especially
> if ath10k doesn't support case rawtxrx=0 and nohwcrypt=1. One
> possibility I came up is to have multiple values for rawtxrx, for
> example is rawtxrx=1 means HW crypt enabled and rawtxrx=2 HW crypt
> disabled. Ideas welcome.


In my CT firmware, I end up using native tx and raw rx to enable rx-sw-crypt.

(I could not figure out how to do raw-tx with encrypted frames, though since
 10.2 FW can do it, I guess it must be possible...)

Maybe we could have a way to specify both rx and rx mode independently of
each other to support that use case as well?

Maybe:


txmode=x;  // 0 == native, 1 == raw (and maybe support other tx modes in the future as desired)
rxmode=x;  // 0 == native, 1 == raw
nohwcrypt=x; // 0 == standard hw crypt, 0x1 == rx-sw-crypt, 0x2 == tx-sw-crypt, 0x3 == tx/rx-sw-crypt

If any limits are placed, please do use feature flags instead of firmware version comparisons
..that way I might can support at least some of this in CT firmware.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

