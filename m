Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:62836 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbbETUxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 16:53:47 -0400
Message-ID: <555CF4C2.7040002@web.de> (sfid-20150520_225351_961647_B7698CFD)
Date: Wed, 20 May 2015 22:55:30 +0200
From: Alexander Wetzel <alexander.wetzel@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Peer, Ilan" <ilan.peer@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 drops packet with old IV after rekeying - workaround
 patch for CCMP
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>		 <1431674716.2426.2.camel@sipsolutions.net>		 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>		 <1431714949.2117.0.camel@sipsolutions.net>		 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>		 <1431806229.2120.6.camel@sipsolutions.net> <20150517160513.GA13175@w1.fi>		 <CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>		 <1431890756.2129.13.camel@sipsolutions.net>		 <CANUX_P3ODruGc2rvV2gLNLU15kEmaJMXeU_ovtaBeOQGnYotoA@mail.gmail.com>		 <1431893157.2129.18.camel@sipsolutions.net>		 <CANUX_P0cJc4Ww5AY7sNFL5z4EPit+ngHvX=4eFXF96K-E8p3MA@mail.gmail.com>		 (sfid-20150517_221304_420222_D8022C07) <1431894140.2129.20.camel@sipsolutions.net>		 <CB3B3D4774441E42AA3EA0E1BA8230A04DA98D91@HASMSX110.ger.corp.intel.com>	 <1431961331.10489.1.camel@sipsolutions.net> <555A41EA.4090905@web.de> <1431986157.10489.12.camel@sipsolutions.net>
In-Reply-To: <1431986157.10489.12.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------000202080506030802060807"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000202080506030802060807
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


I've verified that turning off hardware encryption on the AP and the STA
is indeed preventing the issue.
As soon as one of them is using the hardware encryption I can trigger
the problem. (In my setup it seems to be mostly caused by the AP, since
I needed sometimes as much as three rekeys to get the freeze when the AP
was using Software and the STA hardware encryption.)

So confident that we finally found the root of the evil I tried to write
some code catching the races, see the attachment.

It's probably not the best fix, but the only one I could think of and
deploy myself with the knowledge I gathered here and the last days.

It's only for CCMP for now and I've not checked on assumptions what some
parts of the code are for.
This is just "works for me". (It survived now 30 rekeys under my test
load, when previously nearly every rekey did freeze it.)

I think there is no need any longer to generate captures, but if you
want them anyway I can of course still work on that.


The decision to check if the pn is <= 10 as indicator to switch over to
the "correct" pn counter is at best questionable. (Using 1 does not
work. I have problems with the inital key here and the code was not
switching over to the correct rx_pn counter and I expect that we also
may lose some frames here.) I'm not even sure that it's safe to assume
that pn is always starting at one, since wpa_supplicant is dumping some
sequence number on rekey I would have assumed to be a more or less
random start value. But in the debug prints the real value is always
starting at one. So I'm using that for now.

I'll now try that in my environment, keeping the insane low rekey
interval at two minutes for at least some weeks.

What was really surprising me here is, that this is such a generic issue
and I'm finding that in my home environment. For my understanding that
should break many (all?) EAP Wlan's. (I'm using EAP-TLS and that did
make the WLAN basically unusable and any sane person would have switched
back to PSK...)

For completeness, here is the original openwrt bug report I opened:
https://dev.openwrt.org/ticket/18966


Alexander

--------------000202080506030802060807
Content-Type: text/x-patch;
 name="fix1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="fix1.patch"

diff -ur linux-4.0.4-gentoo/net/mac80211/key.h linux-4.0.4-gentoo_patched=
/net/mac80211/key.h
--- linux-4.0.4-gentoo/net/mac80211/key.h	2015-04-13 00:12:50.000000000 +=
0200
+++ linux-4.0.4-gentoo_patched/net/mac80211/key.h	2015-05-20 13:16:06.370=
256697 +0200
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
diff -ur linux-4.0.4-gentoo/net/mac80211/wpa.c linux-4.0.4-gentoo_patched=
/net/mac80211/wpa.c
--- linux-4.0.4-gentoo/net/mac80211/wpa.c	2015-04-13 00:12:50.000000000 +=
0200
+++ linux-4.0.4-gentoo_patched/net/mac80211/wpa.c	2015-05-20 21:43:25.529=
721066 +0200
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
+	/* HACK: try to work around race when replacing PSK with enabled hardwa=
re offload on AP or STA */
+	if (unlikely(memcmp(key->u.ccmp.rx_pn[queue], zero, IEEE80211_CCMP_PN_L=
EN) =3D=3D 0 )) {
+
+		printk ("DDD - rx_pn is zero, virgin key detected! pl=3D%x\n", pn[IEEE=
80211_CCMP_PN_LEN-1]);
+		print_hex_dump_debug("cnt: ", DUMP_PREFIX_OFFSET, IEEE80211_CCMP_PN_LE=
N, 1, key->u.ccmp.rx_pn[queue], IEEE80211_CCMP_PN_LEN, false);
+		print_hex_dump_debug("pn : ", DUMP_PREFIX_OFFSET, IEEE80211_CCMP_PN_LE=
N, 1, pn, IEEE80211_CCMP_PN_LEN, false);
+
+		if ((memcmp(pn, zero, IEEE80211_CCMP_PN_LEN -1) =3D=3D 0) && pn[IEEE80=
211_CCMP_PN_LEN-1] <=3D 10) {
+			/* pn is <=3D10 , we can start using the new counter */
+			printk ("DDD - set new pn\n");
+			memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+		} else if (memcmp(pn, key->u.ccmp.rx_pn_old[queue], IEEE80211_CCMP_PN_=
LEN) <=3D 0) {
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

--------------000202080506030802060807--
