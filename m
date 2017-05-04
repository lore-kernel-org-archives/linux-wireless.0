Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:24075 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbdEDV1z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 17:27:55 -0400
From: Julien Cubizolles <j.cubizolles@free.fr>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mwifiex won't connect to WPA2 anymore
References: <87wpa3kxgi.fsf@free.fr> <87tw51y91z.fsf@free.fr>
        <1493844237.5647.9.camel@redhat.com>
Date: Thu, 04 May 2017 23:27:53 +0200
In-Reply-To: <1493844237.5647.9.camel@redhat.com> (Dan Williams's message of
        "Wed, 03 May 2017 15:43:57 -0500")
Message-ID: <87a86sfh2e.fsf@free.fr> (sfid-20170504_232812_085824_607841EF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Wed, 2017-05-03 at 22:33 +0200, Julien Cubizolles wrote:

>> It turns out that the problem lies with NetworkManager, I managed to
>> get
>> the wifi working with wpa_supplicant.
>
> That's odd.  Any idea what that was?  MAC randomization?  

I don't know if MAC randomization is supposed to be happen but ifconfig
always display the same MAC address for the wifi interface. Also the
same wifi router allows connections without secrets with another ssid,
and I have no problem connecting in this case.

> NM just uses the supplicant underneath, so there's no particular
> reason NM wouldn't work but wpa_supplicant itself would.

I'm using the following /etc/wpa_supplicant.conf file:

--8<---------------cut here---------------start------------->8---
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
network={
	priority=2
        ssid="beguiled"
        psk="*****"
}

--8<---------------cut here---------------end--------------->8---

For the same ssid: NetworkManager uses the following
/etc/NetworkManager/system-connections/beguiled

--8<---------------cut here---------------start------------->8---
[connection]
id=beguiled
uuid=4ecc0776-046d-4f05-a324-19f5a8fe6853
type=wifi
permissions=
secondaries=

[wifi]
ssid=beguiled

[wifi-security]
psk=******

[ipv4]
dns-search=
method=auto

[ipv6]
addr-gen-mode=stable-privacy
dns-search=
method=auto
--8<---------------cut here---------------end--------------->8---

Here are the logs when NM fails:
--8<---------------cut here---------------start------------->8---

May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.8411] device (wlx6045bdf646b4): set-hw-addr: set MAC address to E2:D4:E4:49:77:59 (scanning)
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.8433] manager: NetworkManager state is now DISCONNECTED
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.8435] device (wlx6045bdf646b4): Activation: starting connection 'beguiled' (406e52d4-e98b-454b-8d32-ce69fee5e03f)
May  4 23:06:25 touco kernel: [   58.255775] IPv6: ADDRCONF(NETDEV_UP): wlx6045bdf646b4: link is not ready
May  4 23:06:25 touco whoopsie[818]: [23:06:25] Cannot reach: https://daisy.ubuntu.com
May  4 23:06:25 touco nm-dispatcher: req:2 'down' [wlx6045bdf646b4]: new request (2 scripts)
May  4 23:06:25 touco nm-dispatcher: req:2 'down' [wlx6045bdf646b4]: start running ordered scripts...
May  4 23:06:25 touco whoopsie[818]: [23:06:25] Cannot reach: https://daisy.ubuntu.com
May  4 23:06:25 touco NetworkManager[833]: <warn>  [1493931985.8711] sup-iface[0x5634f93244e0,wlx6045bdf646b4]: connection disconnected (reason -3)
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.8712] device (wlx6045bdf646b4): supplicant interface state: completed -> disconnected
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.8745] device (wlx6045bdf646b4): state change: disconnected -> prepare (reason 'none') [30 40 0]
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.8747] manager: NetworkManager state is now CONNECTING
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9016] device (wlx6045bdf646b4): set-hw-addr: set-cloned MAC address to 60:45:BD:F6:46:B4 (permanent)
May  4 23:06:25 touco kernel: [   58.316182] IPv6: ADDRCONF(NETDEV_UP): wlx6045bdf646b4: link is not ready
May  4 23:06:25 touco gsd-sharing[2450]: Failed to StopUnit service: GDBus.Error:org.freedesktop.systemd1.NoSuchUnit: Unit rygel.service not loaded.
May  4 23:06:25 touco gsd-sharing[2450]: Failed to StopUnit service: GDBus.Error:org.freedesktop.systemd1.NoSuchUnit: Unit vino-server.service not loaded.
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9314] device (wlx6045bdf646b4): state change: prepare -> config (reason 'none') [40 50 0]
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9322] device (wlx6045bdf646b4): Activation: (wifi) access point 'beguiled' has security, but secrets are required.
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9323] device (wlx6045bdf646b4): state change: config -> need-auth (reason 'none') [50 60 0]
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9394] device (wlx6045bdf646b4): state change: need-auth -> prepare (reason 'none') [60 40 0]
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9403] device (wlx6045bdf646b4): state change: prepare -> config (reason 'none') [40 50 0]
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9406] device (wlx6045bdf646b4): Activation: (wifi) connection 'beguiled' has security, and secrets exist.  No new secrets needed.
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9406] Config: added 'ssid' value 'beguiled'
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9407] Config: added 'scan_ssid' value '1'
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9407] Config: added 'key_mgmt' value 'WPA-PSK'
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9407] Config: added 'auth_alg' value 'OPEN'
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9407] Config: added 'psk' value '<omitted>'
May  4 23:06:25 touco NetworkManager[833]: <info>  [1493931985.9833] sup-iface[0x5634f93244e0,wlx6045bdf646b4]: config: set interface ap_scan to 1
May  4 23:06:26 touco wpa_supplicant[1171]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:18 (SSID='beguiled' freq=2462 MHz)
May  4 23:06:26 touco kernel: [   58.421135] usb 3-3: info: trying to associate to 'beguiled' bssid f4:ca:e5:ef:be:18
May  4 23:06:26 touco kernel: [   58.434898] usb 3-3: info: associated to bssid f4:ca:e5:ef:be:18 successfully
May  4 23:06:26 touco kernel: [   58.434913] IPv6: ADDRCONF(NETDEV_CHANGE): wlx6045bdf646b4: link becomes ready
May  4 23:06:26 touco wpa_supplicant[1171]: wlx6045bdf646b4: Associated with f4:ca:e5:ef:be:18
May  4 23:06:26 touco wpa_supplicant[1171]: WMM AC: Missing IEs
May  4 23:06:26 touco NetworkManager[833]: <info>  [1493931986.0221] device (wlx6045bdf646b4): supplicant interface state: disconnected -> associating
May  4 23:06:26 touco whoopsie[818]: [23:06:26] Cannot reach: https://daisy.ubuntu.com
May  4 23:06:26 touco NetworkManager[833]: <info>  [1493931986.0265] device (wlx6045bdf646b4): supplicant interface state: associating -> 4-way handshake
May  4 23:06:26 touco tracker-miner-a[2529]:   (Sparql buffer) Error in task 0 (file:///home/wilk/.local/share/applications/EmacsClient.desktop) of the array-update: UNIQUE constraint failed: nie:DataObject.nie:url (strerror of errno (not necessarily related): Ressource temporairement non disponible)
May  4 23:06:26 touco tracker-miner-a[2529]: Could not execute sparql: UNIQUE constraint failed: nie:DataObject.nie:url (strerror of errno (not necessarily related): Ressource temporairement non disponible)
May  4 23:06:27 touco ntpd[1990]: Deleting interface #3 wlx6045bdf646b4, 10.2.0.53#123, interface stats: received=0, sent=5, dropped=0, active_time=29 secs
May  4 23:06:27 touco ntpd[1990]: Deleting interface #5 wlx6045bdf646b4, fe80::6245:bdff:fef6:46b4%2#123, interface stats: received=0, sent=0, dropped=0, active_time=29 secs
May  4 23:06:28 touco gnome-shell[2189]: JS WARNING: [resource:///org/gnome/shell/ui/dash.js 760]: reference to undefined property oldApps[oldIndex]
May  4 23:06:28 touco dbus-daemon[1786]: Activating via systemd: service name='org.gnome.zeitgeist.Engine' unit='zeitgeist.service'
May  4 23:06:28 touco systemd[1774]: Starting Zeitgeist activity log service...
May  4 23:06:28 touco dbus-daemon[1786]: Activating via systemd: service name='org.gnome.zeitgeist.SimpleIndexer' unit='zeitgeist-fts.service'
May  4 23:06:28 touco dbus-daemon[1786]: Successfully activated service 'org.gnome.zeitgeist.Engine'
May  4 23:06:28 touco systemd[1774]: Started Zeitgeist activity log service.
May  4 23:06:28 touco systemd[1774]: Starting Zeitgeist full-text search indexer...
May  4 23:06:28 touco zeitgeist-daemon[2849]: #033[31m[21:06:28.606766 WARNING]#033[0m zeitgeist-daemon.vala:127: Unable to parse version info!
May  4 23:06:28 touco zeitgeist-daemon[2849]: #033[31m[21:06:28.608482 WARNING]#033[0m zeitgeist-daemon.vala:127: Unable to parse version info!
May  4 23:06:28 touco zeitgeist-daemon[2849]: #033[31m[21:06:28.631280 WARNING]#033[0m zeitgeist-daemon.vala:127: Unable to parse version info!
May  4 23:06:28 touco dbus-daemon[1786]: Successfully activated service 'org.gnome.zeitgeist.SimpleIndexer'
May  4 23:06:28 touco systemd[1774]: Started Zeitgeist full-text search indexer.
May  4 23:06:28 touco zeitgeist-datah[2857]: zeitgeist-datahub.vala:227: Unable to get name "org.gnome.zeitgeist.datahub" on the bus!
May  4 23:06:28 touco gnome-shell[2189]: JS WARNING: [resource:///org/gnome/shell/ui/appDisplay.js 1298]: reference to undefined property this.name
May  4 23:06:29 touco pulseaudio[2585]: [pulseaudio] module.c: After module unload, module 'module-null-sink' was still loaded!
May  4 23:06:30 touco wpa_supplicant[1171]: wlx6045bdf646b4: CTRL-EVENT-DISCONNECTED bssid=f4:ca:e5:ef:be:18 reason=2
May  4 23:06:30 touco kernel: [   62.437145] usb 3-3: info: successfully disconnected from f4:ca:e5:ef:be:18: reason code 2
May  4 23:06:30 touco kernel: [   62.437439] usb 3-3: CMD_RESP: cmd 0x10f error, result=0x2
May  4 23:06:30 touco wpa_supplicant[1171]: wlx6045bdf646b4: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
May  4 23:06:30 touco NetworkManager[833]: <warn>  [1493931990.0257] sup-iface[0x5634f93244e0,wlx6045bdf646b4]: connection disconnected (reason 2)
May  4 23:06:30 touco wpa_supplicant[1171]: wlx6045bdf646b4: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="beguiled" auth_failures=1 duration=10 reason=WRONG_KEY
May  4 23:06:30 touco NetworkManager[833]: <info>  [1493931990.0340] device (wlx6045bdf646b4): supplicant interface state: 4-way handshake -> disconnected
May  4 23:06:30 touco wpa_supplicant[1171]: wlx6045bdf646b4: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
May  4 23:06:30 touco NetworkManager[833]: <info>  [1493931990.0373] device (wlx6045bdf646b4): Activation: (wifi) disconnected during association, asking for new key
May  4 23:06:30 touco NetworkManager[833]: <info>  [1493931990.0377] device (wlx6045bdf646b4): state change: config -> need-auth (reason 'supplicant-disconnect') [50 60 8]
May  4 23:06:30 touco NetworkManager[833]: <info>  [1493931990.1292] device (wlx6045bdf646b4): supplicant interface state: disconnected -> scanning
May  4 23:06:30 touco org.gnome.Shell.desktop[2189]: Window manager warning: Invalid WM_TRANSIENT_FOR window 0x0 specified for 0x2600007 (Onboard).
May  4 23:06:31 touco kernel: [   64.182891] ieee80211 phy0: mwifiex_cfg80211_sched_scan_start : Invalid Sched_scan parameters
May  4 23:06:31 touco wpa_supplicant[1171]: wlx6045bdf646b4: Failed to initiate sched scan
May  4 23:06:31 touco NetworkManager[833]: <info>  [1493931991.7755] device (wlx6045bdf646b4): supplicant interface state: scanning -> inactive
May  4 23:06:32 touco NetworkManager[833]: <warn>  [1493931992.4940] device (wlx6045bdf646b4): User canceled the secrets request.
May  4 23:06:32 touco NetworkManager[833]: <info>  [1493931992.4941] device (wlx6045bdf646b4): state change: need-auth -> failed (reason 'no-secrets') [60 120 7]
May  4 23:06:32 touco NetworkManager[833]: <info>  [1493931992.4944] manager: NetworkManager state is now DISCONNECTED
May  4 23:06:32 touco NetworkManager[833]: <warn>  [1493931992.4950] device (wlx6045bdf646b4): Activation: failed for connection 'beguiled'
--8<---------------cut here---------------end--------------->8---
