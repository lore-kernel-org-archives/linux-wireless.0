Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:45891 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3FCPUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:20:44 -0400
Received: by mail-ob0-f172.google.com with SMTP id wo10so7438805obc.17
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 08:20:43 -0700 (PDT)
Date: Mon, 3 Jun 2013 11:19:42 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: thomas@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Subject: Re: [PATCH] cfg80211: fix deadlock in cfg80211_leave_mesh()
Message-ID: <20130603151942.GF8644@localhost> (sfid-20130603_172047_250916_D4C06B33)
References: <20130601131916.GA2484@localhost>
 <1370271421.8227.14.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370271421.8227.14.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 03, 2013 at 04:57:01PM +0200, Johannes Berg wrote:
> However, I think that in mac80211 we can instead just remove the locking
> and the cancel_work_sync() since the latter will happen whenever the
> interface goes down, in a different code path outside of this. Just need
> to make sure the work can cope with running while the interface is not
> joined to a mesh, but I guess that's not going to be a big problem.

Yeah, that would be a better approach.  We (myself or Thomas) can give
that a shot today.

-- 
Bob Copeland %% www.bobcopeland.com
