Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57449 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbcF3KHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 06:07:16 -0400
Message-ID: <1467281231.2499.3.camel@sipsolutions.net> (sfid-20160630_120721_364505_0498180B)
Subject: Re: [PATCH] mac80211: use common cleanup for user/!user_mpm
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Date: Thu, 30 Jun 2016 12:07:11 +0200
In-Reply-To: <20160625231416.19488-1-me@bobcopeland.com> (sfid-20160626_011440_567853_49925C4B)
References: <20160625231416.19488-1-me@bobcopeland.com>
	 (sfid-20160626_011440_567853_49925C4B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-06-25 at 19:14 -0400, Bob Copeland wrote:
> We've accumulated a couple of different fixes now to
> mesh_sta_cleanup()
> due to the different paths that user_mpm and !user_mpm cases take --
> one
> fix to flush nexthop paths and one to fix the counting.
> 
> The only caller of mesh_plink_deactivate() is mesh_sta_cleanup(), so
> we
> can push the user_mpm checks down into there in order to share more
> code.
> 
> In doing so, we can remove an extra call to
> mesh_path_flush_by_nexthop()
> and the (unnecessary) call to mesh_accept_plinks_update().  This will
> also ensure the powersaving state code gets called in the user_mpm
> case.
> 
> The only cleanup tasks we need to avoid when MPM is in user-space
> are sending the peering frames and stopping the plink timer, so wrap
> those in the appropriate check.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> 
> This applies on top of Jouni's patch,
> "mac80211: Fix mesh estab_plinks counting in STA removal case", so
> this can go for -next.
> 
Applied.

johannes
