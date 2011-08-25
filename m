Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1HYCIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 22:08:17 -0400
To: Thomas Pedersen <thomas@cozybit.com>
Subject: Re: [PATCH 1/9] mac80211: Fix RCU pointer dereference in  =?UTF-8?Q?mesh=5Fpath=5Fdiscard=5Fframe=28=29?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Wed, 24 Aug 2011 19:08:15 -0700
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>, <linville@tuxdriver.com>
In-Reply-To: <1314236452-7226-2-git-send-email-thomas@cozybit.com>
 (sfid-20110825_034138_436674_B35D5E17)
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314236452-7226-2-git-send-email-thomas@cozybit.com>
 (sfid-20110825_034138_436674_B35D5E17)
Message-ID: <f72a42677c7419161cc9b7f79d93e812@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 24 Aug 2011 18:40:44 -0700, Thomas Pedersen wrote:

>  		da = hdr->addr3;
>  		ra = hdr->addr1;
> +		rcu_read_lock();
>  		mpath = mesh_path_lookup(da, sdata);
> +		rcu_read_unlock();
>  		if (mpath)
>  			sn = ++mpath->sn;
>  		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, skb->data,

You've got to be kidding. Didn't I just explain RCU :)

johannes
