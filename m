Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35022 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3IPRFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 13:05:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 0/7] ath10k: improve TX path
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
	<1379074618-30534-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 16 Sep 2013 20:05:11 +0300
In-Reply-To: <1379074618-30534-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 13 Sep 2013 14:16:51 +0200")
Message-ID: <871u4on1dk.fsf@qca.qualcomm.com> (sfid-20130916_190524_933964_5ED61CAD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset addresses two issues:
>
>  * system/userspace starvation on heavy briding
>    UDP TX
>  * unstable/inconsistent UDP TX throughput
>
> In short the patchset simplifies TX path by
> removing HTC TX workers, makes WMI commands block
> and makes ath10k more responsive to queues
> becoming full. This contributes to both improved
> throughput and makes the system more responsive
> under heavy UDP TX load.
>
> Max stable briding TX (ath10k as TX):
>  UDP w/o patchset: 520mbps
>  UDP w/  patchset: 570mbps
>
>  TCP w/o patchset: 350mbps
>  TCP w/  patchset: 400mbps
>
> Measured with two 2x2 cards, one acting as an AP
> on AP135 board, the other as a STA on a core i5
> laptop. The AP135 was passing traffic from a
> station on LAN/eth1 to the STA/wlan0.
>
> v2:
>  * use DIV_ROUND_UP
>  * comment usage of ath10k_wmi_tx_beacons_nowait
>  * additional check for tx_credits_flow_enabled
>
>
> Michal Kazior (7):
>   ath10k: simplify HTC credits calculation
>   ath10k: add HTC TX credits replenishing notification
>   ath10k: make WMI commands block by design
>   ath10k: simplify HTC command submitting
>   ath10k: improve beacon submission latency
>   ath10k: remove wmi pending count limit
>   ath10k: remove wmi event worker thread

Thanks, applied.

-- 
Kalle Valo
