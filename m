Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr20091.outbound.protection.outlook.com ([40.107.2.91]:30669
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727980AbeGQI2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jul 2018 04:28:04 -0400
Subject: Re: Setting tx retry count in ath10k
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        Ben Greear <greearb@candelatech.com>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com>
 <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de>
From: SEDE <s.deronne@televic.com>
Message-ID: <8b9713fe-7573-f009-d002-13df73315898@televic.com> (sfid-20180717_095650_423039_C87FC190)
Date: Tue, 17 Jul 2018 09:56:39 +0200
MIME-Version: 1.0
In-Reply-To: <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In the standard, 7 is the default for the short retry count, 4 is well 
the default for long retry count.

In ath10k, there is also non_agg_sw_retry_th to control this, will this 
still be used?
Or what is the difference with rc_num_retries?

Kind regards,
Sébastien.


On 2018-07-17 09:39, Benjamin Beichler wrote:
> Hi,
>
> Am 17.07.2018 um 02:37 schrieb Ben Greear:
>> I spent a bit of time looking into setting the tx retry count in
>> ath10k (wave-1 firmware).  The firmware has support for setting this as
>> a vdev parameter, and it defaults to '2', at least in my wave-1 firmware.
>>
>> I enabled propagating the setting from mac80211, ie:
>> iw phy wiphy0 set retry short 2 long 2
>>
>> And while debugging this, I noticed that mac80211 has a default of
>> 4, but the ath10k firmware has a default of 2.  Now, I am not sure
>> if I should enable setting the retry count since it will change
>> the behaviour even if users don't set anything.
>>
> Maybe I'm wrong, but I have in mind, that 7 retries is the default
> setting of mac80211. Although 2 or even 4 seems to be pretty low for the
> overall retry count, so maybe the values are somehow changed in the
> firmware? From our experiments we know (at least for 802.11n) you need
> for normal operation a retry count of something between 5 - 9, but
> sometimes also 12 or 15 is beneficial.
>
> We use for our experimental setup mainly ath9k cards and rt28xx nics,
> and with them you need definitely more retries.
>
> Nonetheless, I don't think the change from 2 to 4 does really affect the
> behavior in a negative way (if it works as expected).
>
>> Any opinions on this?
>>
>> Thanks,
>> Ben
>>
