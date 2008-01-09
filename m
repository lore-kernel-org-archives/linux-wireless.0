Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45997 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYAICN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 21:13:57 -0500
Subject: Re: merge errors on 'everything'
From: Pavel Roskin <proski@gnu.org>
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200801091043.02204.bruno@thinktube.com>
References: <200801091043.02204.bruno@thinktube.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 21:13:55 -0500
Message-Id: <1199844835.3697.12.camel@dv> (sfid-20080109_021401_162361_512679CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-01-09 at 10:43 +0900, bruno randolf wrote:
> hi!
> 
> many times when i do a 'git pull' to update the wireless-2.6 'everything' 
> branch i run into unexplicable merge errors.

I think the explanation is that the changes in the branch are rebased,
rather than merged, when the wireless-2.6 repository is updated from the
upstream Linux repository.

git views changes on top of the old tree in your repository as
independent from those that appear in wireless-2.6, so it tries to merge
them.  But since it's actually the same patches, git sees that as a
conflict.

You can clean up the consequences of the failed merge by running
"git-reset --hard origin/everything" where "origin" is the name of the
remote.

> i created the branch with 'git co --track -b everything origin/everything' and 
> i don't work on this branch so all files are un-modified.
> 
> what am i doing wrong?

I'm not sure you are doing anything wrong.  It's quite possible that git
should be changed to handle this problem better.  Or maybe the
wireless-2.6 repository should be managed differently.

-- 
Regards,
Pavel Roskin
