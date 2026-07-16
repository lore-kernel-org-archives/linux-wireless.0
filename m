Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B26222B8AB;
	Thu, 16 Jul 2026 19:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784229492; cv=none; b=CCyAy9UMK+256PvPAtMk4sYd8QbEC65L4MX0sc/ACD3WqJKr1LC3oBsW1lrQj1mXUG177eb0xkqWqGa0btpRAIrCM+3engLXIbujbRj0K0O1QGfyrfFmo8uUd3J04cK8hPvRoUdjklKtCjUJh3mlHu21JExmoamnbcxMb7c+nVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784229492; c=relaxed/simple;
	bh=6idNok2xXfynpT/4cuRMIM8LMVihxlmG0cTHTY6wADQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mizUzaMi/KJprnK17TfCWnOfxu57l0UCi3vanj0d1wzUBWEfJh+8Rh5rCFD19WQCcD3VhiFjc6JFgb0fE9r/JXVspbTjjY/zXR09H4IKFuoW/DeYDuReOuNQb0fGBjEISksz0p6OMFK7+ORa8jfM762GACRYgkgPwRbDDMs6n2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=16ckLuPj; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="16ckLuPj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=XVmaILPQFz2f1Ud0v6KckAAV6fwLDHR90oRVDaBy6W4=; b=16ckLuPj5NFha7lHTbD5hWdWpR
	D5oc5fOD5QfxK6PpkAQOVMU9t9GAOpzRmrUq3D4fDLwZgjg38yhp/VW/jLyvJ55EUumn8Pm29mJiO
	SUyJJ6ibvNMTTUVmcl3FdOXpy1DVoPxLxwGOxQc1lyxla0qCJNkhnu3AwGWtfO623BcY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wkRak-00Ccct-Ko; Thu, 16 Jul 2026 21:17:54 +0200
Date: Thu, 16 Jul 2026 21:17:54 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Dietz <simon.dietz@plantwatch.de>
Cc: netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
	kuniyu@google.com, andrew+netdev@lunn.ch, dietz23838@hs-ansbach.de,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [RFC PATCH net-next v0 1/6] net: add GeoNetworking protocol
Message-ID: <9db571aa-4d5c-456a-ab24-796119c9807b@lunn.ch>
References: <20260716135902.2895237-1-simon.dietz@plantwatch.de>
 <20260716135902.2895237-2-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716135902.2895237-2-simon.dietz@plantwatch.de>

On Thu, Jul 16, 2026 at 03:58:41PM +0200, Simon Dietz wrote:
> Implement the GeoNetworking / ETSI ITS-G5 ('net/gn') protocol which
> is based on 802.11p wifi and used for vehicle2x applications. It is
> standardized by the ETSI and used by some car manufacturers
> (especially in europe). It enables ad-hoc, multi-hop geographical
> communication and routing among vehicles (and road- or railside
> infrastructure).

I'm probably doing a deep dive too early, but ...

> +#ifdef CONFIG_PROC_FS
> +extern int gn_proc_init(void);
> +extern void gn_proc_exit(void);
> +#else
> +static inline int gn_proc_init(void)
> +{
> +	return 0;
> +}
> +static inline void gn_proc_exit(void)
> +{
> +}
> +#endif /* CONFIG_PROC_FS */

Nothing new has been added to /proc for a long time. Please consider a
different interface. I've not yet looked to see what is there, but
networking now pretty much only uses netlink.

> +/* protocol-specific ioctls */
> +#define SIOCGNSPOSITION			(SIOCPROTOPRIVATE + 0)

New IOCTL code is also very likely to be rejected. The functionality
should go through netlink.

> +static inline void __gn_insert_socket(struct sock *sk)
> +{
> +	sk_add_node(sk, &gn_sockets);
> +}
> +
> +static inline void gn_remove_socket(struct sock *sk)
> +{
> +	write_lock_bh(&gn_sockets_lock);
> +	sk_del_node_init(sk);
> +	write_unlock_bh(&gn_sockets_lock);
> +}

Generally, inline functions in a .c file are rejected. It is better to
let the compiler decide. The exception would be if you have a
benchmark which shows inline actually helps.

