Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33021 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947094Ab3BHXAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 18:00:17 -0500
Received: by mail-ob0-f176.google.com with SMTP id v19so4431624obq.35
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 15:00:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360364077-12204-1-git-send-email-thomas@cozybit.com>
References: <1360364077-12204-1-git-send-email-thomas@cozybit.com>
From: Thomas Pedersen <twpedersen@gmail.com>
Date: Fri, 8 Feb 2013 14:59:57 -0800
Message-ID: <CAHmEv85x8=+iVJLtp5v3sS1+6w7tXjRqTCAh9TSG0n8LYzEf_w@mail.gmail.com> (sfid-20130209_000022_297562_54F74ED7)
Subject: Re: [PATCH] mac80211: fix CONFIG_MAC80211=n build breakage
To: Thomas Pedersen <thomas@cozybit.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

err subject should be CONFIG_MAC80211_MESH=n.

On Fri, Feb 8, 2013 at 2:54 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> The original mesh_sta_cleanup() declaration should have been
> inside the ifdef.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/mesh.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
> index e5f6095..cd7868a 100644
> --- a/net/mac80211/mesh.h
> +++ b/net/mac80211/mesh.h
> @@ -294,7 +294,6 @@ void mesh_plink_block(struct sta_info *sta);
>  void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
>                          struct ieee80211_mgmt *mgmt, size_t len,
>                          struct ieee80211_rx_status *rx_status);
> -void mesh_sta_cleanup(struct sta_info *sta);
>
>  /* Private interfaces */
>  /* Mesh tables */
> @@ -367,6 +366,7 @@ void mesh_plink_quiesce(struct sta_info *sta);
>  void mesh_plink_restart(struct sta_info *sta);
>  void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
>  void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
> +void mesh_sta_cleanup(struct sta_info *sta);
>  #else
>  #define mesh_allocated 0
>  static inline void
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
