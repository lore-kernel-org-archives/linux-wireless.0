Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36407 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1165550AbdD2QJK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2017 12:09:10 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glkwg-linux-wireless@m.gmane.org>)
        id 1d4Uve-0005MF-7S
        for linux-wireless@vger.kernel.org; Sat, 29 Apr 2017 18:09:02 +0200
To: linux-wireless@vger.kernel.org
From: Julien Cubizolles <j.cubizolles@free.fr>
Subject: mwifiex won't connect to WPA2 anymore
Date: Sat, 29 Apr 2017 18:09:01 +0200
Message-ID: <87wpa3kxgi.fsf@free.fr> (sfid-20170429_181028_452277_9E0CD11C)
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't connect anymore to my home wifi since upgrading my machine from
Ubuntu 16.10 to Ubuntu 17.04.

The problem exists with kernel 4.10.0-20-generic from Ubuntu, and
remains with kernel 4.11.0-rc6 that I built from
linux-wireless. However, I can connect to a wifi network without
authentication. In the following logs, beguiled is the SSID of the
WPA-protected I can't connect to and FreeWifi the unprotected one for
which the connection succeeds.

I also copied the firmware files from
git://git.marvell.com/mwifiex-firmware.git, without success.

Here are the relevant lines from syslog. Network manager complains about
a "WRONG_KEY" but obviously I have triple checked the key, simplified
it, and checked that I can succcessfully connect to the same network
from my Android phone.

Let me know if you need anything else to investigate.

Julien.

--8<---------------cut here---------------start------------->8---
Apr 29 17:51:26 touco kernel: [ 1947.432039] usb 3-3: info: trying to associate to 'beguiled' bssid f4:ca:e5:ef:be:18
Apr 29 17:51:26 touco wpa_supplicant[1222]: wlx6045bdf646b4: Associated with f4:ca:e5:ef:be:18
Apr 29 17:51:26 touco wpa_supplicant[1222]: WMM AC: Missing IEs
Apr 29 17:51:26 touco NetworkManager[986]: <info>  [1493481086.5692] device (wlx6045bdf646b4): supplicant interface state: disconnected -> associating
Apr 29 17:51:26 touco NetworkManager[986]: <info>  [1493481086.5694] device (wlx6045bdf646b4): supplicant interface state: associating -> 4-way handshake

Apr 29 17:51:30 touco systemd[1]: Reloading OpenBSD Secure Shell server.
Apr 29 17:51:30 touco systemd[1]: Stopping LSB: Start NTP daemon...
Apr 29 17:51:30 touco systemd[1]: Reloaded OpenBSD Secure Shell server.

Apr 29 17:51:30 touco systemd[1]: Reloading.

Apr 29 17:51:30 touco kernel: [ 1951.459673] usb 3-3: info: successfully disconnected from f4:ca:e5:ef:be:18: reason code 2
Apr 29 17:51:30 touco kernel: [ 1951.459862] usb 3-3: CMD_RESP: cmd 0x10f error, result=0x2
Apr 29 17:51:30 touco wpa_supplicant[1222]: wlx6045bdf646b4: CTRL-EVENT-DISCONNECTED bssid=f4:ca:e5:ef:be:18 reason=2
Apr 29 17:51:30 touco wpa_supplicant[1222]: wlx6045bdf646b4: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
Apr 29 17:51:30 touco wpa_supplicant[1222]: wlx6045bdf646b4: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="beguiled" auth_failures=1 duration=10 reason=WRONG_KEY
Apr 29 17:51:30 touco NetworkManager[986]: <warn>  [1493481090.5439] sup-iface[0x5622b1f28570,wlx6045bdf646b4]: connection disconnected (reason 2)
Apr 29 17:51:30 touco wpa_supplicant[1222]: wlx6045bdf646b4: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Apr 29 17:51:30 touco NetworkManager[986]: <info>  [1493481090.5511] device (wlx6045bdf646b4): supplicant interface state: 4-way handshake -> disconnected
Apr 29 17:51:30 touco NetworkManager[986]: <info>  [1493481090.5523] device (wlx6045bdf646b4): Activation: (wifi) disconnected during association, asking for new key
Apr 29 17:51:30 touco NetworkManager[986]: <info>  [1493481090.5524] device (wlx6045bdf646b4): state change: config -> need-auth (reason 'supplicant-disconnect') [50 60 8]
Apr 29 17:51:30 touco NetworkManager[986]: <info>  [1493481090.6487] device (wlx6045bdf646b4): supplicant interface state: disconnected -> scanning

