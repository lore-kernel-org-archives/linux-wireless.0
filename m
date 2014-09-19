Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64756 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaISF7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 01:59:10 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so1879142wgh.8
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 22:59:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <541B0445.7040707@candelatech.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
	<1411046487-19544-2-git-send-email-michal.kazior@tieto.com>
	<541B0445.7040707@candelatech.com>
Date: Fri, 19 Sep 2014 07:59:09 +0200
Message-ID: <CA+BoTQnanQmHn_y_5hFZSaEVvCzbY42U+3Z=PVnWTRun-6Jx4g@mail.gmail.com> (sfid-20140919_075916_886330_742B3E7F)
Subject: Re: [PATCH 1/9] ath10k: fix tx/rx chainmask init
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 September 2014 18:11, Ben Greear <greearb@candelatech.com> wrote:
> On 09/18/2014 06:21 AM, Michal Kazior wrote:
>> Firmware reports the number of RF chains so use
>> that for initialization of supp_{tx,rx}_chainmask
>> instead of using a macro for 3x3 chips.
>>
>> This should make tx/rx chainmask reports correct
>> for chips other than 3x3.
>
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 2c42bd5..772cca5 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -2198,6 +2198,9 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
>>               ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
>>       }
>>
>> +     ar->supp_tx_chainmask = (1 << ar->num_rf_chains) - 1;
>> +     ar->supp_rx_chainmask = (1 << ar->num_rf_chains) - 1;
>
> Are there are no chips that support a different number
> of tx and rx chains?

I don't think current firmware interface is capable of advertising
that to the host so I'm guessing there are none yet.


Michał
