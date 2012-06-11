Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6820 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2FKNO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 09:14:26 -0400
Message-ID: <4FD5EF2D.7050801@qca.qualcomm.com> (sfid-20120611_151433_000022_5D603345)
Date: Mon, 11 Jun 2012 16:14:21 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V3 1/2] ath6kl: Fix race in aggregation reorder logic
References: <1338361032-6098-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1338361032-6098-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 09:57 AM, Vasanthakumar Thiagarajan wrote:
> There are many places where tid data are accessed without
> the lock (rxtid->lock), this can lead to a race condition
> when the timeout handler for aggregatin reorder and the
> receive function are getting executed at the same time.
> Fix this race, but still there are races which can not
> be fixed without rewriting the whole aggregation reorder
> logic, for now fix the obvious ones.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
