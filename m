Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:49705 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbXCTKlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2007 06:41:07 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 17F148D125
	for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2007 11:41:06 +0100 (CET)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 779CE10090
	for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2007 10:41:08 +0000 (UTC)
Message-Id: <20070320104104.575903961@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
Date: Tue, 20 Mar 2007 10:39:58 +0000
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mac80211: Monitor mode radiotap injection docs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy@warmcat.com>


diff --git a/Documentation/networking/mac80211-injection.txt b/Documentation/networking/mac80211-injection.txt
new file mode 100644
index 0000000..bee8931
--- /dev/null
+++ b/Documentation/networking/mac80211-injection.txt
@@ -0,0 +1,77 @@
+How to use packet injection with mac80211
+=========================================
+
+mac80211 now allows arbitrary packets to be injected down any Monitor Mode
+interface from userland.  The packet you inject needs to be composed in the
+following format:
+
+ [ radiotap header  ]
+ [ ieee80211 header ]
+ [ payload ]
+
+Radiotap headers are variable-length and extensible, you can get most of the
+information you need to know on them from:
+
+./include/net/ieee80211_radiotap.h
+
+But note: all fields in the radiotap header are *little endian*.
+
+There is a fixed portion at the start which contains a u32 bitmap that defines
+if the possible argument is present or not.  At the moment there are only 13
+possible arguments defined, but in case we run out of space in the u32 it is
+defined that b31 set indicates that there is another u32 bitmap following, and
+the start of the arguments is moved forward 4 bytes each time.
+
+After the fixed part of the header, the arguments follow.
+
+ - the arguments are all little-endian!
+
+ - the arguments must be aligned to a boundary of the argument size using
+   padding.  So a u16 argument must start on the next u16 boundary if it isn't
+   already on one, a u32 must start on the next u32 boundary and so on.
+
+Despite 13 radiotap argument types are currently defined, most only make sense
+to appear on received packets.  Currently three kinds of argument are used by
+the injection code, although it knows to skip any other arguments that are
+present (facilitating replay of captured radiotap headers directly):
+
+ - IEEE80211_RADIOTAP_RATE - u8 arg in 500kbps units (0x02 --> 1Mbps)
+
+ - IEEE80211_RADIOTAP_ANTENNA - u8 arg, 0x00 = ant1, 0x01 = ant2
+
+ - IEEE80211_RADIOTAP_DBM_TX_POWER - u8 arg, dBm
+
+Here is an example valid radiotap header defining these three parameters
+
+	0x00, 0x00, // <-- radiotap version
+	0x0b, 0x00, // <- radiotap header length
+	0x04, 0x0c, 0x00, 0x00, // <-- bitmap
+	0x6c, // <-- rate
+	0x0c, //<-- tx power
+	0x01 //<-- antenna
+
+The ieee80211 header follows immediately afterwards, looking for example like
+this:
+
+	0x08, 0x01, 0x00, 0x00,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0x13, 0x22, 0x33, 0x44, 0x55, 0x66,
+	0x13, 0x22, 0x33, 0x44, 0x55, 0x66,
+	0x10, 0x86
+
+Then lastly there is the payload.
+
+After composing the packet contents, it is sent by send()-ing it to a logical
+mac80211 interface that is in Monitor mode.  Libpcap can also be used,
+(which is easier than doing the work to bind the socket to the right
+interface), along the following lines:
+
+	ppcap = pcap_open_live(szInterfaceName, 800, 1, 20, szErrbuf);
+...
+	r = pcap_inject(ppcap, u8aSendBuffer, nLength);
+
+You can also find sources for a complete inject test applet here:
+
+http://penumbra.warmcat.com/_twk/tiki-index.php?page=packetspammer
+
+Andy Green <andy@warmcat.com>

-- 
