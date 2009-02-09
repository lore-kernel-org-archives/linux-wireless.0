Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZBIKfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 05:35:55 -0500
Subject: Re: [PATCH 1/3] mac80211: Modularize Mesh path selection protocol
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Sesser <flomaillist@cosetrain.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com> (sfid-20090208_205239_665709_8D4CC408)
References: <498F36B7.40806@cosetrain.com>
	 <31341041c003f9a10f7ef791dc74748c0ba6b46f.1234118418.git.flomaillist@cosetrain.com>
	 (sfid-20090208_205239_665709_8D4CC408)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-A59ZQwSEY/UksOjdrWe/"
Date: Mon, 09 Feb 2009 11:35:46 +0100
Message-Id: <1234175746.4175.214.camel@johannes.local> (sfid-20090209_113600_147590_EE8BF992)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A59ZQwSEY/UksOjdrWe/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-08 at 20:52 +0100, Florian Sesser wrote:

>  	rm_cache =3D kmem_cache_create("mesh_rmc", sizeof(struct rmc_entry),
>  				     0, 0, NULL);
> +	if (!(ieee80211_mesh_path_sel_proto_find(0x000FACFF)))
> +		ieee80211_mesh_path_sel_proto_register(&mesh_path_sel_hwmp);

Explain please. Why the null protocol here?
=20
> +struct mesh_path_sel_proto *ieee80211_mesh_path_sel_proto_find(u32 id)
> +{
> +	struct mesh_path_sel_proto *a;
> +	list_for_each_entry(a, &mesh_path_sel_proto_list, list) {
> +		if (a->id =3D=3D id)
> +			return a;
> +	}
> +	return NULL;
> +}

Explain why there's no need for any locking.

