Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:64350 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934587AbZHEPKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 11:10:45 -0400
Received: by gxk9 with SMTP id 9so208476gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 08:10:44 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 5 Aug 2009 08:10:18 -0700
Message-ID: <43e72e890908050810h29c28945o4732f8606caab9fb@mail.gmail.com>
Subject: Re: [ath5k-devel] a possible regression in managed mode ?
To: andrea rossato <andrea.rossato@unitn.it>
Cc: ath5k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 5, 2009 at 6:41 AM, andrea rossato<andrea.rossato@unitn.it> wrote:
> On Tue, Aug 04, 2009 at 08:36:43AM -0700, Luis R. Rodriguez wrote:
>> Also, can you try wpa_supplicant from git, to see if that makes a
>> difference?
> ...
>>
>> I should note that new kernel stuff should not bust with old
>> userspace. If upgrading to a newer supplicant fixes your issue
>> we may have a regression somewhere in wireless-testing, which
>> I have been suspicious about, but haven't had time to look at it.
>
>
> On Tue, Aug 04, 2009 at 08:36:43AM -0700, Luis R. Rodriguez wrote:
>> Also, can you try wpa_supplicant from git, to see if that makes a
>> difference?
> ...
>>
>> I should note that new kernel stuff should not bust with old
>> userspace. If upgrading to a newer supplicant fixes your issue
>> we may have a regression somewhere in wireless-testing, which
>> I have been suspicious about, but haven't had time to look at it.
>
>
> Well, I need to correct myself a bit: after trying wpa_supplicant from
> git and noticing it worked fine I wanted to investigate a bit further
> and went back to the 0.6.9 release. And it worked too, sort of...
>
> Basically both versions work with the first association and
> authentication. The problem comes when I ask them or they need to
> reassociate.

Can you try with -D nl80211 and see if that fixes your issue?

Also from your description of the issue below it is unclear to me if
you do not see these issues with an older kernel or if this is only
happening with newer kernels or wireless-testing. Can you please
clarify.

  Luis

