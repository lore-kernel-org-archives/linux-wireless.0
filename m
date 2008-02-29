Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:7841 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761840AbYB2UzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 15:55:04 -0500
Received: by wf-out-1314.google.com with SMTP id 28so4319786wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 29 Feb 2008 12:55:01 -0800 (PST)
Subject: Re: [PATCH 08/13 v2] o11s: other changes in mac80211 for mesh
	interface support
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>
In-Reply-To: <20080223074133.32a4609c@morte>
References: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com>
	 <20080223074133.32a4609c@morte>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 12:56:46 -0800
Message-Id: <1204318606.7735.16.camel@localhost> (sfid-20080229_205525_022197_2DE50A91)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-02-23 at 07:41 +0100, Stefano Brivio wrote:
> > +#ifdef CONFIG_MAC80211_MESH
> > +		if (pf == 100 &&
> > +		    sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
> > +			mesh_plink_broken(sta);
> > +#endif
> 
> I'd like to have this moved, maybe right before this:

Why? pf and tx_num_xmit (which is checked in an if leading to this
lines) are modified between this point and where you want to move the
code. If it is necessary I can add a 'broken link' flag to execute
mesh_plink_broken later.

I think by now I will keep using fail_avg, but if you figure out a
better way to compute a meaningful value please feel free to modify it.
What we need is the probability (value between 0 and 1, now using
integers from 0 to 100 to represent it) that a frame sent in the near
future to this station will fail and will have to be retransmitted.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


