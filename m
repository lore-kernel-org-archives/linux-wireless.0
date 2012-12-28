Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2L1On1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 09:43:27 -0500
Message-ID: <1356705826.9922.17.camel@jlt4.sipsolutions.net> (sfid-20121228_154331_768161_C587E0A9)
Subject: Re: [PATCH/RFC] nl80211/cfg80211/mac80211: add
 NL80211_CMD_GET_MESH_SETUP
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, thomas@cozybit.com,
	devel@lists.open80211s.org
Date: Fri, 28 Dec 2012 15:43:46 +0100
In-Reply-To: <20121214151442.GA10736@localhost> (sfid-20121214_161546_054695_38FC23AF)
References: <20121214151442.GA10736@localhost>
	 (sfid-20121214_161546_054695_38FC23AF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 10:14 -0500, Bob Copeland wrote:
> Add a new netlink call to get the parameters used at join time
> for the mesh.  This provides a way for userspace to get
> some basic mesh properties that are otherwise unavailable, such
> as the meshid and (eventually) configured dtim and beacon
> values.
> 
> Signed-off-by: Bob Copeland <bob@cozybit.com>
> ---
> We can currently return the config values in GET_MESH_CONFIG
> but not the fixed join-time values.
> 
> My use case is to have a way to get the locally configured
> dtim and beacon interval, once Marco's patches are in
> (obviously not handled yet in this patch).  Note the local
> values might be different from peer mesh STAs' settings.
> 
> Thomas suggested a general GET_MESH_SETUP would be good to
> also allow userspace to get the meshid and to know if mesh
> is running without doing a bogus SET_MESH_CONFIG.
> 
> Presumably, once someone implements beacon collision avoidance,
> I'd rather have the current dtim/beacon_int values, which isn't
> really setup anymore, but maybe we don't care so much.

Seems fine, but I think you should document the latter. OTOH, maybe it
should just be documented that the setup values are hints only when that
is implemented ...

I guess the question is: would there be value in knowing what it was set
up with vs. what it's currently doing? Maybe because if other peers go
away it would fall back to the previous values?

Or maybe that just means that if the values are changed they should be
returned differently?

johannes

