Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:31714 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbbERTwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 15:52:21 -0400
Message-ID: <555A41EA.4090905@web.de> (sfid-20150518_215226_895565_38707560)
Date: Mon, 18 May 2015 21:47:54 +0200
From: Alexander Wetzel <alexander.wetzel@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"Peer, Ilan" <ilan.peer@intel.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 drops packet with old IV after rekeying
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>	 <1431674716.2426.2.camel@sipsolutions.net>	 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>	 <1431714949.2117.0.camel@sipsolutions.net>	 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>	 <1431806229.2120.6.camel@sipsolutions.net> <20150517160513.GA13175@w1.fi>	 <CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>	 <1431890756.2129.13.camel@sipsolutions.net>	 <CANUX_P3ODruGc2rvV2gLNLU15kEmaJMXeU_ovtaBeOQGnYotoA@mail.gmail.com>	 <1431893157.2129.18.camel@sipsolutions.net>	 <CANUX_P0cJc4Ww5AY7sNFL5z4EPit+ngHvX=4eFXF96K-E8p3MA@mail.gmail.com>	 (sfid-20150517_221304_420222_D8022C07) <1431894140.2129.20.camel@sipsolutions.net>	 <CB3B3D4774441E42AA3EA0E1BA8230A04DA98D91@HASMSX110.ger.corp.intel.com> <1431961331.10489.1.camel@sipsolutions.net>
In-Reply-To: <1431961331.10489.1.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------060803090403070506010301"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060803090403070506010301
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hello,

I'm the one banging my head against this issue for quite some time, so
if I can do anything to help here contact me. I'll check the mailing
list from time to time but if you have something I should reply please
add/keep me on CC.

I can now reproduce the issue reliable within minutes on demand and can
also patch the kernels at both ends. (Just started looking at openwrt
and got my first openwrt kernel patch crashing the wlan driver:-)

But now to the topic:

> Right. I think the "new key with old PN" part is probably not really
> happening, although it seems possible. I'd think we should look at the
> receiver first and only then move on to the transmitter if issues
> persist. Having a sniffer capture of the problem with known keys (!)
> would be useful though.

For my understanding that has already be done. And at least for me it
looks like we have hard evidence for that fact.

In the linux bug report you can find an capture extract to verify that -
taken with a remote monitor station - and the PSK's needed to decrypt
the traffic:
https://bugzilla.kernel.org/show_bug.cgi?id=92451
You are probably interested in comment 14.

Maybe a short warning here:
The wireshark patch needed to make sense of these captures was written
by me and on my still sketchy understanding how this all works. But I
see no way how it could mix up keys and all it all only a minor
modification was needed. (It's taking a short cut to decide if it will
add the PSK to the packet by only looking at the key index and not at
the appropriate flags, but hardly relevant here.)

The Key information used to decrypt the packets is added in the same
section as the key index, if you have problems finding it.

This is an older capture and I'll verify that with a new one soon.
I have quite many retransmissions in it and the monitoring station also
missed quite some frames for some incomprehensible reason.

If you wanted the full capture and not the sipped down one from the
kernel bugzilla you can download it here:
https://cal.a.wdyn.eu:65443/index.php/s/UdMpcULG16Lz1Ah

I'll hope I can provide a better one at the weekend.

I have also still some output of my poking around with printk's in the
kernel and attached you an sample from them, see debug-out.txt.gz.
I have not preserved the exact kernel patch for those printk messages,
but attached a version close of it.
(The additional MIC check was a failed experiment of many to get it
working without removing the replay detection mechanism.)

The XXX debug lines are not in the patch, these are just some printk's
at the start of the function with the name printed out to see when the
key was installed.


--------------060803090403070506010301
Content-Type: text/x-patch;
 name="wpa-debug.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="wpa-debug.patch"

