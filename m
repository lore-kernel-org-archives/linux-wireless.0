Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:48375 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaEVT1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 15:27:37 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so8046203igb.8
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 12:27:36 -0700 (PDT)
Date: Thu, 22 May 2014 15:27:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org, Thomas Pedersen <thomas@noack.us>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
Message-ID: <20140522192720.GA13440@localhost> (sfid-20140522_212740_772937_52EA880A)
References: <3893194.GDQagdLGN9@desktop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3893194.GDQagdLGN9@desktop.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2014 at 05:06:21PM +0200, Henning Rogge wrote:
> From: Henning Rogge <hrogge@gmail.com>
> 
> This patch is a preparation for exporting the MPP data of the 802.11s
> implementation via netlink to userspace. It unifies the content of the
> mesh_paths and mpp_paths tables in mesh_pathtbl.c without changing
> the behavior of the code.
> 
> Signed-off-by: Henning Rogge <hrogge@gmail.com>

I think I fall on the side of your earlier assessment that they
hold different things and should stay in different tables, even though
there are 200 lines of identical code here.  Maybe some bits could
be shared without sharing the data and changing the API?

> -static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
> -				      struct ieee80211_sub_if_data *sdata)
> +/**
> + * mesh_path_lookup - look up a path in the mesh path table
> + * @sdata: local subif
> + * @dst: hardware address (ETH_ALEN length) of destination
> + * @is_proxied: true to lookup mpp entries, false otherwise

Also, I don't like adding random boolean variables to water down what
this function does.  It means when looking at the caller you have to go
back to the definition to see just what is going on here.

We do mpp_path_lookup exactly twice so it seems weird to have to
change all of the mpath_lookup callers too.

-- 
Bob Copeland %% www.bobcopeland.com
