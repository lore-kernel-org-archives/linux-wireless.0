Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33406 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab0IVT7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 15:59:11 -0400
Received: by eyb6 with SMTP id 6so274491eyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 12:59:10 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Alex Mihaylov <minimumlaw@gmail.com>
Subject: Re: p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)
Date: Wed, 22 Sep 2010 23:59:02 +0400
Cc: "linux-wireless Mail List" <linux-wireless@vger.kernel.org>
References: <AANLkTik3_o03=m0w8XM_B-YTQrR-ibkbtTBErXfcYwGG@mail.gmail.com> <AANLkTinevz-Re9z15CO5tXHygP2n4F13=QUGFsyZLdTC@mail.gmail.com> <AANLkTik7+xBVye_s6gM3XqSn+abPbAoD9RVWOhfrtkkc@mail.gmail.com>
In-Reply-To: <AANLkTik7+xBVye_s6gM3XqSn+abPbAoD9RVWOhfrtkkc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009222359.03621.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> WOW! Bingo! Unfortunately, I'm home now! Tomorroy I try make this tips:
> 
>   SPIDRV_ChipSelect(HIGH);
>   SPIDRV_ChipSelect(LOW); // Start transactions to Data register
> 
> This job NOT maked by XScale SPI driver.
> Hm... Is Omap SPI driver do this? How?

Seems to me that omap2_mcspi_work in drivers/spi/omap2_mcspi.c does it by the calls to omap2_mcspi_force_cs. 

Thanks.
-- Max
