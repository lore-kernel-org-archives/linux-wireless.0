Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gast-001.fem.tu-ilmenau.de ([141.24.44.1]:37039 "EHLO
	a251.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932267Ab3BLQfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:35:39 -0500
From: Michael Braun <michael-dev@fami-braun.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [konusllaptop] [PATCHv2 0/1] mac80211: fix VLAN support on AP with ps-sta
Date: Tue, 12 Feb 2013 17:35:36 +0100
Message-Id: <1360686937-17277-1-git-send-email-michael-dev@fami-braun.de> (sfid-20130212_173543_546980_E6B59D27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending a broadcast while at least on of the connected stations is
sleeping, it gets queued and send after a DTIM beacon is sent.
If the packet was to be sent on a vlan interface, the vif used for dequeing
from the per-bss queue does not hold the per-vlan sdata. The correct sdata is
required to use the correct per-vlan broadcast/multicast key.

Users are affected by not receiving the broadcasts indended for them, which for
example breaks ipv6 autoconf and therefore ipv6 connectivity. Further, they
might be affected as packets might be disclosed to non-intended stas, though
mixing vlan and non-vlan stas might be rare.
This problem is triggered more often by smartphones (which enabled me to track
it down) as they power sleep more often (I guess), but a single sleeping sta on
the ap stops the packet for all connected stas of the ap.
The problem exists in older kernels (at least 3.3.7) as well.

The following patch fixes this by restoring the per-vlan sdata using the
skb->dev entry.

Is it safe to assume that skb->dev is always set correctly there?
This patch works for me with the vlan-interface within a bridge.

Would it be better to maintain the power sleeping state of the stas on a
per-interface basis, as this would permit one group of non-sleeping stas to
receive while another group has sleeping stas? Of course this would not
prevent non-targetted groups of stas to be waked up, but implementing the
latter sounds difficult to me.

Example old backtrace:

Using good key:
[ 301.020467] ieee80211_subif_start_xmit:2000 wlan0_2.501: multicast packet to 33:33:00:00:00:01
[ 301.029146] ieee80211_tx_prepare:1174 wlan0_2.501: multicast packet to 33:33:00:00:00:01
[ 301.037249] ieee80211_tx:1442 wlan0_2.501: multicast packet to 33:33:00:00:00:01
[ 301.044688] wlan0_2.501: packet to 33:33:00:00:00:01 using key type CCMP idx 1 len 16 data de 46 7b 31 4f a3 13 8b 88 0b 4e fb 3f 77 d0 18

Using wrong key:
[ 305.000447] ieee80211_subif_start_xmit:2000 wlan0_2.501: multicast packet to 33:33:00:00:00:01
[ 305.009136] ieee80211_tx_prepare:1174 wlan0_2.501: multicast packet to 33:33:00:00:00:01
[ 305.017238] ieee80211_tx:1442 wlan0_2.501: multicast packet to 33:33:00:00:00:01
[ 305.171713] ieee80211_tx_prepare:1174 wlan0: multicast packet to 33:33:00:00:00:01
[ 305.179314] ieee80211_get_buffered_bc:2797 wlan0: multicast packet to 33:33:00:00:00:01
[ 305.187359] wlan0: packet to 33:33:00:00:00:01 using key type CCMP idx 1 len 16 data ca 85 0f 27 80 78 83 09 49 7a fb c8 c4 dc 45 aa

Example new backtrace:
[ 3157.866478] ieee80211_subif_start_xmit:2000 wlan0_2.501: multicast packet to 33:33:00:00:00:16
[ 3157.875129] ieee80211_tx_prepare:1174 wlan0_2.501: multicast packet to 33:33:00:00:00:16
[ 3157.883227] ieee80211_tx:1442 wlan0_2.501: multicast packet to 33:33:00:00:00:16
[ 3157.916991] ieee80211_tx_prepare:1174 wlan0_2.501: multicast packet to 33:33:00:00:00:16
[ 3157.925111] ieee80211_get_buffered_bc:2798 wlan0_2.501: multicast packet to 33:33:00:00:00:16
[ 3157.933667] wlan0_2.501: packet to 33:33:00:00:00:16 using key type CCMP idx 1 len 16 data  2d 06 89 89 27 74 3e e6 53 22 4b d4 5e 50 c0 39


Michael Braun (1):
  mac80211: Fix WPA with VLAN on AP side with ps client

 net/mac80211/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.10.4

