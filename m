Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33459 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbcBVNMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 08:12:41 -0500
Received: by mail-pa0-f46.google.com with SMTP id fl4so91236548pad.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 05:12:41 -0800 (PST)
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reply-To: arend@broadcom.com
Subject: Re: obtain commit list
References: <56C44E1A.60700@broadcom.com> <20160217140701.GB9315@localhost>
To: Bob Copeland <me@bobcopeland.com>, arend@broadcom.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <56CB0944.8050205@broadcom.com> (sfid-20160222_141245_813628_BD4B7705)
Date: Mon, 22 Feb 2016 14:12:36 +0100
MIME-Version: 1.0
In-Reply-To: <20160217140701.GB9315@localhost>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17-2-2016 15:07, Bob Copeland wrote:
> On Wed, Feb 17, 2016 at 11:40:26AM +0100, Arend Van Spriel wrote:
>> Hi Bob,
>>
>> With the old wireless testing I used to provide a list of commits that
>> were merged from wireless-testing into our internal repo. I am trying to
>> determine the strategy to produce that list with the new
>> wireless-testing using rebase stategy. Do you have a good suggestion for
>> that?
> 
> Hi Arend,
> 
> So I suppose it depends somewhat on how you are using the tree, whether
> you are merging w-t still or rebasing your own tree, but here's a couple
> of barely tested ideas.  [Corrections welcome, I just tried a few things
> that looked "close enough", but I suppose some cases where the downstream
> trees rebase could muck up the result somewhat.]

I am actually doing a rebase of our internal tree on new w-t.

> Suppose I want to see which commits have been added between two
> wireless-testing tags, I can do, for example:
> 
>     git log wt-2016-02-17 ^wt-2016-02-15 -- net drivers/net/wireless | \
>         git shortlog
> 
> You'll see a handful of merge commits from me that don't end up in the
> upstream, but otherwise should see a reasonable set of commits that got
> merged, in this case a few iwlwifi patches.
> 
> Now suppose you're rebasing your internal tree on top of w-t/master
> periodically, e.g., you have:
> 
>     wt-oldbase -- A -- B -- C -- D
> 
> And rebase onto a new w-t tag to get (suppose A is merged upstream):
> 
>     wt-newbase -- B' -- C' -- D'
> 
> wt-oldbase and wt-newbase actually have dated tags associated with them,
> but perhaps it is too much work to look them up and you just use
> "wireless-testing/master" in your rebase script.

Instead of doing 'git pull --rebase' I always start with 'git fetch' so
I get:

 + cdf56a8...34bbd49 master     -> wl-testing/master  (forced update)

which give me wt-oldbase vs wt-newbase.

> Then you could do the same thing but first get the base of the tree:
> 
>     wt_oldbase=$(git merge-base --fork-point wireless-testing/master D)
>     wt_newbase=$(git merge-base --fork-point wireless-testing/master D')
>     git log $wt_newbase ^$wt_oldbase

This time it only gave me the merge commits as there were no patches on
our drivers (I submitted ours a bit late). Still it seems this could
work for me so for that: Thanks!

Regards,
Arend
