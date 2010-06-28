Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44823 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0F1Wbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jun 2010 18:31:45 -0400
Received: by iwn7 with SMTP id 7so470370iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jun 2010 15:31:43 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Jun 2010 00:31:39 +0200
Message-ID: <AANLkTilG4qxjX0e5u_BGp0YcPoVBbsqd6Hlb8E0j_S8S@mail.gmail.com>
Subject: ath9k: ap tsf seems random and only uses lower 24 bits or so
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm getting weird values from the debugfs file ieee80211/phy0/tsf: the
value goes up and down rather randomly and only the lower 24 bits or
so seem to ever be used (see below for details).

The only thing running on phy0 is a single ap interface (and the
monitor companion that hostapd sets up). I was expecting tsf to
increase monotonically until all 64 bits had been used.

root@OpenWrt:/debug/ieee80211/phy0# dmesg | grep phy0
phy0: Selected rate control algorithm 'minstrel_ht'
phy0: Atheros AR9100 MAC/BB Rev:0 AR2133 RF Rev:a2 mem=0xb80c0000, irq=2
root@OpenWrt:/debug/ieee80211/phy0# while sleep 1; do cat tsf; done
0x0000000000059d9b
0x0000000000038fa2
0x00000000000ee67e
0x000000000008121e
0x000000000017752d
0x000000000006438b
0x000000000015a771
0x00000000000d5ea0
0x0000000000085b43
0x0000000000037806
0x000000000001f562
0x0000000000115b03
0x000000000020be55
^C

If you poll tsf really fast it looks a bit like it's running correctly
but being reset very often:

root@OpenWrt:/debug/ieee80211/phy0# while true; do cat tsf; done
...
0x00000000004b2319
0x00000000004b33f2
0x00000000004b46dc
0x00000000004b578c
0x00000000004b6a89
0x0000000000014435
0x00000000000154a0
0x00000000000167ce
0x000000000001785d
...
^C

For a moment I thought it might be the kernel snprintf (on mips)
playing a trick on me so I tried the following patch. But the result
is the same.

diff -urN a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -63,7 +63,8 @@

 	tsf = drv_get_tsf(local);

-	snprintf(buf, sizeof(buf), "0x%016llx\n", (unsigned long long) tsf);
+	snprintf(buf, sizeof(buf), "0x%08lx%08lx\n",
+		 (unsigned long)(tsf >> 32), (unsigned long)tsf);

 	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
 }


What could be causing this? Because it's not supposed to do this,
right? Any insight much appreciated!

/Björn
