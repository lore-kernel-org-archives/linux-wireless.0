Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31243 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673AbbJHRmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 13:42:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@codeaurora.org>
CC: Peter Oh <poh@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: use pre-allocated DMA buffer in Tx
References: <1443117270-16790-1-git-send-email-poh@qca.qualcomm.com>
	<87fv1lvauk.fsf@kamboji.qca.qualcomm.com>
	<5616A511.5060705@codeaurora.org>
Date: Thu, 8 Oct 2015 20:41:48 +0300
In-Reply-To: <5616A511.5060705@codeaurora.org> (Peter Oh's message of "Thu, 8
	Oct 2015 10:17:05 -0700")
Message-ID: <87fv1ltfz7.fsf@kamboji.qca.qualcomm.com> (sfid-20151008_194210_227802_039696EC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@codeaurora.org> writes:

> Does it happen after you applied copy engine patchset or even without
> the patchset? I saw ath10k_pci_htt_tx_cb in backtrace which is not
> merged to master branch yet. If it only happens after the patchset,
> I'll apply them and look into it if any possibilities are there.

Good point. I thought I was able to reproduce the bug with a clean
master branch, but I now checked the logs and all three cases of this
warning had ath10k_pci_htt_tx_cb in the stack trace. So I must have
accidentally tested with a temporary branch where the pending branch was
merged with master branch.

-- 
Kalle Valo
