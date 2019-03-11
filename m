Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8EBC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48F5A2075C
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfCKNkA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfCKNj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:39:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A1198830B;
        Mon, 11 Mar 2019 13:39:59 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E028D1001E69;
        Mon, 11 Mar 2019 13:39:56 +0000 (UTC)
Date:   Mon, 11 Mar 2019 14:39:55 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH 2/4] mt76: mmio: move mt76_insert_hdr_pad in
 mt76_dma_tx_queue_skb
Message-ID: <20190311133954.GD6089@redhat.com>
References: <cover.1552306908.git.lorenzo@kernel.org>
 <e03a38968b3bca0a51a832bdb0dd9ff1beff314d.1552306908.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e03a38968b3bca0a51a832bdb0dd9ff1beff314d.1552306908.git.lorenzo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 11 Mar 2019 13:39:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 01:35:24PM +0100, Lorenzo Bianconi wrote:
> Introduce tx_aligned4_skbs in mt76_driver_ops and move
> mt76_insert_hdr_pad in mt76_dma_tx_queue_skb. This is a preliminary
> patch in order to unify tx dma mapping for mt76x02 and new chipsets
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/dma.c          |  3 +++
>  drivers/net/wireless/mediatek/mt76/mt76.h         |  1 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
>  drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 13 +++++--------
>  drivers/net/wireless/mediatek/mt76/mt76x2/pci.c   |  1 +
>  5 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
> index a66832a02281..14dd6585bab4 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -300,6 +300,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
>  	}
>  
>  	skb->prev = skb->next = NULL;
> +	if (dev->drv->tx_aligned4_skbs)
> +		mt76_insert_hdr_pad(skb);

We need 4 bytes aligned skbs for mt76x02 or we just need header
lenght be multiple of 4 ?  

Stanislaw

