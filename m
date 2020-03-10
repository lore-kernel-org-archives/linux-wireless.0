Return-Path: <SRS0=CJfu=43=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5B8C18E5A
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Mar 2020 22:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7088E222C4
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Mar 2020 22:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgCJWRa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Mar 2020 18:17:30 -0400
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:35170 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726283AbgCJWR3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Mar 2020 18:17:29 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 6609018224D99;
        Tue, 10 Mar 2020 22:17:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: event05_5e115b0cde81b
X-Filterd-Recvd-Size: 4412
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Tue, 10 Mar 2020 22:17:26 +0000 (UTC)
Message-ID: <937b0b529509ec1641453ef7c13f38e2d7cc813e.camel@perches.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Mar 2020 15:15:44 -0700
In-Reply-To: <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
References: <20200305111216.GA24982@embeddedor>
         <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
         <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
         <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
         <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
         <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
         <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
         <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
         <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-03-10 at 17:13 -0500, Gustavo A. R. Silva wrote:
> 
> On 3/10/20 5:07 PM, Jes Sorensen wrote:
> > On 3/10/20 5:52 PM, Gustavo A. R. Silva wrote:
> > > 
> > > On 3/10/20 8:56 AM, Kalle Valo wrote:
> > > > + jes
> > > > 
> > > > "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
> > > > > > I wrote in a confusing way, my question above was about the actual patch
> > > > > > and not the the title. For example, Jes didn't like this style change:
> > > > > > 
> > > > > > https://patchwork.kernel.org/patch/11402315/
> > > > > > 
> > > > > 
> > > > > It doesn't seem that that comment adds a lot to the conversation. The only
> > > > > thing that it says is literally "fix the compiler". By the way, more than
> > > > > a hundred patches have already been applied to linux-next[1] and he seems
> > > > > to be the only person that has commented such a thing.
> > > > 
> > > > But I also asked who prefers this format in that thread, you should not
> > > > ignore questions from two maintainers (me and Jes).
> > > > 
> > > 
> > > I'm sorry. I thought the changelog text had already the proper information.
> > > In the changelog text I'm quoting the GCC documentation below:
> > > 
> > > "The preferred mechanism to declare variable-length types like struct line
> > > above is the ISO C99 flexible array member..." [1]
> > > 
> > > I'm also including a link to the following KSPP open issue:
> > > 
> > > https://github.com/KSPP/linux/issues/21
> > > 
> > > The issue above mentions the following:
> > > 
> > > "Both cases (0-byte and 1-byte arrays) pose confusion for things like sizeof(),
> > > CONFIG_FORTIFY_SOURCE."
> > > 
> > > sizeof(flexible-array-member) triggers a warning because flexible array members have
> > > incomplete type[1]. There are some instances of code in which the sizeof operator
> > > is being incorrectly/erroneously applied to zero-length arrays and the result is zero.
> > > Such instances may be hiding some bugs. So, the idea is also to get completely rid
> > > of those sorts of issues.
> > 
> > As I stated in my previous answer, this seems more code churn than an
> > actual fix. If this is a real problem, shouldn't the work be put into
> > fixing the compiler to handle foo[0] instead? It seems that is where the
> > real value would be.
> > 
> 
> Yeah. But, unfortunately, I'm not a compiler guy, so I'm not able to fix the
> compiler as you suggest. And I honestly don't see what is so annoying/disturbing
> about applying a patch that removes the 0 from foo[0] when it brings benefit
> to the whole codebase.

As far as I can tell, it doesn't actually make a difference as
all the compilers produce the same object code with either form.

There may be some compiler warning by clang through.

Does any version of gcc produce a warning on 

	struct foo {
		...
		type bar[0];
	};

but not

	struct foo {
		...
		type bar[];
	};


