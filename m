Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74956C43387
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 10:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD802073D
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 10:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfACKLn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 05:11:43 -0500
Received: from 7.mo7.mail-out.ovh.net ([46.105.43.131]:47171 "EHLO
        7.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727600AbfACKLn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 05:11:43 -0500
X-Greylist: delayed 7799 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2019 05:11:42 EST
Received: from player697.ha.ovh.net (unknown [10.109.143.208])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 42DF1F1351
        for <linux-wireless@vger.kernel.org>; Thu,  3 Jan 2019 08:42:46 +0100 (CET)
Received: from RCM-web4.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player697.ha.ovh.net (Postfix) with ESMTPSA id 829CF14C7FCA;
        Thu,  3 Jan 2019 07:42:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 03 Jan 2019 08:42:36 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH mips-fixes] MIPS: BCM47XX: Setup struct device for the SoC
In-Reply-To: <c09303d8-a74b-a472-485e-2b4ed7f97acf@hauke-m.de>
References: <20190102125147.3282-1-zajec5@gmail.com>
 <c09303d8-a74b-a472-485e-2b4ed7f97acf@hauke-m.de>
Message-ID: <8437d9abfc02d62b00f1e497d1b57308@milecki.pl>
X-Sender: rafal@milecki.pl
User-Agent: Roundcube Webmail/1.3.8
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
X-Ovh-Tracer-Id: 13616070525805235789
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrudejgdduudehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-02 16:50, Hauke Mehrtens wrote:
> On 1/2/19 1:51 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> So far we never had any device registered for the SoC. This resulted 
>> in
>> some small issues that we kept ignoring like:
>> 1) Not working GPIOLIB_IRQCHIP (gpiochip_irqchip_add_key() failing)
>> 2) Lack of proper tree in the /sys/devices/
>> 3) mips_dma_alloc_coherent() silently handling empty coherent_dma_mask
>> 
>> Kernel 4.19 came with a lot of DMA changes and caused a regression on
>> bcm47xx. Starting with the commit f8c55dc6e828 ("MIPS: use generic dma
>> noncoherent ops for simple noncoherent platforms") DMA coherent
>> allocations just fail. Example:
>> [    1.114914] bgmac_bcma bcma0:2: Allocation of TX ring 0x200 failed
>> [    1.121215] bgmac_bcma bcma0:2: Unable to alloc memory for DMA
>> [    1.127626] bgmac_bcma: probe of bcma0:2 failed with error -12
>> [    1.133838] bgmac_bcma: Broadcom 47xx GBit MAC driver loaded
>> 
>> The bgmac driver also triggers a WARNING:
>> [    0.959486] ------------[ cut here ]------------
>> [    0.964387] WARNING: CPU: 0 PID: 1 at 
>> ./include/linux/dma-mapping.h:516 bgmac_enet_probe+0x1b4/0x5c4
>> [    0.973751] Modules linked in:
>> [    0.976913] CPU: 0 PID: 1 Comm: swapper Not tainted 4.19.9 #0
>> [    0.982750] Stack : 804a0000 804597c4 00000000 00000000 80458fd8 
>> 8381bc2c 838282d4 80481a47
>> [    0.991367]         8042e3ec 00000001 804d38f0 00000204 83980000 
>> 00000065 8381bbe0 6f55b24f
>> [    0.999975]         00000000 00000000 80520000 00002018 00000000 
>> 00000075 00000007 00000000
>> [    1.008583]         00000000 80480000 000ee811 00000000 00000000 
>> 00000000 80432c00 80248db8
>> [    1.017196]         00000009 00000204 83980000 803ad7b0 00000000 
>> 801feeec 00000000 804d0000
>> [    1.025804]         ...
>> [    1.028325] Call Trace:
>> [    1.030875] [<8000aef8>] show_stack+0x58/0x100
>> [    1.035513] [<8001f8b4>] __warn+0xe4/0x118
>> [    1.039708] [<8001f9a4>] warn_slowpath_null+0x48/0x64
>> [    1.044935] [<80248db8>] bgmac_enet_probe+0x1b4/0x5c4
>> [    1.050101] [<802498e0>] bgmac_probe+0x558/0x590
>> [    1.054906] [<80252fd0>] bcma_device_probe+0x38/0x70
>> [    1.060017] [<8020e1e8>] really_probe+0x170/0x2e8
>> [    1.064891] [<8020e714>] __driver_attach+0xa4/0xec
>> [    1.069784] [<8020c1e0>] bus_for_each_dev+0x58/0xb0
>> [    1.074833] [<8020d590>] bus_add_driver+0xf8/0x218
>> [    1.079731] [<8020ef24>] driver_register+0xcc/0x11c
>> [    1.084804] [<804b54cc>] bgmac_init+0x1c/0x44
>> [    1.089258] [<8000121c>] do_one_initcall+0x7c/0x1a0
>> [    1.094343] [<804a1d34>] kernel_init_freeable+0x150/0x218
>> [    1.099886] [<803a082c>] kernel_init+0x10/0x104
>> [    1.104583] [<80005878>] ret_from_kernel_thread+0x14/0x1c
>> [    1.110107] ---[ end trace f441c0d873d1fb5b ]---
>> 
>> This patch setups a "struct device" (and passes it to the bcma) which
>> allows fixing all the mentioned problems. It'll also require a tiny 
>> bcma
>> patch which will follow through the wireless tree & its maintainer.
>> 
>> Fixes: f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple 
>> noncoherent platforms")
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: stable@vger.kernel.org # v4.19+
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> I assume that the old ssb based devices also have such problems did
> you had a look into those?

I've ordered some device with ssb based SoC & I'm planning to test it
next week hopefully.
