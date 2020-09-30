Return-Path: <SRS0=j1Uz=DH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D151C4727E
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Sep 2020 10:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D790A2074A
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Sep 2020 10:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601460256;
	bh=h3lII9feFo679GlwDGoMdyES0Cx9PhK0dx4EC+u43mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tYq6bnXyTL0gHHAhjEqjkhU3JRTg+rOctSYNr6F7hlNDXVoBB/8c1vZvPwW2VmE3x
	 XH2vA8IPFwrvuqwSEr1WdfjB29DaUKbEANiNGYj8VxJWTRQssMibqIe2ZxQYrBYkBf
	 txnjUYQLZp6uTCqghpX1QdrA8W8E7tNaCqu2hLFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgI3KEL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Sep 2020 06:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbgI3KEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Sep 2020 06:04:11 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E575B2074A;
        Wed, 30 Sep 2020 10:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601460250;
        bh=h3lII9feFo679GlwDGoMdyES0Cx9PhK0dx4EC+u43mw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mPp9Qt4jVqc7g8fnbJdvP/BqMl2zkPohuK5zvWekWfrfyziFflkAkQP49IGtDhmfH
         7ezSrbZXNETkOlz4uZo8EA5WMNfR9j658SDpzZT4z5fYgAzSQOQsWo/gwOu2uQ4c/e
         nnzH+dMia5mm3/8pEQFzNINdodGyxGISI3gs2Vjo=
Date:   Wed, 30 Sep 2020 13:04:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Srinivasan Raju <srini.raju@purelifi.com>,
        mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
Message-ID: <20200930100406.GN3094@unreal>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
 <20200928102008.32568-1-srini.raju@purelifi.com>
 <20200930051602.GJ3094@unreal>
 <875z7velk2.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z7velk2.fsf@codeaurora.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Sep 30, 2020 at 11:05:49AM +0300, Kalle Valo wrote:
> Leon Romanovsky <leon@kernel.org> writes:
>
> >> --- /dev/null
> >> +++ b/drivers/net/wireless/purelifi/Kconfig
> >> @@ -0,0 +1,38 @@
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +config WLAN_VENDOR_PURELIFI
> >> +	bool "pureLiFi devices"
> >> +	default y
> >
> > "N" is preferred default.
> >
> >> +	help
> >> +	  If you have a pureLiFi device, say Y.
> >> +
> >> +	  Note that the answer to this question doesn't directly affect the
> >> +	  kernel: saying N will just cause the configurator to skip all the
> >> +	  questions about these cards. If you say Y, you will be asked for
> >> +	  your specific card in the following questions.
> >
> > The text above makes no sense. Of course, it makes a lot of sense to
> > disable this device for whole world.
>
> This is a standard text for all vendor "groups", the actual driver
> should be selected in a separate config. This text has been copied from
> NET_VENDOR_ groups and used by all WLAN_VENDOR configs (or at least that
> was the original plan).

OK, Thanks.

>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
