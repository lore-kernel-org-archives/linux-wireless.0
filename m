Return-Path: <SRS0=c1p6=V5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A8DC19759
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Aug 2019 16:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C45C20B7C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Aug 2019 16:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564677770;
	bh=0pixw0pD9ci8WXzdw9Uc1tAJ1g+aMpJiBL1yEL6eg8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Ki3dfXlWqyK9J1fdrl6mgF5hnlpwBVhIyblZlQQMfLsLKK6gYadsmGTN9J2LXtMsR
	 C9t8HsQjEsiCtIH8aL6zN49Pva13fY8cVWHTw/6TQ1HO86Ytm4otkoP+ny5AttPusl
	 dJ0NdcUYb46IEdLAp1KAwyFdjy1MX8ome3De/viA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733108AbfHAQmt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Aug 2019 12:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729082AbfHAQmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Aug 2019 12:42:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F6520838;
        Thu,  1 Aug 2019 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564677768;
        bh=0pixw0pD9ci8WXzdw9Uc1tAJ1g+aMpJiBL1yEL6eg8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UESIWu2nUV5xEV9AuMstaCs71hmlhAD4iK4xYj9T++L24b91pzRYA2zYUC0g8Zsf9
         9SbLpfLw4iSbZTKSwHvN+D4CUl8hp75m/H5KWX8PjRiRb/Tym3tjAfx4lkaDR0eqSh
         AzhchSnog/6EsKNlpSsWNr7KMmYmq7iJj89rJ+uY=
Date:   Thu, 1 Aug 2019 18:42:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adham.Abozaeid@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        johannes@sipsolutions.net, Ajay.Kathat@microchip.com
Subject: Re: [PATCH] staging: wilc1000: remove unused function
Message-ID: <20190801164246.GA14781@kroah.com>
References: <20190731205546.6647-1-adham.abozaeid@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731205546.6647-1-adham.abozaeid@microchip.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jul 31, 2019 at 09:01:20PM +0000, Adham.Abozaeid@microchip.com wrote:
> From: Adham Abozaeid <adham.abozaeid@microchip.com>
> 
> function wilc_resolve_disconnect_aberration isn't referenced, so
> removing it
> 
> Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_hif.c | 9 ---------
>  drivers/staging/wilc1000/wilc_hif.h | 1 -
>  2 files changed, 10 deletions(-)

When you send multiple patches, with the second one depending on the
first one, always properly number them and send them as a patch series.
Please do that here when you fix up the first one and send both of these
at the same time.

thanks,

greg k-h
