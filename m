Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLDPIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:08:12 -0500
Subject: Re: [PATCH] less eventcause shifts
From: David Woodhouse <dwmw2@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org
In-Reply-To: <20071204145437.GC19911@tuxdriver.com>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196704681.21151.13.camel@localhost.localdomain>
	 <1196714939.13978.171.camel@pmac.infradead.org>
	 <20071204145437.GC19911@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 15:07:46 +0000
Message-Id: <1196780866.13978.275.camel@pmac.infradead.org> (sfid-20071204_150817_262417_2AE210B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-12-04 at 09:54 -0500, John W. Linville wrote:
> The result is a nice, rebased set of patches on top of the current
> upstream work.	If you simply did a "commit, pull, commit, pull,
> etc" cycle then you would end-up with a set of patches that might
> no longer apply on top of a clean upstream branch -- been there,
> wireless-dev RIP.

Ah, I understand your confusion. It reflects akpm's confusion when he
first started trying to use git-bisect.

This thing is, there is no actual need for a 'set of patches'. Git isn't
about patches. It's about commits and pulls. It doesn't _matter_ if you
had to fix up something when you merged from Linus, because when Linus
pulls from your tree, he pulls your manual merge effort too.

That's how git is designed. You're trying to use it as a kind of staging
post before you send a set of patches to Linus, which is why it looks
strange to me. That's the kind of thing that quilt does best, I think.

Perhaps you should investigate stgit, which {ab,}uses git for this kind
of thing and lets you deal with patches that way quite nicely too.

> I really think this is the best methodology for processing patches
> so that they are ready for merging when posted.

You're probably right.

On the other hand, I think the best methodology for processing code
changes to the Linux kernel so that they are ready for merging into
Linus' git tree is probably in a normal git tree :)

Yes, it's useful not to do daily pulls and end up with a ton of 'empty'
merge commits in the graph -- that gets message. For that reason, I tend
to pull from upstream only when there's something there which I depend
on, or when I'll have to do a manual merge. But a reasonable number of
merges is perfectly normal. That's what git was designed to do, after
all.

> [1] If your work does _not_ rely on patches already merged in my tree
> then by all means just use Linus' tree.

That was my intention, right up to the point at which a bunch of
libertas patches appeared in your tree :)

-- 
dwmw2

