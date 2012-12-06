Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2LFNAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 08:00:39 -0500
Message-ID: <1354798860.10150.2.camel@jlt4.sipsolutions.net> (sfid-20121206_140043_828526_DE522F4F)
Subject: Re: [PATCH] mac80211: dont drop mesh peering frames from unknown STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 06 Dec 2012 14:01:00 +0100
In-Reply-To: <1354748666-16123-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <CAG6hwVN3F+KY=LkrG0j8WfFczBJawTD5J4kbbsnPfSAGrX5dXA@mail.gmail.com>
	 <1354748666-16123-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 15:04 -0800, Marco Porsch wrote:
> Previously, mesh peering frames from a STA without a station entry were being
> dropped.
> 
> Mesh Peering Open and Co. frames (WLAN_CATEGORY_SELF_PROTECTED) although from
> a yet unknown STA are valid mesh peering frames. The STA entry will followingly
> be created in mesh_peer_init.
> The problem was previously worked around since both STA receive the beacons
> of one another which create the STA entry. Yet, this creates an unnecessary
> delay and beacons may not be received if either node is in PS mode.

Applied.

johannes

