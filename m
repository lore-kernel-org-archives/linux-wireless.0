Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43560 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754167AbdCaImM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 04:42:12 -0400
Message-ID: <1490949728.6288.3.camel@sipsolutions.net> (sfid-20170331_104308_207927_6BB82AA8)
Subject: Re: [PATCH 1/2] Documentation/sphinx: kerneldoc: add
 "unused-functions"
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org
Date: Fri, 31 Mar 2017 10:42:08 +0200
In-Reply-To: <8F272073-79D4-4721-B481-ED018A58174F@darmarit.de>
References: <20170331071632.6209-1-johannes@sipsolutions.net>
         <8F272073-79D4-4721-B481-ED018A58174F@darmarit.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Do we really need such generic stuff? ... IMO explicit is better than
> implicit. Why not getting an error when a function, which is referred
> from a reST-document disappears in the source? Those errors help
> to maintain the consistency of documentation with source-code.

That's a totally different problem.

> I know, there are also use-cases where generic is very helpful (e.g.
> create a complete API description from the header file, with just
> one line in reST). And I know, that we have already generic e.g. the
> "export" option of the kernel-doc directive.

Exactly. But now you can either

 * use "export" or "internal" to get *everything*
 * list every single function, and get no warning when there's a
   function you didn't list

This serves to help get a mixture of the two, to be able to group
things but also document everything that got missed as a fall-back.

johannes
