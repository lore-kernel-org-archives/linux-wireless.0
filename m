Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:40670 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbXFNMhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 08:37:09 -0400
Message-Id: <20070614123704.418772879@warmcat.com>
References: <20070614123316.868155662@warmcat.com>
Date: Thu, 14 Jun 2007 13:33:17 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>, Andy Green <andy@warmcat.com>
Subject: [PATCH Try#lucky13 1/3] mac80211: Monitor mode radiotap injection docs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try #lucky13
 - Johannes Berg's suggested use of get_unaligned() to protect unaligned
   defreferences of all multibyte radiotap stuff

CC: John Linville <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andy Green <andy@warmcat.com>


---
 Documentation/networking/mac80211-injection.txt |   59 ++++++++++++++++
 Documentation/networking/radiotap-headers.txt   |   87 ++++++++++++++++++++++++
 2 files changed, 146 insertions(+)

Index: wireless-dev/Documentation/networking/mac80211-injection.txt
===================================================================
--- /dev/null
+++ wireless-dev/Documentation/networking/mac80211-injection.txt
@@ -0,0 +1,59 @@
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
+The radiotap format is discussed in
+./Documentation/networking/radiotap-headers.txt.
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
Index: wireless-dev/Documentation/networking/radiotap-headers.txt
===================================================================
--- /dev/null
+++ wireless-dev/Documentation/networking/radiotap-headers.txt
@@ -0,0 +1,87 @@
+How to use radiotap headers
+===========================
+
+Pointer to the radiotap include file
+------------------------------------
+
+Radiotap headers are variable-length and extensible, you can get most of the
+information you need to know on them from:
+
+./include/net/ieee80211_radiotap.h
+
+This document gives an overview and warns on some corner cases.
+
+
+Structure of the header
+-----------------------
+
+There is a fixed portion at the start which contains a u32 bitmap that defines
+if the possible argument associated with that bit is present or not.  So if b0
+of the it_present member of ieee80211_radiotap_header is set, it means that
+the header for argument index 0 (IEEE80211_RADIOTAP_TSFT) is present in the
+argument area.
+
+   < 8-byte ieee80211_radiotap_header >
+   [ <possible argument bitmap extensions ... > ]
+   [ <argument> ... ]
+
+At the moment there are only 13 possible argument indexes defined, but in case
+we run out of space in the u32 it_present member, it is defined that b31 set
+indicates that there is another u32 bitmap following (shown as "possible
+argument bitmap extensions..." above), and the start of the arguments is moved
+forward 4 bytes each time.
+
+Note also that the it_len member __le16 is set to the total number of bytes
+covered by the ieee80211_radiotap_header and any arguments following.
+
+
+Requirements for arguments
+--------------------------
+
+After the fixed part of the header, the arguments follow for each argument
+index whose matching bit is set in the it_present member of
+ieee80211_radiotap_header.
+
+ - the arguments are all stored little-endian!
+
+ - the argument payload for a given argument index has a fixed size.  So
+   IEEE80211_RADIOTAP_TSFT being present always indicates an 8-byte argument is
+   present.  See the comments in ./include/net/ieee80211_radiotap.h for a nice
+   breakdown of all the argument sizes
+
+ - the arguments must be aligned to a boundary of the argument size using
+   padding.  So a u16 argument must start on the next u16 boundary if it isn't
+   already on one, a u32 must start on the next u32 boundary and so on.
+
+ - "alignment" is relative to the start of the ieee80211_radiotap_header, ie,
+   the first byte of the radiotap header.  The absolute alignment of that first
+   byte isn't defined.  So even if the whole radiotap header is starting at, eg,
+   address 0x00000003, still the first byte of the radiotap header is treated as
+   0 for alignment purposes.
+
+ - the above point that there may be no absolute alignment for multibyte
+   entities in the fixed radiotap header or the argument region means that you
+   have to take special evasive action when trying to access these multibyte
+   entities.  Some arches like Blackfin cannot deal with an attempt to
+   dereference, eg, a u16 pointer that is pointing to an odd address.  Instead
+   you have to use a kernel API get_unaligned() to dereference the pointer,
+   which will do it bytewise on the arches that require that.
+
+ - The arguments for a given argument index can be a compound of multiple types
+   together.  For example IEEE80211_RADIOTAP_CHANNEL has an argument payload
+   consisting of two u16s of total length 4.  When this happens, the padding
+   rule is applied dealing with a u16, NOT dealing with a 4-byte single entity.
+
+
+Example valid radiotap header
+-----------------------------
+
+	0x00, 0x00, // <-- radiotap version + pad byte
+	0x0b, 0x00, // <- radiotap header length
+	0x04, 0x0c, 0x00, 0x00, // <-- bitmap
+	0x6c, // <-- rate (in 500kHz units)
+	0x0c, //<-- tx power
+	0x01 //<-- antenna
+
+
+Andy Green <andy@warmcat.com>

-- 
