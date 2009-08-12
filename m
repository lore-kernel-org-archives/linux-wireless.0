Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:49934 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbZHLBm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 21:42:26 -0400
Received: by an-out-0708.google.com with SMTP id d40so4446265and.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 18:42:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A815A3B.3080404@realsil.com.cn>
References: <1249986145-6531-1-git-send-email-xinhua_wu@realsil.com.cn>
	 <1249987806.5705.0.camel@johannes.local>
	 <4A815A3B.3080404@realsil.com.cn>
Date: Tue, 11 Aug 2009 18:42:26 -0700
Message-ID: <445f43ac0908111842g5e43cd22i372e9b4608de98a6@mail.gmail.com>
Subject: Re: diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
From: Javier Cardona <javier@cozybit.com>
To: david woo <xinhua_wu@realsil.com.cn>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"andrey@cozybit.com" <andrey@cozybit.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David,

Thanks for the patch.

2009/8/11 david woo <xinhua_wu@realsil.com.cn>:
> [PATCH] mac80211: Fix preq frame process and peer link frame baselen.
>
> This patch is just to fix rreq reply condition, and peer link confirm frame baselen.
>
> Signed-off-by: David Woo <xinhua_wu@realsil.com.cn>
> ---
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index e1a763e..c065854 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -397,7 +397,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
>
>  static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>                                    struct ieee80211_mgmt *mgmt,
> -                                   u8 *preq_elem, u32 metric) {
> +                                   u8 *preq_elem, u32 metric)
> +{

nak

>        struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>        struct mesh_path *mpath;
>        u8 *dst_addr, *orig_addr;
> @@ -430,7 +431,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>                        if ((!(mpath->flags & MESH_PATH_DSN_VALID)) ||
>                                        DSN_LT(mpath->dsn, dst_dsn)) {
>                                mpath->dsn = dst_dsn;
> -                               mpath->flags &= MESH_PATH_DSN_VALID;
> +                               mpath->flags |= MESH_PATH_DSN_VALID;

This is a valid fix:  at this point we should set the "destination
sequence number" valid flag, not zero all flags.

>                        } else if ((!(dst_flags & MP_F_DO)) &&
>                                        (mpath->flags & MESH_PATH_ACTIVE)) {
>                                reply = true;
> @@ -447,14 +448,15 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>
>        if (reply) {
>                lifetime = PREQ_IE_LIFETIME(preq_elem);
> -               ttl = ifmsh->mshcfg.dot11MeshTTL;
> -               if (ttl != 0)
> +               ttl = PREQ_IE_TTL(preq_elem);
> +               if (ttl != 0) {
> +                       ttl = ifmsh->mshcfg.dot11MeshTTL;

Nak.  The reply to a preq should have the locally configured TTL and
not the TTL that was in the PREP.

>                        mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
>                                cpu_to_le32(dst_dsn), 0, orig_addr,
>                                cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
>                                cpu_to_le32(lifetime), cpu_to_le32(metric),
>                                0, sdata);
> -               else
> +               } else
>                        ifmsh->mshstats.dropped_frames_ttl++;
>        }
>
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index cb14253..ffcbad7 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -409,7 +409,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
>        baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
>        if (mgmt->u.action.u.plink_action.action_code == PLINK_CONFIRM) {
>                baseaddr += 4;
> -               baselen -= 4;
> +               baselen += 4;

I'm confused with this.  Could you actually establish plinks after
changing this?

Can you resubmit the patch with only the MESH_PATH_DSN_VALID for now?

Thanks!

Javier
