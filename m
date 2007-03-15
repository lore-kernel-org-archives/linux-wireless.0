Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:49516 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422821AbXCOF5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2007 01:57:35 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: [RFC][PATCH] Add radiotap-based packet injection capability to monitor mode
Date: Thu, 15 Mar 2007 01:56:58 -0400
Cc: linux-wireless@vger.kernel.org
References: <45F89DA5.8000206@warmcat.com>
In-Reply-To: <45F89DA5.8000206@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15890925.uRDydTBH0d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703150157.02876.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart15890925.uRDydTBH0d
Content-Type: multipart/mixed;
  boundary="Boundary-01=_rAO+FmwFVAkSwcu"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_rAO+FmwFVAkSwcu
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 14 March 2007 21:13, Andy Green wrote:
> This patch adds the monitor mode packet injection stuff that was talked
> about a week or so ago to mac80211.  Using a radiotap header prepended
> to the injection payload was felt to be a reasonable way forward.
>
It seems rather odd to inject with radiotap headers when capturing with AVS=
=20
headers. I've attached a patch which switches mac80211 to using radiotap.=20
It's pretty much the same patch I posted a while ago, except all support fo=
r=20
AVS on monitor interfaces was removed. Drivers need to implement radiotap f=
or=20
best results, but if it isn't implemented, the stack fills in a minimal=20
radiotap header. The minimal radiotap header filling code is new in this=20
version of the patch and I haven't had a chance to test it yet. The rate=20
filling part might be wrong. Anyway, I recommend basing your patch on top o=
f=20
this one. Aside from the new default radiotap filling code, the rest is=20
fairly solid AFAIK. I had a corresponding patch to hook up radiotap support=
=20
in zd1211rw-mac80211 but it seems like I've lost it. I'll put together a ne=
w=20
one tomorrow.

Thanks,
=2DMichael Wu

--Boundary-01=_rAO+FmwFVAkSwcu
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="radio.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="radio.diff"

mac80211: Add radiotap support

=46rom: Michael Wu <flamingice@sourmilk.net>


=2D--

 include/net/mac80211.h         |    3 ++
 net/mac80211/ieee80211.c       |   69 +++++++++++++++++++++++++++++++++---=
=2D---
 net/mac80211/ieee80211_iface.c |    2 +
 3 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 916b21b..050f126 100644
=2D-- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -529,6 +529,9 @@ struct ieee80211_hw {
 	 * per-packet RC4 key with each TX frame when doing hwcrypto */
 #define IEEE80211_HW_TKIP_REQ_PHASE2_KEY (1<<14)
=20
+	/* Driver supports radiotap. Temporary until all drivers support it. */
+#define IEEE80211_HW_RADIOTAP_SUPPORTED (1<<20)
+
 	u32 flags;			/* hardware flags defined above */
=20
 	/* Set to the size of a needed device specific skb headroom for TX skbs. =
*/
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 0b7cb35..c3a9f0e 100644
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
@@ -2741,26 +2750,50 @@ ieee80211_rx_monitor(struct net_device *dev, struct=
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
+		u8 pad0;
+		u8 rate;
+		u8 pad1;
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
@@ -3164,6 +3197,10 @@ ieee80211_rx_h_monitor(struct ieee80211_txrx_data *r=
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
@@ -3731,6 +3768,13 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct =
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
@@ -3767,6 +3811,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct s=
k_buff *skb,
 		goto end;
 	skb =3D rx.skb;
=20
+	skb_push(skb, radiotap_len);
 	if (sta && !sta->assoc_ap && !(sta->flags & WLAN_STA_WDS) &&
 	    !local->iff_promiscs && !multicast) {
 		rx.u.rx.ra_match =3D 1;
@@ -3775,7 +3820,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct s=
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

--Boundary-01=_rAO+FmwFVAkSwcu--

--nextPart15890925.uRDydTBH0d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF+OAuT3Oqt9AH4aERAoCcAJ0TJVTPYYQ94pmF2mxrmlt/R4K1wwCfcuIK
glAxhGQnJeKSiEP8kHEnGJY=
=HUZN
-----END PGP SIGNATURE-----

--nextPart15890925.uRDydTBH0d--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
