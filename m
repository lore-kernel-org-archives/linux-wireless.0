Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:52407 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZKHTLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 14:11:45 -0500
Received: by iwn10 with SMTP id 10so1926104iwn.4
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 11:11:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091108160056.GA9508@jm.kir.nu>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
	<1257625146-17971-7-git-send-email-lrodriguez@atheros.com>
	<20091108160056.GA9508@jm.kir.nu>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 8 Nov 2009 11:11:31 -0800
Message-ID: <43e72e890911081111l2765118aqf2b969b84daeaf4a@mail.gmail.com>
Subject: Re: [PATCH 06/29] ath9k: use correct hw for tx aggregation TX
	completion
To: Jouni Malinen <j@w1.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 8, 2009 at 8:00 AM, Jouni Malinen <j@w1.fi> wrote:
> On Sat, Nov 07, 2009 at 03:18:43PM -0500, Luis R. Rodriguez wrote:
>> When ath9k virtual wiphys are used the sc->hw will not always represent
>> the active hw, instead we need to get it from the skb->cb private
>> driver area. This ensures the right hw is used to find a sta for
>> the TX'd skb.
>
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -267,7 +267,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>> +     struct ieee80211_hw *hw;
>>       struct ieee80211_hdr *hdr;
>> +     struct ieee80211_tx_info *tx_info;
>> +     struct ath_tx_info_priv *tx_info_priv;
>
>> @@ -280,6 +283,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>> +     tx_info = IEEE80211_SKB_CB(skb);
>> +     tx_info_priv = (struct ath_tx_info_priv *) tx_info->rate_driver_data[0];
>> +     hw = tx_info_priv->aphy->hw;
>
> Umm.. This adds a set of new local variables, but no users for those
> are added here. Was this supposed to also change the following
> ieee80211_find_sta_by_hw() call to use the local hw variable instead of
> sc->hw?

Indeed, my rebase seems to have not gone through well but I do recall
having changed the sc->hw to hw here, will go review to see which
patches need fixing. Thanks for the review.

  Luis
