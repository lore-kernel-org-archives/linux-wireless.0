Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33399 "EHLO
	mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbcFEKfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 06:35:17 -0400
Date: Sun, 5 Jun 2016 06:22:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Andrew F. Davis" <afd@ti.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: marvell: libertas: Remove create_workqueue
Message-ID: <20160605102238.GA31708@htj.duckdns.org> (sfid-20160605_123533_943679_3A2BEF08)
References: <20160604135901.GA29897@Karyakshetra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160604135901.GA29897@Karyakshetra>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 04, 2016 at 07:29:01PM +0530, Bhaktipriya Shridhar wrote:
> alloc_workqueue replaces deprecated create_workqueue().
> 
> In if_sdio.c, the workqueue card->workqueue has workitem
> &card->packet_worker, which is mapped to if_sdio_host_to_card_worker.
> The workitem is involved in sending packets to firmware.
> Forward progress under memory pressure is a requirement here.
> 
> In if_spi.c, the workqueue card->workqueue has workitem
> &card->packet_worker, which is mapped to if_spi_host_to_card_worker.
> The workitem is involved in sending command packets from the host.
> Forward progress under memory pressure is a requirement here.
> 
> Dedicated workqueues have been used in both cases since the workitems
> on the workqueues are involved in normal device operation with
> WQ_MEM_RECLAIM set to gurantee forward progress under memory pressure.
> Since there are only a fixed number of work items, explicit concurrency
> limit is unnecessary.
> 
> flush_workqueue is unnecessary since destroy_workqueue() itself calls
> drain_workqueue() which flushes repeatedly till the workqueue
> becomes empty. Hence the calls to flush_workqueue() before
> destroy_workqueue() have been dropped.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
