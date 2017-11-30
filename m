Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36979 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbdK3Q2v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 11:28:51 -0500
Date: Thu, 30 Nov 2017 17:28:42 +0100
In-Reply-To: <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com> <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com> <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Message-ID: <DAB5EBB8-C820-4056-8AAB-063D05F38BD5@toke.dk> (sfid-20171130_172856_338606_8D7D5BFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




>> +struct ath10k_10_2_peer_tx_stats {
>> +	u8 ratecode[PEER_STATS_FOR_NO_OF_PPDUS];
>> +	u8 success_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
>> +	__le16 success_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
>> +	u8 retry_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
>> +	__le16 retry_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
>> +	u8 failed_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
>> +	__le16 failed_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
>> +	u8 flags[PEER_STATS_FOR_NO_OF_PPDUS];
>> +	__le32 tx_duration;
>> +	u8 tx_ppdu_cnt;
>> +	u8 peer_id;
>> +} __packed;
>
>Toke, hopefully the tx_duration value here helps with ATF
>implementation
>using QCA988X=2E

Awesome! What's the semantics of this field? Just total=20
duration spent serving that station in the reporting interval?
Does it include retry attempts?

-Toke
