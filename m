Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38367 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3LFKea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 05:34:30 -0500
Received: by mail-ve0-f174.google.com with SMTP id pa12so538712veb.33
        for <linux-wireless@vger.kernel.org>; Fri, 06 Dec 2013 02:34:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386257143-29840-6-git-send-email-luciano.coelho@intel.com>
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com>
	<1386257143-29840-6-git-send-email-luciano.coelho@intel.com>
Date: Fri, 6 Dec 2013 18:34:29 +0800
Message-ID: <CAEFj9868EWZVx-6hst8bBCjghKgjdGEbHY3L98uf812Rc4Sjmg@mail.gmail.com> (sfid-20131206_113438_265760_5DF9743A)
Subject: Re: [PATCH v8 5/5] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>,
	andrei.otcheretianski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 5476ad9..a7fad0d 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -1051,7 +1051,8 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
>         /* Remove the CSA and MCSP elements from the beacon */
>         tmp_csa_settings = rcu_dereference(ifmsh->csa);
>         rcu_assign_pointer(ifmsh->csa, NULL);
> -       kfree_rcu(tmp_csa_settings, rcu_head);
> +       if (tmp_csa_settings)
> +               kfree_rcu(tmp_csa_settings, rcu_head);

Yes, this solves the problem of kernel oops.

----
Chun-Yeow
