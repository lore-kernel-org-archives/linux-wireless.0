Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from telegweb.telechips.com ([219.240.43.111]:54746 "EHLO
	sfilter.telechips.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3BGGlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 01:41:14 -0500
Received: from [219.240.43.118] ([219.240.43.118])
          by sfilter.telechips.com ([219.240.43.111])
          with ESMTP id 1360217995.380193.2968075184.sfilter
          for <linux-wireless@vger.kernel.org>;
          Thu, 07 Feb 2013 15:19:55 +0900 (KST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Subject: Question: how can i applay  IP/TCP/UDP checksum offload H/W Engine to our softmac driver on mac80211 ?
Date: Thu, 7 Feb 2013 15:41:00 +0900
Message-ID: <F4F751F96C54D346898D4C77E196E3DB0A4C5E25@telegweb.telechips.com> (sfid-20130207_074117_337573_D85930AC)
From: =?ks_c_5601-1987?B?seK787/4IChTVyBLaSk=?= <oprsystem@telechips.com>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello everyone.

i would like to use our hardware TCP/IP Checksum logic on the mac80211 driver.
but, i can see the IP Checksum in Tx skb_buffer on mac80211 tx handler after "g_ieee80211_hw->netdev_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM;"

you can find the IP checksum value that is 0x26, 0x42.
[   40.970000]  queue_skb: IP protocol: 0x00000008
0xC042382E: 88 01 00 00 00 50 43 21 22 2B 00 01 02 03 04 05  .....PC!"+......
0xC042392E: 00 19 B9 79 2D 7E 90 00 00 00 AA AA 03 00 00 00  ...y-~..........
0xC0423A2E: 08 00 45 00 00 54 00 00 40 00 40 01 [26 42] 0A 00  ..E..T..@.@.&B..
0xC0423B2E: 00 04 0A 00 00 64 08 00 CB C5 CB 02 00 01 F0 33  .....d.........3
0xC0423C2E: 71 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00  q...............
0xC0423D2E: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
0xC0423E2E: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
0xC0423F2E: 00 00 00 00 00 00

how can I remove the IP checksum field calculation by software generation on mac80211 stack?

thanks & best regards
Sangwon, Ki