> Now, since I do not use NetworkManager, and I need to connect to
> different wireless networks with different configurations (dhcp,
> proxies, etc.), in my scripts I use something like:
>
> wpa_cli -a/usr/local/sbin/wpa_action -B
>
> followed by a:
> wpa_cli rea
>
> And whenever wpa_supplicat tries to associate for a second time I keep
> getting an authentication timeout error.
>
> For instance:
>
> [13:38:02]$ wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf
> CTRL-EVENT-SCAN-RESULTS
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> CTRL-EVENT-SCAN-RESULTS
> Associated with 00:22:b0:70:1f:67
> WPA: Key negotiation completed with 00:22:b0:70:1f:67 [PTK=CCMP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:22:b0:70:1f:67 completed (auth) [id=1 id_str=]
>
> The first run is ok. But I cannot reassociate. Below you'll see the
> output of wpa_supplicant and iwevent when I run `wpa_cli reas`.
>
> Now, if I run the adapter in Master mode (as an access point) and then
> go back to Managed mode with wpa_supplicant, the first association and
> authentication will work most of the time (not always).
>
> I'm puzzled but that could be a useful piece of information,
> hopefully. Take into account that my other Eee pc connects always
> perfectly with the very same AP (as mine does when running
> wpa_supplicant for the first time).
>
> Right now I have some troubles in providing some better debugging
> output (I cannot reboot right now, due to some unfinished work that
> must have the precedence), but please let me know what might be useful
> and I'll try to come up with something in the next few days.
>
> Andrea
>
> The wpa_supplicant output:
>
> CTRL-EVENT-SCAN-RESULTS
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Authentication with 00:22:b0:70:1f:67 timed out.
> CTRL-EVENT-SCAN-RESULTS
> WPS-AP-AVAILABLE
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Authentication with 00:22:b0:70:1f:67 timed out.
> CTRL-EVENT-SCAN-RESULTS
> WPS-AP-AVAILABLE
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Authentication with 00:22:b0:70:1f:67 timed out.
> CTRL-EVENT-SCAN-RESULTS
> WPS-AP-AVAILABLE
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Authentication with 00:22:b0:70:1f:67 timed out.
> CTRL-EVENT-SCAN-RESULTS
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Authentication with 00:22:b0:70:1f:67 timed out.
> CTRL-EVENT-SCAN-RESULTS
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Authentication with 00:22:b0:70:1f:67 timed out.
> CTRL-EVENT-SCAN-RESULTS
> WPS-AP-AVAILABLE
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Authentication with 00:22:b0:70:1f:67 timed out.
>
> The iwevent session:
> Waiting for Wireless Events from interfaces...
> 13:38:18.981673   wlan0    Set Mode:Managed
> 13:38:20.627136   wlan0    Scan request completed
> 13:38:20.652664   wlan0    Set Mode:Managed
> 13:38:20.652715   wlan0    Set Frequency:2.427 GHz (Channel 4)
> 13:38:20.809462   wlan0    Scan request completed
> 13:38:20.817356   wlan0    Association Response IEs:010882848B960C12182432043048606C
> 13:38:20.817430   wlan0    New Access Point/Cell address:00:22:B0:70:1F:67
> 13:39:01.101861   wlan0    Scan request completed
> 13:39:01.103037   wlan0    Set Mode:Managed
> 13:39:01.103086   wlan0    Set Frequency:2.427 GHz (Channel 4)
> 13:39:16.814358   wlan0    Scan request completed
> 13:39:16.814860   wlan0    Set Mode:Managed
> 13:39:16.814895   wlan0    Set Frequency:2.427 GHz (Channel 4)
> 13:39:32.553004   wlan0    Scan request completed
> 13:39:32.553482   wlan0    Set Mode:Managed
> 13:39:32.553518   wlan0    Set Frequency:2.427 GHz (Channel 4)
> 13:39:48.264804   wlan0    Scan request completed
> 13:39:48.265324   wlan0    Set Mode:Managed
> 13:39:48.265360   wlan0    Set Frequency:2.427 GHz (Channel 4)
> 13:40:03.964434   wlan0    Scan request completed
> 13:40:03.964875   wlan0    Set Mode:Managed
> 13:40:03.964912   wlan0    Set Frequency:2.427 GHz (Channel 4)
> 13:40:19.668543   wlan0    Scan request completed
> 13:40:19.668963   wlan0    Set Mode:Managed
> 13:40:19.668998   wlan0    Set Frequency:2.427 GHz (Channel 4)
> 13:40:35.368787   wlan0    Scan request completed
> 13:40:35.369267   wlan0    Set Mode:Managed
> 13:40:35.369307   wlan0    Set Frequency:2.427 GHz (Channel 4)
> 13:40:51.067925   wlan0    Scan request completed
> 13:40:51.068308   wlan0    Set Mode:Managed
> 13:40:51.068338   wlan0    Set Frequency:2.427 GHz (Channel 4)
>
>
> /var/log/messages when turning on the adapter:
> Aug  5 13:35:45 eeepc kernel: cfg80211: Using static regulatory domain info
> Aug  5 13:35:45 eeepc kernel: cfg80211: Regulatory domain: US
> Aug  5 13:35:45 eeepc kernel: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> Aug  5 13:35:45 eeepc kernel: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> Aug  5 13:35:45 eeepc kernel: ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Aug  5 13:35:45 eeepc kernel: ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Aug  5 13:35:45 eeepc kernel: ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Aug  5 13:35:45 eeepc kernel: ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> Aug  5 13:35:45 eeepc kernel: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> Aug  5 13:35:45 eeepc kernel: cfg80211: Calling CRDA for country: US
> Aug  5 13:35:46 eeepc kernel: cfg80211: Regulatory domain changed to country: US
> Aug  5 13:35:46 eeepc kernel: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> Aug  5 13:35:46 eeepc kernel: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
> Aug  5 13:35:46 eeepc kernel: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
> Aug  5 13:35:46 eeepc kernel: ^I(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Aug  5 13:35:46 eeepc kernel: ^I(5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> Aug  5 13:35:46 eeepc kernel: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
> Aug  5 13:35:46 eeepc kernel: ath5k 0000:01:00.0: enabling device (0000 -> 0002)
> Aug  5 13:35:46 eeepc kernel: ath5k 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> Aug  5 13:35:46 eeepc kernel: ath5k 0000:01:00.0: registered as 'phy0'
> Aug  5 13:35:46 eeepc kernel: Registered led device: ath5k-phy0::rx
> Aug  5 13:35:46 eeepc kernel: Registered led device: ath5k-phy0::tx
> Aug  5 13:35:46 eeepc kernel: ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
>
>
> some output from running wpa_supplicant -d:
>
> Authentication with 00:22:b0:70:1f:67 timed out.
> Added BSSID 00:22:b0:70:1f:67 into blacklist
> No keys have been configured - skip key clearing
> State: ASSOCIATING -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> EAPOL: External notification - portEnabled=0
> EAPOL: SUPP_PAE entering state DISCONNECTED
> EAPOL: SUPP_BE entering state INITIALIZE
> EAPOL: External notification - portValid=0
> EAPOL: External notification - EAP success=0
> Setting scan request: 0 sec 0 usec
> State: DISCONNECTED -> SCANNING
> Starting AP scan (specific SSID)
> Scan SSID - hexdump_ascii(len=14):
>     49 73 74 69 74 75 74 6f 20 43 6f 6c 6c 69         Istituto Colli
> Scan requested (ret=0) - scan timeout 30 seconds
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b19 len=8
> Received 820 bytes of scan results (2 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> WPS-AP-AVAILABLE
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - SSID mismatch
>   selected based on WPA IE
>   selected WPA AP 00:22:b0:70:1f:67 ssid='Istituto Colli'
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Cancelling scan request
> WPA: clearing own WPA/RSN IE
> Automatic auth_alg selection: 0x1
> WPA: using IEEE 802.11i/D3.0
> WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
> WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
> WPA: clearing AP RSN IE
> WPA: using GTK TKIP
> WPA: using PTK CCMP
> WPA: using KEY_MGMT WPA-PSK
> WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
> No keys have been configured - skip key clearing
> wpa_driver_wext_set_drop_unencrypted
> State: SCANNING -> ASSOCIATING
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> wpa_driver_wext_associate
> wpa_driver_wext_set_psk
> Setting authentication timeout: 10 sec 0 usec
> EAPOL: External notification - EAP success=0
> EAPOL: External notification - EAP fail=0
> EAPOL: External notification - portControl=Auto
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b06 len=8
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b04 len=12
> Authentication with 00:22:b0:70:1f:67 timed out.
> BSSID 00:22:b0:70:1f:67 blacklist count incremented to 2
> No keys have been configured - skip key clearing
> State: ASSOCIATING -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> EAPOL: External notification - portEnabled=0
> EAPOL: External notification - portValid=0
> EAPOL: External notification - EAP success=0
> Setting scan request: 0 sec 0 usec
> State: DISCONNECTED -> SCANNING
> Starting AP scan (broadcast SSID)
> Scan requested (ret=0) - scan timeout 30 seconds
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b19 len=8
> Received 327 bytes of scan results (1 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - blacklisted
> Try to find non-WPA AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - blacklisted
> No APs found - clear blacklist and try again
> Removed BSSID 00:22:b0:70:1f:67 from blacklist (clear)
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - SSID mismatch
>   selected based on WPA IE
>   selected WPA AP 00:22:b0:70:1f:67 ssid='Istituto Colli'
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Cancelling scan request
> WPA: clearing own WPA/RSN IE
> Automatic auth_alg selection: 0x1
> WPA: using IEEE 802.11i/D3.0
> WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
> WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
> WPA: clearing AP RSN IE
> WPA: using GTK TKIP
> WPA: using PTK CCMP
> WPA: using KEY_MGMT WPA-PSK
> WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
> No keys have been configured - skip key clearing
> wpa_driver_wext_set_drop_unencrypted
> State: SCANNING -> ASSOCIATING
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> wpa_driver_wext_associate
> wpa_driver_wext_set_psk
> Setting authentication timeout: 10 sec 0 usec
> EAPOL: External notification - EAP success=0
> EAPOL: External notification - EAP fail=0
> EAPOL: External notification - portControl=Auto
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b06 len=8
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b04 len=12
> Authentication with 00:22:b0:70:1f:67 timed out.
> Added BSSID 00:22:b0:70:1f:67 into blacklist
> No keys have been configured - skip key clearing
> State: ASSOCIATING -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> EAPOL: External notification - portEnabled=0
> EAPOL: External notification - portValid=0
> EAPOL: External notification - EAP success=0
> Setting scan request: 0 sec 0 usec
> State: DISCONNECTED -> SCANNING
> Starting AP scan (specific SSID)
> Scan SSID - hexdump_ascii(len=7):
>     75 6e 69 74 6e 2d 78                              unitn-x
> Scan requested (ret=0) - scan timeout 30 seconds
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b19 len=8
> Received 327 bytes of scan results (1 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - SSID mismatch
>   selected based on WPA IE
>   selected WPA AP 00:22:b0:70:1f:67 ssid='Istituto Colli'
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Cancelling scan request
> WPA: clearing own WPA/RSN IE
> Automatic auth_alg selection: 0x1
> WPA: using IEEE 802.11i/D3.0
> WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
> WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
> WPA: clearing AP RSN IE
> WPA: using GTK TKIP
> WPA: using PTK CCMP
> WPA: using KEY_MGMT WPA-PSK
> WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
> No keys have been configured - skip key clearing
> wpa_driver_wext_set_drop_unencrypted
> State: SCANNING -> ASSOCIATING
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> wpa_driver_wext_associate
> wpa_driver_wext_set_psk
> Setting authentication timeout: 10 sec 0 usec
> EAPOL: External notification - EAP success=0
> EAPOL: External notification - EAP fail=0
> EAPOL: External notification - portControl=Auto
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b06 len=8
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b04 len=12
> RX ctrl_iface - hexdump_ascii(len=6):
>     53 54 41 54 55 53                                 STATUS
> Authentication with 00:22:b0:70:1f:67 timed out.
> BSSID 00:22:b0:70:1f:67 blacklist count incremented to 2
> No keys have been configured - skip key clearing
> State: ASSOCIATING -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> EAPOL: External notification - portEnabled=0
> EAPOL: External notification - portValid=0
> EAPOL: External notification - EAP success=0
> Setting scan request: 0 sec 0 usec
> State: DISCONNECTED -> SCANNING
> Starting AP scan (specific SSID)
> Scan SSID - hexdump_ascii(len=14):
>     49 73 74 69 74 75 74 6f 20 43 6f 6c 6c 69         Istituto Colli
> Scan requested (ret=0) - scan timeout 30 seconds
> RX ctrl_iface - hexdump_ascii(len=6):
>     53 54 41 54 55 53                                 STATUS
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b19 len=8
> Received 820 bytes of scan results (2 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> WPS-AP-AVAILABLE
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - blacklisted
> 1: 00:1c:f0:f3:b0:ee ssid='ISITWIFI_SEG' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
>   skip - SSID mismatch
>   skip - SSID mismatch
>   skip - SSID mismatch
> Try to find non-WPA AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - blacklisted
> 1: 00:1c:f0:f3:b0:ee ssid='ISITWIFI_SEG' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
>   skip - SSID mismatch
>   skip - SSID mismatch
>   skip - privacy mismatch
> No APs found - clear blacklist and try again
> Removed BSSID 00:22:b0:70:1f:67 from blacklist (clear)
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - SSID mismatch
>   selected based on WPA IE
>   selected WPA AP 00:22:b0:70:1f:67 ssid='Istituto Colli'
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Cancelling scan request
> WPA: clearing own WPA/RSN IE
> Automatic auth_alg selection: 0x1
> WPA: using IEEE 802.11i/D3.0
> WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
> WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
> WPA: clearing AP RSN IE
> WPA: using GTK TKIP
> WPA: using PTK CCMP
> WPA: using KEY_MGMT WPA-PSK
> WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
> No keys have been configured - skip key clearing
> wpa_driver_wext_set_drop_unencrypted
> State: SCANNING -> ASSOCIATING
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> wpa_driver_wext_associate
> wpa_driver_wext_set_psk
> Setting authentication timeout: 10 sec 0 usec
> EAPOL: External notification - EAP success=0
> EAPOL: External notification - EAP fail=0
> EAPOL: External notification - portControl=Auto
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b06 len=8
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b04 len=12
> Authentication with 00:22:b0:70:1f:67 timed out.
> Added BSSID 00:22:b0:70:1f:67 into blacklist
> No keys have been configured - skip key clearing
> State: ASSOCIATING -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> EAPOL: External notification - portEnabled=0
> EAPOL: External notification - portValid=0
> EAPOL: External notification - EAP success=0
> Setting scan request: 0 sec 0 usec
> State: DISCONNECTED -> SCANNING
> Starting AP scan (broadcast SSID)
> Scan requested (ret=0) - scan timeout 30 seconds
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b19 len=8
> Received 327 bytes of scan results (1 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - SSID mismatch
>   selected based on WPA IE
>   selected WPA AP 00:22:b0:70:1f:67 ssid='Istituto Colli'
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Cancelling scan request
> WPA: clearing own WPA/RSN IE
> Automatic auth_alg selection: 0x1
> WPA: using IEEE 802.11i/D3.0
> WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
> WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
> WPA: clearing AP RSN IE
> WPA: using GTK TKIP
> WPA: using PTK CCMP
> WPA: using KEY_MGMT WPA-PSK
> WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
> No keys have been configured - skip key clearing
> wpa_driver_wext_set_drop_unencrypted
> State: SCANNING -> ASSOCIATING
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> wpa_driver_wext_associate
> wpa_driver_wext_set_psk
> Setting authentication timeout: 10 sec 0 usec
> EAPOL: External notification - EAP success=0
> EAPOL: External notification - EAP fail=0
> EAPOL: External notification - portControl=Auto
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b06 len=8
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b04 len=12
> Authentication with 00:22:b0:70:1f:67 timed out.
> BSSID 00:22:b0:70:1f:67 blacklist count incremented to 2
> No keys have been configured - skip key clearing
> State: ASSOCIATING -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> EAPOL: External notification - portEnabled=0
> EAPOL: External notification - portValid=0
> EAPOL: External notification - EAP success=0
> Setting scan request: 0 sec 0 usec
> State: DISCONNECTED -> SCANNING
> Starting AP scan (specific SSID)
> Scan SSID - hexdump_ascii(len=7):
>     75 6e 69 74 6e 2d 78                              unitn-x
> Scan requested (ret=0) - scan timeout 30 seconds
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b19 len=8
> Received 820 bytes of scan results (2 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> WPS-AP-AVAILABLE
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - blacklisted
> 1: 00:1c:f0:f3:b0:ee ssid='ISITWIFI_SEG' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
>   skip - SSID mismatch
>   skip - SSID mismatch
>   skip - SSID mismatch
> Try to find non-WPA AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - blacklisted
> 1: 00:1c:f0:f3:b0:ee ssid='ISITWIFI_SEG' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
>   skip - SSID mismatch
>   skip - SSID mismatch
>   skip - privacy mismatch
> No APs found - clear blacklist and try again
> Removed BSSID 00:22:b0:70:1f:67 from blacklist (clear)
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - SSID mismatch
>   selected based on WPA IE
>   selected WPA AP 00:22:b0:70:1f:67 ssid='Istituto Colli'
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Cancelling scan request
> WPA: clearing own WPA/RSN IE
> Automatic auth_alg selection: 0x1
> WPA: using IEEE 802.11i/D3.0
> WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
> WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
> WPA: clearing AP RSN IE
> WPA: using GTK TKIP
> WPA: using PTK CCMP
> WPA: using KEY_MGMT WPA-PSK
> WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
> No keys have been configured - skip key clearing
> wpa_driver_wext_set_drop_unencrypted
> State: SCANNING -> ASSOCIATING
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> wpa_driver_wext_associate
> wpa_driver_wext_set_psk
> Setting authentication timeout: 10 sec 0 usec
> EAPOL: External notification - EAP success=0
> EAPOL: External notification - EAP fail=0
> EAPOL: External notification - portControl=Auto
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b06 len=8
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b04 len=12
> Authentication with 00:22:b0:70:1f:67 timed out.
> Added BSSID 00:22:b0:70:1f:67 into blacklist
> No keys have been configured - skip key clearing
> State: ASSOCIATING -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> EAPOL: External notification - portEnabled=0
> EAPOL: External notification - portValid=0
> EAPOL: External notification - EAP success=0
> Setting scan request: 0 sec 0 usec
> State: DISCONNECTED -> SCANNING
> Starting AP scan (specific SSID)
> Scan SSID - hexdump_ascii(len=14):
>     49 73 74 69 74 75 74 6f 20 43 6f 6c 6c 69         Istituto Colli
> Scan requested (ret=0) - scan timeout 30 seconds
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b19 len=8
> Received 327 bytes of scan results (1 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - SSID mismatch
>   selected based on WPA IE
>   selected WPA AP 00:22:b0:70:1f:67 ssid='Istituto Colli'
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Cancelling scan request
> WPA: clearing own WPA/RSN IE
> Automatic auth_alg selection: 0x1
> WPA: using IEEE 802.11i/D3.0
> WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
> WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
> WPA: clearing AP RSN IE
> WPA: using GTK TKIP
> WPA: using PTK CCMP
> WPA: using KEY_MGMT WPA-PSK
> WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
> No keys have been configured - skip key clearing
> wpa_driver_wext_set_drop_unencrypted
> State: SCANNING -> ASSOCIATING
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> wpa_driver_wext_associate
> wpa_driver_wext_set_psk
> Setting authentication timeout: 10 sec 0 usec
> EAPOL: External notification - EAP success=0
> EAPOL: External notification - EAP fail=0
> EAPOL: External notification - portControl=Auto
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b06 len=8
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b04 len=12
> Authentication with 00:22:b0:70:1f:67 timed out.
> BSSID 00:22:b0:70:1f:67 blacklist count incremented to 2
> No keys have been configured - skip key clearing
> State: ASSOCIATING -> DISCONNECTED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> EAPOL: External notification - portEnabled=0
> EAPOL: External notification - portValid=0
> EAPOL: External notification - EAP success=0
> Setting scan request: 0 sec 0 usec
> State: DISCONNECTED -> SCANNING
> Starting AP scan (broadcast SSID)
> Scan requested (ret=0) - scan timeout 30 seconds
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b19 len=8
> Received 327 bytes of scan results (1 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - blacklisted
> Try to find non-WPA AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - blacklisted
> No APs found - clear blacklist and try again
> Removed BSSID 00:22:b0:70:1f:67 from blacklist (clear)
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> 0: 00:22:b0:70:1f:67 ssid='Istituto Colli' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
>   skip - SSID mismatch
>   selected based on WPA IE
>   selected WPA AP 00:22:b0:70:1f:67 ssid='Istituto Colli'
> Trying to associate with 00:22:b0:70:1f:67 (SSID='Istituto Colli' freq=2427 MHz)
> Cancelling scan request
> WPA: clearing own WPA/RSN IE
> Automatic auth_alg selection: 0x1
> WPA: using IEEE 802.11i/D3.0
> WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
> WPA: set AP WPA IE - hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02
> WPA: clearing AP RSN IE
> WPA: using GTK TKIP
> WPA: using PTK CCMP
> WPA: using KEY_MGMT WPA-PSK
> WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
> No keys have been configured - skip key clearing
> wpa_driver_wext_set_drop_unencrypted
> State: SCANNING -> ASSOCIATING
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> wpa_driver_wext_associate
> wpa_driver_wext_set_psk
> Setting authentication timeout: 10 sec 0 usec
> EAPOL: External notification - EAP success=0
> EAPOL: External notification - EAP fail=0
> EAPOL: External notification - portControl=Auto
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b06 len=8
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> Wireless event: cmd=0x8b04 len=12
> Authentication with 00:22:b0:70:1f:67 timed out.
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>
