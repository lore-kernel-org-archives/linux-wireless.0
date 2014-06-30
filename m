Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56822 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaF3FlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 01:41:09 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so7727063wgg.32
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 22:41:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8761jmtp1y.fsf@kamboji.qca.qualcomm.com>
References: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
	<1403860015-31601-3-git-send-email-michal.kazior@tieto.com>
	<8761jmtp1y.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 30 Jun 2014 07:41:07 +0200
Message-ID: <CA+BoTQ=n-NGGbJ9tJ+Q=7Lhnd2XxWTWRZLBV-q1gDoc7bFitrA@mail.gmail.com> (sfid-20140630_074113_509390_551EB819)
Subject: Re: [RFC/RFT 2/2] ath10k: fix Rx aggregation reordering
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Denton Gentry <denton.gentry@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 June 2014 16:17, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Firmware doesn't perform Rx reordering so it is
>> left to the host driver to do that.
>>
>> Use mac80211 to perform reordering instead of
>> re-inventing the wheel.
>>
>> This fixes TCP throughput issues in some
>> environments (notably Windows stations connecting
>> to ath10k AP).
>>
>> Reported-By: Denton Gentry <denton.gentry@gmail.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -21,6 +21,7 @@
>>  #include "txrx.h"
>>  #include "debug.h"
>>  #include "trace.h"
>> +#include "mac.h"
>
> Why this? At least from a quick search I didn't see any reason to add this.

ath10k_get_arvif()


>>
>>  #include <linux/log2.h>
>>
>> @@ -1533,10 +1534,95 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
>>       case HTT_T2H_MSG_TYPE_STATS_CONF:
>>               trace_ath10k_htt_stats(skb->data, skb->len);
>>               break;
>> +     case HTT_T2H_MSG_TYPE_RX_ADDBA: {
>> +             struct ath10k *ar = htt->ar;
>> +             struct htt_rx_addba *ev = &resp->rx_addba;
>> +             struct ath10k_peer *peer;
>> +             struct ath10k_vif *arvif;
>> +             u16 info0, tid, peer_id;
>> +
>> +             info0 = __le32_to_cpu(ev->info0);
>> +             tid = MS(info0, HTT_RX_BA_INFO0_TID);
>> +             peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
>
> This event handling is pretty long. I think it would be better to have a
> separate function for this event.
>
>> +     case HTT_T2H_MSG_TYPE_RX_DELBA: {
>> +             struct ath10k *ar = htt->ar;
>> +             struct htt_rx_addba *ev = &resp->rx_addba;
>> +             struct ath10k_peer *peer;
>> +             struct ath10k_vif *arvif;
>> +             u16 info0, tid, peer_id;
>
> And the same for this event.

Good idea. I'll do that.


Michał
