Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2272EC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 14:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D813720843
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 14:06:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D813720843
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbeIZUTs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 16:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbeIZUTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 16:19:48 -0400
Received: from smtp.corp.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0364988E57;
        Wed, 26 Sep 2018 14:06:41 +0000 (UTC)
Received: from localhost (unknown [10.40.205.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 449708CD24;
        Wed, 26 Sep 2018 14:06:30 +0000 (UTC)
Date:   Wed, 26 Sep 2018 16:06:29 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: fix building without CONFIG_MT76x0U
Message-ID: <20180926140627.GA9265@redhat.com>
References: <20180926125356.2026635-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926125356.2026635-1-arnd@arndb.de>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.27
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 26 Sep 2018 14:06:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Sep 26, 2018 at 02:51:59PM +0200, Arnd Bergmann wrote:
> The recent rework of the mt76 driver caused build failures in
> configurations that leave the mt76x0u support disabled:
> 
> ERROR: "mt76u_mcu_deinit" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
> ERROR: "mt76x02u_set_txinfo" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
> ERROR: "mt76u_queues_deinit" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
> ERROR: "mt76u_stop_stat_wk" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
> 
> The mt76x0_push_txwi()/mt76x0_tx_prepare_skb()/mt76x0_cleanup() functions
> that cause some of these are only called from the usb portion, and can
> be hidden in an #ifdef in this case.
> 
> mt76u_stop_stat_wk() is called mt76x0_mac_stop(), which is in turn
> shared between multiple callers. Calling it only when the USB driver
> is enabled avoids the link error but it is not clear to me whether this
> can be called from a context where it would not do the right thing.

I think there not yet posted Lorenzo patches that fix this build
problem.

Regards
Stanislaw

