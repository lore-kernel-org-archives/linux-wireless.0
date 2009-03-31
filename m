Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:58760 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbZCaWaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 18:30:01 -0400
Received: by qyk16 with SMTP id 16so5010452qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 15:29:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49CC064A.10304@lwfinger.net>
References: <49CBDE6A.6040702@lwfinger.net>
	 <30353c3d0903261426u56c47af9oe15d9775db171714@mail.gmail.com>
	 <49CC064A.10304@lwfinger.net>
Date: Tue, 31 Mar 2009 18:29:58 -0400
Message-ID: <30353c3d0903311529g76009c64o20a11e1aad731499@mail.gmail.com> (sfid-20090401_003009_605374_7C166E98)
Subject: Re: [RFT/RFC 1/2] b43legacy: Fixes for beacons
From: David Ellingsworth <david@identd.dyndns.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 6:48 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> David Ellingsworth wrote:
>>
>> I haven't had a chance to test these as of yet. I had to wait a few
>> extra days in order for my new wireless card to come in (couldn't
>> really test in AP mode with only one card). I built a new kernel last
>> night with these patches, but I still need to setup and configure
>> hostapd. Hopefully, I'll know more later tonight. I'll run tests with
>> and without these patches.
>
> OK. Please take whatever time you need. We already missed to 2.6.30 merge
> window, thus we have a couple of months.
>
> Larry

I've had a chance to review these patches and while I haven't
experienced any crashes as a result of these patches, I haven't yet
been able to get hostapd to work properly with the b43legacy driver. I
haven't tried to set up an AP without the patches, but can test that
as well if the results might be useful. Below is the relevant
information:

Output from "hostapd -dddd ./hostap.conf":
------------------------------------------------
Configuration file: ./hostap.conf
Opening raw packet socket for ifindex -1211076240
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
RATE[0] rate=10 flags=0x2
RATE[1] rate=20 flags=0x6
RATE[2] rate=55 flags=0x6
RATE[3] rate=110 flags=0x6
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Passive scanning not supported
Flushing old station entries
Deauthenticate all stations
Mode: IEEE 802.11g  Channel: 1  Frequency: 2412 MHz
Using interface wlan0 with hwaddr ca:fe:ba:be:b0:0b and ssid 'test'
wlan0: Setup of interface done.
MGMT (TX callback) ACK
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT (TX callback) fail
mgmt::proberesp cb
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
STA de:af:ca:fe:ba:be sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
^CSignal 2 received - terminating
Flushing old station entries
Deauthenticate all stations

Contents of hostap.conf:
------------------------------------------------
interface=wlan0
driver=nl80211

ssid=test
hw_mode=g
channel=1

wpa=0
auth_algs=1

Output from "wpa_supplicant -c ./wpa.conf -i wlan0 -dddd":
---------------------------------------------------
Initializing interface 'wlan0' conf './wpa.conf' driver 'default'
ctrl_interface 'N/A' bridge 'N/A'
Configuration file './wpa.conf' -> '/root/./wpa.conf'
Reading configuration file '/root/./wpa.conf'
ctrl_interface='/var/run/wpa_supplicant'
Line: 3 - start of a new network block
ssid - hexdump_ascii(len=8):
     74 65 73 74                           test
key_mgmt: 0x4
Priority group 0
   id=0 ssid='test'
Initializing interface (2) 'wlan0'
Interface wlan0 set UP - waiting a second for the driver to complete
initialization
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf flags 0x0
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:1e:e5:20:1e:cd
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_countermeasures
wpa_driver_wext_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Added interface wlan0
Ignore event for foreign ifindex 4
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Ignore event for foreign ifindex 4
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b06 len=8
Ignore event for foreign ifindex 4
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Trying to get current scan results first without requesting a new scan
to speed up initial association
Received 0 bytes of scan results (0 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 0
Try to find WPA-enabled AP
Try to find non-WPA AP
No suitable AP found.
Setting scan request: 0 sec 0 usec
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 5 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b19 len=8
Received 321 bytes of scan results (1 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:1d:7e:37:73:09 ssid='*****' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
Try to find non-WPA AP
0: 00:1d:7e:37:73:09 ssid='*****' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
No suitable AP found.
Setting scan request: 5 sec 0 usec
EAPOL: disable timer tick
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added

Contents of wpa.conf:
------------------------------------------------
ctrl_interface=/var/run/wpa_supplicant

network={
        ssid="test"
        key_mgmt=NONE
}

Leaving it run for an extended period of time exhibits the same
results. The client isn't ever able to locate the AP to connect to.
These tests were conducted using a b43 based card as the client and a
b43legacy card as the AP.

Regards,

David Ellingsworth
