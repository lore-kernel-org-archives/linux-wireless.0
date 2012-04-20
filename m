Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:44888 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2DTJQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 05:16:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 20 Apr 2012 11:16:10 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@lists.ath9k.org>
Subject: AR9300 AP/VLAN support
Message-ID: <ec6e0b9887c115cea9aa70c14702b4ae@fami-braun.de> (sfid-20120420_111623_757278_C915806B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm running OpenWRT trunk with Kernel 3.3.0 + OpenWRT patches and 
wireless-compat 2012-04-15 (based on linux-next-20120413) and the [1] 
hotfix applied on Freescale P1020WLAN (PPC SMP) and two AR9300 miniPCIe 
installed (PCI ID 168c:0030, Rev 3) with hostapd trunk (linked into 
libnl 3.2.7).
WPA2 PSK, WPA2 EAP and unsecured networks work fine, howether, once I 
enabled VLAN support, EAP authentication / key negotiation fails.
Radius authentification completes successfully, hostapd adds the 
wlan_<VID> interface (using the correct MAC, and puts it into a bridge) 
and assigns my station to it using the set-station netlink command. Then 
it tries to send some more EAPOL messages out using the sendmsg command, 
which accepts the packet (no error code is returned). Though, this 
packet never (not even during retransmission) appears on air (a separate 
box sniffs the channel) and there is no TX_STATUS confirmation for it 
(it is there once I disable vlans).

There are no related dmesg entries, i.e. when trying again, the bridge 
already is up and forwarding.

Further, once wpa_supplicant times out and tries to reconnect, it 
doesn't get any reply to the EAPOL START cmd (association completes 
successfully) until hostapd clears the station from cache.

This is without 802.11n enabled and in 2.4 Ghz. The channel is noisy, 
but connections work seamlessy with the same AP once VLANs are disabled.

Does anyone have any clues on this? If needed, I can provide debug 
logs.

Regards,
  M. Braun

[1] http://www.spinics.net/lists/linux-wireless/msg88218.html
