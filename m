Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE3FC5519F
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Nov 2020 18:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 228B122202
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Nov 2020 18:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZ0ejuk5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgKUSGj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 21 Nov 2020 13:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgKUSGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Nov 2020 13:06:38 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BA0422201;
        Sat, 21 Nov 2020 18:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605981997;
        bh=pRRiUjCIvCXAWQNcMYZqHMIWEh2yfgzcy8eELup0gSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NZ0ejuk5Xv9pZVpBhbuGW9tzWoNsMypJ7ObGrE/j6g6en8v9NtxU0fUeBrD2JDTuv
         m+Kyi/QLoCfCxrqK+hpCE/Uqk+oj4whfKcAsjMluBdYOmQJB3Lt0CPJlfM140yyJcg
         gfC36WtEGRWL2BXa6CBVyx9z3bxNzvMKPoiQCKa8=
Date:   Sat, 21 Nov 2020 10:06:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Aleksandr Nogikh <aleksandrnogikh@gmail.com>,
        davem@davemloft.net, johannes@sipsolutions.net,
        edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
Message-ID: <20201121100636.26aaaf8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201121165227.GT15137@breakpoint.cc>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
        <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
        <20201121160941.GA485907@shredder.lan>
        <20201121165227.GT15137@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 21 Nov 2020 17:52:27 +0100 Florian Westphal wrote:
> Ido Schimmel <idosch@idosch.org> wrote:
> > Other suggestions?  
> 
> Aleksandr, why was this made into an skb extension in the first place?
> 
> AFAIU this feature is usually always disabled at build time.
> For debug builds (test farm /debug kernel etc) its always needed.
> 
> If thats the case this u64 should be an sk_buff member, not an
> extension.

Yeah, in hindsight I should have looked at how it's used. Not a great
fit for extensions. We can go back, but...

In general I'm not very happy at how this is going. First of all just
setting the handle in a couple of allocs seems to not be enough, skbs
get cloned, reused etc. There were also build problems caused by this
patch and Aleksandr & co where nowhere to be found. Now we find out
this causes leaks, how was that not caught by the syzbot it's supposed
to serve?!

So I'm leaning towards reverting the whole thing. You can attach
kretprobes and record the information you need in BPF maps.
