Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:39009 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203AbYB0NpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 08:45:03 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: Roaming issues.
Date: Wed, 27 Feb 2008 14:44:38 +0100
Message-ID: <004501c87946$e5f1f490$0b3ca8c0@gotws1589> (sfid-20080227_134510_426616_D994B201)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Back with som data regarding roaming.


Prerequisites
=============
Just for your knowledge I'm using the following equipment:
- RT61, mini PCI
- rt2x00.git / 1e0b4c51393308a98f2918db424c676cc99cf123
- Managed mode
- Wpa_supplicant 0.5.9

AP deauthentication.
=====================
When any of the ieee80211_rx_mgmt_deauth() or ieee80211_rx_mgmt_disassoc()
are executed, the mac layer takes two actions.
1) Tells wpa_supplicant what had happened.
2) Start reestabliching the connaction again.

The later action will stop or significantly delay the decisions/action taken
by wpa_supplicant as a result of action 1. Normally the supplicant will
start an AP scan. 
But the mac layer is busy with reestablishing the link and will not start
any scan action.
  
My patches simply put the mac layer in IEEE80211_DISABLED state and wait for
the supplicant to decide.


Monitoring of a usable link to the AP.
======================================
The ieee80211_rx_h_sta_process() and  ieee80211_associated() are involved in
monitors for dead AP connection. A last_rx value is set to indicate a
working connection.

The porblem is the following lines.
	if (!is_multicast_ether_addr(hdr->addr1) ||
	    rx->sdata->vif.type == IEEE80211_IF_TYPE_STA) {

Any package that arrives to an STA will update the last_rx value and
prohibit a link lost action.

I have noticed in my system that this function receives the following type
of frames:
1) Broad cast frames from my BSS (beacons).
2) Data frames addressed to me ;)
3) Data frames from other STA addressed to other MAC addresses but using the
same BSS.
 
It is the case 3 that creates the problem. Another STA, closer to my BSS
will update my last_rx value even I do not receive the BSS.

I have made the following change:

	if ( compare_ether_addr(hdr->addr2, hdr->addr3) == 0 &&
	    rx->sdata->vif.type == IEEE80211_IF_TYPE_STA) {

My last_rx will only be updated as long as I can receive frames from my BSS.
I might have to add some frame type validation, but it solved my problems.


Timeout handling
=================
When any of the ieee80211_authenticate() or ieee80211_associate() function
are executed. 
The mac silently set its state to IEEE80211_DISABLED and waits for the
wpa_supplicant to timeout its current action.

I think it would be a good idea to signal to the supplicant that the
operation has timeout, and no further action will be taken.
To speed up the timeout response I had squeezed the supplicant timeout.

I have patches for all modification but it might be a good start to verify
that my suggestion is 'usabel'

Regards
Lars


