Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34951 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab0J0VVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 17:21:14 -0400
Received: by gwj21 with SMTP id 21so801494gwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 14:21:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinbaAk-=xqhuJ4bJWoLw2cF+iBTEa0S6xfxw4UP@mail.gmail.com>
References: <alpine.DEB.2.00.1010102245220.31264@bigbill> <4CB22F79.60806@openwrt.org>
 <AANLkTinbaAk-=xqhuJ4bJWoLw2cF+iBTEa0S6xfxw4UP@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 27 Oct 2010 14:20:52 -0700
Message-ID: <AANLkTikk_LDfMD71teckmYxLDcjhrUoy_J0gR4HOirt8@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath9k: built-in rate control A-MPDU fix
To: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjorn.smedman@venatech.se>
Cc: Felix Fietkau <nbd@openwrt.org>, linville@tuxdriver.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/10/10 Björn Smedman <bjorn.smedman@venatech.se>:
> 2010/10/10 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-10-10 10:51 PM, Björn Smedman wrote:
>>> --- a/drivers/net/wireless/ath/ath9k/rc.c
>>> +++ b/drivers/net/wireless/ath/ath9k/rc.c
>>> @@ -1375,6 +1375,12 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
>>>       if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
>>>               return;
>>>
>>> +     if (!(tx_info->flags & IEEE80211_TX_STAT_AMPDU)) {
>>> +             tx_info->status.ampdu_ack_len =
>>> +                     (tx_info->flags & IEEE80211_TX_STAT_ACK ? 1 : 0);
>>> +             tx_info->status.ampdu_len = 1;
>>> +     }
>>> +
>> Shouldn't mac80211 do this instead?
>
> I guess you could move this into mac80211 but that would change the
> suggested contract: (1) the ampdu_len and ampdu_ack_len fields of the
> tx status structure must be set correctly by the driver if the
> IEEE80211_TX_STAT_AMPDU flag is set, and (2) the value of these fields
> must not be relied upon by rate control if the flag is not set. I
> personally think this is more clean than having rate control
> algorithms trust the value of ampdu_len and ampdu_ack_len even when
> the frame has clearly not been aggregated.
>
> If the interface was correct in principle I think I could be persuaded
> with a simple renaming of the fields, but in this case the interface
> is fundamentally broken (e.g. in the case of an aggregate in which all
> frames failed to be ACKed and are to be software retried - no rate
> control feedback is possible).
>
> For that reason I think we should push the temporary/ugly code out
> into drivers and rate control plugins and not try to "tidy up" the
> wrong solution in mac80211. But that's just my two cents of course.

what's the status of this patch

 Luis
