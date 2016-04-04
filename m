Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22441 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbcDDOzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 10:55:55 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH 0/9] ath10k: improve throughput performance
Date: Mon, 4 Apr 2016 14:55:16 +0000
Message-ID: <874mbhe84s.fsf@kamboji.qca.qualcomm.com> (sfid-20160404_165603_731191_ABF195F3)
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 22 Mar 2016 17:22:10 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Hi All,
>
> In order to reuse HTT Rx descriptor (copy engine 5), HTT response
> processing should be decoupled from txrx data processing. This change also
> helps to reduce rx ring lock contention. As txrx tasklet's work load is
> reduced, rx replenish task can be combined with txrx_task. Refilling
> complete rx ring from txrx tasket is affecting UDP UL traffic in AP135
> platform. Hence existing refill threshold is updated to meet peak
> throughput in both AP135 and AP148 platforms. Instead of tasklet existing
> refill timer is used to reschedule replenish work at an interval of 5 ms
> incase of more deficit.
>
> This series are experimented in both AP148(QCA99x0) & IPQ4019 platforms.
> Below are consolidated report alongwith CPU usage. Thanks Tamizh for helping 
> to verify the changes.
>
>         IPQ4019(TOT)  IPQ4019(+rework)   AP148(TOT)     AP148(+rework)
>         ===========   ===============    ==========     =============
> TCP DL   639 (40%)       646 (42%)       1134 (71%)      1134 (71%)
> TCP UL   661 (31%)       663 (30%)       1244 (71%)      1270 (72%)
> UDP DL   670 (50%)       682 (49%)       1240 (73%)      1244 (75%)
>
>         AP135 (OpenWrt TOT)     AP135 (+changes)
>         ==================      ===============
>
> TCP DL          603             620
> TCP UL          430             428
> UDP DL          758             803
> UDP UL          420             450
>
> -Rajkumar
>
> Rajkumar Manoharan (9):
>   ath10k: speedup htt rx descriptor processing for tx completion
>   ath10k: copy tx fetch indication message
>   ath10k: remove unused fw_desc processing
>   ath10k: cleanup amsdu processing for rx indication
>   ath10k: speedup htt rx descriptor processing for rx_ind
>   ath10k: register ath10k_htt_htc_t2h_msg_handler
>   ath10k: cleanup copy engine receive next completion
>   ath10k: reuse copy engine 5 (htt rx) descriptors
>   ath10k: combine txrx and replenish task

Applied, thanks.

-- 
Kalle Valo