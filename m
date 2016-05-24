Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35207 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbcEXO4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 10:56:11 -0400
Received: by mail-wm0-f67.google.com with SMTP id f75so6972712wmf.2
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2016 07:56:10 -0700 (PDT)
Subject: Re: How to activate MAC address randomization?
To: Dan Williams <dcbw@redhat.com>, Thomas Haller <thaller@redhat.com>,
	Chris Laprise <tasket@openmailbox.org>,
	networkmanager-list@gnome.org, Lubomir Rintel <lrintel@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.infradead.org" <hostap@lists.infradead.org>,
	Kuba Kicinski <kubakici@wp.pl>
References: <5723BF90.4010701@openmailbox.org>
 <1463091417.20553.1.camel@redhat.com>
 <b640b32b-85b2-4e9b-18af-6e91ac27f108@gmail.com>
 <573A3674.50809@openmailbox.org>
 <9901c3c7-5c73-9d13-72be-1a6b7ddf82e1@gmail.com>
 <1463582960.4426.11.camel@redhat.com>
 <a1f8dee2-33b5-5754-4223-5150944a7915@gmail.com>
 <1463653326.4426.31.camel@redhat.com>
 <66a6e6fa-a31b-33f5-4c07-8f456811bf15@gmail.com>
 <1463765815.32277.21.camel@redhat.com>
 <fba7f9b2-aca0-8273-a333-f4db502a5f04@gmail.com>
 <7f4c8daf-3ec3-f960-cbad-9cd819b559a5@gmail.com>
 <2167f384-ae39-6ecd-91aa-470ce19cd8d7@gmail.com>
 <086327a1-8410-519d-205c-f65c51843d10@gmail.com>
