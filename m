Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40397 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab0LAXIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 18:08:43 -0500
Received: by qyk12 with SMTP id 12so9601688qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 15:08:43 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTinUFXCEAXcp6d=riFMtgq4Y-Na6_NJaRiymTOmB@mail.gmail.com>
References: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
	<AANLkTinUFXCEAXcp6d=riFMtgq4Y-Na6_NJaRiymTOmB@mail.gmail.com>
Date: Thu, 2 Dec 2010 00:08:42 +0100
Message-ID: <AANLkTimAF-fx5JSkyrT3Af+2xu-nE=dHa2WVqOkVCVWj@mail.gmail.com>
Subject: Re: [linux-next] next-20101201: ath5k permanently disconnecting
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 11:05 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2010/12/1 Sedat Dilek <sedat.dilek@googlemail.com>:
>> Hi,
>>
>> I have built today a linux-next (next-20101201) kernel which includes
>> wireless-next-2.6 up to master-2010-11-30.
>>
>> From tig utility:
>> 2010-11-30 15:33 Stanislaw Gruszka  [wireless-next-2.6] iwlagn: fix
>> microcode error on 4965
>> [main] 61790c5f3c5f158821821a00797d94504531839f - commit 1929 of 226338 (0%)
>>
>> Unfortunately, my wlan network connection is totally unstable.
>>
>> $ dmesg | grep "RX AssocResp" | wc -l
>> 216
>>
>> The block looks like this:
>> [ 4436.504059] ieee80211 phy0: wlan0: No probe response from AP
>> 00:04:0e:e4:00:3d after 500ms, disconnecting.
>> [ 4436.504490] cfg80211: Calling CRDA to update world regulatory domain
>> [ 4440.677020] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
>> [ 4440.679096] wlan0: authenticated
>> [ 4440.679158] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
>> [ 4440.684667] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411
>> status=0 aid=1)
>> [ 4440.684673] wlan0: associated
>>
>> My wlan device is an ath5k:
>>
>> $ lspci -nnvv | grep "Ethernet controller" | grep -i ath
>> 02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
>> 802.11abg NIC [168c:1014] (rev 01)
>>
>> Any idea what's wrong? (Just speculating on the last patch-set from Nick...)
>> How can I help to dig into this problem?
>> Debug-session with wpasupplicant? Which kernel-parameters (debug) to
>> be considered/set?
>>
>> Kind Regards,
>> - Sedat -
>>
>
> That's weird I tested all patches for connectivity + iperf, maybe
> something else also went on the tree that results such behavior...
>
> 1) Are you using NetworkManager ? If so disable it and connect manually.

No NM here, using "classic" /etc/network/interfaces with IP-static setup.

[ /etc/network/interfaces ]
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The wireless LAN interface
auto wlan0
iface wlan0 inet static
        address 192.168.178.25
        netmask 255.255.255.0
        broadcast 192.168.178.255
        gateway 192.168.178.1
        dns-nameservers 192.168.178.1 208.67.222.222 208.67.220.220
        wpa-ssid myCastle-WLAN WPA (Wireless LAN)
        wpa-psk mySecretPWD
- EOF -

> 2) Can you disable encryption on your AP and see if it works without it ?

[ /etc/network/interfaces ]
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The wireless LAN interface

allow-hotplug wlan0
iface wlan0 inet dhcp
        wpa-key-mgmt NONE
        wpa-ssid myCastle-WLAN WPA (Wireless LAN)
- EOF -

Router "open" and ath5k "normal":

Dec  1 23:49:26 tbox kernel: [ 8192.504060] ieee80211 phy0: wlan0: No
probe response from AP 00:04:0e:e4:00:3d after 500ms, disconnecting.
Dec  1 23:49:26 tbox wpa_supplicant[5472]: CTRL-EVENT-DISCONNECTED -
Disconnect event - remove keys
Dec  1 23:49:26 tbox kernel: [ 8192.517097] cfg80211: Calling CRDA to
update world regulatory domain
Dec  1 23:49:31 tbox wpa_supplicant[5472]: Trying to associate with
00:04:0e:e4:00:3d (SSID='myCastle-WLAN WPA (Wireless LAN)' freq=2442
MHz)
Dec  1 23:49:31 tbox kernel: [ 8196.683802] wlan0: authenticate with
00:04:0e:e4:00:3d (try 1)
Dec  1 23:49:31 tbox kernel: [ 8196.686256] wlan0: authenticated
Dec  1 23:49:31 tbox kernel: [ 8196.686302] wlan0: associate with
00:04:0e:e4:00:3d (try 1)
Dec  1 23:49:31 tbox kernel: [ 8196.688608] wlan0: RX AssocResp from
00:04:0e:e4:00:3d (capab=0x401 status=0 aid=1)
Dec  1 23:49:31 tbox kernel: [ 8196.688620] wlan0: associated
Dec  1 23:49:31 tbox wpa_supplicant[5472]: Associated with 00:04:0e:e4:00:3d
Dec  1 23:49:31 tbox wpa_supplicant[5472]: CTRL-EVENT-CONNECTED -
Connection to 00:04:0e:e4:00:3d completed (reauth) [id=0 id_str=]

