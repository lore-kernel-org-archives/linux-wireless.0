Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54767 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab1KVUoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 15:44:18 -0500
Received: by fagn18 with SMTP id n18so872132fag.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 12:44:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321871030.3999.35.camel@jlt3.sipsolutions.net>
References: <1321870713.3999.33.camel@jlt3.sipsolutions.net> <1321871030.3999.35.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 22 Nov 2011 12:43:56 -0800
Message-ID: <CAG6hwVPob3h282aAJq7m-0zwVbvXE7yTSHM-WYtzAFcGhp+oWg@mail.gmail.com> (sfid-20111122_214421_498162_C54D9416)
Subject: Re: [PATCH v2] mac80211: fix RCU warnings in mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Javier Cardona <javier@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Mon, Nov 21, 2011 at 2:23 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Sparse RCU checking reports two warnings in the mesh
> path table code. These are due to questionable uses of
> rcu_dereference.
>
> To fix the first one, get rid of mesh_gate_add() and
> just make mesh_path_add_gate() do the correct deref.
>
> To fix the second one, simply remove rcu_dereference()
> in mesh_gate_del() -- it already gets a proper pointer
> as indicated by the prototype (no __rcu annotation)
> and confirmed by the code.
>

Sorry you had to clean up my mess, ACK :)

Thomas

> Cc: Javier Cardona <javier@cozybit.com>
> Cc: Thomas Pedersen <thomas@cozybit.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2: oops. fix prototypes
>
>  net/mac80211/mesh_pathtbl.c |   27 +++++----------------------
>  1 file changed, 5 insertions(+), 22 deletions(-)
>
> --- a/net/mac80211/mesh_pathtbl.c       2011-11-21 11:19:44.000000000 +0100
> +++ b/net/mac80211/mesh_pathtbl.c       2011-11-21 11:23:19.000000000 +0100
> @@ -69,8 +69,6 @@ static inline struct mesh_table *resize_
>                lockdep_is_held(&pathtbl_resize_lock));
>  }
>
> -static int mesh_gate_add(struct mesh_table *tbl, struct mesh_path *mpath);
> -
>  /*
>  * CAREFUL -- "tbl" must not be an expression,
>  * in particular not an rcu_dereference(), since
> @@ -420,21 +418,18 @@ static void mesh_gate_node_reclaim(struc
>  }
>
>  /**
> - * mesh_gate_add - mark mpath as path to a mesh gate and add to known_gates
> - * @mesh_tbl: table which contains known_gates list
> - * @mpath: mpath to known mesh gate
> - *
> - * Returns: 0 on success
> - *
> + * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
> + * @mpath: gate path to add to table
>  */
> -static int mesh_gate_add(struct mesh_table *tbl, struct mesh_path *mpath)
> +int mesh_path_add_gate(struct mesh_path *mpath)
>  {
> +       struct mesh_table *tbl;
>        struct mpath_node *gate, *new_gate;
>        struct hlist_node *n;
>        int err;
>
>        rcu_read_lock();
> -       tbl = rcu_dereference(tbl);
> +       tbl = rcu_dereference(mesh_paths);
>
>        hlist_for_each_entry_rcu(gate, n, tbl->known_gates, list)
>                if (gate->mpath == mpath) {
> @@ -478,8 +473,6 @@ static int mesh_gate_del(struct mesh_tab
>        struct mpath_node *gate;
>        struct hlist_node *p, *q;
>
> -       tbl = rcu_dereference(tbl);
> -
>        hlist_for_each_entry_safe(gate, p, q, tbl->known_gates, list)
>                if (gate->mpath == mpath) {
>                        spin_lock_bh(&tbl->gates_lock);
> @@ -498,16 +491,6 @@ static int mesh_gate_del(struct mesh_tab
>  }
>
>  /**
> - *
> - * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
> - * @mpath: gate path to add to table
> - */
> -int mesh_path_add_gate(struct mesh_path *mpath)
> -{
> -       return mesh_gate_add(mesh_paths, mpath);
> -}
> -
> -/**
>  * mesh_gate_num - number of gates known to this interface
>  * @sdata: subif data
>  */
>
>
>
