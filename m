Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:18586 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933867AbbJIIgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 04:36:35 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: optimize ce_lock on post rx buffer processing
References: <1444047778-22900-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Fri, 9 Oct 2015 11:36:23 +0300
In-Reply-To: <1444047778-22900-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 5 Oct 2015 17:52:58 +0530")
Message-ID: <87h9m0sak8.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_103641_368408_6B9E9BB5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> After processing received packets from copy engine, host will allocate
> new buffer and queue them back to copy engine ring for further
> packet reception. On post rx processing path, skb allocation and
> dma mapping are unnecessarily handled within ce_lock. This is affecting
> peak throughput and also causing more CPU consumption. Optimize this
> by acquiring ce_lock only when accessing copy engine ring and moving
> skb allocation out of ce_lock.
>
> In AP148 platform with QCA99x0 in conducted environment, UDP uplink peak
> throughput is improved from ~1320 Mbps to ~1450 Mbps and TCP uplink peak
> throughput is increased from ~1240 Mbps (70% host CPU load) to ~1300 Mbps
> (71% CPU load). Similarly ~40Mbps improvement is observed in downlink
> path.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
