Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:5687 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbbG3OF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 10:05:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: initialize msdu ext. descriptor before use
References: <1437694326-31977-1-git-send-email-poh@qca.qualcomm.com>
Date: Thu, 30 Jul 2015 17:05:47 +0300
In-Reply-To: <1437694326-31977-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Thu, 23 Jul 2015 16:32:06 -0700")
Message-ID: <87r3np3flw.fsf@kamboji.qca.qualcomm.com> (sfid-20150730_160611_815901_519D84DB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Initial QCA99X0 support has a known issue with TCP Tx throughput.
> All other path such as UDP Tx/Rx and TCP Rx meet their expectation
> (> 900Mbps), but TCP Tx marked as low as 5Mbps when single pair is
> used on iperf.
>
> The root cause is turned out because TSO flag is not initialized
> properly so that firmware configures TSO in wrong way.
> TSO flags in msdu extension descriptor is required to be reset
> to indicate firmware there is no TSO is enabled, otherwise it
> could act as TSO is enabled which causes huge throughput drop.
>
> In fact, it's enough by resetting TSO flags only to prevent the
> unexpected behavior, but initializing whole msdu ext. descriptor
> will help to clear uncertainty of firmware could bring on as it
> constantly updated.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
