Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF5DC46465
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C450B208E7
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKaNcGDP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C450B208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbeKHU5a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 15:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbeKHU5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 15:57:30 -0500
Received: from localhost (71-6-98-120.static-ip.telepacific.net [71.6.98.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E66DD2086C;
        Thu,  8 Nov 2018 11:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541676149;
        bh=VNQ9KRrXZZqntJtj7gay62Kb6GHrFusX2lG7uCbpz34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKaNcGDPXvC6OqPgEjDP191PxhxxkPpHCoK+RSDrdTsleEphmLWwBm21+QInfPPhA
         B+/LWUjLsB0VFdKRKA7Q0BktY8r2tvVM36XK3UZhPkbGaEW6P47L/zM4iMYbxaqumM
         qqWMZ2FJ8t0UANWXTUZi9BMdVKM9GwcTOcBMx6zI=
Date:   Thu, 8 Nov 2018 03:22:28 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adham.Abozaeid@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        johannes@sipsolutions.net, Aditya.Shankar@microchip.com,
        Ganesh.Krishna@microchip.com
Subject: Re: [PATCH v3 2/4] staging: wilc1000: validate cfg parameters before
 scheduling the work
Message-ID: <20181108112228.GA9001@kroah.com>
References: <20181106000109.6178-1-adham.abozaeid@microchip.com>
 <20181106000109.6178-3-adham.abozaeid@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106000109.6178-3-adham.abozaeid@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Nov 06, 2018 at 12:01:18AM +0000, Adham.Abozaeid@microchip.com wrote:
> From: Adham Abozaeid <adham.abozaeid@micochip.com>
> 
> Validate cfg parameters after being called by cfg80211 in set_wiphy_params
> before scheduling the work executed in handle_cfg_param
> 
> Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c     | 61 ++++++-------------
>  .../staging/wilc1000/wilc_wfi_cfgoperations.c | 50 ++++++++++++---
>  2 files changed, 62 insertions(+), 49 deletions(-)

Please fix this up so that the 0-day bot does not complain about it.

thanks,

greg k-h
