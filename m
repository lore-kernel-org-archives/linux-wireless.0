Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:48289 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966116Ab3DQN45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 09:56:57 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>, <devel@lists.open80211s.org>
Subject: RE: ath9k null pointer with mesh network
Date: Wed, 17 Apr 2013 15:56:53 +0200
Message-ID: <011b01ce3b73$6a9c9e90$3fd5dbb0$@acksys.fr> (sfid-20130417_155702_087925_16483D16)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
	ath_tx_aggr_wakeup+0x64/0xe4 [ath9k] (unreliable)
[  128.340486] [c7ffbd10] [c92b0b34] ath9k_deinit_device+0x8d0/0xb28 [ath9k]
[  128.347324] [c7ffbd20] [c9173cf4]
ieee80211_sta_ps_deliver_wakeup+0xa4/0x1e4 [mac80211]
[  128.355365] [c7ffbd50] [c91a3f74]
ieee80211_mps_sta_status_update+0xe4/0x158 [mac80211]
[  128.363403] [c7ffbd70] [c9186f28]
ieee80211_sta_ps_transition+0xff0/0x34e4 [mac80211]
[  128.371268] [c7ffbe00] [c91893b0]
ieee80211_sta_ps_transition+0x3478/0x34e4 [mac80211]
[  128.379219] [c7ffbe40] [c9189ae8] ieee80211_rx+0x6cc/0x798 [mac80211]
[  128.385678] [c7ffbea0] [c92b43c4] ath_rx_tasklet+0xe80/0xf74 [ath9k]
[  128.392039] [c7ffbf70] [c92b1fdc] ath9k_tasklet+0xd0/0x114 [ath9k]
[  128.398219] [c7ffbf90] [c0020b04] tasklet_action+0x88/0xe0
[  128.403694] [c7ffbfb0] [c0021228] __do_softirq+0xa4/0x12c
[  128.409088] [c7ffbff0] [c000cec8] call_do_softirq+0x14/0x24
[  128.414655] [c73b7ee0] [c000550c] do_softirq+0x64/0xa4
[  128.419783] [c73b7f00] [c0021464] irq_exit+0x48/0x74
[  128.424739] [c73b7f10] [c0005424] do_IRQ+0x108/0x120
[  128.429697] [c73b7f40] [c000ec5c] ret_from_except+0x0/0x14

Cedric Voncken 

-----Message d'origine-----
De : linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] De la part de Cedric VONCKEN
Envoyé : mardi 16 avril 2013 18:26
À : linux-wireless@vger.kernel.org
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

