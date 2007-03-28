Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbXC2LHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:07:18 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4qCNBOLiLRifM+quW6B0"
Date: Wed, 28 Mar 2007 21:53:19 +0200
Message-Id: <1175111599.5151.123.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4qCNBOLiLRifM+quW6B0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 04:40 -0700, mohamed wrote:

Scratch my previous comments. Sorry about that, I should've looked
better.

> +inline static int is_agg_frame(struct sk_buff *skb, u16 fc)
> +{
> +       u8 *p =3D skb->data + ieee80211_get_hdrlen(fc) - 2;

See below, but isn't this broken if somebody includes an HT field?

> +       if (!(fc & IEEE80211_STYPE_QOS_DATA));
> +               return 0;
> +
> +       if (*p & QOS_CONTROL_A_MSDU_PRESENT)
> +               return 1;
> +       else
> +               return 0;
> +}

Hmm. Can we add the appropriate stuff to struct ieee80211_hdr in
include/linux/ieee80211.h and use that? Like=20

struct ieee80211_hdr *hdr =3D skb->data;

if (!(fc & ...))
	return 0;
if (le16_to_cpu(hdr->qos_control) & QOS_CONTROL_A_MSDU_PRESENT)
	return 1;
return 0;

Then again, this is a problem with the addr4 format, we'll probably have
to split up ieee80211_hdr into a 3-addr and a 4-addr format, or use a
union like this:

struct ieee80211_hdr {
        __le16 frame_control;
        __le16 duration_id;
        __u8 addr1[6];
        __u8 addr2[6];
        __u8 addr3[6];
        __le16 seq_ctrl;
	union {
	        __u8 addr4[6];	/* keep for easier access */
		struct {
			__u8 addr4[6];
			__le16 qos;
			__le32 ht;
		} _4addr;
		struct {
			__le16 qos;
			__le32 ht;
		} _3addr;
	}
} __attribute__ ((packed));

Or something like that. Can you get frames w/o qos information but with
ht info? If so, we'll need even more cases here :/

Then again, how about we simply add a few inlines like
__le16 ieee80211_get_qos() that gives you the qos field etc, and then
use those. This seems dangerous anyway considering the possible presence
of the HT field.

> +	hdrlen =3D ieee80211_get_hdrlen(fc);

I haven't seen a patch to ieee80211_get_hdrlen to add the HT field.
Isn't that missing?

> +	payload =3D skb->data + hdrlen;

Ok so payload now points to the subframes.

> +	if (unlikely(skb->len - hdrlen < 8)) {
> +		if (net_ratelimit()) {
> +			printk(KERN_DEBUG "%s: RX too short data frame "
> +				"payload\n", dev->name);

Nit: this should increase the counter we have for too short frames
somewhere.

> +		}
> +		return TXRX_DROP;
> +	}
> +
> +	ethertype =3D (payload[6] << 8) | payload[7];

Is that really correct?

> +	if (likely((memcmp(payload, rfc1042_header, 6) =3D=3D 0 &&
> +		ethertype !=3D ETH_P_AARP && ethertype !=3D ETH_P_IPX) ||
> +		memcmp(payload, bridge_tunnel_header, 6) =3D=3D 0)) {
> +		/* remove RFC1042 or Bridge-Tunnel encapsulation and
> +		* replace EtherType */=09
> +		skb_pull(skb, hdrlen + 6);
> +	} else {
> +		skb_pull(skb, hdrlen);
> +	}
> +
> +	eth =3D (struct ethhdr*)skb->data;

So that now points to the first actual subframe ethhdr. I misread that
in my first comment. Why do you actually skb_pull on this skb? It would
probably be more efficient to just assign "eth" in the different cases
since that needs no memory write (eth will probably be kept in a
register). And you throw it away anyway...

