Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56486 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbcCCPS7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:18:59 -0500
Message-ID: <1457018336.2044.21.camel@sipsolutions.net> (sfid-20160303_161902_577355_54BA4D11)
Subject: Re: [PATCH 1/4] mac80211: mesh: move path tables into if_mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Date: Thu, 03 Mar 2016 16:18:56 +0100
In-Reply-To: <1456707839-19469-1-git-send-email-me@bobcopeland.com> (sfid-20160229_020409_241247_D34BE44D)
References: <1456707839-19469-1-git-send-email-me@bobcopeland.com>
	 (sfid-20160229_020409_241247_D34BE44D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-02-28 at 20:03 -0500, Bob Copeland wrote:
> The mesh path and mesh gate hashtables are global, containing
> all of the mpaths for every mesh interface, but the paths are
> all tied logically to a single interface.  The common case is
> just a single mesh interface, so optimize for that by moving
> the global hashtable into the per-interface struct.
> 
> Doing so allows us to drop sdata pointer comparisons inside
> the lookups and also saves a few bytes of BSS and data.
> 
All 4 applied.

johannes