--- ../wpa.c	2015-04-13 00:12:50.000000000 +0200
+++ net/mac80211/wpa.c	2015-05-14 21:01:44.030860184 +0200
@@ -1,5 +1,4 @@
 /*
- * Copyright 2002-2004, Instant802 Networks, Inc.
  * Copyright 2008, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -502,29 +501,48 @@
=20
 	if (!ieee80211_is_data(hdr->frame_control) &&
 	    !ieee80211_is_robust_mgmt_frame(skb))
+	        {printk(KERN_DEBUG "DDD - 1");
 		return RX_CONTINUE;
+		}
=20
 	data_len =3D skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
+		{printk(KERN_DEBUG "DDD - 2");
 		return RX_DROP_UNUSABLE;
+		}
=20
 	if (status->flag & RX_FLAG_DECRYPTED) {
 		if (!pskb_may_pull(rx->skb, hdrlen + IEEE80211_CCMP_HDR_LEN))
+			{printk(KERN_DEBUG "DDD - 3");
 			return RX_DROP_UNUSABLE;
+			}
 	} else {
 		if (skb_linearize(rx->skb))
+			{printk(KERN_DEBUG "DDD - 4");
 			return RX_DROP_UNUSABLE;
+			}
 	}
=20
 	ccmp_hdr2pn(pn, skb->data + hdrlen);
=20
 	queue =3D rx->security_idx;
+/*
+	temp =3D ieee80211_rx_h_michael_mic_verify(rx);
+	printk(KERN_DEBUG "DDD - 5 queue:%i Mutex=3D%i MIC=3D%i",queue, rx->loc=
al->key_mtx.count, temp);
+
+	if(temp =3D=3D RX_DROP_UNUSABLE) {
+		printk(KERN_DEBUG "DDD - MIC verify failed");
+		return RX_DROP_UNUSABLE;
+	}
=20
+	print_hex_dump_debug("cnt: ", DUMP_PREFIX_OFFSET, IEEE80211_CCMP_PN_LEN=
, 1, key->u.ccmp.rx_pn[queue], IEEE80211_CCMP_PN_LEN, false);
+	print_hex_dump_debug("pn : ", DUMP_PREFIX_OFFSET, IEEE80211_CCMP_PN_LEN=
, 1, pn, IEEE80211_CCMP_PN_LEN, false);
 	if (memcmp(pn, key->u.ccmp.rx_pn[queue], IEEE80211_CCMP_PN_LEN) <=3D 0)=
 {
 		key->u.ccmp.replays++;
+		//print_hex_dump_debug("skb->data: ", DUMP_PREFIX_OFFSET, 16, 1, skb->=
data, skb->len, true);
 		return RX_DROP_UNUSABLE;
 	}
-
+*/
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		u8 aad[2 * AES_BLOCK_SIZE];
 		u8 b_0[AES_BLOCK_SIZE];
@@ -536,17 +554,21 @@
 			    skb->data + hdrlen + IEEE80211_CCMP_HDR_LEN,
 			    data_len,
 			    skb->data + skb->len - mic_len, mic_len))
+			{printk(KERN_DEBUG "DDD - 6");
 			return RX_DROP_UNUSABLE;
+			}
 	}
=20
 	memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
=20
 	/* Remove CCMP header and MIC */
 	if (pskb_trim(skb, skb->len - mic_len))
+		{printk(KERN_DEBUG "DDD - 7");
 		return RX_DROP_UNUSABLE;
+		}
 	memmove(skb->data + IEEE80211_CCMP_HDR_LEN, skb->data, hdrlen);
 	skb_pull(skb, IEEE80211_CCMP_HDR_LEN);
-
+	printk(KERN_DEBUG "DDD - 8");
 	return RX_CONTINUE;
 }
=20

--------------060803090403070506010301
Content-Type: application/gzip;
 name="debug-out.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="debug-out.txt.gz"

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
CZQ//BdM0DoFyXYAAA==
--------------060803090403070506010301--