From: poma <pomidorabelisima@gmail.com>
Message-ID: <2d8b2e38-56bd-e64f-a524-e0f95ca809e9@gmail.com> (sfid-20160524_165616_401211_3800935D)
Date: Tue, 24 May 2016 16:56:05 +0200
MIME-Version: 1.0
In-Reply-To: <086327a1-8410-519d-205c-f65c51843d10@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24.05.2016 16:46, poma wrote:
> On 24.05.2016 13:22, poma wrote:
>>
>> [...] NetworkManager [...]
>>
>> WPA Supplicant comparative test
>> - wpa_supplicant v2.6-devel git a26c9c2 2016-05-20
>> - Linux 4.6
>> - QEMU emulator version 2.6.0 (Hotspot)
>>
>>
>> Pre-association / Scanning random MAC address
>>
>>  = Client (mt7601u) =
>>
>> # grep -v '^#\|^$' /etc/wpa_supplicant.conf
>> ctrl_interface=/var/run/wpa_supplicant
>> ctrl_interface_group=wheel
>> preassoc_mac_addr=1
>> network={
>>         ssid="WiFiRd"
>>         bssid=ee:dd:cc:bb:aa:00
>>         key_mgmt=WPA-PSK
>>         psk="**********"
>> }
>>
>>
>> # wpa_supplicant -i wlp0s2f1u3 -c /etc/wpa_supplicant.conf -d -f wpasuplog.txt
>>
>>
>> # grep -i 'mac\|rand\|connected' wpasuplog.txt
>> random: Trying to read entropy from /dev/random
>> preassoc_mac_addr=1
>> wlp0s2f1u3: Own MAC address: 00:aa:bb:cc:dd:ee
>> wlp0s2f1u3: WPS: UUID based on MAC address: [...]
>> EAPOL: SUPP_PAE entering state DISCONNECTED
>> wlp0s2f1u3: State: DISCONNECTED -> DISCONNECTED
>> random: Got 20/20 bytes from /dev/random
>> wlp0s2f1u3: State: DISCONNECTED -> SCANNING
>> nl80211: set_mac_addr for wlp0s2f1u3 to 4a:b1:d6:28:4c:90
>> wlp0s2f1u3: Using random MAC address 4a:b1:d6:28:4c:90
>> nl80211: set_mac_addr for wlp0s2f1u3 to 00:aa:bb:cc:dd:ee
>> wlp0s2f1u3: Using permanent MAC address
>> wlp0s2f1u3: CTRL-EVENT-CONNECTED - Connection to ee:dd:cc:bb:aa:00 completed [id=0 id_str=]
>> ...
>>
>>
>>
>>  = Hotspot (rt2800usb) =
>>
>> # grep -v '^#\|^$' /etc/wpa_supplicant.conf 
>> ctrl_interface=/var/run/wpa_supplicant
>> ctrl_interface_group=wheel
>> network={
>>         ssid="WiFiRd"
>>         key_mgmt=WPA-PSK
>>         psk="**********"
>>         mode=2
>> }
>>
>>
>> # wpa_supplicant -i wlp2s2f7u2 -c /etc/wpa_supplicant.conf -d -f wpasuplog.txt
>>
>>
>> # grep -i '4a:b1:d6:28:4c:90\|00:aa:bb:cc:dd:ee' wpasuplog.txt
>> nl80211: RX frame da=ff:ff:ff:ff:ff:ff sa=4a:b1:d6:28:4c:90 bssid=ff:ff:ff:ff:ff:ff freq=2462 ssi_signal=-19 fc=0x40 seq_ctrl=0x3b20 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=83
>> nl80211: send_mlme - da= 4a:b1:d6:28:4c:90 noack=1 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x50 (WLAN_FC_STYPE_PROBE_RESP) nlmode=3
>> nl80211: RX frame da=ee:dd:cc:bb:aa:00 sa=00:aa:bb:cc:dd:ee bssid=ee:dd:cc:bb:aa:00 freq=2462 ssi_signal=-19 fc=0x8b0 seq_ctrl=0x3b60 stype=11 (WLAN_FC_STYPE_AUTH) len=30
>> ...
>> wlp2s2f7u2: AP-STA-CONNECTED 00:aa:bb:cc:dd:ee
>> ...
>>
>>
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>>
>> Association / Connection random MAC address
>>
>>
>>  = Client (mt7601u) =
>>
>> # grep -v '^#\|^$' /etc/wpa_supplicant.conf
>> ctrl_interface=/var/run/wpa_supplicant
>> ctrl_interface_group=wheel
>> mac_addr=1
>> network={
>>         ssid="WiFiRd"
>>         bssid=ee:dd:cc:bb:aa:00
>>         key_mgmt=WPA-PSK
>>         psk="**********"
>> }
>>
>>
>> # wpa_supplicant -i wlp0s2f1u3 -c /etc/wpa_supplicant.conf -d -f wpasuplog.txt
>>
>>
>> # grep -i 'mac\|rand\|connected' wpasuplog.txt
>> random: Trying to read entropy from /dev/random
>> mac_addr=1
>> wlp0s2f1u3: Own MAC address: 00:aa:bb:cc:dd:ee
>> wlp0s2f1u3: WPS: UUID based on MAC address: [...]
>> EAPOL: SUPP_PAE entering state DISCONNECTED
>> wlp0s2f1u3: State: DISCONNECTED -> DISCONNECTED
>> random: Got 20/20 bytes from /dev/random
>> wlp0s2f1u3: State: DISCONNECTED -> SCANNING
>> nl80211: set_mac_addr for wlp0s2f1u3 to 0e:5d:07:b0:73:a6
>> wlp0s2f1u3: Using random MAC address 0e:5d:07:b0:73:a6
>> wlp0s2f1u3: State: AUTHENTICATING -> DISCONNECTED
>> wlp0s2f1u3: State: DISCONNECTED -> SCANNING
>> wlp0s2f1u3: State: AUTHENTICATING -> DISCONNECTED
>> wlp0s2f1u3: State: DISCONNECTED -> SCANNING
>> wlp0s2f1u3: State: AUTHENTICATING -> DISCONNECTED
>> wlp0s2f1u3: State: DISCONNECTED -> SCANNING
>> wlp0s2f1u3: State: AUTHENTICATING -> DISCONNECTED
>> wlp0s2f1u3: State: DISCONNECTED -> SCANNING
>> wlp0s2f1u3: State: AUTHENTICATING -> DISCONNECTED
>> wlp0s2f1u3: State: DISCONNECTED -> SCANNING
>> wlp0s2f1u3: State: AUTHENTICATING -> DISCONNECTED
>> wlp0s2f1u3: Request to deauthenticate - bssid=00:00:00:00:00:00 pending_bssid=00:00:00:00:00:00 reason=3 state=DISCONNECTED
>> wlp0s2f1u3: State: DISCONNECTED -> DISCONNECTED
>>
>>
>>
>>  = Hotspot (rt2800usb) =
>>
>> # grep -v '^#\|^$' /etc/wpa_supplicant.conf 
>> ctrl_interface=/var/run/wpa_supplicant
>> ctrl_interface_group=wheel
>> network={
>>         ssid="WiFiRd"
>>         key_mgmt=WPA-PSK
>>         psk="**********"
>>         mode=2
>> }
>>
>>
>> # wpa_supplicant -i wlp2s2f7u2 -c /etc/wpa_supplicant.conf -d -f wpasuplog.txt
>>
>>
>> # grep -i acknowledge wpasuplog.txt
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>>
>>
>> # grep -i '00:aa:bb:cc:dd:ee\|0e:5d:07:b0:73:a6' wpasuplog.txt
>> nl80211: RX frame da=ff:ff:ff:ff:ff:ff sa=00:aa:bb:cc:dd:ee bssid=ff:ff:ff:ff:ff:ff freq=2462 ssi_signal=-17 fc=0x40 seq_ctrl=0x3c30 stype=4 (WLAN_FC_STYPE_PROBE_REQ) len=83
>> nl80211: send_mlme - da= 00:aa:bb:cc:dd:ee noack=1 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0x50 (WLAN_FC_STYPE_PROBE_RESP) nlmode=3
>> nl80211: RX frame da=ee:dd:cc:bb:aa:00 sa=0e:5d:07:b0:73:a6 bssid=ee:dd:cc:bb:aa:00 freq=2462 ssi_signal=-15 fc=0xb0 seq_ctrl=0x3c60 stype=11 (WLAN_FC_STYPE_AUTH) len=30
>> authentication: STA=0e:5d:07:b0:73:a6 auth_alg=0 auth_transaction=1 status_code=0 wep=0 seq_ctrl=0x3c60
>> ap_sta_add: register ap_handle_timer timeout for 0e:5d:07:b0:73:a6 (300 seconds - ap_max_inactivity)
>> nl80211: sta_remove -> DEL_STATION wlp2s2f7u2 0e:5d:07:b0:73:a6 --> -2 (No such file or directory)
>> nl80211: Add STA 0e:5d:07:b0:73:a6
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - authentication OK (open system)
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - MLME-AUTHENTICATE.indication(0e:5d:07:b0:73:a6, OPEN_SYSTEM)
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - MLME-DELETEKEYS.request(0e:5d:07:b0:73:a6)
>> authentication reply: STA=0e:5d:07:b0:73:a6 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
>> nl80211: send_mlme - da= 0e:5d:07:b0:73:a6 noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xb0 (WLAN_FC_STYPE_AUTH) nlmode=3
>> nl80211: New station 0e:5d:07:b0:73:a6
>> nl80211: RX frame da=ee:dd:cc:bb:aa:00 sa=0e:5d:07:b0:73:a6 bssid=ee:dd:cc:bb:aa:00 freq=2462 ssi_signal=-15 fc=0x8b0 seq_ctrl=0x3c70 stype=11 (WLAN_FC_STYPE_AUTH) len=30
>> authentication: STA=0e:5d:07:b0:73:a6 auth_alg=0 auth_transaction=1 status_code=0 wep=0 seq_ctrl=0x3c70 retry
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - authentication OK (open system)
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - MLME-AUTHENTICATE.indication(0e:5d:07:b0:73:a6, OPEN_SYSTEM)
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - MLME-DELETEKEYS.request(0e:5d:07:b0:73:a6)
>> authentication reply: STA=0e:5d:07:b0:73:a6 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
>> nl80211: send_mlme - da= 0e:5d:07:b0:73:a6 noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xb0 (WLAN_FC_STYPE_AUTH) nlmode=3
>> wlp2s2f7u2: EVENT_TX_STATUS dst=0e:5d:07:b0:73:a6 type=0 stype=11
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> wlp2s2f7u2: EVENT_TX_STATUS dst=0e:5d:07:b0:73:a6 type=0 stype=11
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> nl80211: RX frame da=ee:dd:cc:bb:aa:00 sa=0e:5d:07:b0:73:a6 bssid=ee:dd:cc:bb:aa:00 freq=2462 ssi_signal=-15 fc=0x8b0 seq_ctrl=0x3c80 stype=11 (WLAN_FC_STYPE_AUTH) len=30
>> authentication: STA=0e:5d:07:b0:73:a6 auth_alg=0 auth_transaction=1 status_code=0 wep=0 seq_ctrl=0x3c80 retry
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - authentication OK (open system)
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - MLME-AUTHENTICATE.indication(0e:5d:07:b0:73:a6, OPEN_SYSTEM)
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - MLME-DELETEKEYS.request(0e:5d:07:b0:73:a6)
>> authentication reply: STA=0e:5d:07:b0:73:a6 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
>> nl80211: send_mlme - da= 0e:5d:07:b0:73:a6 noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xb0 (WLAN_FC_STYPE_AUTH) nlmode=3
>> nl80211: RX frame da=ee:dd:cc:bb:aa:00 sa=0e:5d:07:b0:73:a6 bssid=ee:dd:cc:bb:aa:00 freq=2462 ssi_signal=-15 fc=0x8b0 seq_ctrl=0x3c90 stype=11 (WLAN_FC_STYPE_AUTH) len=30
>> authentication: STA=0e:5d:07:b0:73:a6 auth_alg=0 auth_transaction=1 status_code=0 wep=0 seq_ctrl=0x3c90 retry
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - authentication OK (open system)
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - MLME-AUTHENTICATE.indication(0e:5d:07:b0:73:a6, OPEN_SYSTEM)
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - MLME-DELETEKEYS.request(0e:5d:07:b0:73:a6)
>> authentication reply: STA=0e:5d:07:b0:73:a6 auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
>> nl80211: send_mlme - da= 0e:5d:07:b0:73:a6 noack=0 freq=0 no_cck=0 offchanok=0 wait_time=0 fc=0xb0 (WLAN_FC_STYPE_AUTH) nlmode=3
>> wlp2s2f7u2: EVENT_TX_STATUS dst=0e:5d:07:b0:73:a6 type=0 stype=11
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> wlp2s2f7u2: EVENT_TX_STATUS dst=0e:5d:07:b0:73:a6 type=0 stype=11
>> hostapd_logger: STA 0e:5d:07:b0:73:a6 - did not acknowledge authentication response
>> nl80211: RX frame da=ee:dd:cc:bb:aa:00 sa=0e:5d:07:b0:73:a6 bssid=ee:dd:cc:bb:aa:00 freq=2462 ssi_signal=-15 fc=0x8b0 seq_ctrl=0x3ca0 stype=11 (WLAN_FC_STYPE_AUTH) len=30
>> ...
>>
>>
>>
>> Driver's constraint or wpa_supplicant's issue?
>>
>>
> 
> 
>  = Client (r92su - https://github.com/chunkeey/rtl8192su) =
> 
> # wpa_supplicant -i wlp0s2f1u3 -c /etc/wpa_supplicant.conf
> Successfully initialized wpa_supplicant
> wlp0s2f1u3: Trying to associate with ee:dd:cc:bb:aa:00 (SSID='WiFiRd' freq=2462 MHz)
> wlp0s2f1u3: Associated with ee:dd:cc:bb:aa:00
> wlp0s2f1u3: CTRL-EVENT-SUBNET-STATUS-UPDATE status=0
> wlp0s2f1u3: WPA: Key negotiation completed with ee:dd:cc:bb:aa:00 [PTK=CCMP GTK=TKIP]
> wlp0s2f1u3: CTRL-EVENT-CONNECTED - Connection to ee:dd:cc:bb:aa:00 completed [id=0 id_str=]
> 
> 
> $ macchanger -s wlp0s2f1u3
> Current MAC:   12:21:64:8a:08:ce (unknown)
> Permanent MAC: 00:aa:bb:cc:dd:ee ([...])
> 
> 
> 
>  = Hotspot (rt2800usb) =
> 
> # wpa_supplicant -i wlp2s2f7u2 -c /etc/wpa_supplicant.conf
> Successfully initialized wpa_supplicant
> Using interface wlp2s2f7u2 with hwaddr ee:dd:cc:bb:aa:00 and ssid "WiFiRd"
> wlp2s2f7u2: interface state UNINITIALIZED->ENABLED
> wlp2s2f7u2: AP-ENABLED 
> wlp2s2f7u2: CTRL-EVENT-CONNECTED - Connection to ee:dd:cc:bb:aa:00 completed [id=0 id_str=]
> wlp2s2f7u2: AP-STA-CONNECTED 12:21:64:8a:08:ce
> 
> 
> 
> It seems, at the current stage of development,
> mt7601u.ko cannot cope with the Association / Connection random MAC address
> https://github.com/kuba-moo/mt7601u/commits/master
> 
> So after all, this is driver's constrain, perhaps a bug.
> 


For the record, tricks like this ain't gonna help:
---
 src/ap/ieee802_11.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/src/ap/ieee802_11.c b/src/ap/ieee802_11.c
index 781afa2..16714a3 100644
--- a/src/ap/ieee802_11.c
+++ b/src/ap/ieee802_11.c
@@ -2662,13 +2662,6 @@ static void handle_auth_cb(struct hostapd_data *hapd,
 	auth_transaction = le_to_host16(mgmt->u.auth.auth_transaction);
 	status_code = le_to_host16(mgmt->u.auth.status_code);
 
-	if (!ok) {
-		hostapd_logger(hapd, mgmt->da, HOSTAPD_MODULE_IEEE80211,
-			       HOSTAPD_LEVEL_NOTICE,
-			       "did not acknowledge authentication response");
-		goto fail;
-	}
-
 	if (len < IEEE80211_HDRLEN + sizeof(mgmt->u.auth)) {
 		wpa_printf(MSG_INFO, "handle_auth_cb - too short payload (len=%lu)",
 			   (unsigned long) len);


Bye


