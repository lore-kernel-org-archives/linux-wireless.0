Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:52700 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbYFMM5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 08:57:41 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2506600rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 05:57:39 -0700 (PDT)
Message-ID: <1ba2fa240806130557s16f8ef99y639e4a1287c4f718@mail.gmail.com> (sfid-20080613_145745_260058_E8206A60)
Date: Fri, 13 Jun 2008 15:57:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Maciek Kaliszewski" <mkalkal@interia.pl>
Subject: Re: iwl3945 and WPA
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4852658A.4040402@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4852658A.4040402@interia.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 3:18 PM, Maciek Kaliszewski <mkalkal@interia.pl> wrote:
> I cannot connect to my WIFI/WPA network using iwl3945 driver.
>
> debian:/home/u# iwlist wlan0_rename scanning
> wlan0_rename  Scan completed :
>         Cell 01 - Address: 00:1D:7E:43:B3:3F
>                   ESSID:"APTEKA"
>                   Mode:Master
>                   Channel:11
>                   Frequency:2.462 GHz (Channel 11)
>                   Quality=73/100  Signal level:-61 dBm  Noise level=-127 dBm
>                   Encryption key:on
>                   IE: WPA Version 1
>                       Group Cipher : TKIP
>                       Pairwise Ciphers (1) : TKIP
>                       Authentication Suites (1) : PSK
>                   Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
>                             24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
>                             12 Mb/s; 48 Mb/s
>                   Extra:tsf=0000003b5a033363
>
> debian:/home/u# cat /etc/wpa_supplicant.conf
> ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=root
> network={
>    ssid="APTEKA"
>    scan_ssid=1
>    key_mgmt=WPA-PSK
>    psk="xxx"
> }
>
>
> debian:/home/u# wpa_supplicant -Dwext -iwlan0_rename
> -c/etc/wpa_supplicant.conf -dd
> Initializing interface 'wlan0_rename' conf '/etc/wpa_supplicant.conf' driver
> 'wext' ctrl_interface 'N/A' bridge 'N/A'
> Configuration file '/etc/wpa_supplicant.conf' -> '/etc/wpa_supplicant.conf'
> Reading configuration file '/etc/wpa_supplicant.conf'
> ctrl_interface='DIR=/var/run/wpa_supplicant GROUP=root'
> Line: 2 - start of a new network block
> ssid - hexdump_ascii(len=6):
>    41 50 54 45 4b 41                                 APTEKA
> scan_ssid=1 (0x1)
> key_mgmt: 0x2
> PSK (ASCII passphrase) - hexdump_ascii(len=16): [REMOVED]
> PSK (from passphrase) - hexdump(len=32): [REMOVED]
> Priority group 0
>  id=0 ssid='APTEKA'
> Initializing interface (2) 'wlan0_rename'
> Interface wlan0_rename set UP - waiting a second for the driver to complete
> initialization
> SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
>  capabilities: key_mgmt 0xf enc 0xf
> WEXT: Operstate: linkmode=1, operstate=5
> Own MAC address: 00:1b:77:bc:bb:ec
> wpa_driver_wext_set_wpa
> wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
> wpa_driver_wext_set_countermeasures
> wpa_driver_wext_set_drop_unencrypted
> RSN: flushing PMKID list in the driver
> Setting scan request: 0 sec 100000 usec
> EAPOL: SUPP_PAE entering state DISCONNECTED
> EAPOL: KEY_RX entering state NO_KEY_RECEIVE
> EAPOL: SUPP_BE entering state INITIALIZE
> EAP: EAP entering state DISABLED
> ctrl_interface_group=0 (from group name 'root')
> Added interface wlan0_rename
> Ignore event for foreign ifindex 7
> RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0_rename' added
> RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> Wireless event: cmd=0x8b06 len=12
> State: DISCONNECTED -> SCANNING
> Starting AP scan (specific SSID)
> Scan SSID - hexdump_ascii(len=6):
>    41 50 54 45 4b 41                                 APTEKA         Trying
> to get current scan results first without requesting a new scan to speed up
> initial association
> Received 0 bytes of scan results (0 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> Try to find non-WPA AP
> No suitable AP found.
> Setting scan request: 0 sec 0 usec
> Starting AP scan (broadcast SSID)
> Scan requested (ret=0) - scan timeout 5 seconds
> EAPOL: disable timer tick
> RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> Wireless event: cmd=0x8b19 len=16


> Invalid freq in scan results (BSSID=00:00:01:00:00:1d m=0 e=11)
> Invalid freq in scan results (BSSID=00:00:01:00:00:1d m=0 e=2462)

What system kernel are you using. This looks something we've already solved...
Tomas
