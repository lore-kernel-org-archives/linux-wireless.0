Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:60148 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3BRLIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 06:08:50 -0500
From: Girish Bn <Girish.BN@lnties.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: patch : mac80211:Multicast patch for linux-2.6.28.1 (wl12xx drivers)
Date: Mon, 18 Feb 2013 11:09:59 +0000
Message-ID: <45566970CF58C74CB52107862E0541CD1D1F72A2@POCITMSEXMB02.LntUniverse.com> (sfid-20130218_120856_334947_2BD0FBB7)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

The below patch file is required in order for the multicasting to work properly on Linux kernel below 3.2 for wl12xx drivers
diff -Naur a/net/mac80211/iface.c b/net/mac80211/iface.c
--- a/net/mac80211/iface.c          2012-09-22 22:59:15.000000000 +0530
+++ b/net/mac80211/iface.c      2013-02-07 12:06:03.958268798 +0530
@@ -811,6 +811,9 @@
               .ndo_uninit                        = ieee80211_teardown_sdata,
               .ndo_start_xmit                               = ieee80211_subif_start_xmit,
               .ndo_set_rx_mode        = ieee80211_set_multicast_list,
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0))
+             .ndo_set_multicast_list = ieee80211_set_multicast_list,
+#endif
               .ndo_change_mtu          = ieee80211_change_mtu,
               .ndo_set_mac_address                = ieee80211_change_mac,
               .ndo_select_queue        = ieee80211_netdev_select_queue,

This above patch will disable the multicast filter at the wl1271 hardware

Thanks & Regards,
Girish
L&T IES,
KIADB Industrial Area,
Hebbal-Hootagalli, Mysore - 570 018
Telephone :  DID+91-821-2405552
Mobile: +91-9741206402
E-mail ID :Girish.BN@lnties.com
www.lnties.com

This mail is classified as :
(  ) L&T IES Proprietary
(  ) L&T IES Confidential
(X) L&T IES Internal Use
( ) L&T IES General Business

Larsen & Toubro Limited

www.larsentoubro.com

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
