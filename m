Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange.luceor.com ([178.33.245.144]:24852 "EHLO
	exchange.luceor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784AbcBQIym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 03:54:42 -0500
Subject: Re: wpa_supplicant bridging problems
To: J Mo <jmomo@jmomo.net>, <linux-wireless@vger.kernel.org>
References: <56C3E95A.7080104@jmomo.net>
From: Simon Malthieu <simon.malthieu@luceor.com>
Message-ID: <56C4340D.9000508@luceor.com> (sfid-20160217_095448_283273_0ACE5597)
Date: Wed, 17 Feb 2016 09:49:17 +0100
MIME-Version: 1.0
In-Reply-To: <56C3E95A.7080104@jmomo.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Have you tried to add wlan0 to the bridge **before**
wpa_supplicant (with the -b option) is launched ?

wpa_supplicant opens a socket to listen to EAPOL frames
in the bridge, and it does not seem to work if the interface
is not in the bridge at start.

Regards,
Simon


On 17/02/2016 04:30, J Mo wrote:
>
> Hello everyone
>
> I am having a very difficult time with a wireless bridging problem.
>
> My objective is to use a Debian GNU/Linux host as a wireless ethernet 
> bridge between itself, some hosts connected through a switch on it's 
> eth0 port, and an OpenWRT router.
>
> I have a test setup consisting of a laptop, a small PC (802.11 
> client), and the OpenWRT AP/router.
>
> The wifi client system is an amd64(intel) with one 802.11 interface 
> and a 1000BASE-T interface. The 802.11 hardware here is an Intel 3160. 
> The OS is Debian GNU/Linux unstable with kernel 4.3.0-1-amd64 and 
> wpasupplicant package version 2.3-2.3.
>
> The 802.11 AP is a TP-Link TL-WR710N which is based off the Atheros 
> ar9331.
>
>
>
> My problem is the moment I bridge the wlan0 interface on the 802.11 PC 
> client, wpa_supplicant stops doing it's job. It stops responding to 
> any EAPOL frames from the AP, even though it seems to be receiving them.
>
> It is noteworthy that the bridging works. I am able to get a DHCP 
> lease on the laptop from the OpenWRT AP/router via bridging though the 
> PC. Traffic passes both way and everything works great until the next 
> WPA rekey event comes along (every 10 minutes by default for OpenWRT), 
> and then the client gets deauth'ed from the AP because it fails to 
> respond.
>
> The only way I can get this to work is to first bring up my wlan0 
> interface on the PC so that wpa_supplicant authenticates itself 
> correctly. Once the 802.11 layer 2 is up, I manually use brctl to 
> bridge in the eth0 and wlan0 ports on the PC. Everything works fine 
> until the AP wants to rekey or the client needs to re-auth for some 
> reason.
>
>
>
> Here is what my setup looks like:
>
> The OpenWRT device setup is pretty standard. The only thing required 
> for the bridging is the addition of the "option wds 1" parameter under 
> the wifi-iface in the "wireless" config file. The wds parameter 
> enables 4-address frames to allow the bridging. In case it's relevant, 
> I'm doing WPA2 PSK AES/CCMP.
>
> My PC/client /etc/network/interfaces file looks kind of like this:
>
> allow-hotplug eth0
> iface eth0 inet manual
>
> auto wlan0
> iface wlan0 inet manual
>     wpa-debug-level 2
>     wpa-ssid POTATONET
>     wpa-psk XXXXXXXXX
>     pre-up iw dev wlan0 set 4addr on
>     pre-up iw dev wlan0 set power_save off
>
> allow-auto br0
> # iface br0 inet dhcp
> iface br0 inet manual
>     # bridge_ports wlan0
>     bridge_ports none
>     bridge_stp off
>     bridge_waitport 0
>     bridge_fd 0
>     # wpa-iface wlan0
>     # wpa-bridge br0
>
>
> I bring up wlan0 and br0:
>
> sudo ifup wlan0
> sudo ifup br0
>
> At this point, the wlan0 port should be associated to the AP, even 
> though I don't have any layer 3 interfaces on the PC yet. If I force a 
> re-authentication from the AP it works fine. WPA rekey works fine.
>
> I do this to bridge up the interfaces:
>     sudo brctl addif br0 eth0
>     sudo brctl addif br0 wlan0
>
> From this point on, wpa_supplicant stops working correctly. However, 
> the bridge works and ethernet frames are being passed between the 
> laptop off of PC port eth0 and the OpenWRT AP. Everything is fine 
> until the WPA rekey happens and then the wlan0 interface goes down and 
> stops working.
>
> I did a tcpdump to find out what was going on and discovered that once 
> the AP asked for re-authentication from the client, no traffic was 
> going out of the wlan0 interface on the client PC. This was supported 
> by ifconfig TX counters. wpa_supplicant stops replying to the AP on 
> the wlan0 interface.
>
> It should be noted at this point that I am aware wpa_supplicant is 
> supposed to need the "-b" argument in this kind of setup, which is 
> what the commented-out "wpa-bridge" parameter in the "interfaces" file 
> above is for, but it didn't work. I verified the arguments given to 
> wpa_supplicant were correct via ps:
>
> /sbin/wpa_supplicant -s -B -P /run/wpa_supplicant.wlan0.pid -i wlan0 
> -b br0 -D nl80211,wext -C /run/wpa_supplicant
>
>
>
> Additional notes and observations:
>
> Just to be clear, I have inspected the macaddr and arp tables on both 
> the OpenWRT AP and the laptop and the MACs are correct. The wireless 
> bridging is definitely working as expected. Let me know if you want 
> output from these commands, but I don't think they are relevant.
>
> The default WPA rekey timer is every 10 minutes on OpenWRT, but I can 
> force the AP to re-authenticate the client by doing this:
> ubus call hostapd.wlan0 del_client '{"addr":"34:de:1a:zz:zz:zz", 
> "reason":1, "deauth":true, "ban_time":0}'
>
>
>
> Finally, here is some debugging output (wpa_supplicant -ddd) from the 
> client PC during a failed re-auth with the AP.
>
> http://jmomo.net/files/wpa_probs.txt
>
>
>
> What do?
>
> If additional debugging is needed, let me know what to do. If this is 
> a Debian package problem, let me know and I'll go open a bug there.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