> +static struct gn_iface *gn_if_add_device(struct net_device *dev,
> +					 struct sockaddr_gn *sa)
> +{
> +	bool was_empty;
> +	struct gn_iface *gnif,
> +		*new_gnif = kzalloc(sizeof(struct gn_iface), GFP_KERNEL);
> +
> +	if (!new_gnif)
> +		return NULL;
> +
> +	new_gnif->address = sa->sgn_addr;
> +	new_gnif->dev = dev;
> +
> +	pr_info("Add interface %s with address %llx", dev->name,
> +		new_gnif->address);

This seems like debug. At minimum, it should be _dbg(), but maybe it
should be removed altogether.

> +u32 gn_tai_to_gn(ktime_t tai_time)
> +{
> +	/* unix timestamp of 01/01/2004 00:00:00 UTC and 32 leap seconds between TAI and UNIX*/
> +	const ktime_t tai_offset = ms_to_ktime(1072915200000LLU + 32000LLU);
> +
> +	WARN_ONCE(ktime_before(tai_time, tai_offset),
> +		  "timestamp %lld out of bounds", tai_time);
> +	/* truncate timestamp (GN timestamp has 32 bits) */
> +	return (u32)ktime_sub(tai_time, tai_offset);

I'm too lazy to do the work. When does this wrap around? Maybe add it
as a comment. 

> +static int gn_autobind(struct sock *sock)
> +{
> +	//BUG();

Commented out code is not something we want in the kernel.

Maybe one of your later patches fixes this. We might want to consider
squashing them, so the review is done on the final clean code.

> +static void gn_location_service_req(struct gn_iface *gnif, gn_address_t saddr,
> +				    gn_address_t daddr)
> +{
> +	int size = 0;
> +	struct sk_buff *skb;
> +	struct gn_basic_header *gb_h;
> +	struct gn_common_header *gc_h;
> +	struct gn_ls_request_header *gls_h;

netdev uses reverse christmas tree, longest lines first, shortest
last. It should apply to all functions.


> +// table is * 1000 | p1 * 100 entry
> +static int cos_table[] = {
> +	100000, 99995,	99980,	99955,	99920,	99875,	99820,	99755,	99680,
> +	99595,	99500,	99396,	99281,	99156,	99022,	98877,	98723,	98558,
> +	98384,	98200,	98007,	97803,	97590,	97367,	97134,	96891,	96639,
> +	96377,	96106,	95824,	95534,	95233,	94924,	94604,	94275,	93937,
> +	93590,	93233,	92866,	92491,	92106,	91712,	91309,	90897,	90475,
> +	90045,	89605,	89157,	88699,	88233,	87758,	87274,	86782,	86281,
> +	85771,	85252,	84726,	84190,	83646,	83094,	82534,	81965,	81388,
> +	80803,	80210,	79608,	78999,	78382,	77757,	77125,	76484,	75836,
> +	75181,	74517,	73847,	73169,	72484,	71791,	71091,	70385,	69671,
> +	68950,	68222,	67488,	66746,	65998,	65244,	64483,	63715,	62941,
> +	62161,	61375,	60582,	59783,	58979,	58168,	57352,	56530,	55702,
> +	54869,	54030,	53186,	52337,	51482,	50622,	49757,	48887,	48012,
> +	47133,	46249,	45360,	44466,	43568,	42666,	41759,	40849,	39934,
> +	39015,	38092,	37166,	36236,	35302,	34365,	33424,	32480,	31532,
> +	30582,	29628,	28672,	27712,	26750,	25785,	24818,	23848,	22875,
> +	21901,	20924,	19945,	18964,	17981,	16997,	16010,	15023,	14033,
> +	13042,	12050,	11057,	10063,	9067,	8071,	7074,	6076,	5077,
> +	4079,	3079,	2079,	1080,	0,	-920,	-1920,	-2920,	-3919,
> +	-4918,	-5917,	-6915,	-7912,	-8909,	-9904,	-10899, -11892, -12884,
> +	-13875, -14865, -15853, -16840, -17825, -18808, -19789, -20768, -21745,
> +	-22720, -23693, -24663, -25631, -26596, -27559, -28519, -29476, -30430,
> +	-31381, -32329, -33274, -34215, -35153, -36087, -37018, -37945, -38868,
> +	-39788, -40703, -41615, -42522, -43425, -44323, -45218, -46107, -46992,
> +	-47873, -48748, -49619, -50485, -51345, -52201, -53051, -53896, -54736,
> +	-55570, -56399, -57221, -58039, -58850, -59656, -60455, -61249, -62036,
> +	-62817, -63592, -64361, -65123, -65879, -66628, -67370, -68106, -68834,
> +	-69556, -70271, -70979, -71680, -72374, -73060, -73739, -74411, -75075,
> +	-75732, -76382, -77023, -77657, -78283, -78901, -79512, -80114, -80709,
> +	-81295, -81873, -82444, -83005, -83559, -84104, -84641, -85169, -85689,
> +	-86200, -86703, -87197, -87682, -88158, -88626, -89085, -89534, -89975,
> +	-90407, -90830, -91244, -91648, -92044, -92430, -92807, -93175, -93533,
> +	-93883, -94222, -94553, -94873, -95185, -95486, -95779, -96061, -96334,
> +	-96598, -96852, -97096, -97330, -97555, -97770, -97975, -98170, -98356,
> +	-98531, -98697, -98853, -98999, -99135, -99262, -99378, -99484, -99581,
> +	-99667, -99744, -99810, -99867, -99914, -99950, -99977, -99993, -100000
> +};
> +
> +/* icos() - look up in cos_table for a rad value.
> + * @rad : the rad value.* 10^7
> + *
> + * Return : the cosine value * 100000
> + */
> +static int icos(__s64 rad)
> +{
> +	if (rad > PI)
> +		rad = PI - (rad - PI);
> +	return cos_table[rad / 100000];
> +}
> +
> +/* degree_to_rad() - convert a degree value to a rad value.
> +* @a : the degree value as 1/10 micro degree (10^7).
> +*
> +* Return : the rad value * 10^7.
> +*/
> +static __s64 degree_to_rad(__s64 a)
> +{
> +	return (((RAD_PER_DEGREE * a) / 10000000ULL)) % (PI * 2ULL);
> +}

Not the sort of thing you normally see in the kernel. I've not looked
at the code enough to see the big picture, but generally, the kernel
routing table is static, and fed from a user space daemon. Should all
this code be in user space?

> +static void debug_loc_te(void)
> +{
> +	struct loc_te *entry;
> +	int bucket;
> +
> +	spin_lock_bh(&gn_loc_t_lock);
> +	if (hash_empty(gn_loc_t)) {
> +		spin_unlock_bh(&gn_loc_t_lock);
> +		return;
> +	}
> +
> +	pr_info("Printing location table");
> +	hash_for_each(gn_loc_t, bucket, entry, hnode) {
> +		pr_info("LOC_TE(%p) tst=%x addr=%llx ll_addr=%llx is_neighbour=%x ls_pending=%x",
> +			entry, entry->tst_addr, be64_to_cpu(entry->addr),
> +			be64_to_cpu(entry->ll_address), entry->is_neighbour,
> +			entry->ls_pending);
> +	}
> +	spin_unlock_bh(&gn_loc_t_lock);

debugfs? a netlink dump operation?

	Andrew
