Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:55764 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYEPHbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 03:31:34 -0400
Received: by nf-out-0910.google.com with SMTP id d3so306380nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 00:31:31 -0700 (PDT)
Message-ID: <482D384C.30807@gmail.com> (sfid-20080516_093139_083975_56251B49)
Date: Fri, 16 May 2008 09:31:24 +0200
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Association broken with wpa_supplicant
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not using the latest wireless (2.6.25) but I also have trouble using 
wpa_supplicant (same error as you). After *a lot* of trying, I figured 
this out, to associate I do this:

/sbin/wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf.2 -B
/bin/sleep 5
/usr/bin/killall wpa_supplicant
/sbin/wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf -B
/bin/sleep 5
/sbin/ifconfig wlan0 192.168.2.252 netmask 255.255.255.248
/sbin/route add default gw 192.168.2.254

The contents of wpa_supplicant.conf.2 is:

ctrl_interface=/var/run/wpa_supplicant

ap_scan=2
fast_reauth=0

network={
	bssid=00:1B:2F:A9:48:E8
	ssid="Chimera"
	psk="<<scrubbed>>"
	key_mgmt=WPA-PSK
	proto=WPA2
	pairwise=CCMP
}


The contents of wpa_supplicant.conf is:

ctrl_interface=/var/run/wpa_supplicant

ap_scan=1
fast_reauth=0

network={
	bssid=00:1B:2F:A9:48:E8
	ssid="Chimera"
	psk="<<scrubbed>>"
	key_mgmt=WPA-PSK
	proto=WPA2
	pairwise=CCMP
}

Trying to associate directly with only wpa_supplicant.conf won't work, 
*only* after I used wpa_supplicant.conf.2. Furthermore, I never made a 
bugreport as I thought that it would be an error in wpa_supplicant...

I hope this helps you in any way =)

						Ronald
