Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6885C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 18:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C8BE2064E
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 18:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C8BE2064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=davemloft.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbeJIBPZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 21:15:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeJIBPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 21:15:25 -0400
Received: from localhost (c-67-183-145-105.hsd1.wa.comcast.net [67.183.145.105])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC3011000173E;
        Mon,  8 Oct 2018 11:02:30 -0700 (PDT)
Date:   Mon, 08 Oct 2018 11:02:30 -0700 (PDT)
Message-Id: <20181008.110230.1232459474222849074.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     kvalo@codeaurora.org, nbd@nbd.name, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mt76x0: pci: fix set external PA I/O current
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1539004909-195005-1-git-send-email-yuehaibing@huawei.com>
References: <1539004909-195005-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: Mew version 6.7 on Emacs 26 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Oct 2018 11:02:31 -0700 (PDT)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Mon, 8 Oct 2018 13:21:49 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/mediatek/mt76/mt76x0/pci.c: In function 'mt76x0e_register_device':
> drivers/net/wireless/mediatek/mt76/mt76x0/pci.c:107:8: warning:
>  variable 'data' set but not used [-Wunused-but-set-variable]
> 
> It seems correct value to write is 'data'
> 
> Fixes: 2b2cb40bcd7d ("mt76x0: pci: add hw initialization at bootstrap")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Wireless changes should be marked as appropriate in the Subject line
for targetting the wireless GIT tree, not "net-next".
