Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AD2C282CE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 21:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5201222B1
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 21:54:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="q01WVYvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfBLVyk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 16:54:40 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:54447 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfBLVyk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 16:54:40 -0500
Received: by mail-it1-f194.google.com with SMTP id p11so543398itf.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 13:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ONUEYjzAHpWPE8vf/wPJo/4M5pYR5iObCcWZqTM/Nc8=;
        b=q01WVYvy0Gd7CRBjoQR3aLB+KLt+75jY5t+1VVKcVt0JW6FijsvyJ43CYPEH67WgJc
         XCsMht31ZQUe6uSQX1cfbGKCeMKbbQQJWvKA45Wq9e7hTObw6INu+6nfYinBi+M3nIDy
         3SkDu/UCR2yQJBYWuoZ4c16BcWK4v5qGFqhRPM+cw737AcF65H5qTWSQAz4lJzoVJ8yo
         +8bR2bxX68qtjarK6OLrjkCcd1yzCqI8bw1BmH4D3PBKNFj1PCpSXBT/a/ubp10K9awa
         QWhaXCMYBXCSu5G8OxFL4sYHMCKrVnaL46a+el9XhWWU9vFQ9NYSOzMUKfNT+HXDUMW3
         5NIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ONUEYjzAHpWPE8vf/wPJo/4M5pYR5iObCcWZqTM/Nc8=;
        b=Xe6yMx1dq6WAH2EOjt3nS9xXDufRK6LEA2Bkucd3X5v/2cIWK8cT3qNcLk/D14OpPA
         Kon7XsAvWfcesHlgQdElqPx90Ql1HLK/PTld+LlBH4VjtH70P4iT88TqFGPbb8tXwcSV
         l/ip4R8srfQFEnftCDbi/kCHiaY6soO3fy3p8+JOpW3xltuEw3ujZ0z7Afb2puNHyDhD
         MvAD2m+qFuQ9REI1D8ylIzJKa7KC0G5HnFOa9ga8QJ7lhcxwORYEoOciwCC9fOdGJ692
         MEPfhnaLDNnhHXNV1jJzJOn61kpLDdbxk+Kv2nUMe1+xOGuug6pMtdVHY9lbPgzBn+OJ
         AQVg==
X-Gm-Message-State: AHQUAuYypvqVpFhYRwZ+8SlN74rqN/YcYaMcIyJZ5KzhYcvVmDsRpLKd
        w1jACUP4z2/TUbEX0QiXHWk0vQ==
X-Google-Smtp-Source: AHgI3IbnXRfwlHBPI/zR+atuj4jzvn7g1/tDIW0UrFa/gJNqPYR8wj1Cg0AkQJKO3LRr7JZx0kOq4w==
X-Received: by 2002:a24:1f0c:: with SMTP id d12mr508018itd.147.1550008479018;
        Tue, 12 Feb 2019 13:54:39 -0800 (PST)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id j142sm1997115itj.40.2019.02.12.13.54.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Feb 2019 13:54:38 -0800 (PST)
Received: from bob by hash with local (Exim 4.92-RC4)
        (envelope-from <me@bobcopeland.com>)
        id 1gtg0j-0006gD-7D; Tue, 12 Feb 2019 16:54:37 -0500
Date:   Tue, 12 Feb 2019 16:54:37 -0500
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, j@w1.fi, tgraf@suug.ch,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH v2] rhashtable: make walk safe from softirq context
Message-ID: <20190212215437.GA18182@localhost>
References: <20190206090721.8001-1-johannes@sipsolutions.net>
 <20190212.104339.1794719792249723582.davem@davemloft.net>
 <ea6479e089dffc46bb9b09e28d364db4c071998f.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea6479e089dffc46bb9b09e28d364db4c071998f.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 12, 2019 at 08:03:17PM +0100, Johannes Berg wrote:
> commit 60854fd94573f0d3b80b55b40cf0140a0430f3ab
> Author: Bob Copeland <me@bobcopeland.com>
> Date:   Wed Mar 2 10:09:20 2016 -0500
> 
>     mac80211: mesh: convert path table to rhashtable
> 
> which is kinda old. Not sure why this didn't surface before, because the
> spinlock was introduced *before*, otherwise certainly the mutex would've
> caused us to not be able to do this code to start with (commit
> c6ff5268293 - rhashtable: Fix walker list corruption).
> 
> That commit also just converted an existing hashtable walk to
> rhashtable, so not sure that counts as having introduced the problem :-)

Yeah, I didn't change any of the contexts in which the iterations were
called, except making it possible to replace the previous mesh-specific
RCU hashtable with rhashtable by introducing this.  That said, it would
certainly be nice to not have to walk the table to find paths that
use a specific station as nexthop.

> But I guess we should also ask Bob first:
> 1) do you think it'd be easy to maintain a separate list or avoid the
>    iteration in some otherway, and make that a small enough patch to be
>    applicable for stable?

I'm not sure, it's been a while.  I guess most of the difficulties would
be around station removal?

> 2) or do you think maybe the mesh_plink_broken() call could just be
>    lifted into a workqueue instead?

As far as I know, no reason this can't wait until later; we might send
a few frames to the wrong destination but that can happen anyway.  But
there are a couple more walks in there like mesh_path_flush_by_nexthop().

-- 
Bob Copeland %% https://bobcopeland.com/
