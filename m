Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43218 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbcGHGq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 02:46:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: simplify pktlog htt event processing
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1466592761-6659-1-git-send-email-arnagara@qti.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
	<arnagara@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <228b82f3cbc84bf7b217ef50632825cc@euamsexm01a.eu.qualcomm.com> (sfid-20160708_084659_603260_190C231F)
Date: Fri, 8 Jul 2016 08:46:48 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> wrote:
> It is expected that all pktlog events for 10.4 firmware based solutions
> should come through CE8 where as in case of 10.2 firmware based solutions,
> it should come through one of the HTT events (HTT_T2H_MSG_TYPE_PKTLOG).
> 
> But from experiments with 10.4 based solutions, it is observed that pktlog
> event for ATH_PKTLOG_TYPE_TX_MSDU_ID is coming through HTT pktlog event.
> Currently, we always parse with 10.2 pktlog header which will lead to
> pktlog decoding issues (payload length mismatch exceptions)
> 
> For trace points, it is required to provide only the payload size. So
> fixing this by simplifying the payload size calculation without the use of
> ath10k pktlog headers.
> 
> While there, remove the unused ath10k pktlog headers.
> 
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

34293f75586b ath10k: simplify pktlog htt event processing

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9192399/

