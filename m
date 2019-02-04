Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E024FC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 11:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC58920823
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 11:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549280382;
	bh=wvDF27omMDwTfpFWnnghySJ56NNd4bUymySXD1i/a94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=yLR9pJt7cdgggUMzMqOI9hdkA8H5k+FmEOWcizs/JD2EWeQjR0ORl+U8upb1MDJY9
	 D4nJx4fB1agW0rKkHmmlU4rJ97FDCwZh9ei/46lsvKXxcvEIJ5ngY/b+Z2dUE9qAMm
	 3SA8ptyYLKudahtml6e6khm0GoaiIkcU8ahznM4Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfBDLjl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 06:39:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfBDLjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 06:39:41 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A0372081B;
        Mon,  4 Feb 2019 11:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549280380;
        bh=wvDF27omMDwTfpFWnnghySJ56NNd4bUymySXD1i/a94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o61zZsrVmSpaMoNA6l1NUM14hG6ykIM8FXJiwmbu5UXZoZI+B6IpTwknAMtok6Kxn
         hrYG6QlaG4vkQOn/kDzeCNGfFctU+vaWOJyXfGrAmib6hwFB5im4qRdmKwMQZo3Yng
         VGMknKL3ASxiK7lWW7Cl8sYyPd+V0DTJe9aDHi2w=
Date:   Mon, 4 Feb 2019 12:39:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay.Kathat@microchip.com, devel@driverdev.osuosl.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Adham.Abozaeid@microchip.com
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 08/15] staging: wilc1000: use correct condition in loops
 for 'vif_num' count
Message-ID: <20190204113938.GA24343@kroah.com>
References: <1549134974-5545-1-git-send-email-ajay.kathat@microchip.com>
 <1549134974-5545-9-git-send-email-ajay.kathat@microchip.com>
 <20190204081357.GC2563@kadam>
 <fdcab6a0-cf91-dc85-d674-ce4a3c9bd54d@microchip.com>
 <20190204094723.GD2581@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204094723.GD2581@kadam>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 04, 2019 at 12:47:23PM +0300, Dan Carpenter wrote:
> On Mon, Feb 04, 2019 at 09:42:36AM +0000, Ajay.Kathat@microchip.com wrote:
> > 
> > 
> > On 2/4/2019 1:43 PM, Dan Carpenter wrote:
> > > On Sat, Feb 02, 2019 at 07:17:13PM +0000, Ajay.Kathat@microchip.com wrote:
> > >> From: Ajay Singh <ajay.kathat@microchip.com>
> > >>
> > >> The value of 'vif_num'(interface count) starts with 0, so modified the
> > >> loop conditions to execute for all interface.
> > >>
> > >> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > > 
> > > The right thing to do is to change ->vif_num = i + 1 in
> > > wilc_netdev_init().  That's how it was originally.  Please, add a
> > > Fixes tag.
> > > 
> > > Fixes: 735bb39ca3be ("staging: wilc1000: simplify vif[i]->ndev accesses")
> > > 
> > 
> > Thanks. Sure, I will add Fixes tag and resubmit the changes.
> > 
> > Can other patches from the series be applied excluding this or should I
> > resubmit the complete series?
> > Please suggest.
> 
> I don't have an opinion on that.  I guess if you just resend them all,
> that's the easiest for Greg.

I took the first 7 patches here, so just a respin of the remaining ones
would be fine.

thanks,

greg k-h
