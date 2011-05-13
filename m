Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab1EMHNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 03:13:17 -0400
Subject: Re: mesh RCU issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org
In-Reply-To: <BANLkTinDyLyVX3HFHU7i4GFUi8SixOdzAQ@mail.gmail.com> (sfid-20110513_002720_483327_839FC15E)
References: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
	 <BANLkTinDyLyVX3HFHU7i4GFUi8SixOdzAQ@mail.gmail.com>
	 (sfid-20110513_002720_483327_839FC15E)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 09:13:13 +0200
Message-ID: <1305270793.3487.3.camel@jlt3.sipsolutions.net> (sfid-20110513_091321_229745_4E052355)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-12 at 15:26 -0700, Javier Cardona wrote:

> > And indeed I don't see a del_timer_sync() when the mesh path is freed.
> 
> Isn't the call to del_timer_sync() you are looking for in
> mesh_path_node_reclaim() ?

Hmm, indeed, but it looks like mesh_path_node_free() also frees a node,
no? I'd only found the latter function freeing it and got worried.

> > But this is _clearly_ totally bogus. Somebody please fix ASAP.
> 
> I'll run sparse and see if I see other rcu warnings that I can fix.

Thanks. I think most of the use is probably OK or "just" missing
rcu_dereference() wrappers. The global mesh_paths and mpp_paths
variables should also be __rcu I think, but that caused so many warnings
that I gave up for now, and I didn't quite understand what was going on.

You'll want to apply
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-rcu-annotations.patch to get rid of all the other spurious RCU warnings with CONFIG_SPARSE_RCU.

Thanks,
Johannes

