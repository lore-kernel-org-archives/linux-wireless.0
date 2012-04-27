Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27788 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab2D0HAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 03:00:50 -0400
To: Kevin Fang <chienf@qca.qualcomm.com>
Message-ID: <4F9A441D.2050107@qca.qualcomm.com> (sfid-20120427_090053_576852_D5EA4D65)
Date: Fri, 27 Apr 2012 10:00:45 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: handle background(BK) stream properly on
 htc mbox layer
References: <1335489482-15565-1-git-send-email-kevin.fang@qca.qualcomm.com>
In-Reply-To: <1335489482-15565-1-git-send-email-kevin.fang@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/27/2012 04:18 AM, Kevin Fang wrote:
> Bug description:
> STA sends huge BK QoS data frame first, then sends BE/VI/VO QoS data frame.
> The corresponding throughput becomes much lower than
> that without sends BK QoS data frame before.
> 
> The root cause is that when station send BK stream,
> the tx credits of BK stream don't return back to
> higher priority QoS stream such as BE, VI, and VO stream.
> This patch will handle BK stream properly,
> when there is higher priority QoS stream,
> it will seek tx credits from BK stream properly.
> 
> Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>

Thanks, both patches applied. I just did minor cosmetic changes to the
commit log (word wrapping etc).

Kalle
