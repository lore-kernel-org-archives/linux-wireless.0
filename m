Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:57727 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbLaIMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 03:12:32 -0500
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Emmanuel Grumbach'" <egrumbach@gmail.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>,
	"'Johannes Berg'" <johannes@sipsolutions.net>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local> <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com> <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
In-Reply-To: <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
Subject: RE: Mac80211 : Wpa rekeying issue
Date: Thu, 31 Dec 2015 09:12:26 +0100
Message-ID: <0a6a01d143a2$fcb77720$f6266560$@acksys.fr> (sfid-20151231_091235_685236_2A85A16B)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0A6B_01D143AB.5E7C7B60"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0A6B_01D143AB.5E7C7B60
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

	Hi,=20

I'm not a WPA expert and security expert,=20

Could you explain why the patch sent by Alexander Wetzel break the =
security properties of this code?

The Alexander's patch is in attachment.

Thanks for your help.

> -----Message d'origine-----
> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] De la part de voncken
> Envoy=C3=A9 : mardi 29 d=C3=A9cembre 2015 16:24
> =C3=80 : 'Emmanuel Grumbach'
> Cc : 'linux-wireless'; 'Johannes Berg'
> Objet : RE: Mac80211 : Wpa rekeying issue
>=20
> 	> -----Message d'origine-----
> > De : Emmanuel Grumbach [mailto:egrumbach@gmail.com] Envoy=C3=A9 : =
mardi 29
> > d=C3=A9cembre 2015 15:20 =C3=80 : Cedric VONCKEN Cc : linux-wireless =
Objet : Re:
> > Mac80211 : Wpa rekeying issue
> >
> > On Tue, Dec 29, 2015 at 3:01 PM, Cedric VONCKEN
> > <cedric.voncken@acksys.fr>
> > wrote:
> > > Hi,
> > >
> > > My test plateform is:
> > > 2 equipements
> > > Both equipment used compat version 2015-07-21 from openwrt.
> > > Both equipment used security WPA2
> > >
> > > The equipment #1 is an AP.
> > >         The Group rekey interval is set to 3601s
> > >         The Pair rekey interval set to 50s (I reduced this value =
to
> > > show the issue often)
> > >         The Master rekey interval is set to 86400 s.
> > >
> > > The equipment #2 is a sta+wds
> > >
> > > I used a 5GHz channel to have a free channel (without other AP) I
> > > connected a computer on each equipment.
> > >
> > > To reproduce the issue:
> > >         I ran iperf udp@50Mbps from computer connected to the AP =
to
> > > the computer connected to the sta. After several WPA2 rekeying,
> > > iperf server side didn't received any frame.
> > >
> > > I investigated in the driver. All packets are dropped in sta side,
> > > because the function ieee80211_crypto_ccmp_decrypt return
> > > Rx_DROP_UNUSABLE. This function return this code because the test
> > > if(memcmp(pn,key->u.ccmp.rx_pn[queue],IEEE8021_CCMP_PN_LEN) <=3D0)
> > > return true.
> > >
> > > Have you any idea to fix this issue?
> > >
> >
> > I don't remember exactly what we had, but you may look at
> > =
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/137742
>=20
> Thanks for the link, I think I'm in the same situation.
>=20
> How can I fix this issue?
>=20
> Because the patch sent by Alexander Wetzel was rejected by Johannes =
(for
> security reason), and if I disable the hw crypto I will have =
performance
> issue.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-wireless"
> in the body of a message to majordomo@vger.kernel.org More majordomo =
info
> at  http://vger.kernel.org/majordomo-info.html

------=_NextPart_000_0A6B_01D143AB.5E7C7B60
Content-Type: application/octet-stream;
	name="fix1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="fix1.patch"

diff -ur linux-4.0.4-gentoo/net/mac80211/key.h =
linux-4.0.4-gentoo_patched/net/mac80211/key.h
--- linux-4.0.4-gentoo/net/mac80211/key.h	2015-04-13 00:12:50.000000000 =
+0200
+++ linux-4.0.4-gentoo_patched/net/mac80211/key.h	2015-05-20 =
13:16:06.370256697 +0200
@@ -84,12 +84,14 @@
 			 * Management frames.
 			 */
 			u8 rx_pn[IEEE80211_NUM_TIDS + 1][IEEE80211_CCMP_PN_LEN];
