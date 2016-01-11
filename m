Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbcAKOG1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 09:06:27 -0500
Date: Mon, 11 Jan 2016 15:04:31 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: kvalo@codeaurora.org, johannes.berg@intel.com,
	emmanuel.grumbach@intel.com, ilw@linux.intel.com,
	linuxwifi@intel.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2] iwl4965: Fix a null pointer dereference in
 il_tx_queue_free and il_cmd_queue_free
Message-ID: <20160111140431.GB26139@redhat.com> (sfid-20160111_150642_128278_593DD2F5)
References: <1452519775-7049-1-git-send-email-baijiaju1990@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452519775-7049-1-git-send-email-baijiaju1990@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 11, 2016 at 09:42:54PM +0800, Jia-Ju Bai wrote:
> If "txq->cmd = kzalloc(...)" in il_tx_queue_init fails,
> "kfree(txq->cmd[i])" in il_tx_queue_free and il_cmd_queue_free
> in iwl4965_hw_txq_ctx_free will causes a null pointer dereference,
> because txq->cmd is NULL at that time.
> 
> This patch fixes this problem by adding a if-check before kfree.
> To avoid double free in il_tx_queue_free and il_cmd_queue_free
> caused by the fixing, txq->meta and txq->cmd in error handling code
> of il_tx_queue_init are assigned null values. 
> Otherwise, a double free will occur.
> 
> This patch has been tested in real device, and it actually fixes the bug.
> Thanks Stanislaw for his suggestion.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

