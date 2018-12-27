Return-Path: <SRS0=u8cq=PE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AD0C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 10:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DC0021741
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 10:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbeL0K7O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Dec 2018 05:59:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728373AbeL0K7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Dec 2018 05:59:14 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9F02EC0740F1;
        Thu, 27 Dec 2018 10:59:14 +0000 (UTC)
Received: from localhost (ovpn-204-120.brq.redhat.com [10.40.204.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FF3119C7B;
        Thu, 27 Dec 2018 10:59:10 +0000 (UTC)
Date:   Thu, 27 Dec 2018 11:59:09 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mt76: introduce mt76x02_check_tx_hang watchdog
Message-ID: <20181227105909.GE25885@redhat.com>
References: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
 <cce12fc0b89944f1bea0b8bbddacf81547572c0f.1545667662.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce12fc0b89944f1bea0b8bbddacf81547572c0f.1545667662.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 27 Dec 2018 10:59:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 24, 2018 at 05:24:42PM +0100, Lorenzo Bianconi wrote:
> Port mt76x02_check_tx_hang watchdog from vendor driver in order to
> perform a device reset when tx mac/dma logic hangs. Tx mac/dma stuck
> has been observed when the device is heavily loaded or in a noisy
> environment.

On what hardware this happen ? Is this only for AP mode?
 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> index a4ff5a7a219f..402944e81e5e 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> @@ -778,6 +778,90 @@ static void mt76x02_check_mac_err(struct mt76x02_dev *dev)
>  		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
>  }
>  
> +static void mt76x02_mac_watchdog_reset(struct mt76x02_dev *dev)

This all is MMIO specific, it should be moved to mt76x02_mmio.c

Regards 
Stanislaw