+			u8 rx_pn_old[IEEE80211_NUM_TIDS + 1][IEEE80211_CCMP_PN_LEN];
 			struct crypto_aead *tfm;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
 		} ccmp;
 		struct {
 			atomic64_t tx_pn;
 			u8 rx_pn[IEEE80211_CMAC_PN_LEN];
+			u8 rx_pn_old[IEEE80211_CMAC_PN_LEN];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
@@ -97,6 +99,7 @@
 		struct {
 			atomic64_t tx_pn;
 			u8 rx_pn[IEEE80211_GMAC_PN_LEN];
+			u8 rx_pn_old[IEEE80211_GMAC_PN_LEN];
 			struct crypto_aead *tfm;
 			u32 replays; /* dot11RSNAStatsCMACReplays */
 			u32 icverrors; /* dot11RSNAStatsCMACICVErrors */
@@ -109,12 +112,14 @@
 			 * Management frames.
 			 */
 			u8 rx_pn[IEEE80211_NUM_TIDS + 1][IEEE80211_GCMP_PN_LEN];
+			u8 rx_pn_old[IEEE80211_NUM_TIDS + 1][IEEE80211_GCMP_PN_LEN];
 			struct crypto_aead *tfm;
 			u32 replays; /* dot11RSNAStatsGCMPReplays */
 		} gcmp;
 		struct {
 			/* generic cipher scheme */
 			u8 rx_pn[IEEE80211_NUM_TIDS + 1][MAX_PN_LEN];
+			u8 rx_pn_old[IEEE80211_NUM_TIDS + 1][MAX_PN_LEN];
 		} gen;
 	} u;
=20
diff -ur linux-4.0.4-gentoo/net/mac80211/wpa.c =
linux-4.0.4-gentoo_patched/net/mac80211/wpa.c
--- linux-4.0.4-gentoo/net/mac80211/wpa.c	2015-04-13 00:12:50.000000000 =
+0200
+++ linux-4.0.4-gentoo_patched/net/mac80211/wpa.c	2015-05-20 =
21:43:25.529721066 +0200
@@ -495,6 +495,7 @@
 	struct sk_buff *skb =3D rx->skb;
 	struct ieee80211_rx_status *status =3D IEEE80211_SKB_RXCB(skb);
 	u8 pn[IEEE80211_CCMP_PN_LEN];
+	static u8 zero[IEEE80211_CCMP_PN_LEN];
 	int data_len;
 	int queue;
=20
@@ -525,6 +526,31 @@
 		return RX_DROP_UNUSABLE;
 	}
=20
+	/* HACK: try to work around race when replacing PSK with enabled =
hardware offload on AP or STA */
+	if (unlikely(memcmp(key->u.ccmp.rx_pn[queue], zero, =
IEEE80211_CCMP_PN_LEN) =3D=3D 0 )) {
+
+		printk ("DDD - rx_pn is zero, virgin key detected! pl=3D%x\n", =
pn[IEEE80211_CCMP_PN_LEN-1]);
+		print_hex_dump_debug("cnt: ", DUMP_PREFIX_OFFSET, =
IEEE80211_CCMP_PN_LEN, 1, key->u.ccmp.rx_pn[queue], =
IEEE80211_CCMP_PN_LEN, false);
+		print_hex_dump_debug("pn : ", DUMP_PREFIX_OFFSET, =
IEEE80211_CCMP_PN_LEN, 1, pn, IEEE80211_CCMP_PN_LEN, false);
+
+		if ((memcmp(pn, zero, IEEE80211_CCMP_PN_LEN -1) =3D=3D 0) && =
pn[IEEE80211_CCMP_PN_LEN-1] <=3D 10) {
+			/* pn is <=3D10 , we can start using the new counter */
+			printk ("DDD - set new pn\n");
+			memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+		} else if (memcmp(pn, key->u.ccmp.rx_pn_old[queue], =
IEEE80211_CCMP_PN_LEN) <=3D 0) {
+			printk ("DDD - attack!\n");
+			/* reply attack during rekey operation, guess it will really hard to =
do that... */
+			key->u.ccmp.replays++; /* we count it as an reply anyway...*/
+			return RX_DROP_UNUSABLE;=20
+		} else {=09
+			printk ("DDD - prevent poisening \n");
+			memcpy(key->u.ccmp.rx_pn_old[queue], pn, IEEE80211_CCMP_PN_LEN);
+		}
+	} else {
+		=09
+		memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+	}
+
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		u8 aad[2 * AES_BLOCK_SIZE];
 		u8 b_0[AES_BLOCK_SIZE];
@@ -539,8 +565,6 @@
 			return RX_DROP_UNUSABLE;
 	}
=20
-	memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
-
 	/* Remove CCMP header and MIC */
 	if (pskb_trim(skb, skb->len - mic_len))
 		return RX_DROP_UNUSABLE;

------=_NextPart_000_0A6B_01D143AB.5E7C7B60--

