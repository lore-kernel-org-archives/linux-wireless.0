Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f173.google.com ([209.85.160.173]:47511 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3BQGil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2013 01:38:41 -0500
Received: by mail-gh0-f173.google.com with SMTP id g2so392504ghb.32
        for <linux-wireless@vger.kernel.org>; Sat, 16 Feb 2013 22:38:40 -0800 (PST)
Message-ID: <51207925.5040702@lwfinger.net> (sfid-20130217_073844_625945_C097584C)
Date: Sun, 17 Feb 2013 00:31:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Regression caused by commit df88129
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni and Johannes,

A recent pull of the wireless-testing tree caused my wireless to break. The 
wireless devices can authenticate and associate as follows:

wlan0: authenticate with c0:3f:0e:be:2b:44
wlan0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
wlan0: send auth to c0:3f:0e:be:2b:44 (try 1/3)
wlan0: authenticated
wlan0: associate with c0:3f:0e:be:2b:44 (try 1/3)
wlan0: RX AssocResp from c0:3f:0e:be:2b:44 (capab=0x411 status=0 aid=3)
wlan0: associated
IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)
b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: 
c0:3f:0e:be:2b:44
b43-phy0 debug: Using hardware based encryption for keyidx: 1, mac: 
ff:ff:ff:ff:ff:ff
wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)
wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)

These dropped frame messages persist, and prevent the connection from being 
completed. The code in question is in routine ieee80211_subif_start_xmit() of 
file net/mac80211/tx.c as follows:

==============================================================
         if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
                      !is_multicast_ether_addr(hdr.addr1) && !authorized &&
                      (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
                       !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))) {
#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
                 net_info_ratelimited("%s: dropped frame to %pM (unauthorized 
port)\n",
                                     dev->name, hdr.addr1);
#endif

                 I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);

                 goto fail_rcu;
         }
==============================================================

When the if statement is rewritten as 'if (A || B)', it turns out that A is 
true, and B is false.

The regression was bisected to commit df881293c6ba9a12868491a717b25cb14ec1fa4a.

==============================================================
commit df881293c6ba9a12868491a717b25cb14ec1fa4a
Author: Jouni Malinen <jouni@qca.qualcomm.com>
Date:   Thu Feb 14 21:10:54 2013 +0200

     cfg80211: Pass TDLS peer's QoS/HT/VHT information during set_station

     The information of the peer's capabilities is required for the driver
     to perform TDLS Peer UAPSD operations. This information of the peer is
     passed by the supplicant using NL80211_CMD_SET_STATION command. This
     commit enhances the function nl80211_set_station to pass this
     information of the peer to the driver in case this command is used
     with the TDLS peer STA.

     In addition, make the HT/VHT capability configuration handled more
     consistently for other STA cases (reject both instead of just HT).

     Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
==============================================================

If you need any more debugging output for this problem, please let me know.

Thanks,

Larry
