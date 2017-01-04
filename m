Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:62454 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751622AbdADKjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 05:39:24 -0500
Received: from awak.mobi (unknown [78.207.29.31])
        by smtp5-g21.free.fr (Postfix) with ESMTPS id D4D405FFEA
        for <linux-wireless@vger.kernel.org>; Wed,  4 Jan 2017 11:37:58 +0100 (CET)
Received: from lstlambert-657-1-80-175.w80-13.abo.wanadoo.fr ([80.13.7.175] helo=pcxav)
        by awak.mobi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <xavier.bestel@free.fr>)
        id 1cOixB-0000bX-EA
        for linux-wireless@vger.kernel.org; Wed, 04 Jan 2017 11:37:57 +0100
Message-ID: <1483526270.8560.70.camel@free.fr> (sfid-20170104_114547_927930_08FC0D1B)
Subject: Can't authenticate to WPA network with rt2800usb driver
From: Xavier Bestel <xavier.bestel@free.fr>
To: linux-wireless@vger.kernel.org
Date: Wed, 04 Jan 2017 11:37:50 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have this USB WiFi dongle:

[2921541.271677] usb 3-12.6: new high-speed USB device number 65 using xhci_hcd
[2921541.393139] usb 3-12.6: New USB device found, idVendor=148f, idProduct=5370
[2921541.393141] usb 3-12.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[2921541.393142] usb 3-12.6: Product: 802.11 n WLAN
[2921541.393142] usb 3-12.6: Manufacturer: Ralink
[2921541.393143] usb 3-12.6: SerialNumber: 1.0
[2921541.471914] usb 3-12.6: reset high-speed USB device number 65 using xhci_hcd
[2921541.586974] ieee80211 phy4: rt2x00_set_rt: Info - RT chipset 5390, rev 0502 detected
[2921541.596791] ieee80211 phy4: rt2x00_set_rf: Info - RF chipset 5370 detected
[2921541.597005] ieee80211 phy4: Selected rate control algorithm 'minstrel_ht'
[2921541.806292] rt2800usb 3-12.6:1.0 wlx7cdd90463ef8: renamed from wlan0
[2921541.979061] IPv6: ADDRCONF(NETDEV_UP): wlx7cdd90463ef8: link is not ready
[2921541.979088] ieee80211 phy4: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
[2921542.027030] rt2800usb 3-12.6:1.0: firmware: direct-loading firmware rt2870.bin
[2921542.027035] ieee80211 phy4: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.36

