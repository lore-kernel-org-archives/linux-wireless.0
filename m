Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51066 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbZBMVp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 16:45:58 -0500
Date: Fri, 13 Feb 2009 16:30:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] mac80211: avoid possible buffer overrun in
	sta_agg_status_write
Message-ID: <20090213213050.GJ3581@tuxdriver.com> (sfid-20090213_224602_040016_CADD702A)
References: <1226089619-726-1-git-send-email-linville@tuxdriver.com> <20090208202527.GD17043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090208202527.GD17043@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 08, 2009 at 12:25:27PM -0800, Greg KH wrote:
> 
> John, the patch below seems to have David Miller's ack that he applied
> it to a tree back in November, but I don't see it in Linus's tree
> anywhere.  Did something happen to it?

I think Dave applied a slightly different patch to do more-or-less
the same thing.

commit 013cd397532e5803a1625954a884d021653da720
Author: Jianjun Kong <jianjun@zeuux.org>
Date:   Mon Nov 10 21:37:39 2008 -0800

    mac80211: fix a buffer overrun in station debug code

    net/mac80211/debugfs_sta.c
    The trailing zero was written to state[4], it's out of bounds.

    Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
