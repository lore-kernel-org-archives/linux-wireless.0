Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5354AC43461
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 07:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67FF2080C
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 07:33:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Nmb481MI";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Dy05qWxP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgIIHdk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 03:33:40 -0400
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:49974
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbgIIHdj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 03:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599636818;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=iTMWE0vsu9593V6w+Pw8rMzq0zE6ykSu8zGoebQFncI=;
        b=Nmb481MI2nRdVM+jZRC8AZ40D0QB/tvBx2d6A2JDWwS4zznRXYuHqcSP4YdcV9gs
        qgUR0elVhlgoa8eYyUD6ovHvguJNnrV+wrxQWNTCqI5dpJs5x7mw2TENzAmcK0rFysQ
        dueUvFV1RhkhyNuyeIKB8ceWFB263oXMvMl8XyjQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599636818;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=iTMWE0vsu9593V6w+Pw8rMzq0zE6ykSu8zGoebQFncI=;
        b=Dy05qWxPrvqGQSqFNNWOsJsGDDVu61kWsq/fuaWQABKd7EuGZ0MPUEKC9RttACZa
        wS6Ve2JU2kxN5FvnB0vdbTnN9KESsRhuY7RhggxTtq6w17nJsFpXXMKN/v3g+eaHlmt
        9JsaGqaY9/fB/6FVoFCnG4QUaZOCggDt2sM1yvKw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 63BB2C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: switch from 'pci_' to 'dma_' API
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200907193828.318233-1-christophe.jaillet@wanadoo.fr>
References: <20200907193828.318233-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, straube.linux@gmail.com,
        zhengbin13@huawei.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017471c8ca79-31863cec-baa0-43f6-96c2-bd34f321a002-000000@us-west-2.amazonses.com>
Date:   Wed, 9 Sep 2020 07:33:38 +0000
X-SES-Outgoing: 2020.09.09-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> The only file where some GFP_ flags are updated is 'pci.c'.
> 
> When memory is allocated in '_rtl_pci_init_tx_ring()' and
> '_rtl_pci_init_rx_ring()' GFP_KERNEL can be used because both functions are
> called from a probe function and no spinlock is taken.
> 
> The call chain is:
>   rtl_pci_probe
>     --> rtl_pci_init
>       --> _rtl_pci_init_trx_ring
>         --> _rtl_pci_init_rx_ring
>         --> _rtl_pci_init_tx_ring
> 
> 
> @@
> @@
> -    PCI_DMA_BIDIRECTIONAL
> +    DMA_BIDIRECTIONAL
> 
> @@
> @@
> -    PCI_DMA_TODEVICE
> +    DMA_TO_DEVICE
> 
> @@
> @@
> -    PCI_DMA_FROMDEVICE
> +    DMA_FROM_DEVICE
> 
> @@
> @@
> -    PCI_DMA_NONE
> +    DMA_NONE
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_alloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_zalloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_free_consistent(e1, e2, e3, e4)
> +    dma_free_coherent(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_single(e1, e2, e3, e4)
> +    dma_map_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_single(e1, e2, e3, e4)
> +    dma_unmap_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4, e5;
> @@
> -    pci_map_page(e1, e2, e3, e4, e5)
> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_page(e1, e2, e3, e4)
> +    dma_unmap_page(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_sg(e1, e2, e3, e4)
> +    dma_map_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_sg(e1, e2, e3, e4)
> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2;
> @@
> -    pci_dma_mapping_error(e1, e2)
> +    dma_mapping_error(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_consistent_dma_mask(e1, e2)
> +    dma_set_coherent_mask(&e1->dev, e2)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied to wireless-drivers-next.git, thanks.

0dc0b5c29be2 rtlwifi: switch from 'pci_' to 'dma_' API

-- 
https://patchwork.kernel.org/patch/11762141/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