It's inserted into a debian jessie box, kernel 4.8.0-1-amd64.
The box refuses to connect to a WPA AP (although it connects fine with
a PCI WiFi card):

Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.1350] device (wlx7cdd90463ef8): Activation: starting connection 'MySecretSSID 2' (e6482e2d-adbc-4529-bafc-24c3e54f07e6) 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.1351] audit: op="connection-activate" uuid="e6482e2d-adbc-4529-bafc-24c3e54f07e6" name="MySecretSSID 2" pid=1599 uid=1000 result="success" 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.1352] device (wlx7cdd90463ef8): state change: disconnected -> prepare (reason 'none') [30 40 0] 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.1445] device (wlx7cdd90463ef8): set-hw-addr: set-cloned MAC address to 7C:DD:90:46:3E:F8 (permanent) 
Jan  4 11:22:29 pcxav kernel: [2921135.939166] IPv6: ADDRCONF(NETDEV_UP): wlx7cdd90463ef8: link is not ready 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3266] device (wlx7cdd90463ef8): state change: prepare -> config (reason 'none') [40 50 0] 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3267] device (wlx7cdd90463ef8): Activation: (wifi) access point 'MySecretSSID 2' has security, but secrets are required. 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3267] device (wlx7cdd90463ef8): state change: config -> need-auth (reason 'none') [50 60 0]
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3287] device (wlx7cdd90463ef8): state change: need-auth -> prepare (reason 'none') [60 40 0] 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3289] device (wlx7cdd90463ef8): state change: prepare -> config (reason 'none') [40 50 0] 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3290] device (wlx7cdd90463ef8): Activation: (wifi) connection 'MySecretSSID 2' has security, and secrets exist.  No new secrets needed. 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3291] Config: added 'ssid' value 'MySecretSSID' 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3291] Config: added 'scan_ssid' value '1' 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3291] Config: added 'key_mgmt' value 'WPA-PSK' 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3291] Config: added 'auth_alg' value 'OPEN' 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3291] Config: added 'psk' value '<omitted>' 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3529] sup-iface[0x55f2087344e0,wlx7cdd90463ef8] config: set interface ap_scan to 1 
Jan  4 11:22:29 pcxav wpa_supplicant[13666]: wlx7cdd90463ef8: SME: Trying to authenticate with 5c:33:8e:56:78:d3 (SSID='MySecretSSID' freq=2437 MHz) 
Jan  4 11:22:29 pcxav kernel: [2921135.972360] wlx7cdd90463ef8: authenticate with 5c:33:8e:56:78:d3 
Jan  4 11:22:29 pcxav NetworkManager[15150]: <info>  [1483525349.3774] device (wlx7cdd90463ef8): supplicant interface state: inactive -> authenticating 
Jan  4 11:22:29 pcxav kernel: [2921135.990588] wlx7cdd90463ef8: send auth to 5c:33:8e:56:78:d3 (try 1/3) 
Jan  4 11:22:29 pcxav kernel: [2921135.999983] wlx7cdd90463ef8: authenticated 
Jan  4 11:22:34 pcxav kernel: [2921140.991625] wlx7cdd90463ef8: aborting authentication with 5c:33:8e:56:78:d3 by local choice (Reason: 3=DEAUTH_LEAVING) 
Jan  4 11:22:34 pcxav wpa_supplicant[13666]: wlx7cdd90463ef8: CTRL-EVENT-SSID-TEMP-DISABLED id=1 ssid="MySecretSSID" auth_failures=1 duration=10 reason=CONN_FAILED 
Jan  4 11:22:34 pcxav NetworkManager[15150]: <info>  [1483525354.4250] device (wlx7cdd90463ef8): supplicant interface state: authenticating -> disconnected 
Jan  4 11:22:44 pcxav NetworkManager[15150]: <info>  [1483525364.4264] device (wlx7cdd90463ef8): supplicant interface state: disconnected -> scanning 
Jan  4 11:22:45 pcxav wpa_supplicant[13666]: wlx7cdd90463ef8: CTRL-EVENT-SSID-REENABLED id=1 ssid="MySecretSSID" 
Jan  4 11:22:45 pcxav wpa_supplicant[13666]: wlx7cdd90463ef8: SME: Trying to authenticate with 5c:33:8e:56:78:d3 (SSID='MySecretSSID' freq=2437 MHz) 
Jan  4 11:22:45 pcxav kernel: [2921152.045396] wlx7cdd90463ef8: authenticate with 5c:33:8e:56:78:d3 
Jan  4 11:22:45 pcxav NetworkManager[15150]: <info>  [1483525365.4655] device (wlx7cdd90463ef8): supplicant interface state: scanning -> authenticating 
Jan  4 11:22:45 pcxav kernel: [2921152.079166] wlx7cdd90463ef8: send auth to 5c:33:8e:56:78:d3 (try 1/3) 
Jan  4 11:22:45 pcxav kernel: [2921152.081749] wlx7cdd90463ef8: authenticated 
Jan  4 11:22:50 pcxav kernel: [2921157.080963] wlx7cdd90463ef8: aborting authentication with 5c:33:8e:56:78:d3 by local choice (Reason: 3=DEAUTH_LEAVING) 
Jan  4 11:22:50 pcxav wpa_supplicant[13666]: wlx7cdd90463ef8: CTRL-EVENT-SSID-TEMP-DISABLED id=1 ssid="MySecretSSID" auth_failures=2 duration=20 reason=CONN_FAILED 
Jan  4 11:22:50 pcxav NetworkManager[15150]: <info>  [1483525370.5091] device (wlx7cdd90463ef8): supplicant interface state: authenticating -> disconnected 
Jan  4 11:22:54 pcxav NetworkManager[15150]: <warn>  [1483525374.7275] device (wlx7cdd90463ef8): Activation: (wifi) association took too long, failing activation 
Jan  4 11:22:54 pcxav NetworkManager[15150]: <info>  [1483525374.7275] device (wlx7cdd90463ef8): state change: config -> failed (reason 'ssid-not-found') [50 120 53] 
Jan  4 11:22:54 pcxav NetworkManager[15150]: <warn>  [1483525374.7279] device (wlx7cdd90463ef8): Activation: failed for connection 'MySecretSSID 2' 
Jan  4 11:22:54 pcxav NetworkManager[15150]: <info>  [1483525374.7282] device (wlx7cdd90463ef8): state change: failed -> disconnected (reason 'none') [120 30 0] 
Jan  4 11:22:54 pcxav kernel: [2921161.343145] IPv6: ADDRCONF(NETDEV_UP): wlx7cdd90463ef8: link is not ready 
Jan  4 11:22:54 pcxav NetworkManager[15150]: <info>  [1483525374.7454] device (wlx7cdd90463ef8): set-hw-addr: set MAC address to EA:EC:7C:7D:D6:86 (scanning) 
Jan  4 11:22:54 pcxav kernel: [2921161.536075] IPv6: ADDRCONF(NETDEV_UP): wlx7cdd90463ef8: link is not ready 
Jan  4 11:22:55 pcxav NetworkManager[15150]: <info>  [1483525375.9561] device (wlx7cdd90463ef8): supplicant interface state: disconnected -> inactive 

Does anyone have a hint to make it work ?

Regards,
	Xav
