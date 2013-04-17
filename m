Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp08.msg.oleane.net ([62.161.4.8]:59427 "EHLO
	smtp08.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3DQPW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:22:57 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: <devel@lists.open80211s.org>, <linux-wireless@vger.kernel.org>
Subject: [patch] RE: ath9k null pointer with mesh network
Date: Wed, 17 Apr 2013 17:22:53 +0200
Message-ID: <012401ce3b7f$6e0611e0$4a1235a0$@acksys.fr> (sfid-20130417_172301_453826_C5069E0E)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I fix the issue with this patch

--- a/net/mac80211/sta_info.c	2013-04-17 16:47:16.000000000 +0200
+++ b/net/mac80211/sta_info.c	2013-04-17 16:50:02.697623684 +0200
@@ -1036,7 +1036,8 @@ void ieee80211_sta_ps_deliver_wakeup(str
 	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
 	sta->driver_buffered_tids = 0;
 
-	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
+	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS) &&
+			sta->sta_state >= IEEE80211_STA_ASSOC)
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
 	skb_queue_head_init(&pending);

Is it correct ? 

Cedric Voncken 

-----Message d'origine-----
De : devel-bounces@lists.open80211s.org
[mailto:devel-bounces@lists.open80211s.org] De la part de voncken
Envoyé : mercredi 17 avril 2013 15:57
À : linux-wireless@vger.kernel.org; devel@lists.open80211s.org
Objet : RE: ath9k null pointer with mesh network

	I understand why the ac pointer is  null in ath_tx_aggr_wakeup
function.

	My wireless card receive packet, the ieee80211_rx function is
called. This function call indirectly ath_tx_aggr_wakeup function and my
kernel crash because the ac pointer is null.

	The Ac pointer is null because the sta_state is set to
IEEE80211_STA_NONE, and on this state the function ath_tx_node_init (in
net/wireless/ath/ath9k/xmit.c) is not already called (call only when the
sta_state go to IEEE80211_STA_ASSOC from IEEE80211_STA_AUTH )

	Have you any idea to fix it ?

The kernel panic call stack
	ath_tx_aggr_wakeup+0x64/0xe4 [ath9k] (unreliable) [  128.340486]
[c7ffbd10] [c92b0b34] ath9k_deinit_device+0x8d0/0xb28 [ath9k] [  128.347324]
[c7ffbd20] [c9173cf4]
ieee80211_sta_ps_deliver_wakeup+0xa4/0x1e4 [mac80211] [  128.355365]
[c7ffbd50] [c91a3f74]
ieee80211_mps_sta_status_update+0xe4/0x158 [mac80211] [  128.363403]
[c7ffbd70] [c9186f28]
ieee80211_sta_ps_transition+0xff0/0x34e4 [mac80211] [  128.371268]
[c7ffbe00] [c91893b0]
ieee80211_sta_ps_transition+0x3478/0x34e4 [mac80211] [  128.379219]
[c7ffbe40] [c9189ae8] ieee80211_rx+0x6cc/0x798 [mac80211] [  128.385678]
[c7ffbea0] [c92b43c4] ath_rx_tasklet+0xe80/0xf74 [ath9k] [  128.392039]
[c7ffbf70] [c92b1fdc] ath9k_tasklet+0xd0/0x114 [ath9k] [  128.398219]
[c7ffbf90] [c0020b04] tasklet_action+0x88/0xe0 [  128.403694] [c7ffbfb0]
[c0021228] __do_softirq+0xa4/0x12c [  128.409088] [c7ffbff0] [c000cec8]
call_do_softirq+0x14/0x24 [  128.414655] [c73b7ee0] [c000550c]
do_softirq+0x64/0xa4 [  128.419783] [c73b7f00] [c0021464] irq_exit+0x48/0x74
[  128.424739] [c73b7f10] [c0005424] do_IRQ+0x108/0x120 [  128.429697]
[c73b7f40] [c000ec5c] ret_from_except+0x0/0x14

Cedric Voncken 

-----Message d'origine-----
De : linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] De la part de Cedric VONCKEN
Envoyé : mardi 16 avril 2013 18:26 À : linux-wireless@vger.kernel.org
Objet : ath9k null ppointer

I tried to use a mesh network with security (meshd/authsae).
I am using :
	- openwrt with the latest mac80211 package from openwrt
(2013-02-22).
	-  the Thomas Pedersen patch to add the authsae package in my
openwrt source tree
(http://permalink.gmane.org/gmane.linux.drivers.mesh.open80211s/2530)
(Use the latest version, because I sent a patch in meshd this morning,
without it the HT mode should not correctly enable)
	- AR9xx wirless card
	- Kernel 3.3.8 on power PC (mpc 8314)

When I configure the meshd daemon to use the HT mode, I have a null pointer
in ath9k (That work correctly without HT mode).

In the file, drivers/net/wireless/ath/ath9k in the function
ath_tx_aggr_wakeup the ac pointer is null.

Do you know why this pointer can be null?

Cedric Voncken 



--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

_______________________________________________
Devel mailing list
Devel@lists.open80211s.org
http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel

