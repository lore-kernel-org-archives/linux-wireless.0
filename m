Return-Path: <SRS0=cbTT=DR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D804C43457
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Oct 2020 22:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520D22075E
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Oct 2020 22:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602370391;
	bh=qEv/8rJuvBzSsznkGBS33zRs2V4OUf+87LXb5YdX2+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RsxdAytRi6MuMRBYhXAuIUUEVoN5UaWYd0IdqNaj9fZuWl/j5le9GMJI7oEw3iAr6
	 mczmz63C1gImJUQhxXAukb0To/6+hxVJKVllYwWDuuFa+LA3CH1wa4EgFByLGM2U1e
	 RVyelaquemlAJ7+R+WuTdAq2rzarvYDbkMB5XKMQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388054AbgJJWxF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732643AbgJJTyp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Oct 2020 15:54:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C811206D4;
        Sat, 10 Oct 2020 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602322660;
        bh=qEv/8rJuvBzSsznkGBS33zRs2V4OUf+87LXb5YdX2+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dtZ9I9J0vKwRPkDwHW8WBmWGDTM10AY88wBp3bLQBuvUHQRud+qp5DiL/ceFF3ejE
         3t7EPsC9kSZrsPO4mLwzAZTLmL8lRTvvvL3XCoWcyWWjN6hT3DuccOjsbqg7DAZPv0
         DSvR4/Tzh8rM1ajkCHEPzQzfwI5evgrJY9vwENbU=
Date:   Sat, 10 Oct 2020 11:38:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
Message-ID: <20201010093824.GA986556@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
 <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
 <20201009080355.GA398994@kroah.com>
 <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
 <20201009081624.GA401030@kroah.com>
 <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
 <20201009084729.GA406522@kroah.com>
 <01fcaf4985f57d97ac03fc0b7deb2c225a2fbca1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01fcaf4985f57d97ac03fc0b7deb2c225a2fbca1.camel@sipsolutions.net>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 09, 2020 at 10:48:09AM +0200, Johannes Berg wrote:
> On Fri, 2020-10-09 at 10:47 +0200, Greg KH wrote:
> 
> > > I think adding the .owner everywhere would be good, and perhaps we can
> > > somehow put a check somewhere like
> > > 
> > > 	WARN_ON(is_module_address((unsigned long)fops) && !fops->owner);
> > > 
> > > to prevent the issue in the future?
> > 
> > That will fail for all of the debugfs_create_* operations, as there is
> > only one set of file operations for all of the different files created
> > with these calls.
> 
> Why would it fail? Those have their fops in the core debugfs code, which
> might have a .owner assigned but is probably built-in anyway?

Bad choice of terms, it would "fail" in that this type of check would
never actually work because the debugfs code is built into the kernel,
and there is no module owner for it.  But the value it is referencing is
an address in a module.

> > Which, now that I remember it, is why we went down the proxy "solution"
> > in the first place :(
> 
> Not sure I understand. That was related more to (arbitrary) files having
> to be disappeared rather than anything else?

Isn't this the same issue?

thanks,

greg k-h
