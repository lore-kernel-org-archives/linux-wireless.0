Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51461 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1EMU3C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 16:29:02 -0400
Received: by vxi39 with SMTP id 39so2104402vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 13:29:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305270793.3487.3.camel@jlt3.sipsolutions.net>
References: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
 <BANLkTinDyLyVX3HFHU7i4GFUi8SixOdzAQ@mail.gmail.com> <1305270793.3487.3.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 13 May 2011 13:28:42 -0700
Message-ID: <BANLkTi=R_Eyz8+iZsk+=Gs4vaNo-0eUVng@mail.gmail.com> (sfid-20110513_222907_856686_A223EC2B)
Subject: Re: mesh RCU issues
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 12:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-05-12 at 15:26 -0700, Javier Cardona wrote:
>
>> > And indeed I don't see a del_timer_sync() when the mesh path is freed.
>>
>> Isn't the call to del_timer_sync() you are looking for in
>> mesh_path_node_reclaim() ?
>
> Hmm, indeed, but it looks like mesh_path_node_free() also frees a node,
> no? I'd only found the latter function freeing it and got worried.

Ah, I see.  Yes, looks like the timer should be deleted there as well.
 Patch will follow.

>> > But this is _clearly_ totally bogus. Somebody please fix ASAP.
>>
>> I'll run sparse and see if I see other rcu warnings that I can fix.
>
> Thanks. I think most of the use is probably OK or "just" missing
> rcu_dereference() wrappers. The global mesh_paths and mpp_paths
> variables should also be __rcu I think, but that caused so many warnings
> that I gave up for now, and I didn't quite understand what was going on.
>
> You'll want to apply
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-rcu-annotations.patch to get rid of all the other spurious RCU warnings with CONFIG_SPARSE_RCU.

(You probably meant CONFIG_SPARSE_RCU_POINTER)

I must be doing something wrong because I don't see the RCU warnings
after making {mesh,mpp}_paths __rcu.  I only see two "different
address spaces" errors that are fixed in the patch below.
I do see a bunch of 'warning' errors:

/home/javier/dev/wireless-testing/arch/x86/include/asm/uaccess_32.h:199:2:
error: attribute 'warning': unknown attribute



diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 83ce48e..1db8bba 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -36,8 +36,8 @@ struct mpath_node {
        struct mesh_path *mpath;
 };

-static struct mesh_table *mesh_paths;
-static struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
+static struct mesh_table __rcu *mesh_paths;
+static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */

 int mesh_paths_generation;

@@ -513,7 +513,7 @@ void mesh_plink_broken(struct sta_info *sta)
        for_each_mesh_entry(mesh_paths, p, node, i) {
                mpath = node->mpath;
                spin_lock_bh(&mpath->state_lock);
-               if (mpath->next_hop == sta &&
+               if (rcu_dereference(mpath->next_hop) == sta &&
                    mpath->flags & MESH_PATH_ACTIVE &&
                    !(mpath->flags & MESH_PATH_FIXED)) {
                        mpath->flags &= ~MESH_PATH_ACTIVE;
@@ -549,7 +549,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)

        for_each_mesh_entry(mesh_paths, p, node, i) {
                mpath = node->mpath;
-               if (mpath->next_hop == sta)
+               if (rcu_dereference(mpath->next_hop) == sta)
                        mesh_path_del(mpath->dst, mpath->sdata);
        }
 }

Thoughts?

j

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
