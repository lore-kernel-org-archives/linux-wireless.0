Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:1123 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbZI0VuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 17:50:06 -0400
Date: Sun, 27 Sep 2009 22:50:03 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] cfg80211: fix wireless handlers assignment
In-Reply-To: <Pine.LNX.4.64.0909272139280.4061@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909272237190.4098@sister.anvils>
References: <1254076075.6583.6.camel@johannes.local>
 <Pine.LNX.4.64.0909272139280.4061@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Sep 2009, Hugh Dickins wrote:
> 
> I've experimented by moving your NETDEV_PRE_INIT hunk later in the
> sequence, just before the netdev_initialize_kobject(dev) (so I also
> changed the "goto out" to "goto err_uninit"): both* machines then boot
> correctly, and this mail leaves me wirelessly.
> 
> I'll now experiment to see how early I can move that hunk.

Both machines boot (and do wireless) correctly with your NETDEV_PRE_INIT
hunk placed just after the ndo_init block, instead of just before where
you placed it.  That's i386 kernels on both.

But curiouser and curiouser... the laptop can do 64-bit, so I built
my 64-bit kernel, and went through the motions to reproduce the
early boot crash with the patch as you had it: but the x86_64 kernel
boots (and does wireless) correctly with the NETDEV_PRE_INIT hunk
just where you placed it, before the ndo_init block.

Perhaps there's a difference in the 32- and 64-bit startup sequence
with respect to notifiers; or perhaps your change tickles another bug.
I don't know, I'm turning off now.

Hugh
