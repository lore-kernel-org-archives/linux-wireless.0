Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:6795 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbbJ1Vil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 17:38:41 -0400
From: Julien Cubizolles <j.cubizolles@free.fr>
To: Dan Williams <dcbw@redhat.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex problem: incompatible network settings
References: <87wpu9632c.fsf@free.fr> <1445875814.31216.18.camel@redhat.com>
	<87twpd8fk4.fsf@free.fr> <1445972115005.99995@marvell.com>
	<87a8r4ugth.fsf@free.fr> <1446043853.24757.51.camel@redhat.com>
Date: Wed, 28 Oct 2015 22:38:38 +0100
In-Reply-To: <1446043853.24757.51.camel@redhat.com> (Dan Williams's message of
	"Wed, 28 Oct 2015 09:50:53 -0500")
Message-ID: <87vb9qsmg1.fsf@free.fr> (sfid-20151028_223845_179925_2DE3580F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> He actually meant the wpa_supplicant configuration file, not the
> supplicant's dbus config file.  But when driven by NetworkManager, there
> is no supplicant configuration file.

Sorry about that.

> Instead, you can find out what config NM is pushing to the supplicant by
> checking the NetworkManager logs, where NM will log lines like:

Here are the relevant entries from the syslog file:

I included the failed attempt to connect to the WPA protected network
named "southcentral" and the successful one to a non protected one named
"FreeWifi".

--8<---------------cut here---------------start------------->8---
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): Activation: starting connection 'southcentral' (4c475300-8ffd-4dda-8445-bbd3a9cdc538)
Oct 28 22:27:17 touco dbus[675]: [system] Activating via systemd: service name='org.freedesktop.nm_dispatcher' unit='dbus-org.freedesktop.nm-dispatcher.service'
Oct 28 22:27:17 touco NetworkManager[656]: <warn>  Connection disconnected (reason -3)
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): supplicant interface state: completed -> disconnected
Oct 28 22:27:17 touco systemd[1]: Starting Network Manager Script Dispatcher Service...
Oct 28 22:27:17 touco NetworkManager[656]: <warn>  Connection disconnected (reason 3)
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: disconnected -> prepare (reason 'none') [30 40 0]
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: prepare -> config (reason 'none') [40 50 0]
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): Activation: (wifi) access point 'southcentral' has security, but secrets are required.
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: config -> need-auth (reason 'none') [50 60 0]
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: need-auth -> prepare (reason 'none') [60 40 0]
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: prepare -> config (reason 'none') [40 50 0]
Oct 28 22:27:17 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): Activation: (wifi) connection 'southcentral' has security, and secrets exist.  No new secrets needed.
Oct 28 22:27:17 touco NetworkManager[656]: <info>  Config: added 'ssid' value 'southcentral'
Oct 28 22:27:17 touco NetworkManager[656]: <info>  Config: added 'scan_ssid' value '1'
Oct 28 22:27:17 touco NetworkManager[656]: <info>  Config: added 'key_mgmt' value 'WPA-PSK'
Oct 28 22:27:17 touco NetworkManager[656]: <info>  Config: added 'psk' value '<omitted>'
Oct 28 22:27:17 touco NetworkManager[656]: <info>  Config: set interface ap_scan to 1
Oct 28 22:27:17 touco dbus[675]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Oct 28 22:27:17 touco nm-dispatcher: Dispatching action 'down' for wlx6045bdf646b4
Oct 28 22:27:17 touco systemd[1]: Started Network Manager Script Dispatcher Service.
Oct 28 22:27:19 touco ntpd[5268]: Deleting interface #7 wlx6045bdf646b4, fe80::6245:bdff:fef6:46b4#123, interface stats: received=0, sent=0, dropped=0, active_time=732 secs
Oct 28 22:27:19 touco ntpd[5268]: Deleting interface #3 wlx6045bdf646b4, 10.2.45.69#123, interface stats: received=0, sent=0, dropped=0, active_time=732 secs
Oct 28 22:27:19 touco ntpd[5268]: peers refreshed
Oct 28 22:27:21 touco wpa_supplicant[800]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:18 (SSID='southcentral' freq=2462 MHz)
Oct 28 22:27:21 touco wpa_supplicant[800]: wlx6045bdf646b4: CTRL-EVENT-ASSOC-REJECT status_code=1
Oct 28 22:27:21 touco kernel: [ 1755.971734] usb 1-3: info: trying to associate to 'southcentral' bssid f4:ca:e5:ef:be:18
Oct 28 22:27:21 touco kernel: [ 1755.971755] usb 1-3: info: mwifiex_is_network_compatible: failed: wpa_ie=0xdd wpa2_ie=0x0 WEP=d	WPA=d WPA2=d EncMode=0xfac02 privacy=0x1
Oct 28 22:27:21 touco kernel: [ 1755.971760] usb 1-3: Incompatible network settings
Oct 28 22:27:21 touco kernel: [ 1755.971766] usb 1-3: info: association to bssid f4:ca:e5:ef:be:18 failed
Oct 28 22:27:21 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): supplicant interface state: disconnected -> scanning
Oct 28 22:27:22 touco wpa_supplicant[800]: wlx6045bdf646b4: CTRL-EVENT-REGDOM-CHANGE init=BEACON_HINT type=UNKNOWN
Oct 28 22:27:25 touco wpa_supplicant[800]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:18 (SSID='southcentral' freq=2462 MHz)
Oct 28 22:27:25 touco wpa_supplicant[800]: wlx6045bdf646b4: CTRL-EVENT-ASSOC-REJECT status_code=1
Oct 28 22:27:25 touco kernel: [ 1760.400746] usb 1-3: info: trying to associate to 'southcentral' bssid f4:ca:e5:ef:be:18
Oct 28 22:27:25 touco kernel: [ 1760.400757] usb 1-3: info: mwifiex_is_network_compatible: failed: wpa_ie=0xdd wpa2_ie=0x0 WEP=d	WPA=d WPA2=d EncMode=0xfac02 privacy=0x1
Oct 28 22:27:25 touco kernel: [ 1760.400759] usb 1-3: Incompatible network settings
Oct 28 22:27:25 touco kernel: [ 1760.400762] usb 1-3: info: association to bssid f4:ca:e5:ef:be:18 failed
Oct 28 22:27:25 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): supplicant interface state: scanning -> disconnected
Oct 28 22:27:26 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): supplicant interface state: disconnected -> scanning
Oct 28 22:27:30 touco wpa_supplicant[800]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:18 (SSID='southcentral' freq=2462 MHz)
Oct 28 22:27:30 touco wpa_supplicant[800]: wlx6045bdf646b4: CTRL-EVENT-ASSOC-REJECT status_code=1
Oct 28 22:27:30 touco wpa_supplicant[800]: wlx6045bdf646b4: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="southcentral" auth_failures=1 duration=10 reason=CONN_FAILED
Oct 28 22:27:30 touco kernel: [ 1765.252338] usb 1-3: info: trying to associate to 'southcentral' bssid f4:ca:e5:ef:be:18
Oct 28 22:27:30 touco kernel: [ 1765.252355] usb 1-3: info: mwifiex_is_network_compatible: failed: wpa_ie=0xdd wpa2_ie=0x0 WEP=d	WPA=d WPA2=d EncMode=0xfac02 privacy=0x1
Oct 28 22:27:30 touco kernel: [ 1765.252359] usb 1-3: Incompatible network settings
Oct 28 22:27:30 touco kernel: [ 1765.252362] usb 1-3: info: association to bssid f4:ca:e5:ef:be:18 failed
Oct 28 22:27:30 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): supplicant interface state: scanning -> disconnected
Oct 28 22:27:35 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): supplicant interface state: disconnected -> scanning
Oct 28 22:27:42 touco NetworkManager[656]: <warn>  (wlx6045bdf646b4): Activation: (wifi) association took too long, failing activation
Oct 28 22:27:42 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: config -> failed (reason 'ssid-not-found') [50 120 53]
Oct 28 22:27:42 touco NetworkManager[656]: <info>  Connection 'southcentral' failed to autoconnect; 3 tries left
Oct 28 22:27:42 touco NetworkManager[656]: <warn>  (wlx6045bdf646b4): Activation: failed for connection 'southcentral'
Oct 28 22:27:42 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: failed -> disconnected (reason 'none') [120 30 0]
Oct 28 22:27:42 touco kernel: [ 1777.784238] IPv6: ADDRCONF(NETDEV_UP): wlx6045bdf646b4: link is not ready
Oct 28 22:27:42 touco NetworkManager[656]: <info>  Device 'wlx6045bdf646b4' has no connection; scheduling activate_check in 0 seconds.
Oct 28 22:27:42 touco NetworkManager[656]: <warn>  Failed to GDBus.Error:fi.w1.wpa_supplicant1.NotConnected: This interface is not connected: disconnect.
Oct 28 22:27:42 touco NetworkManager[656]: (NetworkManager:656): GLib-CRITICAL **: Source ID 2796 was not found when attempting to remove it
Oct 28 22:27:42 touco NetworkManager[656]: <info>  Auto-activating connection 'FreeWifi'.
Oct 28 22:27:42 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): Activation: starting connection 'FreeWifi' (0d348d83-b3b0-4ea0-894d-7b3a9e295392)
Oct 28 22:27:42 touco NetworkManager[656]: <warn>  Failed to GDBus.Error:fi.w1.wpa_supplicant1.NotConnected: This interface is not connected: disconnect.
Oct 28 22:27:42 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: disconnected -> prepare (reason 'none') [30 40 0]
Oct 28 22:27:42 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: prepare -> config (reason 'none') [40 50 0]
Oct 28 22:27:42 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): Activation: (wifi) connection 'FreeWifi' requires no security.  No secrets needed.
Oct 28 22:27:42 touco NetworkManager[656]: <info>  Config: added 'ssid' value 'FreeWifi'
Oct 28 22:27:42 touco NetworkManager[656]: <info>  Config: added 'scan_ssid' value '1'
Oct 28 22:27:42 touco NetworkManager[656]: <info>  Config: added 'key_mgmt' value 'NONE'
Oct 28 22:27:42 touco NetworkManager[656]: <warn>  Failed to GDBus.Error:fi.w1.wpa_supplicant1.NotConnected: This interface is not connected: disconnect.
Oct 28 22:27:42 touco NetworkManager[656]: <info>  Config: set interface ap_scan to 1
Oct 28 22:27:46 touco wpa_supplicant[800]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:19 (SSID='FreeWifi' freq=2462 MHz)
Oct 28 22:27:46 touco kernel: [ 1781.642487] usb 1-3: info: trying to associate to 'FreeWifi' bssid f4:ca:e5:ef:be:19
Oct 28 22:27:46 touco kernel: [ 1781.657394] usb 1-3: info: associated to bssid f4:ca:e5:ef:be:19 successfully
Oct 28 22:27:46 touco kernel: [ 1781.657454] IPv6: ADDRCONF(NETDEV_CHANGE): wlx6045bdf646b4: link becomes ready
Oct 28 22:27:46 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): supplicant interface state: scanning -> associating
Oct 28 22:27:46 touco wpa_supplicant[800]: wlx6045bdf646b4: Associated with f4:ca:e5:ef:be:19
Oct 28 22:27:46 touco wpa_supplicant[800]: wlx6045bdf646b4: CTRL-EVENT-CONNECTED - Connection to f4:ca:e5:ef:be:19 completed [id=0 id_str=]
Oct 28 22:27:46 touco wpa_supplicant[800]: WMM AC: Missing IEs
Oct 28 22:27:46 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): supplicant interface state: associating -> completed
Oct 28 22:27:46 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): Activation: (wifi) Stage 2 of 5 (Device Configure) successful.  Connected to wireless network 'FreeWifi'.
Oct 28 22:27:46 touco NetworkManager[656]: <info>  (wlx6045bdf646b4): device state change: config -> ip-config (reason 'none') [50 70 0]
Oct 28 22:27:46 touco NetworkManager[656]: <info>  Activation (wlx6045bdf646b4) Beginning DHCPv4 transaction (timeout in 45 seconds)
Oct 28 22:27:46 touco NetworkManager[656]: <info>  dhclient started with pid 5557
Oct 28 22:27:46 touco dhclient: DHCPREQUEST of 10.2.45.69 on wlx6045bdf646b4 to 255.255.255.255 port 67 (xid=0x4a227e1)
Oct 28 22:27:46 touco dhclient: DHCPACK of 10.2.45.69 from 10.7.255.252
Oct 28 22:27:46 touco NetworkManager[656]: <info>    address 10.2.45.69
Oct 28 22:27:46 touco NetworkManager[656]: <info>    plen 13 (255.248.0.0)
Oct 28 22:27:46 touco NetworkManager[656]: <info>    gateway 10.7.255.254
Oct 28 22:27:46 touco NetworkManager[656]: <info>    server identifier 10.7.255.254
Oct 28 22:27:46 touco NetworkManager[656]: <info>    lease time 3600
Oct 28 22:27:46 touco NetworkManager[656]: <info>    nameserver '212.27.40.241'
Oct 28 22:27:46 touco NetworkManager[656]: <info>    nameserver '212.27.40.240'
Oct 28 22:27:46 touco NetworkManager[656]: <info>  (wlx6045bdf646b4):
DHCPv4 state changed unknown -> bound
--8<---------------cut here---------------end--------------->8---