Apr 29 17:51:33 touco NetworkManager[986]: <info>  [1493481093.3528] device (wlx6045bdf646b4): supplicant interface state: scanning -> inactive

Apr 29 17:51:40 touco nm-dispatcher: req:2 'down' [wlx6045bdf646b4]: start running ordered scripts...

Apr 29 17:51:40 touco systemd[1]: Started LSB: Start NTP daemon.

Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5363] keyfile: update /etc/NetworkManager/system-connections/beguiled (4ecc0776-046d-4f05-a324-19f5a8fe6853,"beguiled")
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5443] device (wlx6045bdf646b4): state change: need-auth -> prepare (reason 'none') [60 40 0]
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5454] device (wlx6045bdf646b4): state change: prepare -> config (reason 'none') [40 50 0]
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5457] device (wlx6045bdf646b4): Activation: (wifi) connection 'beguiled' has security, and secrets exist.  No new secrets needed.
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5457] Config: added 'ssid' value 'beguiled'
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5458] Config: added 'scan_ssid' value '1'
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5458] Config: added 'key_mgmt' value 'WPA-PSK'
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5458] Config: added 'psk' value '<omitted>'
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.5576] sup-iface[0x5622b1f28570,wlx6045bdf646b4]: config: set interface ap_scan to 1
Apr 29 17:51:52 touco NetworkManager[986]: <info>  [1493481112.6146] device (wlx6045bdf646b4): supplicant interface state: inactive -> scanning
Apr 29 17:51:55 touco wpa_supplicant[1222]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:18 (SSID='beguiled' freq=2462 MHz)
Apr 29 17:51:55 touco kernel: [ 1976.214864] usb 3-3: info: trying to associate to 'beguiled' bssid f4:ca:e5:ef:be:18
Apr 29 17:51:55 touco wpa_supplicant[1222]: wlx6045bdf646b4: Associated with f4:ca:e5:ef:be:18
Apr 29 17:51:55 touco wpa_supplicant[1222]: WMM AC: Missing IEs
Apr 29 17:51:55 touco kernel: [ 1976.228198] usb 3-3: info: associated to bssid f4:ca:e5:ef:be:18 successfully
Apr 29 17:51:55 touco NetworkManager[986]: <info>  [1493481115.3376] device (wlx6045bdf646b4): supplicant interface state: scanning -> associating
Apr 29 17:51:55 touco NetworkManager[986]: <info>  [1493481115.3556] device (wlx6045bdf646b4): supplicant interface state: associating -> 4-way handshake
Apr 29 17:51:59 touco wpa_supplicant[1222]: wlx6045bdf646b4: CTRL-EVENT-DISCONNECTED bssid=f4:ca:e5:ef:be:18 reason=2
Apr 29 17:51:59 touco kernel: [ 1980.230780] usb 3-3: info: successfully disconnected from f4:ca:e5:ef:be:18: reason code 2
Apr 29 17:51:59 touco kernel: [ 1980.231075] usb 3-3: CMD_RESP: cmd 0x10f error, result=0x2
Apr 29 17:51:59 touco wpa_supplicant[1222]: wlx6045bdf646b4: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
Apr 29 17:51:59 touco wpa_supplicant[1222]: wlx6045bdf646b4: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="beguiled" auth_failures=1 duration=10 reason=WRONG_KEY
Apr 29 17:51:59 touco NetworkManager[986]: <warn>  [1493481119.3198] sup-iface[0x5622b1f28570,wlx6045bdf646b4]: connection disconnected (reason 2)
Apr 29 17:51:59 touco wpa_supplicant[1222]: wlx6045bdf646b4: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
Apr 29 17:51:59 touco NetworkManager[986]: <info>  [1493481119.3268] device (wlx6045bdf646b4): supplicant interface state: 4-way handshake -> disconnected
Apr 29 17:51:59 touco NetworkManager[986]: <info>  [1493481119.3289] device (wlx6045bdf646b4): Activation: (wifi) disconnected during association, asking for new key
Apr 29 17:51:59 touco NetworkManager[986]: <info>  [1493481119.3292] device (wlx6045bdf646b4): state change: config -> need-auth (reason 'supplicant-disconnect') [50 60 8]
Apr 29 17:51:59 touco NetworkManager[986]: <info>  [1493481119.4229] device (wlx6045bdf646b4): supplicant interface state: disconnected -> inactive
Apr 29 17:52:01 touco NetworkManager[986]: <warn>  [1493481121.2329] device (wlx6045bdf646b4): User canceled the secrets request.
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.2330] device (wlx6045bdf646b4): state change: need-auth -> failed (reason 'no-secrets') [60 120 7]
Apr 29 17:52:01 touco NetworkManager[986]: <warn>  [1493481121.2335] device (wlx6045bdf646b4): Activation: failed for connection 'beguiled'
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.2341] device (wlx6045bdf646b4): state change: failed -> disconnected (reason 'none') [120 30 0]
Apr 29 17:52:01 touco kernel: [ 1982.148580] IPv6: ADDRCONF(NETDEV_UP): wlx6045bdf646b4: link is not ready
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.2368] device (wlx6045bdf646b4): set-hw-addr: set MAC address to 76:26:8D:50:C1:25 (scanning)
Apr 29 17:52:01 touco kernel: [ 1982.151031] IPv6: ADDRCONF(NETDEV_UP): wlx6045bdf646b4: link is not ready
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.2405] policy: auto-activating connection 'FreeWifi'
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.2415] device (wlx6045bdf646b4): Activation: starting connection 'FreeWifi' (0d348d83-b3b0-4ea0-894d-7b3a9e295392)
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.2417] device (wlx6045bdf646b4): state change: disconnected -> prepare (reason 'none') [30 40 0]
Apr 29 17:52:01 touco wpa_supplicant[1222]: wlx6045bdf646b4: Failed to initiate sched scan
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.2981] device (wlx6045bdf646b4): set-hw-addr: set-cloned MAC address to 60:45:BD:F6:46:B4 (permanent)
Apr 29 17:52:01 touco kernel: [ 1982.212280] IPv6: ADDRCONF(NETDEV_UP): wlx6045bdf646b4: link is not ready
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3081] device (wlx6045bdf646b4): state change: prepare -> config (reason 'none') [40 50 0]
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3089] device (wlx6045bdf646b4): Activation: (wifi) connection 'FreeWifi' requires no security.  No secrets needed.
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3094] Config: added 'ssid' value 'FreeWifi'
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3098] Config: added 'scan_ssid' value '1'
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3098] Config: added 'key_mgmt' value 'NONE'
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3527] sup-iface[0x5622b1f28570,wlx6045bdf646b4]: config: set interface ap_scan to 1
Apr 29 17:52:01 touco wpa_supplicant[1222]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:19 (SSID='FreeWifi' freq=2462 MHz)
Apr 29 17:52:01 touco kernel: [ 1982.278390] usb 3-3: info: trying to associate to 'FreeWifi' bssid f4:ca:e5:ef:be:19
Apr 29 17:52:01 touco kernel: [ 1982.291327] usb 3-3: info: associated to bssid f4:ca:e5:ef:be:19 successfully
Apr 29 17:52:01 touco kernel: [ 1982.291453] IPv6: ADDRCONF(NETDEV_CHANGE): wlx6045bdf646b4: link becomes ready
Apr 29 17:52:01 touco wpa_supplicant[1222]: wlx6045bdf646b4: Associated with f4:ca:e5:ef:be:19
Apr 29 17:52:01 touco wpa_supplicant[1222]: wlx6045bdf646b4: CTRL-EVENT-CONNECTED - Connection to f4:ca:e5:ef:be:19 completed [id=0 id_str=]
Apr 29 17:52:01 touco wpa_supplicant[1222]: WMM AC: Missing IEs
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3817] device (wlx6045bdf646b4): supplicant interface state: inactive -> associating
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3853] device (wlx6045bdf646b4): supplicant interface state: associating -> completed
Apr 29 17:52:01 touco NetworkManager[986]: <info>  [1493481121.3858] device (wlx6045bdf646b4): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'FreeWifi'.
--8<---------------cut here---------------end--------------->8---
