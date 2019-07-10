Return-Path: <SRS0=HTPg=VH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85408C74A2B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 15:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681502087F
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Jul 2019 15:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfGJPqM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Jul 2019 11:46:12 -0400
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:58243 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725832AbfGJPqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jul 2019 11:46:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id C502F1802912E;
        Wed, 10 Jul 2019 15:46:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: range96_50d7d845d712e
X-Filterd-Recvd-Size: 3121
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jul 2019 15:45:54 +0000 (UTC)
Message-ID: <b9c3b83c9be50286062ae8cefd5d38e2baa0fb22.camel@perches.com>
Subject: Re: [PATCH 00/12] treewide: Fix GENMASK misuses
From:   Joe Perches <joe@perches.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Andrew Jeffery <andrew@aj.id.au>, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date:   Wed, 10 Jul 2019 08:45:53 -0700
In-Reply-To: <20190710094337.wf2lftxzfjq2etro@shell.armlinux.org.uk>
References: <cover.1562734889.git.joe@perches.com>
         <5fa1fa6998332642c49e2d5209193ffe2713f333.camel@sipsolutions.net>
         <20190710094337.wf2lftxzfjq2etro@shell.armlinux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-07-10 at 10:43 +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jul 10, 2019 at 11:17:31AM +0200, Johannes Berg wrote:
> > On Tue, 2019-07-09 at 22:04 -0700, Joe Perches wrote:
> > > These GENMASK uses are inverted argument order and the
> > > actual masks produced are incorrect.  Fix them.
> > > 
> > > Add checkpatch tests to help avoid more misuses too.
> > > 
> > > Joe Perches (12):
> > >   checkpatch: Add GENMASK tests
> > 
> > IMHO this doesn't make a lot of sense as a checkpatch test - just throw
> > in a BUILD_BUG_ON()?

I tried that.

It'd can't be done as it's used in declarations
and included in asm files and it uses the UL()
macro.

I also tried just making it do the right thing
whatever the argument order.

Oh well.

> My personal take on this is that GENMASK() is really not useful, it's
> just pure obfuscation and leads to exactly these kinds of mistakes.
> 
> Yes, I fully understand the argument that you can just specify the
> start and end bits, and it _in theory_ makes the code more readable.
> 
> However, the problem is when writing code.  GENMASK(a, b).  Is a the
> starting bit or ending bit?  Is b the number of bits?  It's confusing
> and causes mistakes resulting in incorrect code.  A BUILD_BUG_ON()
> can catch some of the cases, but not all of them.

It's a horrid little macro and I agree with Russell.

I also think if it existed at all it should have been
GENMASK(low, high) not GENMASK(high, low).

I

