Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f195.google.com ([209.85.223.195]:34575 "EHLO
	mail-ie0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbbFKSoi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 14:44:38 -0400
Received: by iebtr6 with SMTP id tr6so4217866ieb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 11:44:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87vbeubb24.fsf@kamboji.qca.qualcomm.com>
References: <1433812382-10287-1-git-send-email-cfliu.tw@gmail.com> <87vbeubb24.fsf@kamboji.qca.qualcomm.com>
From: "Liu CF/TW" <cfliu.tw@gmail.com>
Date: Thu, 11 Jun 2015 11:43:55 -0700
Message-ID: <CAG5N3qEfcFegKo_hc+oDxA85igEJqv9E42BEPd63iRksJw7b5Q@mail.gmail.com> (sfid-20150611_204441_973616_22984EC6)
Subject: Re: [PATCH v3] ath10k: add 'cryptmode' param to support raw tx
 injection and software crypto
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2015 at 6:59 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Liu CF/TW <cfliu.tw@gmail.com> writes:
>
>> This change supports hardware crypto engine bypass by enabling raw
>> Rx/Tx encap mode. This enables use cases such as software crypto and raw
>> tx injection. This change introduces a new module param 'cryptmode'.
>>
>> cryptmode:
>>
>>   0: Use hardware crypto engine globally with native Wi-Fi mode TX/RX
>>      encapsulation to the firmware. This is the default mode.
>>   1: Use sofware crypto engine globally with raw mode TX/RX encapsulation
>>      to the firmware.
>
> These two values are ok.
>
>>   2: Supports both hardware and software crypto with raw mode TX/RX
>>      encapsulation to the firmware. By default hardware crypto engine is
>>      used. To use software crypto in this mode, set the per ath10k_vif
>>      'nohwcrypt' flag value to True.*
>>      *) The patch for setting vif specific 'nohwcrypt' flag when
>>         cryptmode=2 would be a separate patch to mac80211.
>
> But this the problematic one. I cannot apply something to ath10k until
> Johannes applies the mac80211 part. Didn't I mention this already
> earlier? At least I was supposed to do that.
>

Yes I already removed those mac80211 dependent changes in v3. So this
patch doesn't really depend on any mac80211 change.


> And most importantly does Johannes even agree with the approach? IIRC he
> was pretty reluctant about configuring the crypto mode via nl80211.
>
> I suggest splitting the patch into two: patch 1 adding support for
> cryptmode values 0 and 1, patch 2 adding support for cryptmode 2. That
> way we can commit patch 1 early and see what we can do with patch 2.

Thanks. Will do in v4.
Removing cryptmode=2 is just a enum change. No additional changes in
the business logic required.

After your review of v1, I have implemented knobs in both mac80211's
debugfs and nl80211. I will send an RFC to mac80211 ML to see which
one they prefer.

>
> --
> Kalle Valo
