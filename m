Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58734 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab1HXSpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 14:45:14 -0400
Date: Wed, 24 Aug 2011 14:44:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: Re: [PATCH] mac80211: remove mesh paths when an interface is removed
Message-ID: <20110824184453.GK9770@tuxdriver.com> (sfid-20110824_204517_482409_006E04C6)
References: <1313785375-32709-1-git-send-email-javier@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1313785375-32709-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 19, 2011 at 01:22:55PM -0700, Javier Cardona wrote:
> When an interface is removed, the mesh paths associated with it should
> also be removed.
> 
> This fixes a bug we observed when reloading a device driver module
> without reloading mac80211s.
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>

  CC [M]  net/mac80211/mesh_pathtbl.o
net/mac80211/mesh_pathtbl.c: In function ‘mpp_path_flush’:
net/mac80211/mesh_pathtbl.c:862:8: error: invalid type argument of ‘->’ (have ‘rwlock_t’)
make[1]: *** [net/mac80211/mesh_pathtbl.o] Error 1
make: *** [net/mac80211/] Error 2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
