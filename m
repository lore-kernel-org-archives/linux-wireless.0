Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51755 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310Ab0E0Nv7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 09:51:59 -0400
Message-ID: <4BFE78F7.5010906@openwrt.org>
Date: Thu, 27 May 2010 15:51:51 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: fix dma sync in rx path
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com> <1273842969-3435-1-git-send-email-tom.leiming@gmail.com> <4BED5E08.3050000@openwrt.org> <AANLkTikVkBdTopPJlU2lGkafLIkiiviUHe8J-lTy67y9@mail.gmail.com> <4BED7809.3090204@openwrt.org> <AANLkTikV8cAc4Njpa1cXq1BHRExkwbaKwjlyyH52rgqO@mail.gmail.com> <4BEE689A.9060102@openwrt.org> <AANLkTikFtb1j7x9-d-SpV8AAODQAxNAobIZePCQNLbip@mail.gmail.com> <20100515182540.6f4e140c@tom-lei>
In-Reply-To: <20100515182540.6f4e140c@tom-lei>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-15 12:25 PM, Ming Lei wrote:
> From edd368e7436e7a80c5a43e7ad40cff1f3fa20806 Mon Sep 17 00:00:00 2001
> From: Ming Lei <tom.leiming@gmail.com>
> Date: Fri, 14 May 2010 17:35:51 +0800
> Subject: [PATCH 2/2] ath9k: fix dma sync in rx path(v2)
> 
> If buffer is to be accessed by cpu after dma is over, but
> between dma mapping and dma unmapping, we should use
> dma_sync_single_for_cpu to sync the buffer between cpu with
> device. And dma_sync_single_for_device is used to let
> device gain the buffer again.
> 
> v2: Felix pointed out dma_sync_single_for_device is needed to return
> buffer to device if an unsuccessful status bit check is found.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Sorry for the delay. I've tested your patch and it works for me.

Acked-by: Felix Fietkau <nbd@openwrt.org>
