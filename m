Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:40110
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbZBXOYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 09:24:38 -0500
Message-ID: <49A40320.1040902@erley.org> (sfid-20090224_152440_445499_285C3053)
Date: Tue, 24 Feb 2009 09:24:32 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Jouni Malinen <jouni.malinen@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Add module parameter to disable hardware crypto
References: <20090224114201.GB21933@jm.kir.nu>
In-Reply-To: <20090224114201.GB21933@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> nohwcrypt=1 module parameter can now be used to disable hardware
> crypto in ath9k. While the hardware acceleration handles most cases,
> it may be useful to be able to force mac80211 software implementation
> to be used for some tests, e.g., with virtual interface combinations
> that may not yet be supported in the key cache configuration. In
> addition, this allows management frame protection to be tested with
> older hardware revisions.
> 
With this patch, and nohwcrypt=1, I get the following in hostapd (this
system runs as an access point) when I try to associate with a client.

I can't say whether this is a hostapd problem or an ath9k problem yet,
but it's a different behavior than with nohwcrypt=0 or without this 
patch.  With this patch, wpa2 works perfectly, as without it, as well
as wep working perfectly.  

I wouldn't call this report a 'ACK/NACK' report as it has caused no
new problems, nor fixed any old problems.  Unfortunately I don't have 
a log around of the old behavior right now, for comparison.  I just 
wanted to report what I've found based on this patch.

Pat Erley

---
Configuration file: ./hostapd-wpa.conf
Using interface wlan0 with hwaddr 00:11:50:f6:c1:f0 and ssid 'FooBarCafeWPA'
wlan0: STA 00:1f:a7:70:2d:8d IEEE 802.11: authentication OK (open system)
wlan0: STA 00:1f:a7:70:2d:8d MLME: MLME-AUTHENTICATE.indication(00:1f:a7:70:2d:8d, OPEN_SYSTEM)
wlan0: STA 00:1f:a7:70:2d:8d MLME: MLME-DELETEKEYS.request(00:1f:a7:70:2d:8d)
wlan0: STA 00:1f:a7:70:2d:8d IEEE 802.11: authenticated
wlan0: STA 00:1f:a7:70:2d:8d IEEE 802.11: association OK (aid 1)
wlan0: STA 00:1f:a7:70:2d:8d IEEE 802.11: associated (aid 1)
wlan0: STA 00:1f:a7:70:2d:8d MLME: MLME-ASSOCIATE.indication(00:1f:a7:70:2d:8d)
wlan0: STA 00:1f:a7:70:2d:8d MLME: MLME-DELETEKEYS.request(00:1f:a7:70:2d:8d)
wlan0: STA 00:1f:a7:70:2d:8d WPA: event 1 notification
wlan0: STA 00:1f:a7:70:2d:8d WPA: start authentication
wlan0: STA 00:1f:a7:70:2d:8d IEEE 802.1X: unauthorizing port
Could not set station 00:1f:a7:70:2d:8d flags for kernel driver (errno=17).
wlan0: STA 00:1f:a7:70:2d:8d WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA 00:1f:a7:70:2d:8d WPA: EAPOL-Key timeout
wlan0: STA 00:1f:a7:70:2d:8d WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA 00:1f:a7:70:2d:8d WPA: EAPOL-Key timeout
wlan0: STA 00:1f:a7:70:2d:8d WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA 00:1f:a7:70:2d:8d WPA: received EAPOL-Key frame (2/4 Pairwise)
wlan0: STA 00:1f:a7:70:2d:8d WPA: invalid MIC in msg 2/4 of 4-Way Handshake
wlan0: STA 00:1f:a7:70:2d:8d WPA: received EAPOL-Key 2/4 Pairwise with unexpected replay counter
wlan0: STA 00:1f:a7:70:2d:8d WPA: received EAPOL-Key 2/4 Pairwise with unexpected replay counter
wlan0: STA 00:1f:a7:70:2d:8d WPA: EAPOL-Key timeout
wlan0: STA 00:1f:a7:70:2d:8d WPA: sending 1/4 msg of 4-Way Handshake
wlan0: STA 00:1f:a7:70:2d:8d WPA: received EAPOL-Key frame (2/4 Pairwise)
wlan0: STA 00:1f:a7:70:2d:8d WPA: invalid MIC in msg 2/4 of 4-Way Handshake
wlan0: STA 00:1f:a7:70:2d:8d WPA: EAPOL-Key timeout
wlan0: STA 00:1f:a7:70:2d:8d IEEE 802.1X: unauthorizing port
Could not set station 00:1f:a7:70:2d:8d flags for kernel driver (errno=17).
wlan0: STA 00:1f:a7:70:2d:8d IEEE 802.11: deauthenticated due to local deauth request
wlan0: STA 00:1f:a7:70:2d:8d IEEE 802.11: authentication OK (open system)
wlan0: STA 00:1f:a7:70:2d:8d MLME: MLME-AUTHENTICATE.indication(00:1f:a7:70:2d:8d, OPEN_SYSTEM)
wlan0: STA 00:1f:a7:70:2d:8d MLME: MLME-DELETEKEYS.request(00:1f:a7:70:2d:8d)

<at which point the log repeats over and over>
