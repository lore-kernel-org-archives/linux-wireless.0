Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:58800 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbXKFCKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 21:10:40 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IpDtn-0003KC-9S
	for linux-wireless@vger.kernel.org; Mon, 05 Nov 2007 21:10:39 -0500
Subject: Re: Problem with wireless-2.6
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <472F57A6.3020107@lwfinger.net>
References: <472F57A6.3020107@lwfinger.net>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 21:10:35 -0500
Message-Id: <1194315035.22337.13.camel@dv> (sfid-20071106_021044_507559_7AECF5F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Larry!

On Mon, 2007-11-05 at 11:49 -0600, Larry Finger wrote:
> John,
> 
> I did the following set of steps:
> 
> git clone --reference ~/linux-2.6 \
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git junk
> 
> cd junk
> git checkout -b everything origin/everything
> git pull
> Warning: No merge candidate found because value of config option
>          "branch.everything.merge" does not match any remote branch fetched.
> No changes.

Just add "--track" to the git-checkout command, and it will be fine:

[proski@dv junk]$ git checkout --track -b everything origin/everything
Branch everything set up to track remote branch refs/remotes/origin/everything.
Switched to a new branch "everything"
[proski@dv junk]$ git-pull
Already up-to-date.
[proski@dv junk]$

Or better yet, add this to ~/.gitconfig:

[branch]
        autosetupmerge = true

This would be equivalent to using "--track" by default.  Please make
sure you have a recent version of git, as --track appeared first in
git-1.5.1.

-- 
Regards,
Pavel Roskin

