Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lerya.net ([213.251.186.118]:52289 "EHLO mx.lerya.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621Ab3CYSbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 14:31:49 -0400
Date: Mon, 25 Mar 2013 19:29:11 +0100
From: Vincent Brillault <gentoo@lerya.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
Message-ID: <20130325182910.GA10274@Fea.lerya.net> (sfid-20130325_193155_943131_FF3AEF78)
References: <20130307192920.GB8668@Fea.lerya.net>
 <20130308215833.GA2829@Fea.lerya.net>
 <513A960B.2020304@lwfinger.net>
 <20130309113222.GA3009@Fea.lerya.net>
 <513B7E58.9000505@lwfinger.net>
 <20130311183825.GG3009@Fea.lerya.net>
 <20130313080048.GB3484@Fea.lerya.net>
 <20130317141201.GA2557@Fea.lerya.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130317141201.GA2557@Fea.lerya.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry and everyone else on the list,

I've seen your 25 patches and applied them in hope my problems were
resolved. They are not :'(

I've tried to look further, I think that the root of this problem is in
core.c, in the rtl_op_bss_info_changed function. This function make a
call to get_sta on the new bssid. The problem is that at this point, the
sta is still not inserted, thus cannot be accessed by this method. As
far as I understand the code, this specific rtl_op_bss_info_changed is
responsible for setting rtlmac->mode, which explains why this mode is
never set on my system.

Example of logs (I've added some printk myself):
[ 1468.664159] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[ 1468.664271] cfg80211: Ignoring regulatory request Set by core since
the driver uses its own custom regulatory domain
[ 1468.664334] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[ 1468.664612] rtlwifi: wireless switch is on
[ 1476.203273] rtl_op_add_interface called: opmode 2, addr
30:85:a9:f4:ac:50
[ 1476.213917] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1477.330146] wlan0: authenticate with 00:21:1e:4d:57:60
[ 1477.330154] wlan0: Allocated STA 00:21:1e:4d:57:60
[ 1477.349758] rtl_op_bss_info_changed: changed & BSS_CHANGED_BSSID:
calling get_sta on 0:21:1e:4d:57:60
[ 1477.349758] Sta not found !
[ 1477.349758] wlan0: Inserted STA 00:21:1e:4d:57:60
[ 1477.349758] wlan0: send auth to 00:21:1e:4d:57:60 (try 1/3)
[ 1477.353936] wlan0: authenticated
[ 1477.353942] wlan0: moving STA 00:21:1e:4d:57:60 to state 2
[ 1477.353963] rtl8192ce 0000:03:00.0 wlan0: disabling HT as WMM/QoS is
not supported by the AP
[ 1477.353967] rtl8192ce 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is
not supported by the AP
[ 1477.354903] wlan0: associate with 00:21:1e:4d:57:60 (try 1/3)
[ 1477.360928] wlan0: RX AssocResp from 00:21:1e:4d:57:60 (capab=0x451
status=0 aid=2)
[ 1477.360934] wlan0: moving STA 00:21:1e:4d:57:60 to state 3
[ 1477.360938] rtl_op_sta_add: sta 0:21:1e:4d:57:60
[ 1477.360957] wlan0: moving STA 00:21:1e:4d:57:60 to state 4
[ 1477.360975] wlan0: associated
[ 1477.360983] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 1477.363615] get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode
= 0
[ 1477.363619] get_highest_rix called, sta not null, mode 4
[ 1477.363623] ------------[ cut here ]------------
[ 1477.363660] WARNING: at net/mac80211/tx.c:771
ieee80211_tx_h_rate_ctrl+0x3a4/0x48a [mac80211]()
[ 1477.363663] Hardware name: To Be Filled By O.E.M.


The problem seems to be at 1477.349758.

My system is using the latest wireless-testing version, plus your 25
patches. For the authentication, net-wireless/wpa_supplicant-2.0 with
libnl-3.2.21 is used.

Please contact me of you need any more debug information or if you need
me to run other tests.

Sincerely yours,
Vincent Brillault
