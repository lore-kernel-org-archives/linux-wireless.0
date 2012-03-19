Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61897 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030812Ab2CSRCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 13:02:41 -0400
Received: by yhmm54 with SMTP id m54so5676678yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 10:02:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332164326-17884-1-git-send-email-yeohchunyeow@gmail.com>
References: <1332164326-17884-1-git-send-email-yeohchunyeow@gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 19 Mar 2012 10:02:20 -0700
Message-ID: <CAPjQAd9j_XgkXr-M5v58K-q3aEo15gK+O+GBi6spHyx27UPTow@mail.gmail.com> (sfid-20120319_180244_750740_4EF3FBA2)
Subject: Re: [PATCH] mac80211: fix the sparse warnings on endian handling in
 RANN propagation
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 19, 2012 at 6:38 AM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> The HWMP sequence number of received RANN element is compared to decide whether to be
> propagated. The sequence number is required to covert from 32bit little endian data into
> CPUs endianness for comparison. The same applies to the RANN metric.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>

> ---
>  include/linux/ieee80211.h |    6 +++---
>  net/mac80211/mesh_hwmp.c  |    4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 210e2c3..cd4c7ed 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -640,9 +640,9 @@ struct ieee80211_rann_ie {
>        u8 rann_hopcount;
>        u8 rann_ttl;
>        u8 rann_addr[6];
> -       u32 rann_seq;
> -       u32 rann_interval;
> -       u32 rann_metric;
> +       __le32 rann_seq;
> +       __le32 rann_interval;
> +       __le32 rann_metric;
>  } __attribute__ ((packed));
>
>  enum ieee80211_rann_flags {
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 1c6f3d0..f80a9e3 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -748,10 +748,10 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>        flags = rann->rann_flags;
>        root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
>        orig_addr = rann->rann_addr;
> -       orig_sn = rann->rann_seq;
> +       orig_sn = le32_to_cpu(rann->rann_seq);
>        hopcount = rann->rann_hopcount;
>        hopcount++;
> -       metric = rann->rann_metric;
> +       metric = le32_to_cpu(rann->rann_metric);
>
>        /*  Ignore our own RANNs */
>        if (compare_ether_addr(orig_addr, sdata->vif.addr) == 0)
> --
> 1.7.0.4
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
