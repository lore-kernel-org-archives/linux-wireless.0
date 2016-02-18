Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bias.opendreams.net ([107.191.118.74]:46003 "EHLO
	bias.opendreams.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424337AbcBREQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 23:16:53 -0500
Subject: Re: wpa_supplicant bridging problems
To: linux-wireless@vger.kernel.org
References: <56C3E95A.7080104@jmomo.net> <56C4340D.9000508@luceor.com>
 <56C445E2.1050904@jmomo.net>
From: J Mo <jmomo@jmomo.net>
Message-ID: <56C545B3.2060902@jmomo.net> (sfid-20160218_051658_879974_03762AAB)
Date: Wed, 17 Feb 2016 20:16:51 -0800
MIME-Version: 1.0
In-Reply-To: <56C445E2.1050904@jmomo.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I decided to grab another 802.11 adapter and test with it. This time a 
rtl8192cu (ALFA AWUS036NHR). Same behavior. No change.

Here is what happens when I run the Debian ifup script in verbose mode:

user@host-->sudo ifup -v br0
Configuring interface br0=br0 (inet)
iw dev wlan0 set 4addr on
iw dev wlan0 set power_save off
/bin/run-parts --exit-on-error --verbose /etc/network/if-pre-up.d
run-parts: executing /etc/network/if-pre-up.d/bridge

Waiting for a max of 5 seconds for wlan0 to become available.

Waiting for br0 to get ready (MAXWAIT is 2 seconds).
run-parts: executing /etc/network/if-pre-up.d/ethtool
run-parts: executing /etc/network/if-pre-up.d/vlan
run-parts: executing /etc/network/if-pre-up.d/wireless-tools
run-parts: executing /etc/network/if-pre-up.d/wpasupplicant
wpa_supplicant: wpa-bridge br0
wpa_supplicant: wpa-driver nl80211,wext (default)
wpa_supplicant: /sbin/wpa_supplicant -s -B -P 
/run/wpa_supplicant.wlan0.pid -i wlan0 -b br0 -D nl80211,wext -C 
/run/wpa_supplicant
Starting /sbin/wpa_supplicant...
wpa_supplicant: creating sendsigs omission pidfile: 
/run/sendsigs.omit.d/wpasupplicant.wpa_supplicant.wlan0.pid
wpa_supplicant: ctrl_interface socket located at /run/wpa_supplicant/wlan0
wpa_supplicant: configuring network block -- 0
wpa_supplicant: wpa-ssid "POTATONET" -- OK
wpa_supplicant: wpa-psk ***** -- OK
wpa_supplicant: enabling network block 0 -- OK
/bin/ip addr add 192.168.130.251/255.255.255.0 broadcast 192.168.130.255 
       dev br0 label br0
/bin/ip link set dev br0   up

/bin/run-parts --exit-on-error --verbose /etc/network/if-up.d
run-parts: executing /etc/network/if-up.d/000resolvconf
run-parts: executing /etc/network/if-up.d/arping
run-parts: executing /etc/network/if-up.d/avahi-autoipd
run-parts: executing /etc/network/if-up.d/clamav-freshclam-ifupdown
run-parts: executing /etc/network/if-up.d/ethtool
run-parts: executing /etc/network/if-up.d/ip
run-parts: executing /etc/network/if-up.d/mountnfs
run-parts: executing /etc/network/if-up.d/openssh-server
run-parts: executing /etc/network/if-up.d/upstart
run-parts: executing /etc/network/if-up.d/wpasupplicant



It is notable that if I remove the "pre-up iw dev wlan0 set 4addr on" 
parameter from the interfaces config file under br0, I get this error 
when attempting to bring the interface up:

Waiting for a max of 0 seconds for wlan0 to become available.
can't add wlan0 to bridge br0: Operation not supported

So that's the point where the wlan0 interface gets bridged onto br0. 
This indicates that the bridge is definitely exists and wlan0 is a 
member prior to wpa_supplicant being invoked.



On 2/17/16 02:05, J Mo wrote:
>
> I will go look and verify the order of operations for the Debian 
> networking system, but I am under the impression that it brings up the 
> wlan interface (via bridge_ports), does all bridging, and then 
> processes the wpa-* commands.
>
> In other words, it's already doing what you suggested.
>
> Also, wpa_supplicant gives errors if either the 802.11 interface (-i 
> wlan0) or bridge interface (-b br0) wasn't up at the time it was 
> launched, so I don't think it's even possible to get the order wrong 
> without obvious signs. I just don't think that's the issue here.
>
> Still, I'll take your advice and double check. I think I can debug the 
> ifup/down scripts a little more than what I've already done, but I 
> don't think order of operation is an issue.
>
> One thing to note is that if I bridge the wlan0 interface and let an 
> AP-reauth fail and then take the bridge off, wpa_supplicant starts 
> working again. Put the bridge back on and it breaks again, etc. I can 
> do this live with brctl without restarting wpa_supplicant and it will 
> start and stop working.
>
> I don't even understand why wpa_supplicant needs to know about the 
> bridge in this situation, but whatever!
>
> FYI By "official method", I mean the ideal config setup with an 
> "interfaces" config like this:
>
> allow-auto wlan0
> iface wlan0 inet manual
>
> allow-auto br0
> iface br0 inet dhcp
>     bridge_ports wlan0
>     bridge_stp off
>     bridge_waitport 5
>     bridge_fd 0
>     wpa-ssid POTATONET
>     wpa-psk xxxxxxx
>     wpa-iface wlan0
>     wpa-bridge br0
>     pre-up iw dev wlan0 set 4addr on
>     pre-up iw dev wlan0 set power_save off
>
>
>
> On 2/17/16 00:49, Simon Malthieu wrote:
>> Hi,
>>
>> Have you tried to add wlan0 to the bridge **before**
>> wpa_supplicant (with the -b option) is launched ?
>>
>> wpa_supplicant opens a socket to listen to EAPOL frames
>> in the bridge, and it does not seem to work if the interface
>> is not in the bridge at start.
>>
>> Regards,
>> Simon
>>
>>
>> On 17/02/2016 04:30, J Mo wrote:
>>>
>>> Hello everyone
>>>
>>> I am having a very difficult time with a wireless bridging problem.
>>>
>>> My objective is to use a Debian GNU/Linux host as a wireless 
>>> ethernet bridge between itself, some hosts connected through a 
>>> switch on it's eth0 port, and an OpenWRT router.
>>>
>>> I have a test setup consisting of a laptop, a small PC (802.11 
>>> client), and the OpenWRT AP/router.
>>>
>>> The wifi client system is an amd64(intel) with one 802.11 interface 
>>> and a 1000BASE-T interface. The 802.11 hardware here is an Intel 
>>> 3160. The OS is Debian GNU/Linux unstable with kernel 4.3.0-1-amd64 
>>> and wpasupplicant package version 2.3-2.3.
>>>
>>> The 802.11 AP is a TP-Link TL-WR710N which is based off the Atheros 
>>> ar9331.
>>>
>>>
>>>
>>> My problem is the moment I bridge the wlan0 interface on the 802.11 
>>> PC client, wpa_supplicant stops doing it's job. It stops responding 
>>> to any EAPOL frames from the AP, even though it seems to be 
>>> receiving them.
>>>
>>> It is noteworthy that the bridging works. I am able to get a DHCP 
>>> lease on the laptop from the OpenWRT AP/router via bridging though 
>>> the PC. Traffic passes both way and everything works great until the 
>>> next WPA rekey event comes along (every 10 minutes by default for 
>>> OpenWRT), and then the client gets deauth'ed from the AP because it 
>>> fails to respond.
>>>
>>> The only way I can get this to work is to first bring up my wlan0 
>>> interface on the PC so that wpa_supplicant authenticates itself 
>>> correctly. Once the 802.11 layer 2 is up, I manually use brctl to 
>>> bridge in the eth0 and wlan0 ports on the PC. Everything works fine 
>>> until the AP wants to rekey or the client needs to re-auth for some 
>>> reason.
>>>
>>>
>>>
>>> Here is what my setup looks like:
>>>
>>> The OpenWRT device setup is pretty standard. The only thing required 
>>> for the bridging is the addition of the "option wds 1" parameter 
>>> under the wifi-iface in the "wireless" config file. The wds 
>>> parameter enables 4-address frames to allow the bridging. In case 
>>> it's relevant, I'm doing WPA2 PSK AES/CCMP.
>>>
>>> My PC/client /etc/network/interfaces file looks kind of like this:
>>>
>>> allow-hotplug eth0
>>> iface eth0 inet manual
>>>
>>> auto wlan0
>>> iface wlan0 inet manual
>>>     wpa-debug-level 2
>>>     wpa-ssid POTATONET
>>>     wpa-psk XXXXXXXXX
>>>     pre-up iw dev wlan0 set 4addr on
>>>     pre-up iw dev wlan0 set power_save off
>>>
>>> allow-auto br0
>>> # iface br0 inet dhcp
>>> iface br0 inet manual
>>>     # bridge_ports wlan0
>>>     bridge_ports none
>>>     bridge_stp off
>>>     bridge_waitport 0
>>>     bridge_fd 0
>>>     # wpa-iface wlan0
>>>     # wpa-bridge br0
>>>
>>>
>>> I bring up wlan0 and br0:
>>>
>>> sudo ifup wlan0
>>> sudo ifup br0
>>>
>>> At this point, the wlan0 port should be associated to the AP, even 
>>> though I don't have any layer 3 interfaces on the PC yet. If I force 
>>> a re-authentication from the AP it works fine. WPA rekey works fine.
>>>
>>> I do this to bridge up the interfaces:
>>>     sudo brctl addif br0 eth0
>>>     sudo brctl addif br0 wlan0
>>>
>>> From this point on, wpa_supplicant stops working correctly. However, 
>>> the bridge works and ethernet frames are being passed between the 
>>> laptop off of PC port eth0 and the OpenWRT AP. Everything is fine 
>>> until the WPA rekey happens and then the wlan0 interface goes down 
>>> and stops working.
>>>
>>> I did a tcpdump to find out what was going on and discovered that 
>>> once the AP asked for re-authentication from the client, no traffic 
>>> was going out of the wlan0 interface on the client PC. This was 
>>> supported by ifconfig TX counters. wpa_supplicant stops replying to 
>>> the AP on the wlan0 interface.
>>>
>>> It should be noted at this point that I am aware wpa_supplicant is 
>>> supposed to need the "-b" argument in this kind of setup, which is 
>>> what the commented-out "wpa-bridge" parameter in the "interfaces" 
>>> file above is for, but it didn't work. I verified the arguments 
>>> given to wpa_supplicant were correct via ps:
>>>
>>> /sbin/wpa_supplicant -s -B -P /run/wpa_supplicant.wlan0.pid -i wlan0 
>>> -b br0 -D nl80211,wext -C /run/wpa_supplicant
>>>
>>>
>>>
>>> Additional notes and observations:
>>>
>>> Just to be clear, I have inspected the macaddr and arp tables on 
>>> both the OpenWRT AP and the laptop and the MACs are correct. The 
>>> wireless bridging is definitely working as expected. Let me know if 
>>> you want output from these commands, but I don't think they are 
>>> relevant.
>>>
>>> The default WPA rekey timer is every 10 minutes on OpenWRT, but I 
>>> can force the AP to re-authenticate the client by doing this:
>>> ubus call hostapd.wlan0 del_client '{"addr":"34:de:1a:zz:zz:zz", 
>>> "reason":1, "deauth":true, "ban_time":0}'
>>>
>>>
>>>
>>> Finally, here is some debugging output (wpa_supplicant -ddd) from 
>>> the client PC during a failed re-auth with the AP.
>>>
>>> http://jmomo.net/files/wpa_probs.txt
>>>
>>>
>>>
>>> What do?
>>>
>>> If additional debugging is needed, let me know what to do. If this 
>>> is a Debian package problem, let me know and I'll go open a bug there.
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

