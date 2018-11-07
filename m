Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50740C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 08:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1473A20827
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 08:27:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1473A20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbeKGR40 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 12:56:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbeKGR40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 12:56:26 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B3F258E40;
        Wed,  7 Nov 2018 08:27:08 +0000 (UTC)
Received: from localhost (unknown [10.40.205.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE24C648A6;
        Wed,  7 Nov 2018 08:27:05 +0000 (UTC)
Date:   Wed, 7 Nov 2018 09:27:04 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: introduce mt76x02_config_mac_addr_list routine
Message-ID: <20181107082704.GA2549@redhat.com>
References: <cover.1541544212.git.lorenzo.bianconi@redhat.com>
 <c9e89034e9d421bd1f2b159050c95fb1d6c236e8.1541544212.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9e89034e9d421bd1f2b159050c95fb1d6c236e8.1541544212.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 07 Nov 2018 08:27:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Nov 06, 2018 at 11:49:12PM +0100, Lorenzo Bianconi wrote:
> Add mt76x02_config_mac_addr_list routine in order to set
> the mac address list supported by the driver. Initialize
> wiphy->addresses/n_addresses for mt76x0e driver
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  .../net/wireless/mediatek/mt76/mt76x0/init.c  |  2 ++
>  drivers/net/wireless/mediatek/mt76/mt76x02.h  |  1 +
>  .../net/wireless/mediatek/mt76/mt76x02_util.c | 22 +++++++++++++++++++
>  .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 17 ++------------
>  4 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> index e74d476eca24..87b575fe1c74 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> @@ -289,6 +289,8 @@ int mt76x0_register_device(struct mt76x02_dev *dev)
>  	int ret;
>  
>  	mt76x02_init_device(dev);
> +	mt76x02_config_mac_addr_list(dev);
> +

Does this work for USB devices ?

Thanks
Stanislaw
