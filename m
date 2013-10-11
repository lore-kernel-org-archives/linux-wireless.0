Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3JKNfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 09:35:19 -0400
Message-ID: <1381498511.14293.17.camel@jlt4.sipsolutions.net> (sfid-20131011_153523_350141_0397F7A6)
Subject: Re: [PATCH v3 5/6] {nl,cfg,mac}80211: finalizing mesh channel
 switching
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Fri, 11 Oct 2013 15:35:11 +0200
In-Reply-To: <1380760429-26100-6-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131003_023416_975774_DB8C026F)
References: <1380760429-26100-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1380760429-26100-6-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20131003_023416_975774_DB8C026F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-02 at 17:33 -0700, Chun-Yeow Yeoh wrote:

> +int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> +	struct cfg80211_csa_settings *tmp_csa_settings;
> +	int ret = 0;
> +
> +	/* Remove the CSA and MCSP elements from the beacon */
> +	tmp_csa_settings = rcu_dereference(ifmsh->csa_settings);
> +	rcu_assign_pointer(ifmsh->csa_settings, NULL);
> +	kfree(tmp_csa_settings);

This looks broken without kfree_rcu() or synchronize_rcu(), if it's OK
then at least add a comment? I think it's not OK though.

johannes

