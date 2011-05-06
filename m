Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1EFWRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 18:17:35 -0400
Subject: Re: [PATCH] mac80211: Only process mesh PREPs with equal seq
 number if metric is better.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Fabrice Deyber <fabricedeyber@agilemesh.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1304719911-22636-1-git-send-email-javier@cozybit.com> (sfid-20110507_001221_302201_902C39CF)
References: <1304719911-22636-1-git-send-email-javier@cozybit.com>
	 (sfid-20110507_001221_302201_902C39CF)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 00:17:28 +0200
Message-ID: <1304720248.3595.13.camel@jlt3.sipsolutions.net> (sfid-20110507_001737_141312_4F2FC315)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-06 at 15:11 -0700, Javier Cardona wrote:
> From: Fabrice Deyber <fabricedeyber@agilemesh.com>
> 
> This fixes routing loops in PREP propagation and is in accordance with Draft
> 11, Section: 11C.9.8.4.

> +++ b/net/mac80211/mesh_hwmp.c
> @@ -391,7 +391,6 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
>  			    (mpath->flags & MESH_PATH_SN_VALID)) {
>  				if (SN_GT(mpath->sn, orig_sn) ||
>  				    (mpath->sn == orig_sn &&
> -				     action == MPATH_PREQ &&

I don't understand how removing the action comparison maps to the patch
description -- can you explain a bit more?

johannes

