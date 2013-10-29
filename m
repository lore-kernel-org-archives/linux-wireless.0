Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37709 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3J2Se7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 14:34:59 -0400
Received: by mail-lb0-f170.google.com with SMTP id u14so377428lbd.29
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 11:34:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5311DA48427A8F44AF96B64A3AF0074D06DCDF69@aphydexd01a>
References: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
 <1382375691-25476-3-git-send-email-mcgrof@do-not-panic.com> <5311DA48427A8F44AF96B64A3AF0074D06DCDF69@aphydexd01a>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 29 Oct 2013 19:34:37 +0100
Message-ID: <CAB=NE6VHkcr1D0afHKkp8-jWgqR_7ZbnfKVsQf8hTX_rCN_g+w@mail.gmail.com> (sfid-20131029_193501_765222_9915E603)
Subject: Re: [PATCH 2/5] ath: clean up ath_reg_apply_active_scan_flags()
To: "Shete, Mihir" <smihir@qti.qualcomm.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"Bhattacharyya, Tushnim" <tushnimb@qca.qualcomm.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 29, 2013 at 5:19 PM, Shete, Mihir <smihir@qti.qualcomm.com> wrote:
>
>
>> -----Original Message-----
>> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
>> Rodriguez
>> Sent: Monday, October 21, 2013 10:45 PM
>> To: linville@tuxdriver.com; johannes@sipsolutions.net
>> Cc: linux-wireless@vger.kernel.org; janusz.dziedzic@tieto.com; Shete, Mihir;
>> Bhattacharyya, Tushnim; Luis R. Rodriguez
>> Subject: [PATCH 2/5] ath: clean up ath_reg_apply_active_scan_flags()
>>
>> The routine ath_reg_apply_active_scan_flags() can be a bit hard to read, this
>> cleans it up by adding helpers for the two cases of clearing IR flags or adding
>> them. This approach also makes no assumptions on the index of channels 12
>> and 13 so it should be portable accross different drivers.
>>
>> Cc: smihir@qti.qualcomm.com
>> Cc: tushnimb@qca.qualcomm.com
>> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
>> ---
>>  drivers/net/wireless/ath/regd.c | 101 +++++++++++++++++++++++++-------
>> --------
>>  1 file changed, 63 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/regd.c
>> b/drivers/net/wireless/ath/regd.c index 1b4a532..48e2368 100644
>> --- a/drivers/net/wireless/ath/regd.c
>> +++ b/drivers/net/wireless/ath/regd.c
>> @@ -177,6 +177,47 @@ static bool ath_is_radar_freq(u16 center_freq)
>>       return (center_freq >= 5260 && center_freq <= 5700);  }
>>
>> +static void ath_force_clear_no_ir_chan(struct wiphy *wiphy,
>> +                                    struct ieee80211_channel *ch) {
>> +     const struct ieee80211_reg_rule *reg_rule;
>> +
>> +     reg_rule = freq_reg_info(wiphy, ch->center_freq);
>
> Do we not require to provide the frequency in KHZ here?

Good catch! This has been beautifully broken for eons. And guess, what
all those other drivers that copied the code also have this broken.
I'll just send a follow up patch to fix this on top of this patch for
each driver as they're all broken. In a way this seems to be begging
to just share a reg_notifier between drivers as a few drivers copied
the same behaviour from ath9k.

  Luis
