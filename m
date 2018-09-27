Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB849C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6735D21571
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:06:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6735D21571
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbeI0QYF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:24:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbeI0QYF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:24:05 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1A61A811A9;
        Thu, 27 Sep 2018 10:06:35 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBB7A6108F;
        Thu, 27 Sep 2018 10:06:31 +0000 (UTC)
Date:   Thu, 27 Sep 2018 12:06:30 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/26] mt76: move mt76x02_beacon_offset in mt76x02_core.c
Message-ID: <20180927100629.GA19941@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <a3e3e4065e8dc6455ad6653c10b31b0a6fe3b7ef.1538036134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3e3e4065e8dc6455ad6653c10b31b0a6fe3b7ef.1538036134.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 27 Sep 2018 10:06:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 11:01:35AM +0200, Lorenzo Bianconi wrote:
> Move mt76x02_beacon_offset utility routine in mt76x02-lib module
> since it is shared between mt76x0 and mt76x2 driver and remove
> duplicated code. Moreover move beacon_offset data structure in
> mt76x02-lib module since it is shared between mt76x0 and mt76x2
> drivers
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
<snip>

> +const u16 mt76x02_beacon_offsets[16] = {
> +	/* 1024 byte per beacon */
> +	0xc000,
> +	0xc400,
> +	0xc800,
> +	0xcc00,
> +	0xd000,
> +	0xd400,
> +	0xd800,
> +	0xdc00,
> +	/* BSS idx 8-15 not used for beacons */
> +	0xc000,
> +	0xc000,
> +	0xc000,
> +	0xc000,
> +	0xc000,
> +	0xc000,
> +	0xc000,
> +	0xc000,
> +};
> +EXPORT_SYMBOL_GPL(mt76x02_beacon_offsets);
I don't think this should be added to mt76x02_core.c with interrupt stuff.
Interrupts are mmio specific, and beaconing are generic for both buses.
Seems mt76x02_util is better place for beaconing.

Also maybe to avoid confusion mt76x02_core.c should be named
mt76x02_mmio.c and contain only code for PCIe i.e. mt76x0e, mt76x2e.

Thanks
Stanislaw
