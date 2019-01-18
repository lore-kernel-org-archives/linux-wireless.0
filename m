Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE1DC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 09:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38C4D20855
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 09:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547804512;
	bh=b527gET5VjHPb1jyhLBHwQDsNRAn17WvRPMLwTl3omk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Zz5F2BUClomp6OGE2VFgk5PW1hUtfV5lBaCnTHcH73z8CdnXJWk7wFEwP4WwGWKRe
	 Ev1plMBG8a+Q+V0rY+D0zbi8zhA53992SKC19tJwociy4rTRZLTxKcpjXGva3woHAI
	 1cyL41lpEUZDc3O4OPUzJIX/1b7JJQCCM2U/+wMk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfARJlv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 04:41:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbfARJlv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 04:41:51 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA4D920823;
        Fri, 18 Jan 2019 09:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547804510;
        bh=b527gET5VjHPb1jyhLBHwQDsNRAn17WvRPMLwTl3omk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xmXAAM05k08+IITLQYqxUpK398z45t4M7Kg+LA0AQP0ZkIO53zFLIA6Pxo1lDKeFL
         Ll+tKBUGfkbpT0MuPAy6So10k0TZnmzxj1CfAgw1+Tj1GXwTQ0QwQrSqvLLptNd3Wd
         a9Gz3fkMS4WqQD8u8GBmluKYqvINSoxyS1Oucav8=
Date:   Fri, 18 Jan 2019 10:41:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        johannes@sipsolutions.net, Adham.Abozaeid@microchip.com
Subject: Re: [PATCH 00/13] staging: wilc1000: address few mainline review
Message-ID: <20190118094127.GA31389@kroah.com>
References: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 17, 2019 at 01:21:06PM +0000, Ajay.Kathat@microchip.com wrote:
> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> This series contains changes to address few of the review comments[1].
> It mainly has the modification to remove the use of scan shadow
> buffer, make use of kernel provided API, avoid typedef's and few
> changes to simplify the logic.
> 
> [1]. https://www.spinics.net/lists/linux-wireless/msg178735.html
>      https://www.spinics.net/lists/linux-wireless/msg179533.html
>      https://www.spinics.net/lists/linux-wireless/msg178760.html
> 
> Ajay Singh (13):
>   staging: wilc1000: make use of get_unaligned_le16/le32 to pack data
>   staging: wilc1000: refactor wilc_wlan_set_bssid()
>   staging: wilc1000: use 'struct' to pack cfg header frame in
>     wilc_wlan_cfg_commit()
>   staging: wilc1000: remove the use of scan shadow buffer
>   staging: wilc1000: make use of cfg80211_inform_bss_frame()
>   staging: wilc1000: corrected order to pack join param buffer
>   staging: wilc1000: use struct to pack join parameters for FW
>   staging: wilc1000: rename hidden_network related data structure
>   staging: wilc1000: use single struct for 'connect' related parameters
>   staging: wilc1000: refactor information message parsing logic
>   staging: wilc1000: remove 'disconnect_info' structure
>   staging: wilc1000: refactor handle_set_mcast_filter()
>   staging: wilc1000: avoid the use of typedef for function pointers
> 
>  drivers/staging/wilc1000/host_interface.c         | 979 +++++++---------------
>  drivers/staging/wilc1000/host_interface.h         | 127 +--
>  drivers/staging/wilc1000/linux_wlan.c             |  12 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 450 ++--------
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   5 +-
>  drivers/staging/wilc1000/wilc_wlan.c              |  35 +-
>  drivers/staging/wilc1000/wilc_wlan.h              |  19 +-
>  drivers/staging/wilc1000/wilc_wlan_cfg.c          |  27 +-
>  drivers/staging/wilc1000/wilc_wlan_if.h           |   3 -
>  9 files changed, 456 insertions(+), 1201 deletions(-)

Nice set of cleanups!

all applied, thanks.

greg k-h
