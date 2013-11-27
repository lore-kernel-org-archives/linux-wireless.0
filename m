Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm43.bullet.mail.ne1.yahoo.com ([98.138.120.50]:20388 "HELO
	nm43.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756145Ab3K0QP2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 11:15:28 -0500
Message-ID: <1385568765.12744.YahooMailNeo@web125003.mail.ne1.yahoo.com> (sfid-20131127_171531_933726_F917F3AF)
Date: Wed, 27 Nov 2013 08:12:45 -0800 (PST)
From: Gertjan Hofman <gertjan_hofman@yahoo.com>
Reply-To: Gertjan Hofman <gertjan_hofman@yahoo.com>
Subject: unwanted client isolation on 5 GHz atheros cards
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Apologies is this should go to the ath mailing list, but we are not sure where in the stack the problem lies.

On a 3.11 kernel, we are trying to create a AP host using the following  hardware: driver (usb) ath9k_htc: Atheros AR9280 Rev:2 using htc_7010.fw firmware  (1.3, extracted from debian unstable)   After solving some  regulatory domain issues by patching the ath driver, we can force the card into becoming master at 5 GHz.  However, at  5GHz, the clients are isolated from each other (can not ping etc).  When we switch back  to 2.4 GHz (making only two changes in the hostapd file, hw_mode=a->g, channel=36->1) the system works as expected.  


Using wireshark/tcpdump I verified that ARP packets are _not_ 
transmitted from the AP host to other clients. In other words, ARP from 
client to AP hosts are resolved ok, but a client trying to resolve the 
MAC from another client gets no response and the packet is not seen even on a Windows host running wireshark.  Switch to 2.4 GHz and the ARP packets return.


Looking at mac80211/cfg.c, I see that host isolation is indeed an option.  I  printed the value of IEEE80211_SDATA_DONT_BRIDGE_PACKETS but it is  false as expected. 


Can anyone tell me whether this is likely a problem at the mac80211 level  or closer to the hardware ? Are there other settings that kick in a 5  GHz that would not at 2.4 GHz ?

We are quite capable of modifying drivers but have little knowledge of  wireless hardware.  Any information would be much appreciated.


Sincerely,

Gertjan


hostapd (v1.1) settings are:
interface=wlan0
driver=nl80211
ssid=MSS-01
ieee80211n=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=1
require_ht=1
ht_capab=[HT40+][SHORT-GI-40][TXSTBC][RXSTBC123]
wmm_enabled=1
hw_mode=a
channel=36
country_code=US
ap_isolate=0
