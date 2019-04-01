Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292B7C10F05
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 11:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E182320883
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554119416;
	bh=6E1G88CUpXHxjfZd+Zai6hjb4/fZgVM51rlu0WlJ5OQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DiaWz6Z9ct5L8vOS6cbg1t/xixkCUJmlNScbWWVieoK4nPm/xXAPdH3pNDH0s9g8r
	 mZdZFdA81/wrIxKKFE5P870bZVyjJfTuiTTr8hCOikv78yMmclhDftyb8CLvAk8ovQ
	 ExpyuCcrHRl3RXKw7gDOBO3JSrqXTf1MdbkqcWPc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbfDALuP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 07:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfDALuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 07:50:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E55C02082C;
        Mon,  1 Apr 2019 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554119414;
        bh=6E1G88CUpXHxjfZd+Zai6hjb4/fZgVM51rlu0WlJ5OQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lOxe+hmQd2HI/Q3umtw12Hh8pmMRX/IBiQRBTOWagrAqGQBi2iL7nrLpX2e4GyD04
         NoLZFIFcmYeOAzJIGvcNyyScnl1jiivNkdVkoXYALpB/NrLfJANULjCigb4C35N12Q
         FIvGiudLIHrJe7wgFSly6krcygr90K3mtrdlEjR0=
Date:   Mon, 1 Apr 2019 13:50:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Jan Viktorin <jan.viktorin@gmail.com>
Subject: Re: [PATCH 4.20, 5.0] mt76x02u: use usb_bulk_msg to upload firmware
Message-ID: <20190401115010.GG8156@kroah.com>
References: <20190328132932.GA16543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328132932.GA16543@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Mar 28, 2019 at 02:29:39PM +0100, Stanislaw Gruszka wrote:
> commit 5de4db8fcb6d6fc7d9064c22841211790c0ab81b upstream.
> 
> We don't need to send firmware data asynchronously, much simpler is just
> use synchronous usb_bulk_msg().
> 
> [ stable note: this patch was originally developed as cleanup, but it
> remove incorrect usage of page_frag_alloc(): alloc more than PAGE_SIZE
> and create not ARCH_DMA_MINALIGN dma buffers needed at least for
> performance reason. Was tested on 5.0 and 4.20, see
> https://bugzilla.kernel.org/show_bug.cgi?id=202673 and
> https://bugzilla.kernel.org/show_bug.cgi?id=202241 ]
> 
> Tested-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h          | 13 ++++++
>  .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 52 +++++++---------------
>  drivers/net/wireless/mediatek/mt76/usb.c           |  1 -
>  3 files changed, 29 insertions(+), 37 deletions(-)

4.20 is now end-of-life, but I have queued this up for 5.0.y, thanks!

greg k-h
