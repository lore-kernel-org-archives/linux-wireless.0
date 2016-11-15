Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64622 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938657AbcKOOgZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 09:36:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2,1/2] ath10k: add per peer htt tx stats support for 10.4
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1476783085-10724-2-git-send-email-akolli@qti.qualcomm.com>
References: <1476783085-10724-2-git-send-email-akolli@qti.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <82cc2d18b1e747068ea6a10ca47b212a@euamsexm01a.eu.qualcomm.com> (sfid-20161115_153654_799160_F3A61036)
Date: Tue, 15 Nov 2016 15:36:12 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@qti.qualcomm.com wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
> 
> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
> event, Firmware sends one HTT event for every four PPDUs.
> HTT payload has success pkts/bytes, failed pkts/bytes, retry
> pkts/bytes and rate info per ppdu.
> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
> which are nowadays enabled by default.
> 
> Parse peer stats and update the tx rate information per STA.
> 
> tx rate, Peer stats are tested on QCA4019 with Firmware version
> 10.4-3.2.1-00028.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>

I see a new sparse warning:

drivers/net/wireless/ath/ath10k/htt_rx.c:2290:17: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/htt_rx.c:2290:17:    expected int [signed] peer_id
drivers/net/wireless/ath/ath10k/htt_rx.c:2290:17:    got restricted __le16 [usertype] peer_id

2 patches set to Changes Requested.

9381691 [PATCHv2,1/2] ath10k: add per peer htt tx stats support for 10.4
9381693 [PATCHv2,2/2] ath10k: add support for per sta tx bitrate

-- 
https://patchwork.kernel.org/patch/9381691/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
