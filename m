Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab2FFKZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:25:07 -0400
Message-ID: <1338978305.4513.56.camel@jlt3.sipsolutions.net> (sfid-20120606_122511_053172_C22098B0)
Subject: Re: [PATCH 3/4] mac80211: implement the proactive PREP generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Wed, 06 Jun 2012 12:25:05 +0200
In-Reply-To: <1338978039-4269-4-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122109_108972_4454EBD9)
References: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
	 <1338978039-4269-4-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120606_122109_108972_4454EBD9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	} else if (is_broadcast_ether_addr(target_addr) &&
> +			(target_flags & MP_F_DO)) {

please indent to below is_

> +		mpath = mesh_path_lookup(orig_addr, sdata);
> +		if (mpath) {
> +			if (flags & PREQ_F_PREP)
> +				reply = true;
> +			if (root_is_gate)
> +				mesh_path_add_gate(mpath);
> +		}
>  	} else {
>  		rcu_read_lock();
>  		mpath = mesh_path_lookup(target_addr, sdata);
> @@ -581,11 +594,20 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>  		ttl = ifmsh->mshcfg.element_ttl;
>  		if (ttl != 0) {
>  			mhwmp_dbg("replying to the PREQ");
> -			mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
> -				cpu_to_le32(orig_sn), 0, target_addr,
> -				cpu_to_le32(target_sn), mgmt->sa, 0, ttl,
> -				cpu_to_le32(lifetime), cpu_to_le32(metric),
> -				0, sdata);
> +			if (!is_broadcast_ether_addr(target_addr))
> +				mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
> +				    cpu_to_le32(orig_sn), 0, target_addr,
> +				    cpu_to_le32(target_sn), mgmt->sa, 0, ttl,
> +				    cpu_to_le32(lifetime), cpu_to_le32(metric),
> +				    0, sdata);
> +			else {

please put braces around all pieces of an if/else if on one branch

Maybe you should run checkpatch :-)

johannes

