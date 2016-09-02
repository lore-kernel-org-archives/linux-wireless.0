Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49274 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932537AbcIBPwQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:52:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: improve wake_tx_queue ops performance
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160817153253.6615-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
        <rmanohar@codeaurora.org>
Message-ID: <2bbb5b5df5f44598ac35860bcf353d08@euamsexm01a.eu.qualcomm.com> (sfid-20160902_175220_670223_46DC54CA)
Date: Fri, 2 Sep 2016 17:52:08 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> txqs_lock is interfering with wake_tx_queue submitting more frames.
> so queues don't get filled in and don't keep firmware/hardware busy
> enough. This change helps to reduce the txqs_lock contention and
> wake_tx_queue() blockage to being possible in txrx_unref().
> 
> To reduce turn around time of wake_tx_queue ops and to maintain fairness
> among all txqs, the callback is updated to push first txq alone from
> pending list for every wake_tx_queue call. Remaining txqs will be
> processed later upon tx completion.
> 
> Below improvements are observed in push-only mode and validated on
> IPQ4019 platform. With this change, in AP mode ~10Mbps increase is
> observed in downlink (AP -> STA) traffic and approx. 5-10% of CPU
> usage is reduced.
> 
> Major improvement is observed in 1-hop Mesh mode topology in 11ACVHT80.
> Compared to Infra mode, CPU overhead is higher in Mesh mode due to path
> lookup and no fast-xmit support. So reducing spin lock contention is
> helping in Mesh.
> 
>              TOT       +change
>            --------    --------
> TCP DL     545 Mbps    595 Mbps
> TCP UL     555 Mbps    585 Mbps
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

83e164b7679d ath10k: improve wake_tx_queue ops performance

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9286083/
