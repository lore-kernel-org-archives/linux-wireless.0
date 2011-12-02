Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54064 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab1LBQkt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 11:40:49 -0500
Message-ID: <4ED8FF8A.503@openwrt.org> (sfid-20111202_174052_735185_B369A797)
Date: Fri, 02 Dec 2011 17:40:42 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nikolay Martynov <mar.kolya@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/4] ath9k: use config.enable_ani to check if ani should
 be performed
References: <20111130201051.GC2477@tuxdriver.com> <1322685980-8757-1-git-send-email-mar.kolya@gmail.com> <1322685980-8757-4-git-send-email-mar.kolya@gmail.com> <4ED8B0BA.2020706@openwrt.org> <CALGY4fuiQ5k3yq9UtPVfLRaoDj-4Ui8vThnDnprsCoZNdPcOZw@mail.gmail.com>
In-Reply-To: <CALGY4fuiQ5k3yq9UtPVfLRaoDj-4Ui8vThnDnprsCoZNdPcOZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-12-02 4:22 PM, Nikolay Martynov wrote:
> 2011/12/2 Felix Fietkau <nbd@openwrt.org>:
>> On 2011-11-30 9:46 PM, Nikolay Martynov wrote:
>>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>> index 0b9a0e8..391d59c 100644
>>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>>> @@ -808,7 +808,8 @@ void ath9k_htc_ani_work(struct work_struct *work)
>>>       }
>>>
>>>       /* Verify whether we must check ANI */
>>> -     if ((timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
>>> +     if (sc->sc_ah->config.enable_ani &&
>>> +         (timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
>>>               aniflag = true;
>>>               common->ani.checkani_timer = timestamp;
>>>       }
>> Does not compile, there is no 'sc' variable, use ah->config.enable_ani.
> 
>   Hmm... weird that it didn't fail when I applied this to openwrt.
> Anyway, thanks for letting me know, I'll send an updated patch!
Maybe you didn't enable kmod-ath9k-htc - if that one's disabled, it does
not build this source file.

- Felix
