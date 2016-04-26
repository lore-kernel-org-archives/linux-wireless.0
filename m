Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50341 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbcDZJIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:08:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [MOREWORK,
 14/19] rtl818x_pci: Fix a memory leak in rtl8180_init_rx_ring
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <4920ab8faf66e456a1fad1e79607d15a04cbb029.1458262312.git.julian.calaby@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Jia-Ju Bai <baijiaju1990@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Andrea Merello <andrea.merello@gmail.com>,
	linux-wireless@vger.kernel.org
Message-Id: <20160426090843.B9118612F0@smtp.codeaurora.org> (sfid-20160426_110850_167429_2CD5DE4D)
Date: Tue, 26 Apr 2016 09:08:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jia-Ju Bai <baijiaju1990@163.com>
> 
> When dev_alloc_skb or pci_dma_mapping_error in rtl8180_init_rx_ring fails,
> the memory allocated by pci_zalloc_consistent is not freed.
> 
> This patch fixes the bug by adding pci_free_consistent
> in error handling code.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
