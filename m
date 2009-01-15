Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms046pub.verizon.net ([206.46.252.46]:56713 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935856AbZAOWfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 17:35:07 -0500
Received: from depotrd.localnet ([96.237.21.85])
 by vms046.mailsrvcs.net (Sun Java System Messaging Server 6.2-6.01 (built Apr
 3 2006)) with ESMTPA id <0KDJ00F98APZPOY3@vms046.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Thu, 15 Jan 2009 16:34:49 -0600 (CST)
Date: Thu, 15 Jan 2009 17:34:45 -0500
From: Glenn Burkhardt <gbburkhardt@verizon.net>
Subject: Re: poor performance with ath5k; reverting to ath_pci
In-reply-to: <40f31dec0901140530n7ff2029em67687dcd1eab590f@mail.gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <200901151734.46144.gbburkhardt@verizon.net> (sfid-20090115_233530_592118_8F05F9F7)
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
References: <200901140003.31693.gbburkhardt@verizon.net>
 <40f31dec0901140530n7ff2029em67687dcd1eab590f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 January 2009 08:30:03 Nick Kossifidis wrote:
> 2009/1/14 Glenn Burkhardt <gbburkhardt@verizon.net>:
> > I just upgraded my system to Suse 11.1, and it installed the ath5k
> > driver.  I started having trouble with network access, and found that the
> > response time to the wireless router in my house was lousy:
> >
> > glenn@DepotRd:~> ping 192.168.2.1
> > PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
> > 64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=1233 ms
> > 64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=1901 ms
> > 64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=1550 ms
> >
> > So I pulled the madwifi-0.9.4-1.src.rpm, and re-configured to use the
> > ath_pci driver.  The results were much better:
> >
> > glenn@DepotRd:~> ping 192.168.2.1
> > PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
> > 64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=0.493 ms
> > 64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=0.485 ms
> > 64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=0.501 ms
> > 64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=0.518 ms
> >
> > The card I have is the Netgear WG311T, which reports with PCI ID
> > 0x168c:0x0013, and in the log as "Atheros Communications Inc. Atheros
> > AR5001X+ Wireless Network Adapter (rev 01)".
> >
> > I'd be happy to try to help figure out why the response time is so bad
> > with the ath5k driver, but I'm completely new to this code set.
>
> Can you please post the dmesg output from when ath5k loads ?

With ath_pci driver:

glenn@DepotRd:~> ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=0.974 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=0.946 ms
64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=0.964 ms
64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=1.39 ms
64 bytes from 192.168.2.1: icmp_seq=5 ttl=64 time=0.964 ms
64 bytes from 192.168.2.1: icmp_seq=6 ttl=64 time=0.956 ms
64 bytes from 192.168.2.1: icmp_seq=7 ttl=64 time=0.948 ms
64 bytes from 192.168.2.1: icmp_seq=8 ttl=64 time=0.963 ms
64 bytes from 192.168.2.1: icmp_seq=9 ttl=64 time=0.957 ms
64 bytes from 192.168.2.1: icmp_seq=10 ttl=64 time=1.71 ms
64 bytes from 192.168.2.1: icmp_seq=11 ttl=64 time=3.62 ms
64 bytes from 192.168.2.1: icmp_seq=12 ttl=64 time=0.958 ms
^C
--- 192.168.2.1 ping statistics ---
12 packets transmitted, 12 received, 0% packet loss, time 11043ms
rtt min/avg/max/mdev = 0.946/1.279/3.624/0.744 ms
glenn@DepotRd:~> iwconfig
lo        no wireless extensions.

wifi0     no wireless extensions.

ath0      IEEE 802.11g  ESSID:"Belkin_N_Wireless_A99331"  
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1C:DF:A9:93:31   
          Bit Rate:54 Mb/s   Tx-Power:15 dBm   Sensitivity=1/1  
          Retry:off   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=25/70  Signal level=-70 dBm  Noise level=-95 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

eth0      no wireless extensions.


Shortly thereafter, with ath5k loaded:

DepotRd:/home/gbb-suse # modprobe ath5k
DepotRd:/home/gbb-suse # /etc/init.d/network restart
Shutting down network interfaces:
    eth0      device: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ 
(rev 10)
              No configuration found for eth0 
              Nevertheless the interface will be shut down.          done
    wlan0     device: Atheros Communications Inc. Atheros AR5001X+ Wireless 
Network Adapter (rev 01)                                                 done
Shutting down service network  .  .  .  .  .  .  .  .  .             done
Hint: you may set mandatory devices in /etc/sysconfig/network/config
Setting up network interfaces:
    eth0      device: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ 
(rev 10)
              No configuration found for eth0                        unused
    wlan0     device: Atheros Communications Inc. Atheros AR5001X+ Wireless 
Network Adapter (rev 01)
    wlan0     warning: WPA configured but may be unsupported
    wlan0     warning: by this device
    wlan0     starting wpa_supplicant
    wlan0     Starting DHCP4 client. . . . . . . .  
    wlan0     DHCP4 continues in background                          waiting
Setting up service network  .  .  .  .  .  .  .  .  .  .             done
DepotRd:/home/gbb-suse # ping 192.168.2.1
connect: Network is unreachable
DepotRd:/home/gbb-suse # ifconfig
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:62 errors:0 dropped:0 overruns:0 frame:0
          TX packets:62 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:4028 (3.9 Kb)  TX bytes:4028 (3.9 Kb)

wlan0     Link encap:Ethernet  HWaddr 00:0F:B5:1D:93:2B  
          inet addr:192.168.2.3  Bcast:192.168.2.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

wmaster0  Link encap:UNSPEC  HWaddr 00-0F-
B5-1D-93-2B-00-00-00-00-00-00-00-00-00-00  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

DepotRd:/home/gbb-suse # ping 192.168.2.1
connect: Network is unreachable
DepotRd:/home/gbb-suse # ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=30 ttl=64 time=18.1 ms
64 bytes from 192.168.2.1: icmp_seq=31 ttl=64 time=4.25 ms
64 bytes from 192.168.2.1: icmp_seq=32 ttl=64 time=8.36 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=34 ttl=64 time=4.24 ms
64 bytes from 192.168.2.1: icmp_seq=35 ttl=64 time=10.1 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=37 ttl=64 time=6.25 ms
64 bytes from 192.168.2.1: icmp_seq=38 ttl=64 time=5.95 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=40 ttl=64 time=7.60 ms
64 bytes from 192.168.2.1: icmp_seq=41 ttl=64 time=5.36 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=43 ttl=64 time=7.49 ms
64 bytes from 192.168.2.1: icmp_seq=44 ttl=64 time=6.14 ms
64 bytes from 192.168.2.1: icmp_seq=45 ttl=64 time=1.06 ms
64 bytes from 192.168.2.1: icmp_seq=46 ttl=64 time=6.89 ms
64 bytes from 192.168.2.1: icmp_seq=47 ttl=64 time=6.74 ms
64 bytes from 192.168.2.1: icmp_seq=48 ttl=64 time=0.750 ms
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

wmaster0  Link encap:UNSPEC  HWaddr 00-0F-
B5-1D-93-2B-00-00-00-00-00-00-00-00-00-00  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

DepotRd:/home/gbb-suse # ping 192.168.2.1
connect: Network is unreachable
DepotRd:/home/gbb-suse # ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=30 ttl=64 time=18.1 ms
64 bytes from 192.168.2.1: icmp_seq=31 ttl=64 time=4.25 ms
64 bytes from 192.168.2.1: icmp_seq=32 ttl=64 time=8.36 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=34 ttl=64 time=4.24 ms
64 bytes from 192.168.2.1: icmp_seq=35 ttl=64 time=10.1 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=37 ttl=64 time=6.25 ms
64 bytes from 192.168.2.1: icmp_seq=38 ttl=64 time=5.95 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=40 ttl=64 time=7.60 ms
64 bytes from 192.168.2.1: icmp_seq=41 ttl=64 time=5.36 ms
ping: sendmsg: Network is unreachable
64 bytes from 192.168.2.1: icmp_seq=43 ttl=64 time=7.49 ms
64 bytes from 192.168.2.1: icmp_seq=44 ttl=64 time=6.14 ms
64 bytes from 192.168.2.1: icmp_seq=45 ttl=64 time=1.06 ms
64 bytes from 192.168.2.1: icmp_seq=46 ttl=64 time=6.89 ms
64 bytes from 192.168.2.1: icmp_seq=47 ttl=64 time=6.74 ms
64 bytes from 192.168.2.1: icmp_seq=48 ttl=64 time=0.750 ms
64 bytes from 192.168.2.1: icmp_seq=49 ttl=64 time=6.25 ms
64 bytes from 192.168.2.1: icmp_seq=50 ttl=64 time=5.38 ms
64 bytes from 192.168.2.1: icmp_seq=51 ttl=64 time=0.734 ms
64 bytes from 192.168.2.1: icmp_seq=52 ttl=64 time=6.47 ms
ping: sendmsg: Network is unreachable
^C
--- 192.168.2.1 ping statistics ---
53 packets transmitted, 19 received, 64% packet loss, time 52164ms
rtt min/avg/max/mdev = 0.734/6.228/18.178/3.726 ms
DepotRd:/home/gbb-suse # emacs /var/log/messages &
[1] 2236
DepotRd:/home/gbb-suse # iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"Belkin_N_Wireless_A99331"  
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1C:DF:A9:93:31   
          Bit Rate=54 Mb/s   Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:713A-E283-4CAA-0D17-911E-A88E-B3AC-8C88-E5B3-
AE6C-0923-FC80-5AF4-444F-08EB-4D2E [2]   Security mode:open
          Power Management:off
          Link Quality=37/100  Signal level:-66 dBm  Noise level=-90 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


Output from dmesg:

NET: Registered protocol family 10
lo: Disabled Privacy Extensions
agpgart-sis 0000:00:00.0: AGP 3.5 bridge
agpgart-sis 0000:00:00.0: putting AGP V3 device into 8x mode
nvidia 0000:01:00.0: putting AGP V3 device into 8x mode
NET: Registered protocol family 17
ath0: no IPv6 routers present
bootsplash: status on console 0 changed to on
ath_pci 0000:00:07.0: PCI INT A disabled
ath_pci: driver unloaded
ath_rate_sample: unloaded
wlan: driver unloaded
ath_hal: driver unloaded
ath5k_pci 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k_pci 0000:00:07.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF2112A 2GHz radio found (0x46)
ADDRCONF(NETDEV_UP): wlan0: link is not ready
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: authenticate with AP 00:1c:df:a9:93:31
wlan0: authenticated
wlan0: associate with AP 00:1c:df:a9:93:31
wlan0: RX AssocResp from 00:1c:df:a9:93:31 (capab=0x411 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
padlock: VIA PadLock not detected.
wlan0: no IPv6 routers present



