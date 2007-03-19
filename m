Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:42100 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966034AbXCSRQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 13:16:29 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH 1/3] mac80211: Add radiotap support
Date: Mon, 19 Mar 2007 13:15:26 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070319110124.819185242@warmcat.com> <20070319110256.288303943@warmcat.com>
In-Reply-To: <20070319110256.288303943@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2946526.4qkEjm3QeM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703191315.33695.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2946526.4qkEjm3QeM
Content-Type: multipart/mixed;
  boundary="Boundary-01=_uUs/FzUqWXddRPs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_uUs/FzUqWXddRPs
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 19 March 2007 07:01, andy@warmcat.com wrote:
> +	struct ieee80211_rtap_hdr {
> +		struct ieee80211_radiotap_header hdr;
> +		u8 flags;
> +		u8 pad0;
> +		u8 rate;
> +		u8 pad1;
> +		__le16 chan_freq;
> +		__le16 chan_flags;
> +		u8 antsignal;
> +	} __attribute__ ((packed)) *rthdr;
>
Looks like I screwed up the padding there. New patch without the padding=20
attached. Probably explains why rate isn't being reported correctly..

=2DMichael Wu

--Boundary-01=_uUs/FzUqWXddRPs
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="radio.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="radio.diff"

mac80211: Add radiotap support

=46rom: Michael Wu <flamingice@sourmilk.net>


=2D--

 include/net/mac80211.h         |    3 ++
 net/mac80211/ieee80211.c       |   67 +++++++++++++++++++++++++++++++++---=
=2D---
 net/mac80211/ieee80211_iface.c |    2 +
 3 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 916b21b..27cffdc 100644
=2D-- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -518,6 +518,9 @@ struct ieee80211_hw {
 	 * normal operation. */
 #define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
=20
+	/* Driver supports radiotap. */
+#define IEEE80211_HW_RADIOTAP_SUPPORTED (1<<10)
+
 	/* please fill this gap when adding new flags */
=20
 	/* calculate Michael MIC for an MSDU when doing hwcrypto */
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 0b7cb35..6bffc29 100644
=2D-- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -8,6 +8,7 @@
  */
=20
 #include <net/mac80211.h>
+#include <net/ieee80211_radiotap.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
@@ -286,6 +287,14 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff=
 *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
=20
+static int ieee80211_get_radiotap_len(struct sk_buff *skb)
+{
+	struct ieee80211_radiotap_header *hdr =3D
+		(struct ieee80211_radiotap_header *) skb->data;
+
+	return le16_to_cpu(hdr->it_len);
+}
+
 #ifdef CONFIG_MAC80211_LOWTX_FRAME_DUMP
 static void ieee80211_dump_frame(const char *ifname, const char *title,
 				 const struct sk_buff *skb)
@@ -2741,26 +2750,48 @@ ieee80211_rx_monitor(struct net_device *dev, struct=
 sk_buff *skb,
 		     struct ieee80211_rx_status *status)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
=2D	struct ieee80211_frame_info *fi;
 	struct ieee80211_sub_if_data *sdata;
=2D	const size_t hlen =3D sizeof(struct ieee80211_frame_info)
=2D				- sizeof(fi->msg_type);
+	struct ieee80211_rtap_hdr {
+		struct ieee80211_radiotap_header hdr;
+		u8 flags;
+		u8 rate;
+		__le16 chan_freq;
+		__le16 chan_flags;
+		u8 antsignal;
+	} __attribute__ ((packed)) *rthdr;
=20
 	skb->dev =3D dev;
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
=20
=2D	if (skb_headroom(skb) < hlen) {
=2D		I802_DEBUG_INC(local->rx_expand_skb_head);
=2D		if (pskb_expand_head(skb, hlen, 0, GFP_ATOMIC)) {
=2D			dev_kfree_skb(skb);
=2D			return;
+	if (!(local->hw.flags & IEEE80211_HW_RADIOTAP_SUPPORTED)) {
+		if (skb_headroom(skb) < sizeof(*rthdr)) {
+			I802_DEBUG_INC(local->rx_expand_skb_head);
+			if (pskb_expand_head(skb, sizeof(*rthdr), 0, GFP_ATOMIC)) {
+				dev_kfree_skb(skb);
+				return;
+			}
 		}
=2D	}
=20
=2D	fi =3D (struct ieee80211_frame_info *) skb_push(skb, hlen);
+		rthdr =3D (struct ieee80211_rtap_hdr *) skb_push(skb, sizeof(*rthdr));
+		memset(rthdr, 0, sizeof(*rthdr));
+		rthdr->hdr.it_len =3D cpu_to_le16(sizeof(*rthdr));
+		rthdr->hdr.it_present =3D
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) ||
+				    (1 << IEEE80211_RADIOTAP_RATE) ||
+				    (1 << IEEE80211_RADIOTAP_CHANNEL) ||
+				    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL));
+		rthdr->flags =3D local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS ?
+			       IEEE80211_RADIOTAP_F_FCS : 0;
+		rthdr->rate =3D status->rate / 5;
+		rthdr->chan_freq =3D cpu_to_le16(status->freq);
+		rthdr->chan_flags =3D
+			status->phymode =3D=3D MODE_IEEE80211A ?
+			cpu_to_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ) :
+			cpu_to_le16(IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ);
+		rthdr->antsignal =3D status->ssi;
+	}
=20
=2D	ieee80211_fill_frame_info(local, fi, status);
 	sdata->stats.rx_packets++;
 	sdata->stats.rx_bytes +=3D skb->len;
