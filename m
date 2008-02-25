Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:4231 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYBYTOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:14:44 -0500
Received: by wr-out-0506.google.com with SMTP id c48so2637523wra.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 11:14:43 -0800 (PST)
Subject: Re: [PATCH 04/13 v2] o11s: added mesh.h, mesh function and data
	structures definitions
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203697425.7082.70.camel@johannes.berg>
References: <47be7732.20588c0a.0360.ffff8f1c@mx.google.com>
	 (sfid-20080222_071816_353396_9A4A9995)  <1203697425.7082.70.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:16:18 -0800
Message-Id: <1203966978.6929.11.camel@localhost> (sfid-20080225_191448_053912_B0C0E1FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 17:23 +0100, Johannes Berg wrote:
> I don't think I fully understand that. The mesh path points to a sta
> structure, so when that sta is removed, the corresponding mesh path must
> also be deleted. I think I need to look closer at where that is done to
> understand how it could be substituted.

In sta_info_free() we call mesh_plink_deactivate(sta), which calls
mesh_path_flush_by_nexthop(). There is where you could substitute the
mesh path (copy it with next_hop pointing to NULL, substitute pointer,
rcu_synchronize()). However there is not much to gain. Since mesh paths
are freed if inactive sooner than mesh peer links are, this will
actually only happen when mesh peer links are either deleted from user
land or because a specific "peer link close" frame is received.


-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


