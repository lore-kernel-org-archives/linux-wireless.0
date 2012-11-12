Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53112 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2KLTDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:03:25 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so3966964qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:03:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6X-LvntZ+fOV2b1AGmpQxEqyJNEu-wsc1wP7zvb8+vhFA@mail.gmail.com>
References: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
 <1352746052-1828-2-git-send-email-thomas@cozybit.com> <CAB=NE6X-LvntZ+fOV2b1AGmpQxEqyJNEu-wsc1wP7zvb8+vhFA@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 12 Nov 2012 11:03:04 -0800
Message-ID: <CAG6hwVM0ELJZ2co_=GrUN+7wbOof_2w-q7Fbow3u=Lf-BKG1Qw@mail.gmail.com> (sfid-20121112_200328_493595_080629D6)
Subject: Re: [PATCH 1/2] ath9k: RX timestamp is reported at end of frame
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2012 at 11:00 AM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> On Mon, Nov 12, 2012 at 7:47 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
>> Tested with AR9280.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/recv.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index a04028b..d4df98a 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -976,7 +976,7 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
>>         rx_status->freq = hw->conf.channel->center_freq;
>>         rx_status->signal = ah->noise + rx_stats->rs_rssi;
>>         rx_status->antenna = rx_stats->rs_antenna;
>> -       rx_status->flag |= RX_FLAG_MACTIME_MPDU;
>> +       rx_status->flag |= RX_FLAG_MACTIME_END;
>>         if (rx_stats->rs_moreaggr)
>>                 rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
>
> Thanks but can you clarify the implications of this change within the
> commit log ? Was something not working, if not, why exactly is this
> change important?

Sure.

Thomas
