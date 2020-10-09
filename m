Return-Path: <SRS0=ugwx=DQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5978AC433DF
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Oct 2020 08:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C3D22227
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Oct 2020 08:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602231346;
	bh=bS3V9uZo4PgOtJ1O8yC/OZ2Npybro8w45UriJBmph14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ilaVWJXaH7FMXnrhBG20RvmZWdrSlV7hAoL++ExAXWdYC6Sd0Tvq+Znw0gYY4JkJK
	 T1BwYvzJJRXCtDVd+VToMIPXoEgbeJCDoakbp5UB1cf1u3FAo4UB6cOldDDGZpcD3i
	 jIHqM7DUksgO05aROBg5nVLzryf+8bKQzz5/0BAg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732570AbgJIIPj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Oct 2020 04:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732467AbgJIIPj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Oct 2020 04:15:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BADA2222C;
        Fri,  9 Oct 2020 08:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602231338;
        bh=bS3V9uZo4PgOtJ1O8yC/OZ2Npybro8w45UriJBmph14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmEQoSqYkxoN7Bun525jzPHg4FMECofYVkMgf1RljW4VMfjMparKGTf6iTk5UI4xh
         TBsiLIPs7Nv7bkQ8GwShvMmvy/R5exO4rSWqhy2jwoG2Xombp/KU5rUgwBdIgf+sTt
         cV2YkUZux9zLw55XdPrc9ykH0sbJqyYGCQJGh6xQ=
Date:   Fri, 9 Oct 2020 10:16:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
Message-ID: <20201009081624.GA401030@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
 <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
 <20201009080355.GA398994@kroah.com>
 <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 09, 2020 at 10:06:14AM +0200, Johannes Berg wrote:
> We used to say the proxy_fops weren't needed and it wasn't an issue, and
> then still implemented it. Dunno. I'm not really too concerned about it
> myself, only root can hold the files open and remove modules ...

proxy_fops were needed because devices can be removed from the system at
any time, causing their debugfs files to want to also be removed.  It
wasn't because of unloading kernel code.

thanks,

greg k-h
