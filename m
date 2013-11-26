Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm39.bullet.mail.ne1.yahoo.com ([98.138.229.32]:30385 "EHLO
	nm39.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757440Ab3KZVV0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 16:21:26 -0500
Message-ID: <1385500717.14399.YahooMailNeo@web125003.mail.ne1.yahoo.com> (sfid-20131126_222140_314636_37BCC095)
Date: Tue, 26 Nov 2013 13:18:37 -0800 (PST)
From: Gertjan Hofman <gertjan_hofman@yahoo.com>
Reply-To: Gertjan Hofman <gertjan_hofman@yahoo.com>
Subject: Unwanted client isolation mode @ 5 Ghz/ Atheros
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Apologies is this should go to the ath mailing list, but we are not sure where in the stack the problem lies.

On a 3.11 kernel, we are trying to create a AP host using the following  hardware: driver (usb) ath9k_htc: Atheros AR9280 Rev:2 using htc_7010.fw firmware  (extracted from debian unstable)   After solving some  regulatory domain issues by patching the ath driver, we can force the card into becoming master at 5 GHz.  However, at  5GHz, the clients are isolated from each other (ARP request from one client are not seen by the other).  When we switch back  to 2.4 GHz the system works as expected.  We need connection between the clients.


Looking at mac80211/cfg.c, I see that host isolation is indeed an option.  I  printed the value of  IEEE80211_SDATA_DONT_BRIDGE_PACKETS but it is  false as expected.  


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
