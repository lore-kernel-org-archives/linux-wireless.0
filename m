Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:48422 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557AbZGAWKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 18:10:22 -0400
Subject: Unable to complete a connection with nl80211 and wpa_supplicant?
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 17:10:26 -0500
Message-Id: <1246486226.11632.50.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guys,

Does the following log showing wpa_supplicant's inability
to assoc/auth using the nl80211 driver look familiar
to anyone?  The same setup and config works using the
wext driver. Do I just need a more recent wireless-testing
kernel?  This is wireless-testing at d1a6d5c2f6.  And
if it matters, it's the ar9170 driver below that.

Thanks,
jdl


# cat /etc/wpa_supplicant.conf 
network={
	ssid="bigfoot"
	scan_ssid=1
	key_mgmt=WPA-PSK
	psk="my-secret"
}


# wpa_supplicant -c /etc/wpa_supplicant.conf  -Dnl80211 -i wlan0

CTRL-EVENT-SCAN-RESULTS 
Trying to associate with 00:1e:58:f2:f5:71 (SSID='bigfoot' freq=2422 MHz)
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Associated with 00:1e:58:f2:f5:71
Authentication with 00:1e:58:f2:f5:71 timed out.
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to associate with 00:1e:58:f2:f5:71 (SSID='bigfoot' freq=2422 MHz)
Associated with 00:1e:58:f2:f5:71
Authentication with 00:1e:58:f2:f5:71 timed out.
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to associate with 00:1e:58:f2:f5:71 (SSID='bigfoot_' freq=2422 MHz)





