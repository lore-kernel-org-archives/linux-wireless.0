Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631Ab3E2TxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 15:53:05 -0400
Message-ID: <1369857181.12820.6.camel@jlt4.sipsolutions.net> (sfid-20130529_215310_350608_8D1DB974)
Subject: Re: [PATCH] mac80211: mesh formation info properly set
From: Johannes Berg <johannes@sipsolutions.net>
To: Jacob Minshall <jacob@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Wed, 29 May 2013 21:53:01 +0200
In-Reply-To: <1369857129.12820.5.camel@jlt4.sipsolutions.net> (sfid-20130529_215221_985597_4EBA8B9A)
References: <1369855313-25871-1-git-send-email-jacob@cozybit.com>
	 (sfid-20130529_212202_758720_0E1A739C) <1369857129.12820.5.camel@jlt4.sipsolutions.net>
	 (sfid-20130529_215221_985597_4EBA8B9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-29 at 21:52 +0200, Johannes Berg wrote:

> >  	atomic_inc(&sdata->u.mesh.estab_plinks);
> > -	return mesh_accept_plinks_update(sdata);
> > +	mesh_accept_plinks_update(sdata);
> > +	return BSS_CHANGED_BEACON;
> 
> These changes seem odd to me, why doesn't mesh_accept_plinks_update()
> just return the change value then?

Oh wait, n/m, but shouldn't you have something like

	return mesh_accept_...(...) | BSS_CHANGED_BEACON;

?

johannes

