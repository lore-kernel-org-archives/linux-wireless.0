Return-Path: <SRS0=etsy=AN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9961DC433E1
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jul 2020 16:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80A6320720
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jul 2020 16:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGBQXO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Jul 2020 12:23:14 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:53202 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726140AbgGBQXN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Jul 2020 12:23:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 53EF6180A813A;
        Thu,  2 Jul 2020 16:23:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: eggs64_191235726e8a
X-Filterd-Recvd-Size: 3163
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Thu,  2 Jul 2020 16:23:08 +0000 (UTC)
Message-ID: <f65392bbd1732eff72d5b24c5ba3ea230ab2a3ae.camel@perches.com>
Subject: Re: [PATCH v2 08/16] spi: davinci: Remove uninitialized_var() usage
From:   Joe Perches <joe@perches.com>
To:     Kees Cook <keescook@chromium.org>, Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mm@kvack.org,
        clang-built-linux@googlegroups.com
Date:   Thu, 02 Jul 2020 09:23:07 -0700
In-Reply-To: <202007020839.545A571CA4@keescook>
References: <20200620033007.1444705-1-keescook@chromium.org>
         <20200620033007.1444705-9-keescook@chromium.org>
         <20200701203920.GC3776@sirena.org.uk> <202007020819.318824DA@keescook>
         <20200702152335.GJ4483@sirena.org.uk> <202007020839.545A571CA4@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-07-02 at 08:42 -0700, Kees Cook wrote:
> On Thu, Jul 02, 2020 at 04:23:35PM +0100, Mark Brown wrote:
> > On Thu, Jul 02, 2020 at 08:21:40AM -0700, Kees Cook wrote:
> > > On Wed, Jul 01, 2020 at 09:39:20PM +0100, Mark Brown wrote:
> > > > Please copy maintainers on patches :(
> > > Hi! Sorry about that; the CC list was giant, so I had opted for using
> > > subsystem mailing lists where possible.
> > 
> > If you're going to err in a direction there I'd err in the direction of
> > CCing the people not the list - I only saw this since I was looking for
> > something else, I don't normally see stuff in the mailing list folder.
> 
> Yeah, I've gotten conflicting feedback on treewide changes:
> - please CC me on only the one patch, I don't want to see everything else
> - please CC me on the whole series, I want the full context for the change
> 
> I opted toward "CC me on this series", but then I get stuck when the CC
> is giant. I think I may switch back to individual CCs for specific
> patches, and point people to lore if they want greater context. (lore
> didn't exist before...)

IMO:

For a patch series that spans multiple subsystems,
each patch should always CC any specific subsystem
maintainers..

A good trick would be to use the cover letter
message-id: and have each individual patch in the
series reference the cover letter id below the
--- line so any reviewer doesn't have to find the
in-reply-to: message id and then reference the
lore link.

Something like:

---

For complete series see: https://lore.kernel.org/r/<cover_letter_message_id>