> +void ieee80211_mesh_path_sel_proto_set(struct ieee80211_if_mesh *sta,
> +				struct mesh_path_sel_proto *algo)
> +{
> +	/* first, check if algo has been properly registered */
> +	if (ieee80211_mesh_path_sel_proto_find(algo->id)) {
> +		if (!sta->mesh_pp) {
> +			/* set all three locations: */
> +			/* connects an interface to its mesh pp algo */
> +			sta->mesh_pp =3D algo;
> +			/* used to compare meshes (see mesh_matches_local) */
> +			memcpy(sta->mesh_pp_id, &(algo->id), 4);
> +			/* used by the nl80211 layer */
> +			sta->mshcfg.mesh_path_selection_protocol_id =3D algo->id;
> +
> +			printk(KERN_INFO "o11s: Initial mesh path selection "
> +				"algorithm %s / %08X\n", algo->name, algo->id);
> +			return;
> +		}

Please rewrite this entire function to have less deep nesting. And
rename the "sta" variable here to something more customary. "sta" means
struct sta_info. Also, see whether the printks are all necessary, should
depend on debugging options and are user triggerable.

> +void ieee80211_mesh_path_sel_proto_register(struct mesh_path_sel_proto *=
algo)
> +{
> +	/* Sanity checks */
> +	BUG_ON(!algo->ops->path_start_discovery);
> +	BUG_ON(!algo->ops->nexthop_lookup);
> +	BUG_ON(!algo->ops->path_error_tx);
> +	BUG_ON(!algo->ops->queue_preq);
> +	BUG_ON(!algo->ops->rx_path_sel_frame);
> +	BUG_ON(!algo->ops->path_sel_start);
> +	BUG_ON(!algo->ops->path_sel_stop);

How about also BUG_ON(!algo->ops) :)

> +	spin_lock(&path_sel_list_lock);
> +	if (!ieee80211_mesh_path_sel_proto_find(algo->id)) {
> +		list_add_tail(&algo->list, &mesh_path_sel_proto_list);
> +		spin_unlock(&path_sel_list_lock);
> +		printk(KERN_INFO "o11s: Mesh path selection algorithm %s / "
> +			"%08X registered\n", algo->name, algo->id);
> +	} else {
> +		spin_unlock(&path_sel_list_lock);
> +		printk(KERN_WARNING "o11s: Error: Path selection algorithm "
> +			"%s / %08X already registered\n", algo->name,
> +			algo->id);
> +	}

Wow, that unlocking is awkward. Fix that please by moving it out of the
conditionals.

> +void ieee80211_mesh_path_sel_proto_unregister(struct mesh_path_sel_proto=
 *algo)
> +{
> +	if (ieee80211_mesh_path_sel_proto_find(algo->id)) {
> +		list_del(&algo->list);
> +		printk(KERN_INFO "o11s: Mesh path selection algorithm %s / "
> +			"%08X unregistered\n", algo->name, algo->id);
> +	} else {
> +		printk(KERN_WARNING "o11s: Error: Mesh path selection algorithm"
> +			" %s / %08X not found\n", algo->name, algo->id);
> +	}
> +}

Explain the ability to not lock here.

> +/* Set path selection protocol ID: OUI followed by arbitrary 2 bytes */

two bytes??

> +void mesh_ids_set_pp(struct ieee80211_if_mesh *sta, u32 pp)
> +{
> +	struct mesh_path_sel_proto *nalgo =3D
> +		ieee80211_mesh_path_sel_proto_find(pp);
> +
> +	if (nalgo)
> +		ieee80211_mesh_path_sel_proto_set(sta, nalgo);
> +	else
> +		printk(KERN_WARNING "o11s: Could not find mesh path selection "
> +			"protocol with ID %08X\n", pp);
> +}
> +/* Set path selection metric ID: OUI followed by arbitrary 2 bytes */
> +void mesh_ids_set_pm(struct ieee80211_if_mesh *sta, u32 pm)

Generally you need to be way more liberal with adding empty lines to aid
the reader. Your _primary_ (!!) concern should be the _human_ consumer
of the code, not the compiler.

> +{
> +	memcpy(sta->mesh_pm_id, &pm, 4);
> +}
> +/* Set congestion control mode ID: OUI followed by arbitrary 2 bytes */
> +void mesh_ids_set_cc(struct ieee80211_if_mesh *sta, u32 cc)
> +{
> +	memcpy(sta->mesh_cc_id, &cc, 4);
> +}

Both of these look like candidates for static inlines, but they're both
not endian safe. Also observe the variable naming I mentioned above.

> @@ -346,16 +463,6 @@ void mesh_table_free(struct mesh_table *tbl, bool fr=
ee_leafs)
>  	__mesh_table_free(tbl);
>  }
> =20
> -static void ieee80211_mesh_path_timer(unsigned long data)
> -{
> -	struct ieee80211_sub_if_data *sdata =3D
> -		(struct ieee80211_sub_if_data *) data;
> -	struct ieee80211_if_mesh *ifmsh =3D &sdata->u.mesh;
> -	struct ieee80211_local *local =3D sdata->local;
> -
> -	queue_work(local->hw.workqueue, &ifmsh->work);
> -}
> -
>  struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
>  {
>  	struct mesh_table *newtbl;
> @@ -444,6 +551,16 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_da=
ta *sdata)
>  	queue_work(local->hw.workqueue, &ifmsh->work);
>  	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
>  				   IEEE80211_IFCC_BEACON_ENABLED);
> +
> +	/* If no PS protocol has manually been set, go with the default */

"PS" is overloaded, elaborate.

> +	if (!ifmsh->mesh_pp)
> +		ifmsh->mesh_pp =3D ieee80211_mesh_path_sel_proto_find
> +			(0x000FACFF);
> +	/* If we still have no PS Proto, bail out */
> +	if (!ifmsh->mesh_pp) {
> +		printk(KERN_WARNING "o11s: Could not load HWMP, aborting\n");
> +		ieee80211_stop_mesh(sdata);
> +	}
>  }

That looks horrible. No space between the function name and opening
parenthesis please, more blank lines. Avoid all the error cases by
forcing the user to build at least one algorithm into the kernel.

>  void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
> @@ -523,7 +640,8 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee=
80211_sub_if_data *sdata,
>  		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
>  		break;
>  	case MESH_PATH_SEL_CATEGORY:
> -		mesh_rx_path_sel_frame(sdata, mgmt, len);
> +		sdata->u.mesh.mesh_pp->ops->
> +			rx_path_sel_frame(sdata, mgmt, len);

