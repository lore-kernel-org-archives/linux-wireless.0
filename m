Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3JQPLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 11:11:30 -0400
Message-ID: <1382022683.14410.18.camel@jlt4.sipsolutions.net> (sfid-20131017_171133_820548_11AEDD71)
Subject: Re: [PATCH v5 4/5] {nl,cfg,mac}80211: implement mesh channel switch
 userspace API
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Thu, 17 Oct 2013 17:11:23 +0200
In-Reply-To: <1381802911-3921-5-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131015_040859_448481_79770152)
References: <1381802911-3921-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1381802911-3921-5-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20131015_040859_448481_79770152)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-14 at 19:08 -0700, Chun-Yeow Yeoh wrote:

> +int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
> +			      struct cfg80211_csa_settings *csa_settings,
> +			      bool csa_action)
> +{
> +	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> +	struct mesh_csa_settings *tmp_csa_settings;
> +	int ret = 0;
> +
> +	if (csa_action)
> +		ieee80211_send_action_csa(sdata, csa_settings);
> +
> +	tmp_csa_settings = kmalloc(sizeof(*tmp_csa_settings),
> +				   GFP_ATOMIC);
> +	if (!tmp_csa_settings)
> +		return -ENOMEM;
> +
> +	memcpy(&tmp_csa_settings->settings, csa_settings,
> +	       sizeof(struct cfg80211_csa_settings));
> +
> +	rcu_assign_pointer(ifmsh->csa, tmp_csa_settings);
> +
> +	ret = ieee80211_mesh_rebuild_beacon(sdata);
> +	if (ret)
> +		return -EINVAL;

If this fails, do we leak the CSA settings?

johannes

