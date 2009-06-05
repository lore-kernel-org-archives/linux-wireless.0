Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:59882 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZFEW1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 18:27:48 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1088425ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2009 15:27:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910906051516t55e51136v42b43d67ece04c23@mail.gmail.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	<1244180502-4323-2-git-send-email-lrodriguez@atheros.com>
	<69e28c910906051516t55e51136v42b43d67ece04c23@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 5 Jun 2009 15:27:30 -0700
Message-ID: <43e72e890906051527t12fd67b6ic8ae80b3fb4ffd60@mail.gmail.com>
Subject: Re: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/5 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Fri, Jun 5, 2009 at 7:41 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:

>> index ba06e78..abad86b 100644
>> --- a/drivers/net/wireless/ath/ath9k/rc.c
>> +++ b/drivers/net/wireless/ath/ath9k/rc.c
>> @@ -741,10 +741,24 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
>>        if (rate > (ath_rc_priv->rate_table_size - 1))
>>                rate = ath_rc_priv->rate_table_size - 1;
>>
>> -       ASSERT((rate_table->info[rate].valid &&
>> -               (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
>> -              (rate_table->info[rate].valid_single_stream &&
>> -               !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
>> +       if (rate_table->info[rate].valid &&
>> +           (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG))
>> +               return rate;
>> +
>> +       if (rate_table->info[rate].valid_single_stream &&
>> +           !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG));
>> +               return rate;
>> +
>> +       /*
>> +        * This should not happen, but we know it does for now... This
>> +        * needs a proper fix but we're still not sure how this is caused.
>> +        * Its not *critical* though so lets just warn when debug is enabled
>> +        * for configuration changes.
>> +        */
>> +       if (sc->debug.debug_mask & ATH_DBG_RATE)
>> +               WARN_ON(1);
>
> WARN_ON(sc->debug.debug_mask & ATH_DBG_RATE)

Will do, thanks.

  Luis
