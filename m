Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:41167 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953Ab3BLOGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 09:06:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 12 Feb 2013 15:05:50 +0100
From: michael-dev <michael-dev@fami-braun.de>
To: <projekt-wlan@fem.tu-ilmenau.de>, <linux-wireless@vger.kernel.org>
Subject: [BUG] mac80211 queues per bss breaking vlan support
Reply-To: <projekt-wlan@fem.tu-ilmenau.de>,
	  <linux-wireless@vger.kernel.org>
In-Reply-To: <a5de216143f5905d943b7604efbc5fae@fami-braun.de>
References: <a5de216143f5905d943b7604efbc5fae@fami-braun.de>
Message-ID: <ff2b44a591d3407606e7ce1e254c8378@fami-braun.de> (sfid-20130212_150608_841973_977EAFDF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

tracing mac80211 using debug calls, here come traces for two packages. 
The first is fine, the second uses the wrong key.

[ 301.020467] ieee80211_subif_start_xmit:2000 wlan0_2.501: multicast 
packet to 33:33:00:00:00:01
[ 301.029146] ieee80211_tx_prepare:1174 wlan0_2.501: multicast packet 
to 33:33:00:00:00:01
[ 301.037249] ieee80211_tx:1442 wlan0_2.501: multicast packet to 
33:33:00:00:00:01
[ 301.044688] wlan0_2.501: packet to 33:33:00:00:00:01 using key type 
CCMP idx 1 len 16 data de 46 7b 31 4f a3 13 8b 88 0b 4e fb 3f 77 d0 18
[ 305.000447] ieee80211_subif_start_xmit:2000 wlan0_2.501: multicast 
packet to 33:33:00:00:00:01
[ 305.009136] ieee80211_tx_prepare:1174 wlan0_2.501: multicast packet 
to 33:33:00:00:00:01
[ 305.017238] ieee80211_tx:1442 wlan0_2.501: multicast packet to 
33:33:00:00:00:01
[ 305.171713] ieee80211_tx_prepare:1174 wlan0: multicast packet to 
33:33:00:00:00:01
[ 305.179314] ieee80211_get_buffered_bc:2797 wlan0: multicast packet to 
33:33:00:00:00:01
[ 305.187359] wlan0: packet to 33:33:00:00:00:01 using key type CCMP 
idx 1 len 16 data ca 85 0f 27 80 78 83 09 49 7a fb c8 c4 dc 45 aa

The number behind the function indicates the line. It looks to me, as 
if ps_data buffering is local to the bss, so when dequeing, 
ieee80211_get_buffered_bc uses bss vif for tx->sdata instead of the 
group interface, which means that vlan support is currently broken in 
mac80211?

Any ideas?

Thanks,
  M. Braun

