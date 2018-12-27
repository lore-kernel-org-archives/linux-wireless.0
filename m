Return-Path: <SRS0=u8cq=PE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79750C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 10:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B84F214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 10:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbeL0KyP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Dec 2018 05:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728373AbeL0KyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Dec 2018 05:54:15 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0CF78C04F4D3;
        Thu, 27 Dec 2018 10:54:15 +0000 (UTC)
Received: from localhost (ovpn-204-120.brq.redhat.com [10.40.204.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FEF9620D0;
        Thu, 27 Dec 2018 10:54:11 +0000 (UTC)
Date:   Thu, 27 Dec 2018 11:54:10 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mt76: run mac work every 100ms
Message-ID: <20181227105410.GD25885@redhat.com>
References: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
 <f28b63441e1a1c1518e28dc70ff7fc854ae60361.1545667662.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f28b63441e1a1c1518e28dc70ff7fc854ae60361.1545667662.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 27 Dec 2018 10:54:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 24, 2018 at 05:24:41PM +0100, Lorenzo Bianconi wrote:
> Introduce MT_WATCHDOG_TIME macro in order to run mac work every 100ms.
> This is a preliminary patch to implement a proper tx hang watchdog
<snip>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> index b54a32397486..ec936002a286 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> @@ -33,7 +33,7 @@ mt76x2_start(struct ieee80211_hw *hw)
>  		goto out;
>  
>  	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
> -				     MT_CALIBRATE_INTERVAL);
> +				     MT_WATCHDOG_TIME);

There are other procedures that are performed on mac_work , which most
likely don't have to be done so frequently. I think watchdog should
be placed it it's own work.

Regards
Stanislaw

