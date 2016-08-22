Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35056 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755316AbcHVTXy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 15:23:54 -0400
Subject: Re: [PATCH] rtlwifi: Fix missing country code for Great Britain
To: Kalle Valo <kvalo@codeaurora.org>
References: <1471619674-29439-1-git-send-email-Larry.Finger@lwfinger.net>
 <87wpj8vmqs.fsf@kamboji.qca.qualcomm.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <71332954-2da8-ae90-0305-deede823f317@lwfinger.net> (sfid-20160822_212431_638757_C1A75AE9)
Date: Mon, 22 Aug 2016 14:23:29 -0500
MIME-Version: 1.0
In-Reply-To: <87wpj8vmqs.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2016 10:36 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> Some RTL8821AE devices sold in Great Britain have the country code of
>> 0x25 encoded in their EEPROM. This value is not tested in the routine
>> that establishes the regulatory info for the chip. The fix is to set
>> this code to have the same capabilities as the EU countries.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
>
> [...]
>
>> --- a/drivers/net/wireless/realtek/rtlwifi/regd.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
>> @@ -345,9 +345,9 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
>>  		return &rtl_regdom_no_midband;
>>  	case COUNTRY_CODE_IC:
>>  		return &rtl_regdom_11;
>> -	case COUNTRY_CODE_ETSI:
>>  	case COUNTRY_CODE_TELEC_NETGEAR:
>>  		return &rtl_regdom_60_64;
>> +	case COUNTRY_CODE_ETSI:
>>  	case COUNTRY_CODE_SPAIN:
>>  	case COUNTRY_CODE_FRANCE:
>>  	case COUNTRY_CODE_ISRAEL:
>
> I didn't check the full source, but here you seem to be changing also
> the content of ETSI regdomain. The commit log doesn't mention anything
> about that so I want to double check that this is really intentionally.

Yes, I did intend to change all of ETSI. It was previously allowing channels 
appropriate for China and Israel.

I will resubmit with an improved commit message.

Thanks,

Larry
