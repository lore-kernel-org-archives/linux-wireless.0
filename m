Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50235 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab0ENO2f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 10:28:35 -0400
Message-ID: <4BED5E08.3050000@openwrt.org>
Date: Fri, 14 May 2010 16:28:24 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: tom.leiming@gmail.com
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: fix dma sync in rx path
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com> <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-14 3:16 PM, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> If buffer is to be accessed by cpu after dma transfer is over, but
> between dma mapping and dma unmapping, we should use
> dma_sync_single_for_cpu to sync the buffer between cpu with
> device. And dma_sync_single_for_device is used to let
> device gain the buffer again.
I think this patch is wrong. On most MIPS devices,
dma_sync_single_for_cpu is a no-op. In fact, with this patch, the rx
path fails very quickly.
I believe keeping the dma_sync_single_for_device variant is necessary
for all syncs.

- Felix
