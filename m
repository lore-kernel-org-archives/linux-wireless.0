Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33400 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZGJTAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 15:00:55 -0400
Date: Fri, 10 Jul 2009 14:51:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: javier@cozybit.com
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net, Andrey Yurovsky <andrey@cozybit.com>
Subject: Re: [PATCH v5] mac80211: Fix regression in mesh forwarding path.
Message-ID: <20090710185150.GF2825@tuxdriver.com>
References: <20090707170307.GC2768@tuxdriver.com> <1246989303-19462-1-git-send-email-javier@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1246989303-19462-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 07, 2009 at 10:55:03AM -0700, javier@cozybit.com wrote:
> From: Javier Cardona <javier@cozybit.com>
> 
> The removal of the master netdev broke the mesh forwarding path.  This patch
> fixes it by using the new internal 'pending' queue.
> 
> As a result of this change, mesh forwarding no longer does the inefficient
> 802.11 -> 802.3 -> 802.11 conversion that was done before.
> 
> [Changes since v1]
> Suggested by Johannes:
>  - Select queue before adding to mpath queue
>  - ieee80211_add_pending_skb -> ieee80211_add_pending_skbs
>  - Remove unnecessary header wme.h
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

What tree are you basing this on?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
