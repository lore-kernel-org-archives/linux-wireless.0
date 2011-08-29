Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1H2Si5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 14:38:57 -0400
Subject: Re: [PATCH v2 6/8] mac80211: Consolidate {mesh,mpp}_path_flush
 into one function
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <CAPjQAd8esVjckBCwya+a5dFiLmu14KpCW5acjNeLHk32XZYs2g@mail.gmail.com> (sfid-20110829_203711_145180_7DDE26B6)
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
	 <1314404294-4233-1-git-send-email-javier@cozybit.com>
	 <1314404294-4233-7-git-send-email-javier@cozybit.com>
	 <1314625745.8959.9.camel@jlt3.sipsolutions.net>
	 <CAPjQAd8esVjckBCwya+a5dFiLmu14KpCW5acjNeLHk32XZYs2g@mail.gmail.com>
	 (sfid-20110829_203711_145180_7DDE26B6)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 20:38:51 +0200
Message-ID: <1314643131.8959.26.camel@jlt3.sipsolutions.net> (sfid-20110829_203900_059337_23C7A471)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 11:36 -0700, Javier Cardona wrote:

> >> -     read_lock_bh(&pathtbl_resize_lock);
> >> -     tbl = rcu_dereference_protected(mpp_paths,
> >> -                                     lockdep_is_held(pathtbl_resize_lock));
> >> +     WARN_ON(!rcu_read_lock_held());
> >>       for_each_mesh_entry(tbl, p, node, i) {
> >>               mpath = node->mpath;
> >> +             if (mpath->sdata != sdata)
> >> +                     continue;
> >>               spin_lock_bh(&tbl->hashwlock[i]);
> >>               __mesh_path_del(tbl, node);
> >>               spin_unlock_bh(&tbl->hashwlock[i]);
> >>       }
> >> -     read_unlock_bh(&pathtbl_resize_lock);
> >>  }
> >
> > So what protects against the table being grown at the same time? A copy
> > will be made, but here you'll be iterating the old table -- which won't
> > crash or anything but is semantically incorrect.
> 
> You are right.  And I believe it actually may crash, given that the
> nodes we wanted to delete will still exist in the new table.  I'll
> re-spin right away.

Yes, it will crash just as before -- I was referring to this function
only. Due to RCU, this function will always have a valid "node" pointer,
but of course deleting that might not delete it from the right table...

johannes

