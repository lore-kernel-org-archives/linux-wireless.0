Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21221 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbcLOIoA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 03:44:00 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath9k: Introduce airtime fairness scheduling between stations
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161128101256.6721-1-toke@toke.dk>
References: <20161128101256.6721-1-toke@toke.dk>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
CC: <make-wifi-fast@lists.bufferbloat.net>,
        <linux-wireless@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Message-ID: <5a4a2fe919de44ab8f5ffffcf5db8911@euamsexm01a.eu.qualcomm.com> (sfid-20161215_094404_363384_01FAE840)
Date: Thu, 15 Dec 2016 09:43:39 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen wrote:
> This reworks the ath9k driver to schedule transmissions to connected
> stations in a way that enforces airtime fairness between them. It
> accomplishes this by measuring the time spent transmitting to or
> receiving from a station at TX and RX completion, and accounting this to
> a per-station, per-QoS level airtime deficit. Then, an FQ-CoDel based
> deficit scheduler is employed at packet dequeue time, to control which
> station gets the next transmission opportunity.
> 
> Airtime fairness can significantly improve the efficiency of the network
> when station rates vary. The following throughput values are from a
> simple three-station test scenario, where two stations operate at the
> highest HT20 rate, and one station at the lowest, and the scheduler is
> employed at the access point:
> 
>                   Before   /   After
> Fast station 1:    19.17   /   25.09 Mbps
> Fast station 2:    19.83   /   25.21 Mbps
> Slow station:       2.58   /    1.77 Mbps
> Total:             41.58   /   52.07 Mbps
> 
> The benefit of airtime fairness goes up the more stations are present.
> In a 30-station test with one station artificially limited to 1 Mbps,
> we have seen aggregate throughput go from 2.14 to 17.76 Mbps.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>

Patch applied to ath-next branch of ath.git, thanks.

63fefa050477 ath9k: Introduce airtime fairness scheduling between stations

-- 
https://patchwork.kernel.org/patch/9449275/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
