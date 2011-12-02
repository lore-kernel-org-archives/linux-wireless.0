Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53902 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab1LBPWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 10:22:19 -0500
Received: by faaq16 with SMTP id q16so2130739faa.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2011 07:22:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED8B0BA.2020706@openwrt.org>
References: <20111130201051.GC2477@tuxdriver.com>
	<1322685980-8757-1-git-send-email-mar.kolya@gmail.com>
	<1322685980-8757-4-git-send-email-mar.kolya@gmail.com>
	<4ED8B0BA.2020706@openwrt.org>
Date: Fri, 2 Dec 2011 10:22:17 -0500
Message-ID: <CALGY4fuiQ5k3yq9UtPVfLRaoDj-4Ui8vThnDnprsCoZNdPcOZw@mail.gmail.com> (sfid-20111202_162225_060780_B32EB077)
Subject: Re: [PATCH v3 3/4] ath9k: use config.enable_ani to check if ani
 should be performed
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/2 Felix Fietkau <nbd@openwrt.org>:
> On 2011-11-30 9:46 PM, Nikolay Martynov wrote:
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> index 0b9a0e8..391d59c 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> @@ -808,7 +808,8 @@ void ath9k_htc_ani_work(struct work_struct *work)
>>       }
>>
>>       /* Verify whether we must check ANI */
>> -     if ((timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
>> +     if (sc->sc_ah->config.enable_ani &&
>> +         (timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
>>               aniflag = true;
>>               common->ani.checkani_timer = timestamp;
>>       }
> Does not compile, there is no 'sc' variable, use ah->config.enable_ani.

  Hmm... weird that it didn't fail when I applied this to openwrt.
Anyway, thanks for letting me know, I'll send an updated patch!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
