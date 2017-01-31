Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:36502 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751517AbdAaRvg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 12:51:36 -0500
Received: by mail-ot0-f170.google.com with SMTP id 32so112858646oth.3
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2017 09:51:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1485561708-31559-3-git-send-email-rmanohar@qca.qualcomm.com>
References: <1485561708-31559-1-git-send-email-rmanohar@qca.qualcomm.com> <1485561708-31559-3-git-send-email-rmanohar@qca.qualcomm.com>
From: Thomas Pedersen <thomas@eero.com>
Date: Tue, 31 Jan 2017 09:51:35 -0800
Message-ID: <CADjYELxr+OuJxpFUm+OocCaMRmTM1=GZEw1keYOAOCN2T3o4sg@mail.gmail.com> (sfid-20170131_185251_404285_0131DDFA)
Subject: Re: [PATCH 3/3] mac80211: clear failure average upon mesh path deactivation
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

Thanks this looks good, but..

On Fri, Jan 27, 2017 at 4:01 PM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> Mesh moving average should be cleared, whenever mesh paths
> to the given station are deactivated due to bad link. This will
> give enough room to analysis more tx status than retaining the
> current average.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/mac80211/mesh_pathtbl.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index f0e6175a9821..208ad36c0a7f 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -510,6 +510,7 @@ void mesh_plink_broken(struct sta_info *sta)
>         struct mesh_path *mpath;
>         struct rhashtable_iter iter;
>         int ret;
> +       bool paths_deactivated = false;
>
>         ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
>         if (ret)
> @@ -535,8 +536,11 @@ void mesh_plink_broken(struct sta_info *sta)
>                                 sdata->u.mesh.mshcfg.element_ttl,
>                                 mpath->dst, mpath->sn,
>                                 WLAN_REASON_MESH_PATH_DEST_UNREACHABLE, bcast);
> +                       paths_deactivated = true;
>                 }
>         }
> +       if (paths_deactivated)
> +               sta->mesh->fail_avg = 0;

.. why this indirection? Just reset mesh->fail_avg unconditionally in
this function?


-- 
thomas
