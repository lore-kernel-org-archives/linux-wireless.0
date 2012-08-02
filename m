Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2HBGcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 02:32:20 -0400
Message-ID: <1343889136.4458.2.camel@jlt3.sipsolutions.net> (sfid-20120802_083224_083772_F0905D9A)
Subject: Re: [PATCH] mac80211: improve cleanup when leaving mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
Date: Thu, 02 Aug 2012 08:32:16 +0200
In-Reply-To: <1343855731-27920-1-git-send-email-thomas@cozybit.com> (sfid-20120801_231538_431274_7DAFE894)
References: <1343855731-27920-1-git-send-email-thomas@cozybit.com>
	 (sfid-20120801_231538_431274_7DAFE894)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 14:15 -0700, Thomas Pedersen wrote:
> A couple improvements to cleanup when stopping a mesh:
> 
>  - flush mpath entries.
>  - flush sta entries per-sdata so we don't remove entries belonging to
>    other vifs on the same hw.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/mesh.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 764593d..21c02c6 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -618,7 +618,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>  
>  	ifmsh->mesh_id_len = 0;
>  	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
> -	sta_info_flush(local, NULL);
> +	sta_info_flush(local, sdata);
> +	mesh_path_flush_by_iface(sdata);

We can remove ieee80211_clean_sdata() then, right?

johannes

