Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35296 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965692Ab0BZSnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 13:43:15 -0500
Received: by pvc21 with SMTP id 21so103560pvc.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 10:43:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267209201.30426.8.camel@mj>
References: <19335.43241.887933.207404@gargle.gargle.HOWL>
	<1267209201.30426.8.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 26 Feb 2010 10:42:55 -0800
Message-ID: <43e72e891002261042s587f9fb8g9f491b1bac363582@mail.gmail.com>
Subject: Re: [PATCH] ath9k_htc: Add ath9k_htc driver
To: Pavel Roskin <proski@gnu.org>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Vasanth.Thiagarajan@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 26, 2010 at 10:33 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Fri, 2010-02-26 at 16:26 +0530, Sujith wrote:
>
>> Support for AR9271 chipset.
>
> Great news!!!
>
>> --- a/drivers/net/wireless/ath/ath9k/calib.h
>> +++ b/drivers/net/wireless/ath/ath9k/calib.h
>> @@ -114,6 +114,7 @@ struct ath9k_nfcal_hist {
>>  };
>>
>>  #define MAX_PACAL_SKIPCOUNT 8
>> +
>>  struct ath9k_pacal_info{
>
> You may want to omit this part ;-)
>
>> @@ -1240,7 +1228,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
>>  {
>>       struct ath_common *common = ath9k_hw_common(ah);
>>
>> -     if (common->state <= ATH_HW_INITIALIZED)
>> +     if (common->state < ATH_HW_INITIALIZED)
>>               goto free_hw;
>>
>>       if (!AR_SREV_9100(ah))
>
> There are some non-trivial parts like this one that could be submitted
> separately.
>
>> @@ -1249,10 +1237,8 @@ void ath9k_hw_deinit(struct ath_hw *ah)
>>       ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
>>
>>  free_hw:
>> -     if (!AR_SREV_9280_10_OR_LATER(ah))
>> +     if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah))
>>               ath9k_hw_rf_free_ext_banks(ah);
>> -     kfree(ah);
>> -     ah = NULL;
>
> Another one.  Actually, it is trivial, but not ath9k_htc related.
>
> It would be really nice to fast track the ath9k_htc driver to 2.6.34,
> but the changes affecting other devices should be separate, I believe.

While at it, if you can separate the ath9k_hw changes that would be great.

  Luis
