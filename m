Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38767 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab0GNPhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 11:37:42 -0400
Received: by pwi5 with SMTP id 5so2801195pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 08:37:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19517.12171.792656.215696@gargle.gargle.HOWL>
References: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
	<1279070845-29442-3-git-send-email-lrodriguez@atheros.com>
	<19517.12171.792656.215696@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 14 Jul 2010 08:37:07 -0700
Message-ID: <AANLkTikk-tvwicGx60pHTWV_OrVZvd_Vg8sfRVZBO3Ow@mail.gmail.com>
Subject: Re: [PATCH 2/3] ath9k_htc: implement mac80211 flush op
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 13, 2010 at 8:31 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> This implements the mac80211 flush callback to let mac80211
>> flush the hardware queues when it deems appropriate.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |   24 ++++++++++++++++++++++++
>>  1 files changed, 24 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> index e38ca66..fc234a7 100644
>> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
>> @@ -1803,6 +1803,29 @@ static void ath9k_htc_set_coverage_class(struct ieee80211_hw *hw,
>>       mutex_unlock(&priv->mutex);
>>  }
>>
>> +static void ath9k_htc_flush(struct ieee80211_hw *hw, bool drop)
>> +{
>> +     struct ath9k_htc_priv *priv = hw->priv;
>> +     u8 cmd_rsp;
>> +     int ret;
>> +
>> +     mutex_lock(&priv->mutex);
>> +
>> +     if (priv->op_flags & OP_INVALID)
>> +             goto err;
>> +
>> +     ath9k_htc_ps_wakeup(priv);
>> +
>> +     WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
>> +     if (drop)
>> +             skb_queue_purge(&priv->tx_queue);
>> +
>> +     ath9k_htc_ps_restore(priv);
>> +
>> +err:
>> +     mutex_unlock(&priv->mutex);
>> +}
>> +
>
> I don't think this would work.
>
> Queuing of packets is done in the HIF (USB) layer.
> Flushing would require dropping (or not) the buffered packets in the
> USB layer.

Ah yes, good point, but I don't see us doing an HIF flush prior to
scan either. Even in the cas where we can rm -rf everything I don't
see us doing an HIF flush, for example device stop, or as you noted
ath9k_htc_radio_disable().

> Also, we don't actually require this, since IDLE state
> is handled in radio_disable(), where everything is flushed properly ...

flush() is for other uses, like prior to scanning, it would mean we
can remove some code from where we do flushes as mac80211 would do
that for us in proper places. It also means we can address flushing
within mac80211 instead of the core driver, and we'd do it in one
place, mac80211 instead of drivers.

  Luis
