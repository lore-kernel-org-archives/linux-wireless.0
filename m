Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0JHS2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:28:36 -0400
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Steve deRosier <steve@cozybit.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikXeA=Q5C84-aaZeq1+vR8vFdXEEe5GyQfCDqr1@mail.gmail.com>
References: <201009210057.13297.chunkeey@googlemail.com>
	 <20100924180013.GD8077@tuxdriver.com>
	 <201009250002.21219.chunkeey@googlemail.com>
	 <AANLkTinCkWGs_KMz+QBUw2J5HUVU2hK1+8kVDr_PNZwP@mail.gmail.com>
	 <1286492072.20974.49.camel@jlt3.sipsolutions.net>
	 <AANLkTin6nwrhcGdnGxg_gMGSrD_GBc-R51qiendF4iAc@mail.gmail.com>
	 <1286560985.3612.12.camel@jlt3.sipsolutions.net>
	 <AANLkTikXeA=Q5C84-aaZeq1+vR8vFdXEEe5GyQfCDqr1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 20:28:34 +0200
Message-ID: <1286562514.3612.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-08 at 11:25 -0700, Javier Cardona wrote:

> > But then you can't ever actually properly process a *matching*
> > PLINK_OPEN frame, afaict, because those definitely do have
> >        "!sta && ftype == PLINK_OPEN"
> 
> Not always: an sta can be created on reception of a beacon or probe
> response (mesh_neighbour_update()), so you could have ftype ==
> PLINK_OPEN and a non-null sta. Buy, yes, I agree that !sta && ftype ==
> PLINK_OPEN is a valid case.

Ah, indeed.

> > which is how the "if (!sta && ftype != PLINK_OPEN) return" came about,
> > afaict.
> 
> Yes, and Christian's *second* patch (submitted as RFC on Sept 24) does
> not change that check.  The matching PLINK_OPEN would be handled in
> the following branch:
> 
>         } else if (!sta) {
>                 /* ftype == PLINK_OPEN */
>                 u32 rates;
>                 (...)
>                 sta = mesh_plink_alloc(sdata, mgmt->sa, rates);
> 
> > So I still don't think it's quite correct to fix it this way.
> 
> Could it be that we are looking at different patches?  Just to be
> sure, let me paste below the one we are referring to as sent by
> Christian:

Ahrg, yes, I always just went back to his first patch.

> ---
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index ea13a80..8b7efee 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -412,7 +412,7 @@ void mesh_rx_plink_frame(struct
> ieee80211_sub_if_data *sdata, struct ieee80211_m
>        enum plink_event event;
>        enum plink_frame_type ftype;
>        size_t baselen;
> -       bool deactivated;
> +       bool deactivated, matches_local = true;
>        u8 ie_len;
>        u8 *baseaddr;
>        __le16 plid, llid, reason;
> @@ -487,6 +487,7 @@ void mesh_rx_plink_frame(struct
> ieee80211_sub_if_data *sdata, struct ieee80211_m
>        /* Now we will figure out the appropriate event... */
>        event = PLINK_UNDEFINED;
>        if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
> +               matches_local = false;
>                switch (ftype) {
>                case PLINK_OPEN:
>                        event = OPN_RJCT;
> @@ -498,7 +499,15 @@ void mesh_rx_plink_frame(struct
> ieee80211_sub_if_data *sdata, struct ieee80211_m
>                        /* avoid warning */
>                        break;
>                }
> -               spin_lock_bh(&sta->lock);
> +       }
> +
> +       if (!sta && !matches_local) {
> +               rcu_read_unlock();
> +               reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
> +               llid = 0;
> +               mesh_plink_frame_tx(sdata, PLINK_CLOSE, mgmt->sa, llid,
> +                                   plid, reason);
> +               return;
>        } else if (!sta) {
>                /* ftype == PLINK_OPEN */
>                u32 rates;
> @@ -522,7 +531,7 @@ void mesh_rx_plink_frame(struct
> ieee80211_sub_if_data *sdata, struct ieee80211_m
>                }
>                event = OPN_ACPT;
>                spin_lock_bh(&sta->lock);
> -       } else {
> +       } else if (matches_local) {
>                spin_lock_bh(&sta->lock);
>                switch (ftype) {
>                case PLINK_OPEN:
> @@ -564,6 +573,8 @@ void mesh_rx_plink_frame(struct
> ieee80211_sub_if_data *sdata, struct ieee80211_m
>                        rcu_read_unlock();
>                        return;
>                }
> +       } else {
> +               spin_lock_bh(&sta->lock);
>        }

Yeah, this looks good. Sorry!

johannes

