Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:50333 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932913Ab0BEH2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 02:28:24 -0500
Message-ID: <4B6BC701.7060407@free.fr>
Date: Fri, 05 Feb 2010 08:21:37 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix rate table choice
References: <1265317566-15372-1-git-send-email-benoit.papillault@free.fr> <19307.41957.838154.472055@gargle.gargle.HOWL>
In-Reply-To: <19307.41957.838154.472055@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith a écrit :
> Benoit Papillault wrote:
>   
>> ath9k rate control choose the rate table based on the current channel
>> (if it is ht40 or not). However, it happens that at this stage, the
>> channel is still ht20 even if the peer sta capabilities would later
>> allow ht40. So let's use peer sta capabilities directly.
>>
>> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
>> ---
>>  drivers/net/wireless/ath/ath9k/rc.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
>> index 1196884..5ce9da5 100644
>> --- a/drivers/net/wireless/ath/ath9k/rc.c
>> +++ b/drivers/net/wireless/ath/ath9k/rc.c
>> @@ -1341,10 +1341,8 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
>>                 if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
>>                         return;
>>
>> -               if (sc->hw->conf.channel_type == NL80211_CHAN_HT40MINUS ||
>> -                   sc->hw->conf.channel_type == NL80211_CHAN_HT40PLUS)
>> -                       oper_cw40 = true;
>> -
>> +               oper_cw40 = (sta->ht_cap.cap &
>> +                            IEEE80211_HT_CAP_SUP_WIDTH_20_40) ? true : false;
>>                 oper_sgi40 = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
>>                         true : false;
>>
>>     
>
> This is wrong, the AP can certainly support HT40/HT20 and switch between them
> dynamically - this patch changes how ath9k reacts to channel switching.
>   
Sure, but when the channel is switched, ath9k rate control is not called 
AFAIK. So nothing is updated.
ath_rate_update is called by rate_control_rate_update, which is only 
called by enable_ht. enable_ht is called as association time and on RX 
beacon. However, since the content of RX beacon is not changed, 
rate_control_rate_update will not be called again. That's what I show in 
my logs...
> The AP can switch its operating channel to HT20 - but the HT40 supported bit
> will _still_ be set. Can you capture the association sequence and check the
> HT_INFO IE ( which is different from HT CAP) ?
>
> Sujith
>   
Will try to do it. I see your point :
- current code never enables ht40 rate table, but the rate table if 
updated if the AP switch to an ht20 operating channel.
- my patch correctly enables ht40 rate table, but is not updated if the 
AP switch to an ht20 operating channel.

Maybe local->oper_channel_type could be passed directly to 
rate_control_rate_update?
Or as Johannes suggest, we could always select the ht40 rate table and 
adapt in ath_get_rate according to hw.conf.channel_type dynamically?

Regards,
Benoit

