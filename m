Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64963 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2DJFAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 01:00:13 -0400
Received: by obbtb18 with SMTP id tb18so6774404obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 22:00:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334032316-7011-1-git-send-email-yeohchunyeow@gmail.com>
References: <1334032316-7011-1-git-send-email-yeohchunyeow@gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 9 Apr 2012 21:59:52 -0700
Message-ID: <CAPjQAd8FuPbL+QRMij=j29CZCuxZ+29FpBB2fD5btsz80Ep9YQ@mail.gmail.com> (sfid-20120410_070018_169039_C1F1B800)
Subject: Re: [PATCH v2] mac80211: fix the assignment of PREQ's MAC address for
 Proactive RANN
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 9, 2012 at 9:31 PM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Record the RANN sender's address only for RANNs that meet the acceptance
> criteria (per sections 13.10.12.4.2).
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Reviewed-by: Javier Cardona <javier@cozybit.com>

> ---
> v2: reword description (Javier)
>    initialize is_root and rann_snd_addr
>
>  net/mac80211/mesh_hwmp.c    |    5 +++--
>  net/mac80211/mesh_pathtbl.c |    2 ++
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index a80da37..8130e5f 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -800,10 +800,11 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>                                       0, sdata);
>                mpath->sn = orig_sn;
>                mpath->rann_metric = metric + metric_txsta;
> +               /* Recording RANNs sender address to send individually
> +                * addressed PREQs destined for root mesh STA */
> +               memcpy(mpath->rann_snd_addr, mgmt->sa, ETH_ALEN);
>        }
>
> -       /* Using individually addressed PREQ for root node */
> -       memcpy(mpath->rann_snd_addr, mgmt->sa, ETH_ALEN);
>        mpath->is_root = true;
>
>        if (root_is_gate)
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 49aaefd..baa6096 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -538,6 +538,8 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
>
>        read_lock_bh(&pathtbl_resize_lock);
>        memcpy(new_mpath->dst, dst, ETH_ALEN);
> +       memset(new_mpath->rann_snd_addr, 0xff, ETH_ALEN);
> +       new_mpath->is_root = false;
>        new_mpath->sdata = sdata;
>        new_mpath->flags = 0;
>        skb_queue_head_init(&new_mpath->frame_queue);
> --
> 1.7.0.4
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
