Return-Path: <SRS0=e4fn=UL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDAEC31E46
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 10:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C572F2080A
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 10:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560334175;
	bh=3NHS8kmPrCkDPGon2qVUgteO61BOSsSea/7gNmxeIKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=yJTvzqrF6pT1Kccq3cTuUwv+Tw5NCXa/lmDTn21/nV42sOsf+fl4ez+uwNuTejtwr
	 r5AZWoZLjvjPlymE4xGRVjZ75K2EnLXlpelBKIESBG57BZ356XLoRD/qtez8wodjC0
	 v9DB/csXrw6uLFN41j8olA2lJgaHYIhocjDuPJG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437855AbfFLKJf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Jun 2019 06:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437611AbfFLKJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jun 2019 06:09:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47AF2080A;
        Wed, 12 Jun 2019 10:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560334174;
        bh=3NHS8kmPrCkDPGon2qVUgteO61BOSsSea/7gNmxeIKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v7jwknWMh7WAhjJvsOTp6E15PiW4GxRAElTtAV2Je48DuRpF8od4yL78ZFG9X3Md3
         1NF6+1D7kT68DbcbK242sdes627Bi6uJ7sEIP84XOgDOdO1WOEenkhPIsr89dPQF/1
         nExrpstHSLeVP+F/xKZKc5ErHYSTyk9n1pBVG6kk=
Date:   Wed, 12 Jun 2019 12:09:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Maya Erez <merez@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH] wireless: wil6210: no need to check return value of
 debugfs_create functions
Message-ID: <20190612100931.GA19472@kroah.com>
References: <20190611191024.GA17227@kroah.com>
 <20190612100717.GA19167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612100717.GA19167@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jun 12, 2019 at 12:07:17PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 11, 2019 at 09:10:24PM +0200, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Cc: Maya Erez <merez@codeaurora.org>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: wil6210@qti.qualcomm.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/wireless/ath/wil6210/debugfs.c | 80 ++++++----------------
> >  1 file changed, 22 insertions(+), 58 deletions(-)
> 
> Oops, 0-day finally woke up and shows I messed this patch up.  Please
> drop it, I will submit a v2 soon.

{sigh}, no, that was a different patch that broke things.  This pathc is
fine, please consider it as-is.

I'll go get more coffee...

greg k-h
