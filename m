Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39230 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbcF2PnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:43:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: libertas_tf: Remove create_workqueue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160607200853.GA13742@Karyakshetra>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>, Tejun Heo <tj@kernel.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160629154258.60BFC613A6@smtp.codeaurora.org> (sfid-20160629_174334_688909_F49ACD8C)
Date: Wed, 29 Jun 2016 15:42:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhaktipriya Shridhar <bhaktipriya96@gmail.com> wrote:
> alloc_workqueue replaces deprecated create_workqueue().
> 
> A dedicated workqueue has been used since the workitem (viz
> &priv->cmd_work per priv, which maps to lbtf_cmd_work) is involved in
> actual command processing and may be used on a memory reclaim path.
> The workitems require forward progress under memory pressure and hence,
> WQ_MEM_RECLAIM has been set. Since there are only a fixed number of work
> items, explicit concurrency limit is unnecessary here.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks, 1 patch applied to wireless-drivers-next.git:

452fa86e9806 libertas_tf: Remove create_workqueue

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9162447/

