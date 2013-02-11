Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab3BKVVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:21:04 -0500
Message-ID: <1360617645.8738.42.camel@jlt4.sipsolutions.net> (sfid-20130211_222111_009659_99668683)
Subject: Re: [PATCH 3/3] mac80211: generate mesh probe responses
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 11 Feb 2013 22:20:45 +0100
In-Reply-To: <1360616843-24618-3-git-send-email-thomas@cozybit.com> (sfid-20130211_220850_670177_78A066DA)
References: <1360616843-24618-1-git-send-email-thomas@cozybit.com>
	 <1360616843-24618-3-git-send-email-thomas@cozybit.com>
	 (sfid-20130211_220850_670177_78A066DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 13:07 -0800, Thomas Pedersen wrote:

> +	if (elems.mesh_id_len != 0 &&
> +	    (elems.mesh_id_len != ifmsh->mesh_id_len ||
> +	     memcmp(elems.mesh_id, ifmsh->mesh_id, ifmsh->mesh_id_len))) {
> +		mpl_dbg(sdata, "ignoring probe request for different MBSS\n");

> +	presp = dev_alloc_skb(local->tx_headroom +
> +			      bcn->head_len + bcn->tail_len);
> +	if (WARN_ON(!presp))
> +		goto out;

same as before.


> +	mpl_dbg(sdata, "sending probe resp. to %pM\n", hdr->da);

I also think you should probably drop both mpl_dbg() statements as
they're likely to just be noise for any other debugging when you
actually use this?

johannes

