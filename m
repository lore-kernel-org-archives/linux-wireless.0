Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20096 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbcFBOvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 10:51:04 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath10k: fix diag_read to collect data for larger memory
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1464187154-26687-1-git-send-email-arnagara@qti.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
	<arnagara@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <8d461713b1d345ebb4e04fb5f6ba44be@euamsexm01a.eu.qualcomm.com> (sfid-20160602_165109_774438_30128195)
Date: Thu, 2 Jun 2016 16:50:56 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> wrote:
> diag_read uses dma_alloc_coherent to allocate memory requested by the
> caller. If this memory requested is larger, more than DIAG_TRANSFER_LIMIT
> (2K), then it is likely that we may not get the requested memory and we
> would fail.
> 
> To solve this, request dma_alloc_coherent for only DIAG_TRANSFER_LIMIT, and
> reuse this buffer multiple times as needed to copy the data requested in
> smaller chunks of size not more than DIAG_TRANSFER_LIMIT. Previously we
> were reading into the caller's only after getting the complete requested
> data.
> 
> Fixes: 68c03249f388 ('ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()')
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

Thanks, 1 patch applied to ath.git:

1e56d5127d5c ath10k: fix diag_read to collect data for larger memory

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9135561/

