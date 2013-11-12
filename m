Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3KLJJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 04:09:12 -0500
Message-ID: <1384247346.14301.2.camel@jlt4.sipsolutions.net> (sfid-20131112_100942_383261_B76053D9)
Subject: Re: [PATCH] mac80211: use put_unaligned_le16 for precedence value
 in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 12 Nov 2013 10:09:06 +0100
In-Reply-To: <1384223508-3024-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131112_033336_637700_EEE77577)
References: <1384223508-3024-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20131112_033336_637700_EEE77577)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-12 at 10:31 +0800, Chun-Yeow Yeoh wrote:
> use put_unaligned_le16 for precedence value in mesh
> channel switch support

Applied - there are more potential places I guess.

johannes


> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/mac80211/mesh.c |    5 +----
>  net/mac80211/util.c |    4 +---
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index ba10525..01a6685 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -674,8 +674,6 @@ ieee80211_mesh_build_beacon(struct
> ieee80211_if_mesh *ifmsh)
>         rcu_read_lock();
>         csa = rcu_dereference(ifmsh->csa);
>         if (csa) {
> -               __le16 pre_value;
> -
>                 pos = skb_put(skb, 13);
>                 memset(pos, 0, 13);
>                 *pos++ = WLAN_EID_CHANNEL_SWITCH;
> @@ -697,8 +695,7 @@ ieee80211_mesh_build_beacon(struct
> ieee80211_if_mesh *ifmsh)
>                           WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT :
> 0x00;
>                 put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos);
>                 pos += 2;
> -               pre_value = cpu_to_le16(ifmsh->pre_value);
> -               memcpy(pos, &pre_value, 2);
> +               put_unaligned_le16(ifmsh->pre_value, pos);
>                 pos += 2;
>         }
>         rcu_read_unlock();
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 7650efa..679e9d7 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -2449,7 +2449,6 @@ int ieee80211_send_action_csa(struct
> ieee80211_sub_if_data *sdata,
>  
>         if (ieee80211_vif_is_mesh(&sdata->vif)) {
>                 struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> -               __le16 pre_value;
>  
>                 skb_put(skb, 8);
>                 *pos++ = WLAN_EID_CHAN_SWITCH_PARAM;            /* EID
> */
> @@ -2461,8 +2460,7 @@ int ieee80211_send_action_csa(struct
> ieee80211_sub_if_data *sdata,
>                           WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT :
> 0x00;
>                 put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos); /*
> Reason Cd */
>                 pos += 2;
> -               pre_value = cpu_to_le16(ifmsh->pre_value);
> -               memcpy(pos, &pre_value, 2);             /* Precedence
> Value */
> +               put_unaligned_le16(ifmsh->pre_value, pos);/*
> Precedence Value */
>                 pos += 2;
>         }
>  
> -- 
> 1.7.9.5

