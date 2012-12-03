Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39940 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2LCGlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 01:41:32 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so2146970obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Dec 2012 22:41:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAr_hs53SddPbUUAdaqBFjc8fx-sqDPVjqkq645cMptQqsaQOw@mail.gmail.com>
References: <1354393301-11051-1-git-send-email-lewurm@gmail.com>
	<CAAr_hs53SddPbUUAdaqBFjc8fx-sqDPVjqkq645cMptQqsaQOw@mail.gmail.com>
Date: Mon, 3 Dec 2012 12:11:31 +0530
Message-ID: <CAD2nsn1WUzo0jBv=zJ4Bw+A_4=zr9YszCzP+X4ujXFfGwKAk8w@mail.gmail.com> (sfid-20121203_074137_404540_D25474A9)
Subject: Re: [PATCH] ath9k_htc: update RSSI values only when the device is associated
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Bernhard Urban <lewurm@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	c_manoha@qca.qualcomm.com, Sujith.Manoharan@atheros.com,
	linville@tuxdriver.com, m.sujith@gmail.com, nbd@openwrt.org,
	markus@indoo.rs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bernhard,

On Sun, Dec 2, 2012 at 1:56 AM, Bernhard Urban <lewurm@gmail.com> wrote:
> On Sat, Dec 1, 2012 at 9:21 PM, Bernhard Urban <lewurm@gmail.com> wrote:
>> add an if-guard, otherwise iw(8) reports weird signal strengths.
>>
>> The behaviour was fine before this commit:
>> 7c277349ecbd66e19fad3d949fa6ef6c131a3b62
>> This patch is therefore a partially revert of it.
>>
>> Tested with "TP-Link TL-WN722N"
>>
>> Thanks to indoo.rs http://indoo.rs/ for sponsoring
>>
>> Reported-by: Markus Krainz <markus@indoo.rs>
>> Tested-by: Markus Krainz <markus@indoo.rs>
>> Signed-off-by: Bernhard Urban <lewurm@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/htc.h          |    1 +
>>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   29 +++++++++++++++----------
>>  2 files changed, 19 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
>> index 936e920..00ebf1c 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc.h
>> +++ b/drivers/net/wireless/ath/ath9k/htc.h
>> @@ -22,6 +22,7 @@
>>  #include <linux/firmware.h>
>>  #include <linux/skbuff.h>
>>  #include <linux/netdevice.h>
>> +#include <linux/etherdevice.h>
>>  #include <linux/leds.h>
>>  #include <linux/slab.h>
>>  #include <net/mac80211.h>
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
>> index 47e61d0..8b4da3d 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
>> @@ -969,6 +969,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
>>         int hdrlen, padpos, padsize;
>>         int last_rssi = ATH_RSSI_DUMMY_MARKER;
>>         __le16 fc;
>> +       u8 is_mybeacon;
>>
>>         if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
>>                 ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",
>> @@ -1060,22 +1061,28 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
>>         ath9k_process_rate(hw, rx_status, rxbuf->rxstatus.rs_rate,
>>                            rxbuf->rxstatus.rs_flags);
>>
>> -       if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
>> -           !rxbuf->rxstatus.rs_moreaggr)
>> -               ATH_RSSI_LPF(priv->rx.last_rssi,
>> -                            rxbuf->rxstatus.rs_rssi);
>> +       is_mybeacon = ieee80211_is_beacon(fc) &&
>> +               !is_zero_ether_addr(common->curbssid) &&
>> +               ether_addr_equal(hdr->addr3, common->curbssid);
>>
>> -       last_rssi = priv->rx.last_rssi;
>> +       if (is_mybeacon && priv->ah->opmode == NL80211_IFTYPE_STATION) {
>> +               if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
>> +                   !rxbuf->rxstatus.rs_moreaggr)
>> +                       ATH_RSSI_LPF(priv->rx.last_rssi,
>> +                                    rxbuf->rxstatus.rs_rssi);

should we account for IBSS mode ?

>>
>> -       if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
>> -               rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
>> -                                                    ATH_RSSI_EP_MULTIPLIER);
>> +               last_rssi = priv->rx.last_rssi;
>>
>> -       if (rxbuf->rxstatus.rs_rssi < 0)
>> -               rxbuf->rxstatus.rs_rssi = 0;
>> +               if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER)) {
>> +                       s8 rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
>> +                       rxbuf->rxstatus.rs_rssi = rssi;
>> +               }
>> +
>> +               if (rxbuf->rxstatus.rs_rssi < 0)
>> +                       rxbuf->rxstatus.rs_rssi = 0;
>>
>> -       if (ieee80211_is_beacon(fc))
>>                 priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
>> +       }


please cross-verify with ath9k's ath9k_process_rssi, otherwise should be fine.

>>
>>         rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
>>         rx_status->band = hw->conf.channel->band;
>> --
>> 1.7.9.5
>>
>
> I'm sending this patch again, because I'm not sure if I messed up
> something with my mail client in this reply:
> http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg09470.html
>
> It doesn't show up on gmane for linux-wireless and I didn't get an
> answer so far.
>
>
> Thanks,
> Bernhard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
