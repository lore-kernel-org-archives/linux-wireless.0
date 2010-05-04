Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45157 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab0EDTge (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 15:36:34 -0400
Message-ID: <4BE0773A.8090009@openwrt.org>
Date: Tue, 04 May 2010 21:36:26 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix another source of corrupt frames
References: <4BDFD3C1.4000209@openwrt.org> <u2q43e72e891005041109i5106ba24ma7345c4f4c4fde21@mail.gmail.com>
In-Reply-To: <u2q43e72e891005041109i5106ba24ma7345c4f4c4fde21@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-04 8:09 PM, Luis R. Rodriguez wrote:
> On Tue, May 4, 2010 at 12:58 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Atheros hardware supports receiving frames that span multiple
>> descriptors and buffers. In this case, the rx status of every
>> descriptor except for the last one is invalid and may contain random
>> data. Because the driver does not support this, it needs to drop such
>> frames.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>> --- a/drivers/net/wireless/ath/ath9k/common.c
>> +++ b/drivers/net/wireless/ath/ath9k/common.c
>> @@ -57,13 +57,19 @@ static bool ath9k_rx_accept(struct ath_c
>>         * rs_more indicates chained descriptors which can be used
>>         * to link buffers together for a sort of scatter-gather
>>         * operation.
>> -        *
>> +        * reject the frame, we don't support scatter-gather yet and
>> +        * the frame is probably corrupt anyway
>> +        */
>> +       if (rx_stats->rs_more)
>> +               return false;
> 
> Actually this is required by ath9k_htc, it does process these, but
> ath9k doesn't so this could be done within ath9k itself.
I don't see any place in ath9k_htc that processes rs_more. And even if
it did, processing the rx status of a frame that has more descriptors
chained after it would be wrong, since the rx status is only valid for
the last frame of the descriptor chain.
I think my patch would work fine for ath9k_htc as well.

- Felix
