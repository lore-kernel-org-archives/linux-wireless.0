Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34344 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbLUWsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 17:48:37 -0500
Received: by mail-ig0-f177.google.com with SMTP id m11so39656593igk.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 14:48:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFqt6zY_aQKmHi=ai+4MUVKcy7oDSNsERG0NiDYAAi4HYq+V8w@mail.gmail.com>
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
 <1450344029-5296-2-git-send-email-janusz.dziedzic@tieto.com> <CAFqt6zY_aQKmHi=ai+4MUVKcy7oDSNsERG0NiDYAAi4HYq+V8w@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 22 Dec 2015 09:48:17 +1100
Message-ID: <CAGRGNgUv0A_G20xFzi4iem78ay_HKPqmnG1_pnky3kPa0M2bmQ@mail.gmail.com> (sfid-20151221_234840_431186_60807184)
Subject: Re: [RFC/RFT 2/2] ath9k: request aligned skb
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Dec 22, 2015 at 5:53 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> On Thu, Dec 17, 2015 at 2:50 PM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>>
>> Set NEEDS_ALIGNED4_SKB hw flag.
>> This allow driver to save CPU and remove two memmove
>> from tx path.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/init.c |  1 +
>>  drivers/net/wireless/ath/ath9k/xmit.c | 15 ++++++++++-----
>>  2 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
>> index 6abace6..d578a00 100644
>> --- a/drivers/net/wireless/ath/ath9k/init.c
>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>> @@ -831,6 +831,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>>         ieee80211_hw_set(hw, RX_INCLUDES_FCS);
>>         ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
>>         ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
>> +       ieee80211_hw_set(hw, NEEDS_ALIGNED4_SKBS);
>>
>>         if (ath9k_ps_enable)
>>                 ieee80211_hw_set(hw, SUPPORTS_PS);
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 82fc76f..c3bd1b1 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -2267,11 +2267,15 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
>>         padpos = ieee80211_hdrlen(hdr->frame_control);
>>         padsize = padpos & 3;
>>         if (padsize && skb->len > padpos) {
>> -               if (skb_headroom(skb) < padsize)
>> -                       return -ENOMEM;
>> +               if (ieee80211_hw_check(hw, NEEDS_ALIGNED4_SKBS)) {
>> +                       frmlen -= padsize;
>> +               } else {
>> +                       if (skb_headroom(skb) < padsize)
>> +                               return -ENOMEM;
>>
>> -               skb_push(skb, padsize);
>> -               memmove(skb->data, skb->data + padsize, padpos);
>
>                   why the same lines has been removed and added again ?

The indentation is different as they're now in another if statement
under the if (padsize... statement.

>> +                       skb_push(skb, padsize);
>> +                       memmove(skb->data, skb->data + padsize, padpos);
>> +               }
>>         }
>
>
>
>>
>>
>>         setup_frame_info(hw, sta, skb, frmlen);
>> @@ -2494,7 +2498,8 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
>>
>>         padpos = ieee80211_hdrlen(hdr->frame_control);
>>         padsize = padpos & 3;
>> -       if (padsize && skb->len>padpos+padsize) {
>> +       if (padsize && skb->len > padpos + padsize &&
>> +           !ieee80211_hw_check(sc->hw, NEEDS_ALIGNED4_SKBS)) {
>>                 /*
>>                  * Remove MAC header padding before giving the frame back to
>>                  * mac80211.
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Regards
> Souptick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