Add static inline wrappers for the function ops calls, and if you call
those like the original functions your patch could be a lot clearer.


> -		mesh_path_start_discovery(sdata);
> +		ifmsh->mesh_pp->ops->path_start_discovery(sdata);

ditto

> @@ -169,6 +169,57 @@ struct mesh_rmc {
>   */
>  #define MESH_PREQ_MIN_INT	10
>  #define MESH_DIAM_TRAVERSAL_TIME 50
> +
> +/* Default Path Selection, Path Metric, Congestion Control Mode */
> +#define MESH_PATH_SELECTION_PROTOCOL_ID 0x000FACFF
> +#define MESH_PATH_SELECTION_METRIC_ID 0x000FACFF
> +#define MESH_CONGESTION_CONTROL_MODE_ID 0x000FACFF

These are "null", and you should probably define them in a proper header
(linux/ieee80211.h), not this internal one.

> +/**
> +  * struct mesh_path_sel_ops - Mesh Path Selection Protocol function poi=
nters

Is it conceivable that somebody wants a MPSP _outside_ net/mac80211/?
Say an external test module? In that case all this needs to go into
include/net/mac80211.h. Mind you, in that case you cannot pass around
internal structs like "sub_if_data" or "mesh_path".

However, if you don't want to clean it up to allow that, I oppose adding
all the EXPORT_SYMBOLs and will ask you to not modularise the algorithms
into kernel modules but rather just make them selectable at mac80211
build time and build them all into mac80211.ko.

> +  * This resembles the main part of the mesh path selection protocol
> +  * abstracion layer. Every new PS protocol has to define every member.

typo "abstraction", see above for "PS" or just remove the "PS" here.

> +struct mesh_path_sel_ops {
> +	void (*path_start_discovery) (struct ieee80211_sub_if_data *sdata);
> +	int (*nexthop_lookup) (struct sk_buff *skb,
> +		struct ieee80211_sub_if_data *sdata);
> +	void (*queue_preq) (struct mesh_path *mpath, u8 flags);
> +	int (*path_error_tx) (u8 *dst, __le32 dst_dsn, u8 *ra,
> +		struct ieee80211_sub_if_data *sdata);
> +	void (*rx_path_sel_frame) (struct ieee80211_sub_if_data *sdata,
> +		struct ieee80211_mgmt *mgmt, size_t len);
> +	void (*path_sel_start) (struct ieee80211_if_mesh *sta);
> +	void (*path_sel_stop) (struct ieee80211_if_mesh *sta);
> +};

no space between ) (, please indent to the right depth of the
parameters.

> +#define MESH_ALGO_NAME_MAX    (16)
> +struct mesh_path_sel_proto {
> +	struct list_head list;
> +	char name[MESH_ALGO_NAME_MAX];
> +	u32 id;
> +	struct mesh_path_sel_ops *ops;
> +	struct module *owner;
> +};

Why bother with two structs? You also need to make it perfectly clear
that the "list" member is not for public consumption but internal.

>  #ifdef CONFIG_MAC80211_MESH
>  extern int mesh_allocated;
> +extern struct mesh_path_sel_proto mesh_path_sel_hwmp;

Why is that not a pointer?
=20
> +struct mesh_path_sel_proto mesh_path_sel_hwmp;

??? You just pulled that declaration from mesh.h

> -int mesh_nexthop_lookup(struct sk_buff *skb,
> +static int mesh_nexthop_lookup(struct sk_buff *skb,
>  			struct ieee80211_sub_if_data *sdata)

please adjust the parameter indent

> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 3c72557..f8a795f 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -26,7 +26,7 @@
>  				time_after(jiffies, mpath->exp_time) && \
>  				!(mpath->flags & MESH_PATH_FIXED))
> =20
> -struct mpath_node {
> +		struct mpath_node {

???

>  	struct hlist_node list;
>  	struct rcu_head rcu;
>  	/* This indirection allows two different tables to point to the same

> +void mesh_path_timer(unsigned long data)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	struct mesh_path *mpath;
> +
> +	rcu_read_lock();
> +	mpath =3D (struct mesh_path *) data;
> +	mpath =3D rcu_dereference(mpath);
> +	if (!mpath)
> +		goto endmpathtimer;
> +	spin_lock_bh(&mpath->state_lock);
> +	sdata =3D mpath->sdata;
> +	if (mpath->flags & MESH_PATH_RESOLVED ||
> +			(!(mpath->flags & MESH_PATH_RESOLVING)))
> +		mpath->flags &=3D ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
> +	else if (mpath->discovery_retries < max_preq_retries(sdata)) {
> +		++mpath->discovery_retries;
> +		mpath->discovery_timeout *=3D 2;
> +		sdata->u.mesh.mesh_pp->ops->queue_preq(mpath, 0);
> +	} else {
> +		mpath->flags =3D 0;
> +		mpath->exp_time =3D jiffies;
> +		mesh_path_flush_pending(mpath);
> +	}
> +
> +	spin_unlock_bh(&mpath->state_lock);
> +endmpathtimer:
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(mesh_path_timer);

This export doesn't look right at all, explain.

> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -105,6 +105,7 @@ struct sta_info *sta_info_get(struct ieee80211_local =
*local, const u8 *addr)
>  	}
>  	return sta;
>  }
> +EXPORT_SYMBOL(sta_info_get);

absolutely not.
=20
> +#ifdef CONFIG_MAC80211_MESH
>  		else
> -			if (mesh_nexthop_lookup(skb, osdata)) {
> +			if (osdata->u.mesh.mesh_pp->ops->
> +				nexthop_lookup(skb, osdata)) {
>  				dev_put(odev);
>  				return 0;
>  			}
> +#endif

see above - static inlines, and those can get ifdefs.


Generally, this looks like a decent idea, but the execution definitely
is lacking. You need to put more thought into proper boundaries/APIs
between the various parts of things instead of blindly exporting all
symbols that might be necessary.

Also, it is good etiquette to CC the maintainer and people who have
previously worked on the code or commented on your patches.

johannes

--=-A59ZQwSEY/UksOjdrWe/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkAb/AAoJEKVg1VMiehFY6lMP/iMFTW9Qkn6DBTYkgH/yMJs+
fJUwAYKS7thfCA76NBUJ0GEidMB9jQp0nhSOqhh0YeAlaLqusyeYVJ7kdQ/t1fC9
/wOB80cuQdTLpAcWqKmjq4fgQHIAMcdqBtKO7nhu05TUefiW35ZDsh8EVfV0q5ds
GM8PxF22KNM4v+imAO2aT7qdWkMlBt1EsmDKMHFHaZrmbwxu3Yodfb0091Rmd3nZ
Q5LQ7GZn4sqYmOIAH9Pa9tikvSioMH5CxDJIE4jmh1QXOJ9ANDrEfoXiXNSEwHGm
Dt7oDnUIStdd3bn/GZSLgFyhKzXevSh01q1Ol7wCcYmpMLE1HzBPGsSMObywK4WI
OKmPjjYd//FbQknotNeZ+oD9dIbqSyg/LJd6kHUdkwXFzmxS841GuZeauuIrzeQ8
EjgTJm/ypJ+gOxH9BU2MX1+WhN1fsTTHSG/DVD6I9g8+qQ1abLGthedDxda/3Hx7
1d8RohZhYJ1Dvgu2AX01Y9N/KiiFg0YPDOOpqKaxrw76mS8y+mvjKmfiJj+cI0AM
uOk3DgXc2N5bwmIvdlOY66sHPVzQOUIR+wxCLK4mhHazmpDVbcsk9aTLK52zbLBH
9x+gX6mUGP6WiFBJmvqMUZbRiWd11Sl2JQ+ZHU0MhI69Ko+auMgQw484Ij/ZMMup
3l1lryHdcwWvALRDJ/ga
=VMWH
-----END PGP SIGNATURE-----

--=-A59ZQwSEY/UksOjdrWe/--