=20
@@ -3164,6 +3195,10 @@ ieee80211_rx_h_monitor(struct ieee80211_txrx_data *r=
x)
 		return TXRX_QUEUED;
 	}
=20
+	if (rx->local->monitors &&
+	    rx->local->hw.flags & IEEE80211_HW_RADIOTAP_SUPPORTED)
+		skb_pull(rx->skb, ieee80211_get_radiotap_len(rx->skb));
+
 	return TXRX_CONTINUE;
 }
=20
@@ -3731,6 +3766,13 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct =
sk_buff *skb,
 	struct ieee80211_txrx_data rx;
 	u16 type;
 	int multicast;
+	int radiotap_len =3D 0;
+
+	if (local->monitors &&
+	    local->hw.flags & IEEE80211_HW_RADIOTAP_SUPPORTED) {
+		radiotap_len =3D ieee80211_get_radiotap_len(skb);
+		skb_pull(skb, radiotap_len);
+	}
=20
 	hdr =3D (struct ieee80211_hdr *) skb->data;
 	memset(&rx, 0, sizeof(rx));
@@ -3767,6 +3809,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct s=
k_buff *skb,
 		goto end;
 	skb =3D rx.skb;
=20
+	skb_push(skb, radiotap_len);
 	if (sta && !sta->assoc_ap && !(sta->flags & WLAN_STA_WDS) &&
 	    !local->iff_promiscs && !multicast) {
 		rx.u.rx.ra_match =3D 1;
@@ -3775,7 +3818,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct s=
k_buff *skb,
 	} else {
 		struct ieee80211_sub_if_data *prev =3D NULL;
 		struct sk_buff *skb_new;
=2D		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len);
+		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len - radiotap_len);
=20
 		list_for_each_entry(sdata, &local->sub_if_list, list) {
 			rx.u.rx.ra_match =3D 1;
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index 3e0b4fa..51197b1 100644
=2D-- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -199,7 +199,7 @@ void ieee80211_if_set_type(struct net_device *dev, int =
type)
 		break;
 	}
 	case IEEE80211_IF_TYPE_MNTR:
=2D		dev->type =3D ARPHRD_IEEE80211_PRISM;
+		dev->type =3D ARPHRD_IEEE80211_RADIOTAP;
 		break;
 	default:
 		printk(KERN_WARNING "%s: %s: Unknown interface type 0x%x",

--Boundary-01=_uUs/FzUqWXddRPs--

--nextPart2946526.4qkEjm3QeM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF/sU1T3Oqt9AH4aERAvEKAKC7K/DuU79lfV7NmYUYIHft/mZzbQCfUggg
jeAkF2QvbFzE2/P8FsJc+Ww=
=R99k
-----END PGP SIGNATURE-----

--nextPart2946526.4qkEjm3QeM--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
