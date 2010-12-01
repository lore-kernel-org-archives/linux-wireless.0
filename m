Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63626 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab0LAUpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 15:45:19 -0500
Received: by qyk12 with SMTP id 12so9455622qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 12:45:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291235337.4199.14.camel@jlt3.sipsolutions.net>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com>
 <1291184383.4199.4.camel@jlt3.sipsolutions.net> <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
 <1291229642.4199.11.camel@jlt3.sipsolutions.net> <1291232151.4199.12.camel@jlt3.sipsolutions.net>
 <AANLkTimgfRvqp=-CDU=G8o-ZfD4fVbf3j-AdXCVtoM6c@mail.gmail.com> <1291235337.4199.14.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 1 Dec 2010 12:44:58 -0800
Message-ID: <AANLkTi=GS7vjH07CJmN05Uc6jazNjjY2Pt6yGqwAYLmH@mail.gmail.com>
Subject: Re: [PATCH/RFC] mac80211: use configured mesh TTL
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Wed, Dec 1, 2010 at 12:28 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> It seems the configured mesh TTL should be used,
> not the default value.

Path selection frames use a different TTL, which was recently renamed
from 'TTL' to 'Element TTL' in the 11s draft:

element time to live (Element TTL): An integer number that is used to
limit the number of hops an
HWMP element may be processed and propagated. Note that this Element
TTL is different from the
Mesh TTL in the Mesh Control (see 7.1.3.6.3 (Mesh Control field)).

So no, I would not change this.

Javier

> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/mesh_pathtbl.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> --- wireless-testing.orig/net/mac80211/mesh_pathtbl.c   2010-12-01 21:26:47.000000000 +0100
> +++ wireless-testing/net/mac80211/mesh_pathtbl.c        2010-12-01 21:27:42.000000000 +0100
> @@ -467,8 +467,8 @@ void mesh_plink_broken(struct sta_info *
>                        mpath->flags &= ~MESH_PATH_ACTIVE;
>                        ++mpath->sn;
>                        spin_unlock_bh(&mpath->state_lock);
> -                       mesh_path_error_tx(MESH_TTL, mpath->dst,
> -                                       cpu_to_le32(mpath->sn),
> +                       mesh_path_error_tx(sdata->u.mesh.mshcfg.dot11MeshTTL,
> +                                       mpath->dst, cpu_to_le32(mpath->sn),
>                                        cpu_to_le16(PERR_RCODE_DEST_UNREACH),
>                                        bcast, sdata);
>                } else
> @@ -614,7 +614,8 @@ void mesh_path_discard_frame(struct sk_b
>                mpath = mesh_path_lookup(da, sdata);
>                if (mpath)
>                        sn = ++mpath->sn;
> -               mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(sn),
> +               mesh_path_error_tx(sdata->u.mesh.mshcfg.dot11MeshTTL, skb->data,
> +                                  cpu_to_le32(sn),
>                                   cpu_to_le16(PERR_RCODE_NO_ROUTE), ra, sdata);
>        }
>
>
>
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
