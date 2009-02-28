Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46400
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbZB1XvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Feb 2009 18:51:02 -0500
Date: Sat, 28 Feb 2009 15:50:43 -0800 (PST)
Message-Id: <20090228.155043.46469864.davem@davemloft.net> (sfid-20090301_005111_443487_DFA81A2A)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-02-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090227204110.GJ3687@tuxdriver.com>
References: <20090227204110.GJ3687@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 27 Feb 2009 15:41:10 -0500

> Here is an even bigger batch of changes intended for 2.6.30.  They run
> the usual gamut of wireless driver and mac80211 changes...
> 
> I have reverted the genetlink patch from Johannes and another of
> his that relied upon it.  There is also still that ugly one from me.
> It is a kluge but it prevents a crash on my Lenovo T400.  I bisected
> the crash down to "mac80211: use cfg80211s BSS infrastructure",
> which is already in net-next-2.6.  Still, if it is too ugly then let
> me know and I'll reformulate without it.
> 
> Please let me know if there are problems!

Hmmm, here is something mysterious:

davem@sunset:~/src/GIT/net-next-2.6$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git master
 ...
>From git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
 * branch            master     -> FETCH_HEAD
fatal: unable to read tree c9ee57c5c20c3b7a2d7784a4172aef8b34c3a844
davem@sunset:~/src/GIT/net-next-2.6$ git show c9ee57c5c20c3b7a2d7784a4172aef8b34c3a844
fatal: bad object c9ee57c5c20c3b7a2d7784a4172aef8b34c3a844
davem@sunset:~/src/GIT/net-next-2.6$ 

Yet, that tree object does exist in my tree on kernel.org:

[davem@hera net-next-2.6.git]$ git show c9ee57c
tree c9ee57c

Kconfig
Makefile
...

But if I try to pull kernel.org's net-next-2.6.git into my local
copy I don't get that object, it's clean.

I wonder if I reverted a push and it contaminated your tree?

I'll try to figure out where that turd came from.
