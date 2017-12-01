Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35320 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbdLAEXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 23:23:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 01 Dec 2017 09:53:30 +0530
From: akolli@codeaurora.org
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
In-Reply-To: <87bmjjzppd.fsf@kamboji.qca.qualcomm.com>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
 <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
 <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com>
 <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk>
 <87bmjjzppd.fsf@kamboji.qca.qualcomm.com>
Message-ID: <5080a68538fd2d883e15bacaa969661b@codeaurora.org> (sfid-20171201_052513_859058_810F97D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-11-30 22:08, Kalle Valo wrote:
> Toke Høiland-Jørgensen <toke@toke.dk> writes:
> 
>>>> +struct ath10k_10_2_peer_tx_stats {
>>>> +	u8 ratecode[PEER_STATS_FOR_NO_OF_PPDUS];
>>>> +	u8 success_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
>>>> +	__le16 success_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
>>>> +	u8 retry_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
>>>> +	__le16 retry_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
>>>> +	u8 failed_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
>>>> +	__le16 failed_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
>>>> +	u8 flags[PEER_STATS_FOR_NO_OF_PPDUS];
>>>> +	__le32 tx_duration;
>>>> +	u8 tx_ppdu_cnt;
>>>> +	u8 peer_id;
>>>> +} __packed;
>>> 
>>> Toke, hopefully the tx_duration value here helps with ATF
>>> implementation
>>> using QCA988X.
>> 
>> Awesome! What's the semantics of this field? Just total
>> duration spent serving that station in the reporting interval?
>> Does it include retry attempts?
> 
> I have no clue :) I just noticed this while I was reviewing the patch
> internally and immediately recalled our discussions at Seoul. I can try
> to find out, but that will take a long time as I have way too much 
> stuff
> pending at the moment. Hopefully someone more knowledgeable 
> (Anilkumar?)
> can chime in and help.

tx_duration is aggregate time duration of 4 PPDU sent to STA.
FW sends these values for retry packets also.

Thanks,
Anil.