Router "open" ath5k with nohwcrypt=1:

Dec  1 23:51:20 tbox kernel: [ 8306.504080] ieee80211 phy0: wlan0: No
probe response from AP 00:04:0e:e4:00:3d after 500ms, disconnecting.
Dec  1 23:51:20 tbox kernel: [ 8306.504968] cfg80211: Calling CRDA to
update world regulatory domain
Dec  1 23:51:22 tbox ntpdate[5739]: adjust time server 192.53.103.108
offset 0.001238 sec
Dec  1 23:51:25 tbox wpa_supplicant[5677]: Trying to associate with
00:04:0e:e4:00:3d (SSID='myCastle-WLAN WPA (Wireless LAN)' freq=2442
MHz)
Dec  1 23:51:25 tbox kernel: [ 8310.755922] wlan0: authenticate with
00:04:0e:e4:00:3d (try 1)
Dec  1 23:51:25 tbox kernel: [ 8310.758023] wlan0: authenticated
Dec  1 23:51:25 tbox kernel: [ 8310.758103] wlan0: associate with
00:04:0e:e4:00:3d (try 1)
Dec  1 23:51:25 tbox kernel: [ 8310.760738] wlan0: RX AssocResp from
00:04:0e:e4:00:3d (capab=0x401 status=0 aid=1)
Dec  1 23:51:25 tbox kernel: [ 8310.760750] wlan0: associated
Dec  1 23:51:25 tbox wpa_supplicant[5677]: Associated with 00:04:0e:e4:00:3d
Dec  1 23:51:25 tbox wpa_supplicant[5677]: CTRL-EVENT-CONNECTED -
Connection to 00:04:0e:e4:00:3d completed (reauth) [id=0 id_str=]



> 3) Try and enable/disable hw encryption with nohwcrypt module parameter.

# modinfo ath5k | grep nohwcrypt
parm:           nohwcrypt:Disable hardware encryption. (bool)

# modprobe -v ath5k nohwcrypt=1

# lsmod | egrep -i 'ath|80211|aes'
ath5k                 137422  0
ath                    10977  1 ath5k
mac80211              150863  1 ath5k
cfg80211               97248  3 ath5k,ath,mac80211
aes_i586                6856  0
aes_generic            25758  1 aes_i586
rfkill                 10754  4 cfg80211,bluetooth,thinkpad_acpi

Same error-messages AFAICS:

Dec  1 23:22:27 tbox kernel: [ 6573.500056] ieee80211 phy0: wlan0: No
probe response from AP 00:04:0e:e4:00:3d after 500ms, disconnecting.
Dec  1 23:22:27 tbox kernel: [ 6573.500541] cfg80211: Calling CRDA to
update world regulatory domain
Dec  1 23:22:32 tbox wpa_supplicant[3372]: Trying to associate with
00:04:0e:e4:00:3d (SSID='myCastle-WLAN WPA (Wireless LAN)' freq=2442
MHz)
Dec  1 23:22:32 tbox kernel: [ 6577.739895] wlan0: authenticate with
00:04:0e:e4:00:3d (try 1)
Dec  1 23:22:32 tbox kernel: [ 6577.741981] wlan0: authenticated
Dec  1 23:22:32 tbox kernel: [ 6577.742028] wlan0: associate with
00:04:0e:e4:00:3d (try 1)
Dec  1 23:22:32 tbox kernel: [ 6577.747151] wlan0: RX AssocResp from
00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
Dec  1 23:22:32 tbox kernel: [ 6577.747163] wlan0: associated
Dec  1 23:22:32 tbox wpa_supplicant[3372]: Associated with 00:04:0e:e4:00:3d
Dec  1 23:22:33 tbox wpa_supplicant[3372]: WPA: Key negotiation
completed with 00:04:0e:e4:00:3d [PTK=CCMP GTK=CCMP]
Dec  1 23:22:33 tbox wpa_supplicant[3372]: CTRL-EVENT-CONNECTED -
Connection to 00:04:0e:e4:00:3d completed (reauth) [id=0 id_str=]

> 4) What's your signal strength/rate when you connect to the AP ?

[1] ath5k with nohwcrypt=1 (mostly 1MBps @ -55dBm)

# iw dev wlan0 station dump
Station 00:04:0e:e4:00:3d (on wlan0)
        inactive time:  1876 ms
        rx bytes:       28313
        rx packets:     341
        tx bytes:       4629
        tx packets:     29
        signal:         -66 dBm
        tx bitrate:     1.0 MBit/s

# iw dev wlan0 station dump
Station 00:04:0e:e4:00:3d (on wlan0)
        inactive time:  708 ms
        rx bytes:       26476
        rx packets:     334
        tx bytes:       2835
        tx packets:     10
        signal:         -66 dBm
        tx bitrate:     48.0 MBit/s

[2] ath5k (with no modules options):

# iw dev wlan0 station dump
Station 00:04:0e:e4:00:3d (on wlan0)
        inactive time:  32 ms
        rx bytes:       17987
        rx packets:     197
        tx bytes:       15193
        tx packets:     56
        signal:         -64 dBm
        tx bitrate:     18.0 MBit/s

- Sedat -
