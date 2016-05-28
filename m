Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22715 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbcE1IUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 May 2016 04:20:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/6] wil6210: fix race conditions between TX send and completion
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1463426615-15523-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	Maya Erez <qca_merez@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Message-ID: <016c89d7d1be483faf9795a999b63970@euamsexm01a.eu.qualcomm.com> (sfid-20160528_102013_940488_487797AC)
Date: Sat, 28 May 2016 10:19:58 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> There are 2 possible race conditions, both are solved by addition of
> memory barrier:
> 1. wil_tx_complete reads the swhead to determine if the vring is
> empty. In case the swhead was updated before the descriptor update
> was performed in __wil_tx_vring/__wil_tx_vring_tso, the completion
> loop will not end and as the DU bit may still be set from a previous
> run, this skb can be handled as completed before it was sent, which
> will lead to double free of the same SKB.
> 2. __wil_tx_vring/__wil_tx_vring_tso calculate the number of available
> descriptors according to the swtail. In case the swtail is updated
> before memset of ctx to zero is completed, we can handle this
> descriptor while later on ctx is zeroed.
> 
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

Thanks, 6 patches applied to ath.git:

eb26cff148f5 wil6210: fix race conditions between TX send and completion
ab6d7cc3eab4 wil6210: guarantee safe access to rx descriptors shared memory
34b8886e502a wil6210: protect wil_vring_fini_tx in parallel to tx completions
a1526f7eafa4 wil6210: fix dma mapping error cleanup in __wil_tx_vring_tso
e34dc6475a7b wil6210: add pm_notify handling
8fe2a5f9f9b5 wil6210: align wil log functions to wil_dbg_ratelimited implementation

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9105441/

