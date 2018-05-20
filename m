Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33436 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbeETKs2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 06:48:28 -0400
Subject: Re: [RFC v2 09/18] mt76: introduce tx_queue_skb function pointer in
 mt76_bus_ops
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
References: <20180520081522.10163-10-lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <6cae97cf-3c40-9ac9-8a9f-1b6877f3d411@nbd.name> (sfid-20180520_124831_766282_37F3F080)
Date: Sun, 20 May 2018 12:48:26 +0200
MIME-Version: 1.0
In-Reply-To: <20180520081522.10163-10-lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-20 10:15, Lorenzo Bianconi wrote:
> Add tx_queue_skb function pointer in mt76_bus_ops since mt76x2u based
> devices do not map mt76x2_txwi on dma buffers and it is not possible
> to reuse mt76_tx_queue_skb() routine to enqueue tx frames to hw buffers
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Please move mt76_tx_queue_skb to dma.c and rename it to
mt76_dma_tx_queue_skb.

Thanks,

- Felix
