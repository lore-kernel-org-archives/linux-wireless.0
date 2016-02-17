Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:36338 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423147AbcBQOHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 09:07:18 -0500
Received: by mail-qg0-f52.google.com with SMTP id y9so12313540qgd.3
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 06:07:18 -0800 (PST)
Date: Wed, 17 Feb 2016 09:07:01 -0500
From: Bob Copeland <me@bobcopeland.com>
To: arend@broadcom.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: obtain commit list
Message-ID: <20160217140701.GB9315@localhost> (sfid-20160217_150723_407330_F835F441)
References: <56C44E1A.60700@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C44E1A.60700@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2016 at 11:40:26AM +0100, Arend Van Spriel wrote:
> Hi Bob,
> 
> With the old wireless testing I used to provide a list of commits that
> were merged from wireless-testing into our internal repo. I am trying to
> determine the strategy to produce that list with the new
> wireless-testing using rebase stategy. Do you have a good suggestion for
> that?

Hi Arend,

So I suppose it depends somewhat on how you are using the tree, whether
you are merging w-t still or rebasing your own tree, but here's a couple
of barely tested ideas.  [Corrections welcome, I just tried a few things
that looked "close enough", but I suppose some cases where the downstream
trees rebase could muck up the result somewhat.]

Suppose I want to see which commits have been added between two
wireless-testing tags, I can do, for example:

    git log wt-2016-02-17 ^wt-2016-02-15 -- net drivers/net/wireless | \
        git shortlog

You'll see a handful of merge commits from me that don't end up in the
upstream, but otherwise should see a reasonable set of commits that got
merged, in this case a few iwlwifi patches.

Now suppose you're rebasing your internal tree on top of w-t/master
periodically, e.g., you have:

    wt-oldbase -- A -- B -- C -- D

And rebase onto a new w-t tag to get (suppose A is merged upstream):

    wt-newbase -- B' -- C' -- D'

wt-oldbase and wt-newbase actually have dated tags associated with them,
but perhaps it is too much work to look them up and you just use
"wireless-testing/master" in your rebase script.

Then you could do the same thing but first get the base of the tree:

    wt_oldbase=$(git merge-base --fork-point wireless-testing/master D)
    wt_newbase=$(git merge-base --fork-point wireless-testing/master D')
    git log $wt_newbase ^$wt_oldbase

Hope that helps,
Bob

-- 
Bob Copeland %% http://bobcopeland.com/
