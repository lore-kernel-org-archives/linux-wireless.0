Return-Path: <SRS0=wyJf=7R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB63C433DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Jun 2020 01:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7756120657
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Jun 2020 01:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgFDBrU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Jun 2020 21:47:20 -0400
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:36934 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgFDBrT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jun 2020 21:47:19 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id C6C99837F24C;
        Thu,  4 Jun 2020 01:47:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: actor89_4e0069c26d93
X-Filterd-Recvd-Size: 3931
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Thu,  4 Jun 2020 01:47:14 +0000 (UTC)
Message-ID: <6f921002478544217903ee4bfbe3c400e169687f.camel@perches.com>
Subject: Re: [PATCH 08/10] checkpatch: Remove awareness of
 uninitialized_var() macro
From:   Joe Perches <joe@perches.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Date:   Wed, 03 Jun 2020 18:47:13 -0700
In-Reply-To: <202006031838.55722640DC@keescook>
References: <20200603233203.1695403-1-keescook@chromium.org>
         <20200603233203.1695403-9-keescook@chromium.org>
         <ff9087b0571e1fc499bd8a4c9fd99bfc0357f245.camel@perches.com>
         <202006031838.55722640DC@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-06-03 at 18:40 -0700, Kees Cook wrote:
> On Wed, Jun 03, 2020 at 05:02:29PM -0700, Joe Perches wrote:
> > On Wed, 2020-06-03 at 16:32 -0700, Kees Cook wrote:
> > > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > > (or can in the future), and suppresses unrelated compiler warnings
> > > (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> > > either simply initialize the variable or make compiler changes.
> > > 
> > > In preparation for removing[2] the[3] macro[4], effectively revert
> > > commit 16b7f3c89907 ("checkpatch: avoid warning about uninitialized_var()")
> > > and remove all remaining mentions of uninitialized_var().
> > > 
> > > [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> > > [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> > > [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> > > [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> > 
> > nack.  see below.
> > 
> > I'd prefer a simple revert, but it shouldn't
> > be done here.
> 
> What do you mean? (I can't understand this and "fine by me" below?)

I did write "other than that"...

I mean that the original commit fixed 2 issues,
one with the uninitialized_var addition, and
another with the missing void function declaration.

I think I found the missing void function bit because
the uninitialized_var use looked like a function so I
fixed both things at the same time.

If you change it, please just remove the bit that
checks for uninitialized_var.

Thanks, Joe

> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > []
> > > @@ -4075,7 +4074,7 @@ sub process {
> > >  		}
> > >  
> > >  # check for function declarations without arguments like "int foo()"
> > > -		if ($line =~ /(\b$Type\s*$Ident)\s*\(\s*\)/) {
> > > +		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
> > 
> > This isn't right because $Type includes a possible trailing *
> > where there isn't a space between $Type and $Ident
> 
> Ah, hm, that was changed in the mentioned commit:
> 
> -               if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
> +               if ($line =~ /(\b$Type\s*$Ident)\s*\(\s*\)/) {
> 
> > e.g.:	int *bar(void);
> > 
> > Other than that, fine by me...
> 
> Thanks for looking it over! I'll adjust it however you'd like. :)
> 

