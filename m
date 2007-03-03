Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992787AbXCCAWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 19:22:07 -0500
Subject: zd1211rw-mac80211 error codes and monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>, Daniel Drake <dsd@gentoo.org>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 01:21:31 +0100
Message-Id: <1172881291.8247.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried to figure out why I was getting this:

# iwconfig wlan1 mode monitor
# ip link set wlan1 up
SIOCSIFFLAGS: Operation not permitted

Well, -EPERM == -1!

Here's an example junk packet I captured:
0000  80 21 10 01 00 00 00 40 00 00 00 00 00 00 00 00   .!.....@........
0010  00 00 00 03 e1 ec bb 90 00 00 00 07 00 00 00 07   ................
0020  00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 03   ................
0030  00 00 00 18 00 00 00 00 00 00 00 00 00 00 00 00   ................
0040  00 00 0e 00 0e 00 00 00 04 02 8a 09 a0 00 40 6c   ..............@l
0050  00 00 ff ff 9f c9 ff ff 00 15 f2 3d af 91 30 0e   ...........=..0.
0060  f2 3d 63 97 90 00 67 cb 1d fb e2 dc 00 66 67 00   .=c...g......fg.
0070  11 cc 06 04 62 65 72 67 01 08 82 84 8b 96 24 30   ....berg......$0
0080  78 77 03 01 01 05 84 f2 cd 6d 00 2a 01 04 b7 0c   xw.......m.*....
0090  04 32 04 0c 12 18 60 dd 06 00 10 18 02 02 00 33   .2....`........3
00a0  ae 4f 4b                                          .OK

That's supposed to include a radiotap header etc. The same packet (well
beacon from the same AP) captured with bcm43xx looks like this:

0000  80 21 10 01 00 00 00 40 00 00 00 00 00 00 53 73   .!.....@......Ss
0010  00 00 00 03 f8 7b 92 f0 00 00 00 07 00 00 00 03   .....{..........
0020  00 00 00 0a 00 00 00 00 ff ff ff ff 00 00 00 03   ................
0030  00 00 00 3b 00 00 00 00 00 00 00 00 00 00 00 00   ...;............
0040  80 00 00 00 ff ff ff ff ff ff 00 15 f2 3d 63 97   .............=c.
0050  00 15 f2 3d 63 97 20 56 f8 c1 ac 11 63 05 00 00   ...=c. V....c...
0060  64 00 11 00 00 04 62 65 72 67 01 08 82 84 8b 96   d.....berg......
0070  24 30 48 6c 03 01 01 05 04 00 01 00 00 2a 01 04   $0Hl.........*..
0080  2f 01 04 32 04 0c 12 18 60 dd 06 00 10 18 02 02   /..2....`.......
0090  00                                                .

(the radiotap header goes up to 0x3f, packet starts at 0x40)

--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c	2007-03-03 01:05:05.840721703 +0100
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c	2007-03-03 01:09:50.930721703 +0100
@@ -513,14 +513,17 @@ static int zd_mac_add_interface(struct i
 
 	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
 	if (mac->mode != IEEE80211_IF_TYPE_MGMT)
-		return -1;
+		return -EOPNOTSUPP;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
+	/* if I enable this captured packets are junk, needs work
+	case IEEE80211_IF_TYPE_MNTR:
+	*/
 		mac->mode = conf->type;
 		break;
 	default:
-		return -1;
+		return -EOPNOTSUPP;
 	}
 
 	mac->hwaddr = conf->mac_addr;


