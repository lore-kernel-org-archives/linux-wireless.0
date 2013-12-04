Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:51905 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3LDJf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 04:35:58 -0500
Received: by mail-ve0-f180.google.com with SMTP id jz11so11505510veb.39
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 01:35:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386078502-19845-6-git-send-email-luciano.coelho@intel.com>
References: <1386078502-19845-1-git-send-email-luciano.coelho@intel.com>
	<1386078502-19845-6-git-send-email-luciano.coelho@intel.com>
Date: Wed, 4 Dec 2013 17:35:57 +0800
Message-ID: <CAEFj9850NcEhzBFTDkOhCKzpQNtBooSCj3CqsJHuncunUxXw9Q@mail.gmail.com> (sfid-20131204_103607_594668_5EC5CCA6)
Subject: Re: [PATCH v6 5/5] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  #ifdef CONFIG_MAC80211_MESH
>         case NL80211_IFTYPE_MESH_POINT:
> @@ -3159,12 +3208,18 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
>                 if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_NONE)
>                         ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_INIT;
>
> -               err = ieee80211_mesh_csa_beacon(sdata, params,
> -                       (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT));
> -               if (err < 0) {
> -                       ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
> -                       return err;
> +               if (params->count > 1) {
> +                       err = ieee80211_mesh_csa_beacon(sdata, params);
> +                       if (err < 0) {
> +                               ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
> +                               return err;
> +                       }
> +                       changed |= err;
>                 }

Since the ieee80211_mesh_csa_beacon is not called, the kfree_rcu of
tmp_csa_settings in ieee80211_mesh_finish_csa has caused kernel oops.

Anyway, I would like to suggest if the params->count is less than 1,
the mesh channel switch is not triggered since there maybe mesh STA
located two hops away from the initiator.

if (params->count > 1) {
.....
} else
return -EINVAL;




> +
> +               if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT)
> +                       ieee80211_send_action_csa(sdata, params);
> +
>                 break;

----
Chun-Yeow
