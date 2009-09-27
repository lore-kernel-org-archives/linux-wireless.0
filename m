Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:1751 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbZI0U6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 16:58:45 -0400
Date: Sun, 27 Sep 2009 21:58:38 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] cfg80211: fix wireless handlers assignment
In-Reply-To: <1254076075.6583.6.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0909272139280.4061@sister.anvils>
References: <1254076075.6583.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Sep 2009, Johannes Berg wrote:

> The point we assign dev->wireless_handlers at is too
> late, we need to do that before netdev_register_kobject()
> gets called, so use the new NETDEV_PRE_INIT notifier.
> The result of adding wireless_handlers too late is the
> disappearance of /sys/class/net/wlan0/wireless which a
> bunch of distro scripts still require.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

This 2/2 patch does indeed work: many thanks.  But...

> ---
> This should fix the regression Hugh reported (of course requires the
> other patch which unfortunately I forgot to CC you, Hugh, I'll send you
> a copy in private).

... the 1/2 patch has a couple of problems.

The trivial problem is that include/linux/notifier.h in Linus's git has
#define NETDEV_PRE_UP		0x000D
#define NETDEV_BONDING_OLDTYPE  0x000E
#define NETDEV_BONDING_NEWTYPE  0x000F

So it rejects the patch you posted: I changed it to add
#define NETDEV_PRE_INIT		0x0010
just after the NETDEV_BONDING_NEWTYPE line.

The more serious problem is that it stops both my machines from booting,
too early for framebuffer to show any messages, but vga=normal shows a
long stacktrace scrolling offscreen, with some notifier stuff in there.

I've experimented by moving your NETDEV_PRE_INIT hunk later in the
sequence, just before the netdev_initialize_kobject(dev) (so I also
changed the "goto out" to "goto err_uninit"): both* machines then boot
correctly, and this mail leaves me wirelessly.

I'll now experiment to see how early I can move that hunk.

Hugh

* I wrote that hoping the Aspire One build would complete soon,
but it's still going: assume it's fine unless I say otherwise.