> +	while ((u8*)eth < skb->data + skb->len) {

And that compares the pointer, not the value at it as I thought. Sorry.

> +        	unsigned int eth_len =3D sizeof(struct ethhdr) +=20
> +						ntohs(eth->h_proto);

rename to subframe_len maybe?

> +		frame =3D dev_alloc_skb(3000);
> +
> +		if (frame =3D=3D NULL)=20
> +			return TXRX_DROP;
> +
> +		frame->mac.raw =3D frame->data;
> +		memcpy(skb_put(frame, eth_len), (u8*)eth, eth_len);

Nope, not nice to do this. You really need to check if eth_len doesn't
exceed the original skb's length or people can crash this by sending you
short frames with bogus huge eth len embedded in it. And if you move the
check up a bit then you can reuse "skb" for the last subframe in the
case where people don't send us garbage:

	int remaining =3D subframe_len - ((u8*)eth - skb->data);
	if (remaining < 0)
		/* idiots. should blacklist their mac address */
		return TXRX_DROP;
	if (remaining < 4 /* padding */) {
		frame =3D skb;
		skb =3D NULL;
		skb_pull(blabla)
	} else {
		frame =3D dev_alloc_skb(...)
		if (!frame)
			return TXRX_DROP;
	}

or something like that.

Don't you also need to set ((ethhdr*)frame->data)->h_proto to something
other than the length? Not exactly sure though, it seems eth_type_trans
can handle that and I don't have the 802.3 specs handy.

> +		frame->dev =3D dev;

I think it'd be good to move that closer to the netif_rx.

> +
> +		skb2 =3D NULL;
> +
> +		sdata->stats.rx_packets++;
> +		sdata->stats.rx_bytes +=3D frame->len;
> +
> +		if (local->bridge_packets &&=20
> +		    (sdata->type =3D=3D IEEE80211_IF_TYPE_AP ||
> +		     sdata->type =3D=3D IEEE80211_IF_TYPE_VLAN) &&=20
> +                    rx->u.rx.ra_match) {

> +			if (is_multicast_ether_addr(frame->data)) {

Use a new ethhdr* variable for that, like subframe_hdr, and then use
subframe_hdr->h_dest. Makes it much clearer what's going on with these
subframes.

> +				/* send multicast frames both to higher layers
> +				* in local net stack and back to the wireless=20
> +				* media */
> +				skb2 =3D skb_copy(frame, GFP_ATOMIC);
> +				if (!skb2)
> +					printk(KERN_DEBUG "%s: failed to clone "
> +					"multicast frame\n", dev->name);
> +			} else {
> +				struct sta_info *dsta;
> +				dsta =3D sta_info_get(local, frame->data);
> +				if (dsta && !dsta->dev) {
> +					printk(KERN_DEBUG "Station with null "
> +					"dev structure!\n");
> +                        	} else if (dsta && dsta->dev =3D=3D dev) {
> +                                	/* Destination station is associated=20
> +					* to this AP, so send the frame
> +					* directly to it and do not pass=20
> +					* the frame to local net stack.
> +					*/
> +					skb2 =3D skb;
> +					skb =3D NULL;

I'm pretty sure you mean frame here instead of skb in both cases and
this is a copy/paste error from the other data rx handler.

> +				}
> +				if (dsta)
> +					sta_info_put(dsta);
> +			}
> +		}
> +		if (frame) {
> +			/* deliver to local stack */
> +			frame->protocol =3D eth_type_trans(frame, dev);
> +			memset(frame->cb, 0, sizeof(frame->cb));

That memset is useless on a newly allocated frame.

> +			netif_rx(frame);
> +		}
> +
> +		if (skb2) {
> +			/* send to wireless media */
> +			skb2->protocol =3D __constant_htons(ETH_P_802_3);
> +			skb2->mac.raw =3D skb2->nh.raw =3D skb2->data;
> +			dev_queue_xmit(skb2);
> +		}
> +
> +		eth =3D (struct ethhdr*)((u8*)eth + eth_len=20
> +					+ calc_pad_len(eth_len));
> +	}
> +
> +	dev_kfree_skb(skb);
> +        return TXRX_QUEUED;
> +}
> +
>  static ieee80211_txrx_result
>  ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
>  {
> @@ -4373,6 +4510,7 @@ static ieee80211_rx_handler ieee80211_rx
>  	ieee80211_rx_h_remove_qos_control,
>  	ieee80211_rx_h_802_1x_pae,
>  	ieee80211_rx_h_drop_unencrypted,
> +	ieee80211_rx_h_data_agg,
>  	ieee80211_rx_h_data,
>  	ieee80211_rx_h_mgmt,
>  	NULL
> diff -Nupr wireless-dev/net/mac80211/wme.h
> wireless-dev-new/net/mac80211/wme.h
> --- wireless-dev/net/mac80211/wme.h	2007-03-22 11:40:17.000000000 -0700
> +++ wireless-dev-new/net/mac80211/wme.h	2007-03-27 01:48:34.000000000
> -0700
> @@ -24,6 +24,8 @@
> =20
>  #define QOS_CONTROL_TAG1D_MASK 0x07
> =20
> +#define QOS_CONTROL_A_MSDU_PRESENT 0x80

Hm. Can we put all these things into <linux/ieee80211.h> instead? I'm ok
with you putting it here for now, we'll just move them later. Or you can
add a patch to your series before this one that already moves the
defines and adds this one.

johannes

--=-4qCNBOLiLRifM+quW6B0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCsev/ETPhpq3jKURAsJIAJ4jY4r0gCptca/SFAkoAa4/Qk/a+gCdFauJ
scSaGEYGcAFcP9pWRCAPWuk=
=Kn0v
-----END PGP SIGNATURE-----

--=-4qCNBOLiLRifM+quW6B0--

