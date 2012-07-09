Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3553 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2GIEqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 00:46:08 -0400
Message-ID: <4FFA61FF.7010903@qca.qualcomm.com> (sfid-20120709_064612_774452_A72C2AE2)
Date: Mon, 9 Jul 2012 10:15:51 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: Re: [PATCH v2 1/2] ath9k: Fix MCI cleanup
References: <1341585556-9992-1-git-send-email-mohammed@qca.qualcomm.com> <CAGRGNgVpk4tk0aCyb77_jE4Dg6d_DRW5MzKacr0CTVZE+1O2sg@mail.gmail.com>
In-Reply-To: <CAGRGNgVpk4tk0aCyb77_jE4Dg6d_DRW5MzKacr0CTVZE+1O2sg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On Monday 09 July 2012 04:57 AM, Julian Calaby wrote:
> Hi Mohammed,
>
> On Sat, Jul 7, 2012 at 12:39 AM, Mohammed Shafi Shajakhan
> <mohammed@qca.qualcomm.com> wrote:
>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>
>> We are doing MCI cleanup eventhough BTCOEX is not enabled
>> via module parameter. This means we do ath_mci_cleanup
>> though we skipped calling ath_mci_setup. Yet it does not
>> causes any issues now  as we free the DMA buffer allocated
>> only when it is allocated during ath_mci_setup.
>>
>> Reviewed-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
>> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/gpio.c |    4 +++-
>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
>> index 5eac4d1..43557c2 100644
>> --- a/drivers/net/wireless/ath/ath9k/gpio.c
>> +++ b/drivers/net/wireless/ath/ath9k/gpio.c
>> @@ -387,11 +387,13 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
>>
>>   void ath9k_deinit_btcoex(struct ath_softc *sc)
>>   {
>> +       struct ath_hw *ah = sc->sc_ah;
>> +
>
> Why introduce a new variable if you only use it once?
>

oh yeah, could have avoided that (or) could have make use of it instead 
of sc->sc_ah in 2 places of the same function!

if ((sc->btcoex.no_stomp_timer) &&
             ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
                 ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);

thanks for your review, John had already merged with patch.
We could cleanup this in some future cleanups.


-- 
thanks,
shafi


