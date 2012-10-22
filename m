Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2JVNbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 09:31:50 -0400
Message-ID: <1350912743.10166.10.camel@jlt4.sipsolutions.net> (sfid-20121022_153153_645358_4FF0C1AA)
Subject: Re: [PATCH] mac80211: mesh STAs only process mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Oct 2012 15:32:23 +0200
In-Reply-To: <1350784990-14242-1-git-send-email-thomas@cozybit.com> (sfid-20121021_040319_201504_578B6A8D)
References: <1350784990-14242-1-git-send-email-thomas@cozybit.com>
	 (sfid-20121021_040319_201504_578B6A8D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-10-20 at 19:03 -0700, Thomas Pedersen wrote:
> Before, a mesh STA would execute some code on behalf of AP or IBSS
> beacons. Since the mesh stack currently does not consider anything but
> other mesh STAs interesting, limit processing to just these and save a
> little overhead.

I can apply this, but I think while you're at it the function deserves a
bit more thought:

> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

> -	if (elems.mesh_id && elems.mesh_config &&
> -	    mesh_matches_local(sdata, &elems))
> +	if (mesh_matches_local(sdata, &elems))
>  		mesh_neighbour_update(sdata, mgmt->sa, &elems);
>  
>  	if (ifmsh->sync_ops)

Why would you want to invoke sync_ops when the mesh is somebody else's
mesh, i.e. doesn't match local?

johannes

