Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:3532 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752499AbdK3QO4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Nov 2017 11:14:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "toke@toke.dk" <toke@toke.dk>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "akolli@codeaurora.org" <akolli@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Anilkumar Kolli" <akolli@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
Date: Thu, 30 Nov 2017 16:14:49 +0000
Message-ID: <87k1y7zqtj.fsf@kamboji.qca.qualcomm.com> (sfid-20171130_171515_581495_B0068A08)
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
        <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
In-Reply-To: <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
        (akolli@qti.qualcomm.com's message of "Thu, 30 Nov 2017 18:28:21        +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<akolli@qti.qualcomm.com> writes:

> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>
> 10.2.4 firmware branch (used in QCA988X) does not support
> HTT_10_4_T2H_MSG_TYPE_PEER_STATS and that's why ath10k does not provide
> tranmission rate statistics to user space, instead it just shows
> hardcoded 6 Mbit/s. But pktlog firmware facility provides per peer tx
> statistics. The firmware sends one pktlog event for every four
> PPDUs per peer, which include:
>
> * successful number of packets and bytes transmitted
> * number of packets and bytes dropped
> * retried number of packets and bytes
> * rate info per ppdu
>
> Firmware supports WMI_SERVICE_PEER_STATS, pktlog is enabled through
> ATH10K_FLAG_PEER_STATS, which is nowadays enabled by default in ath10k.
>
> This patch does not impact throughput.
>
> Tested on QCA9880 with firmware version 10.2.4.70.48. This should also
> work with firmware branch 10.2.4-1.0-00029
>
> Parse peer stats from pktlog packets and update the tx rate information
> per STA. This way user space can query about transmit rate with iw:
>
> $iw wlan0 station dump
> Station 3c:a9:f4:72:bb:a4 (on wlan1)
>         inactive time:  8210 ms
>         rx bytes:       9166
>         rx packets:     44
>         tx bytes:       1105
>         tx packets:     9
>         tx retries:     0
>         tx failed:      1
>         rx drop misc:   3
>         signal:         -75 [-75, -87, -88] dBm
>         signal avg:     -75 [-75, -85, -88] dBm
>         tx bitrate:     39.0 MBit/s MCS 10
>         rx bitrate:     26.0 MBit/s MCS 3
>         rx duration:    23250 us
>         authorized:     yes
>         authenticated:  yes
>         associated:     yes
>         preamble:       short
>         WMM/WME:        yes
>         MFP:            no
>         TDLS peer:      no
>         DTIM period:    2
>         beacon interval:100
>         short preamble: yes
>         short slot time:yes
>         connected time: 22 seconds
>
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>

[...]

> +struct ath10k_10_2_peer_tx_stats {
> +	u8 ratecode[PEER_STATS_FOR_NO_OF_PPDUS];
> +	u8 success_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
> +	__le16 success_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
> +	u8 retry_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
> +	__le16 retry_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
> +	u8 failed_pkts[PEER_STATS_FOR_NO_OF_PPDUS];
> +	__le16 failed_bytes[PEER_STATS_FOR_NO_OF_PPDUS];
> +	u8 flags[PEER_STATS_FOR_NO_OF_PPDUS];
> +	__le32 tx_duration;
> +	u8 tx_ppdu_cnt;
> +	u8 peer_id;
> +} __packed;

Toke, hopefully the tx_duration value here helps with ATF implementation
using QCA988X.

--=20
Kalle Valo=
