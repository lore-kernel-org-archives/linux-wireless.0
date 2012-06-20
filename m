Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4009 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2FTFNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 01:13:53 -0400
Message-ID: <4FE15BDE.10407@qca.qualcomm.com> (sfid-20120620_071355_815714_3CD354B0)
Date: Wed, 20 Jun 2012 10:43:02 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	<aeolus@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 05/10] ath9k: advertise supported WoW flags to upper layer
References: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com> <1340120850-9155-6-git-send-email-mohammed@qca.qualcomm.com> <CAGRGNgUhCvTVaCd7KxuvP5ZUNED2vN7yFHdL27Jp+sg183KobQ@mail.gmail.com>
In-Reply-To: <CAGRGNgUhCvTVaCd7KxuvP5ZUNED2vN7yFHdL27Jp+sg183KobQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

>
> On Wed, Jun 20, 2012 at 1:47 AM, Mohammed Shafi Shajakhan
> <mohammed@qca.qualcomm.com>  wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> currently the code supports WoW triggers due to
>> *magic packet
>> *user defined patterns
>> *deauth and disassoc patterns
>> *disconnect - beacon miss, last beacon received timeout,
>> no ack for keeep alive frames.
>>
>> we need to support other WoW offload features in the
>> near future. also a minor cleanup.
>>
>> Cc: Senthil Balasubramanian<senthilb@qca.qualcomm.com>
>> Cc: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
>> Cc: vadivel@qca.qualcomm.com
>> Tested-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> Signed-off-by: Luis R. Rodriguez<mcgrof@qca.qualcomm.com>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/init.c |   20 ++++++++++++++++++--
>>   1 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
>> index 9dfce1a..d08824f 100644
>> --- a/drivers/net/wireless/ath/ath9k/init.c
>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>> @@ -688,8 +688,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>>                 IEEE80211_HW_SPECTRUM_MGMT |
>>                 IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>>
>> -       if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_HT)
>> -                hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
>> +       if (ah->caps.hw_caps&  ATH9K_HW_CAP_HT)
>> +               hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
>
> This doesn't look like it belongs with the rest of the patch.
>

its a minor cleanup, but would be best to do it separately. there is 
also another place i did this thing, thanks i will address in v2.

-- 
thanks,
shafi
