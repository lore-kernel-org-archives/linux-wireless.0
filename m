Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab1EMXag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 19:30:36 -0400
Subject: Re: mesh RCU issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org
In-Reply-To: <BANLkTi=R_Eyz8+iZsk+=Gs4vaNo-0eUVng@mail.gmail.com> (sfid-20110513_222925_238565_758AD262)
References: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
	 <BANLkTinDyLyVX3HFHU7i4GFUi8SixOdzAQ@mail.gmail.com>
	 <1305270793.3487.3.camel@jlt3.sipsolutions.net>
	 <BANLkTi=R_Eyz8+iZsk+=Gs4vaNo-0eUVng@mail.gmail.com>
	 (sfid-20110513_222925_238565_758AD262)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 01:30:34 +0200
Message-ID: <1305329434.32461.2.camel@jlt3.sipsolutions.net> (sfid-20110514_013039_651933_DBC30774)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 13:28 -0700, Javier Cardona wrote:

> >> Isn't the call to del_timer_sync() you are looking for in
> >> mesh_path_node_reclaim() ?
> >
> > Hmm, indeed, but it looks like mesh_path_node_free() also frees a node,
> > no? I'd only found the latter function freeing it and got worried.
> 
> Ah, I see.  Yes, looks like the timer should be deleted there as well.
>  Patch will follow.

Thanks!

> > You'll want to apply
> > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-rcu-annotations.patch to get rid of all the other spurious RCU warnings with CONFIG_SPARSE_RCU.
> 
> (You probably meant CONFIG_SPARSE_RCU_POINTER)

Yeah, sorry.

> I must be doing something wrong because I don't see the RCU warnings
> after making {mesh,mpp}_paths __rcu.  I only see two "different
> address spaces" errors that are fixed in the patch below.
> I do see a bunch of 'warning' errors:
> 
> /home/javier/dev/wireless-testing/arch/x86/include/asm/uaccess_32.h:199:2:
> error: attribute 'warning': unknown attribute

Oh, damn. You're running into a sparse issue: upon encountering an
error, it aborts parsing/checking. So since you're getting an error from
an include file, you never see any warnings from the rest of the file.

> 
> 
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 83ce48e..1db8bba 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -36,8 +36,8 @@ struct mpath_node {
>         struct mesh_path *mpath;
>  };
> 
> -static struct mesh_table *mesh_paths;
> -static struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
> +static struct mesh_table __rcu *mesh_paths;
> +static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
> 
>  int mesh_paths_generation;
> 
> @@ -513,7 +513,7 @@ void mesh_plink_broken(struct sta_info *sta)
>         for_each_mesh_entry(mesh_paths, p, node, i) {
>                 mpath = node->mpath;
>                 spin_lock_bh(&mpath->state_lock);
> -               if (mpath->next_hop == sta &&
> +               if (rcu_dereference(mpath->next_hop) == sta &&
>                     mpath->flags & MESH_PATH_ACTIVE &&
>                     !(mpath->flags & MESH_PATH_FIXED)) {
>                         mpath->flags &= ~MESH_PATH_ACTIVE;
> @@ -549,7 +549,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
> 
>         for_each_mesh_entry(mesh_paths, p, node, i) {
>                 mpath = node->mpath;
> -               if (mpath->next_hop == sta)
> +               if (rcu_dereference(mpath->next_hop) == sta)
>                         mesh_path_del(mpath->dst, mpath->sdata);
>         }
>  }
> 
> Thoughts?

I'll try if this is sufficient but it seemed there were more warnings
when I tried.

johannes

