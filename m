Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59025 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbcFPPWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:22:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: libertas: Remove create_workqueue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160604135901.GA29897@Karyakshetra>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Andreas Kemnade <andreas@kemnade.info>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
	"Andrew F. Davis" <afd@ti.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Mark Brown <broonie@kernel.org>, Tejun Heo <tj@kernel.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160616152246.B3B6E61457@smtp.codeaurora.org> (sfid-20160616_172312_185158_89D59CA2)
Date: Thu, 16 Jun 2016 15:22:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhaktipriya Shridhar <bhaktipriya96@gmail.com> wrote:
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
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks, 1 patch applied to wireless-drivers-next.git:

f9f905b00b87 libertas: Remove create_workqueue

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9154703/

