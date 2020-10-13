Return-Path: <SRS0=0U/s=DU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421C1C433E7
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Oct 2020 20:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC22F20E65
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Oct 2020 20:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602619923;
	bh=Xx6L1F9q0rYk23T9RdX/EZiahjuKdggxm/95WJY7k1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sQ1sKv4k5HdPIsgeBcW9taDJYemvMSry5Os6Dkn5FSW70x9KH7QC5W283QHNtrKwd
	 +ov+qDp8dlqGXLNwnRH3fHDsACbv+JmaHjeLE+clr6pR55CNE8HIpQXtrtIWR8dhVO
	 dqSWo5HCa0GDXLPF1n3IAU3K1kfTRrtFjUCA0gRw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbgJMUL7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Oct 2020 16:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbgJMUL7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Oct 2020 16:11:59 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B38C220BED;
        Tue, 13 Oct 2020 20:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602619918;
        bh=Xx6L1F9q0rYk23T9RdX/EZiahjuKdggxm/95WJY7k1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=quf1aUTWtiJWP9gzQhM9tUT5ZNpsaiIWJzQ8aymChlKiuZNmYrql8y+1QSNL/njA+
         3yvTgSu3IJdBQApEYTWORO765YMLT2bM4OPKBLU+UeAYXKGZMMFytpZkgm4LyF2sUu
         IBBj8FR6Ltxkc1ObX9wEhwYRucjlRInSOicna5oo=
Received: by pali.im (Postfix)
        id 6A24F589; Tue, 13 Oct 2020 22:11:56 +0200 (CEST)
Date:   Tue, 13 Oct 2020 22:11:56 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 07/23] wfx: add bus_sdio.c
Message-ID: <20201013201156.g27gynu5bhvaubul@pali>
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
 <20201012104648.985256-8-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012104648.985256-8-Jerome.Pouiller@silabs.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello!

On Monday 12 October 2020 12:46:32 Jerome Pouiller wrote:
> +#define SDIO_VENDOR_ID_SILABS        0x0000
> +#define SDIO_DEVICE_ID_SILABS_WF200  0x1000
> +static const struct sdio_device_id wfx_sdio_ids[] = {
> +	{ SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200) },

Please move ids into common include file include/linux/mmc/sdio_ids.h
where are all SDIO ids. Now all drivers have ids defined in that file.

> +	// FIXME: ignore VID/PID and only rely on device tree
> +	// { SDIO_DEVICE(SDIO_ANY_ID, SDIO_ANY_ID) },

What is the reason for ignoring vendor and device ids?

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> +
> +struct sdio_driver wfx_sdio_driver = {
> +	.name = "wfx-sdio",
> +	.id_table = wfx_sdio_ids,
> +	.probe = wfx_sdio_probe,
> +	.remove = wfx_sdio_remove,
> +	.drv = {
> +		.owner = THIS_MODULE,
> +		.of_match_table = wfx_sdio_of_match,
> +	}
> +};
> -- 
> 2.28.0
> 
