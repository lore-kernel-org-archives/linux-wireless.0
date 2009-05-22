Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:58518 "EHLO
	spunkymail-a17.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753191AbZEVSG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 14:06:29 -0400
Message-ID: <4A16E98C.2060000@hiramoto.org>
Date: Fri, 22 May 2009 20:06:04 +0200
From: Karl Hiramoto <karl@hiramoto.org>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] hostapd not sending beacons, and no traffic.
References: <4A168B8A.4070609@hiramoto.org> <4A16AD12.2020200@hiramoto.org> <4A16C6DC.7070502@hiramoto.org>
In-Reply-To: <4A16C6DC.7070502@hiramoto.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If anyone can help me with this, I'd appreciate it.  I'm not sure where 
to look next. 

Using wireless-testing from today, but the same occurs on 2.6.30-rc6

I simplified my test case and what fails still is copying from one 
interface to another when routing.   I  now have no bridges.

# ip addr
1: lo: <LOOPBACK,UP,10000> mtu 16436 qdisc noqueue
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
2: eth1: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:13:01:00:02:18 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.55/24 brd 192.168.10.255 scope global eth1
3: eth0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 9e:b6:45:72:d7:98 brd ff:ff:ff:ff:ff:ff
4: wmaster0: <UP,10000> mtu 0 qdisc pfifo_fast qlen 1000
    link/ieee802.11 00:0e:8e:15:6e:16 brd 00:00:00:00:00:00
5: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop qlen 1000
    link/ether 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff
6: wlan0_0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc cbq qlen 1000
    link/ether 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.1/24 brd 192.168.1.255 scope global wlan0_0
8: mon.wlan0_0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast 
qlen 1000
    link/[803] 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff


# ip link
1: lo: <LOOPBACK,UP,10000> mtu 16436 qdisc noqueue
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth1: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:13:01:00:02:18 brd ff:ff:ff:ff:ff:ff
3: eth0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 9e:b6:45:72:d7:98 brd ff:ff:ff:ff:ff:ff
4: wmaster0: <UP,10000> mtu 0 qdisc pfifo_fast qlen 1000
    link/ieee802.11 00:0e:8e:15:6e:16 brd 00:00:00:00:00:00
5: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop qlen 1000
    link/ether 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff
6: wlan0_0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc cbq qlen 1000
    link/ether 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff
8: mon.wlan0_0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast 
qlen 1000
    link/[803] 00:0e:8e:15:6e:16 brd ff:ff:ff:ff:ff:ff


# ip route
192.168.1.0/24 dev wlan0_0  proto kernel  scope link  src 192.168.1.1
192.168.10.0/24 dev eth1  proto kernel  scope link  src 192.168.10.55
127.0.0.0/8 dev lo  scope link
default via 192.168.10.254 dev eth1  proto static


Downloading a 40MB file from a http server on eth1 lan   to  wifi client 
on  access point  wlan0_0,     The connection at some point of the http 
file download fails.


hostapd.conf:

interface=wlan0_0
driver=nl80211
logger_syslog=-1
logger_syslog_level=2
logger_stdout=0
logger_stdout_level=2
dump_file=/tmp/hostapd/hostapd.0.dump
ssid=karl
channel=1
hw_mode=g
auth_algs=1
macaddr_acl=0
accept_mac_file=/tmp/hostapd/hostapd.wlan0_0.accept
deny_mac_file=/tmp/hostapd/hostapd.wlan0_0.deny
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=hiramoto
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
ieee8021x=0
eap_server=0


kernel log messages with modprobe ath9k debug=0xFFFFFFFF


ath9k: 0x10000 => 0xf0010071
ath9k: new IMR 0x918104b4  
ath9k: enable IER          
ath9k: AR_IMR 0x918104b4 IER 0x1
ath9k: 0xf0010071 => 0x10000   
ath9k: disable IER             
ath9k: new IMR 0x10000         
ath9k: 0x10000 => 0xf0010071   
ath9k: new IMR 0x918104b4      
ath9k: enable IER              
ath9k: AR_IMR 0x918104b4 IER 0x1
ath9k: 0xf0010071 => 0x10000   
ath9k: disable IER             
ath9k: new IMR 0x10000         
ath9k: 0x10000 => 0xf0010071   
ath9k: new IMR 0x918104b4      
ath9k: enable IER              
ath9k: AR_IMR 0x918104b4 IER 0x1
ath9k: 0xf0010071 => 0x10000   
ath9k: disable IER             
ath9k: new IMR 0x10000         
ath9k: 0x10000 => 0xf0010071   
ath9k: new IMR 0x918104b4      
ath9k: enable IER              
ath9k: AR_IMR 0x918104b4 IER 0x1
ath9k: slot 1 [tsf 124687418 tsftu 121765 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 124713007 tsftu 121790 intval 100] vif (null) 
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 124738618 tsftu 121815 intval 100] vif (null) 
ath9k: slot 2 [tsf 124764218 tsftu 121840 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 124790116 tsftu 121865 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 124815418 tsftu 121890 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 124841017 tsftu 121915 intval 100] vif (null) 
ath9k: slot 2 [tsf 124866621 tsftu 121940 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 124892217 tsftu 121965 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 124917804 tsftu 121990 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 124943418 tsftu 122015 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 124969107 tsftu 122040 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3b15480                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae78f0 (ffc128f0)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae78f0), link ffc128f0                       
ath9k: TX complete: skb: c3b15480                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae78f0), link (null)                         
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 124994618 tsftu 122065 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125020222 tsftu 122090 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125045910 tsftu 122115 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 125071420 tsftu 122140 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 125097018 tsftu 122165 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125122610 tsftu 122190 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125148459 tsftu 122215 intval 100] vif (null) 
ath9k: slot 2 [tsf 125173808 tsftu 122240 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 125199420 tsftu 122265 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125225099 tsftu 122290 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125250621 tsftu 122315 intval 100] vif (null) 
ath9k: slot 2 [tsf 125276218 tsftu 122340 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 125301817 tsftu 122365 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125327419 tsftu 122390 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           

ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125353017 tsftu 122415 intval 100] vif (null) 
ath9k: slot 2 [tsf 125378619 tsftu 122440 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 125404231 tsftu 122465 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125429787 tsftu 122490 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125455422 tsftu 122515 intval 100] vif (null) 
ath9k: slot 2 [tsf 125481020 tsftu 122540 intval 100] vif (null) 
ath9k: slot 1 [tsf 125506622 tsftu 122565 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125532225 tsftu 122590 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125557818 tsftu 122615 intval 100] vif (null) 
ath9k: slot 2 [tsf 125583420 tsftu 122640 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 125609018 tsftu 122665 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: slot 0 [tsf 125634622 tsftu 122690 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: <7>ath9k: 0xf0010071 => 0x10000                           
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
AR_IMR 0x918104b4 IER 0x1                                        
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125660210 tsftu 122715 intval 100] vif (null) 
ath9k: slot 2 [tsf 125685845 tsftu 122740 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 125711421 tsftu 122765 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125737021 tsftu 122790 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125762817 tsftu 122815 intval 100] vif (null) 
ath9k: slot 2 [tsf 125788217 tsftu 122840 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 125813818 tsftu 122865 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125839404 tsftu 122890 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125865016 tsftu 122915 intval 100] vif (null) 
ath9k: slot 2 [tsf 125890684 tsftu 122940 intval 100] vif (null) 
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: slot 1 [tsf 125916424 tsftu 122965 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 125941823 tsftu 122990 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 125967417 tsftu 123015 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3afe540                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae7980 (ffc12980)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae7980), link ffc12980                       
ath9k: TX complete: skb: c3afe540                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae7980), link (null)                         
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 125993021 tsftu 123040 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 126018616 tsftu 123065 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 126044211 tsftu 123090 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3a5fb40                        
ath9k: qnum: 3, txq depth: 1                                     
ath9k: TXDP[3] = 3ae7a10 (ffc12a10)                              
ath9k: Enable TXE on queue: 3                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 3 (3ae7a10), link ffc12a10                       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 3 (3ae7a10), link ffc12a10                       
ath9k: TX complete: skb: c3a5fb40                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126069817 tsftu 123115 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 126095418 tsftu 123140 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        

ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3afcb40                        
ath9k: qnum: 3, txq depth: 1                                     
ath9k: TXDP[3] = 3ae7aa0 (ffc12aa0)                              
ath9k: Enable TXE on queue: 3                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 3 (3ae7aa0), link ffc12aa0                       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 126120994 tsftu 123165 intval 100] vif c3f3e584
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: Enable TXE on queue: 9                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 3 (3ae7aa0), link ffc12aa0                       
ath9k: TX complete: skb: c3afcb40                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 126146616 tsftu 123190 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126172339 tsftu 123215 intval 100] vif (null) 
ath9k: slot 2 [tsf 126197821 tsftu 123240 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 1 [tsf 126223541 tsftu 123265 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 126249295 tsftu 123290 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126274874 tsftu 123315 intval 100] vif (null) 
ath9k: slot 2 [tsf 126300215 tsftu 123340 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 126325897 tsftu 123365 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 126351417 tsftu 123390 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126377017 tsftu 123415 intval 100] vif (null) 
ath9k: slot 2 [tsf 126402618 tsftu 123440 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 126428217 tsftu 123465 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: slot 0 [tsf 126453820 tsftu 123490 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126479418 tsftu 123515 intval 100] vif (null) 
ath9k: slot 2 [tsf 126505014 tsftu 123540 intval 100] vif (null) 
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: slot 1 [tsf 126530618 tsftu 123565 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 126556217 tsftu 123590 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126581805 tsftu 123615 intval 100] vif (null) 
ath9k: slot 2 [tsf 126607534 tsftu 123640 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 126633031 tsftu 123665 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: slot 0 [tsf 126658618 tsftu 123690 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126684218 tsftu 123715 intval 100] vif (null) 
ath9k: slot 2 [tsf 126709820 tsftu 123740 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 126735492 tsftu 123765 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 126761012 tsftu 123790 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126786617 tsftu 123815 intval 100] vif (null) 
ath9k: slot 2 [tsf 126812359 tsftu 123840 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 126837818 tsftu 123865 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 126863418 tsftu 123890 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126889019 tsftu 123915 intval 100] vif (null) 
ath9k: slot 2 [tsf 126914622 tsftu 123940 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               

ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 126940216 tsftu 123965 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 126965879 tsftu 123990 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c2c03f00                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae7b30 (ffc12b30)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae7b30), link ffc12b30                       
ath9k: TX complete: skb: c2c03f00                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae7b30), link (null)                         
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 126991417 tsftu 124015 intval 100] vif (null) 
ath9k: slot 2 [tsf 127017020 tsftu 124040 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127042617 tsftu 124065 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127068216 tsftu 124090 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 127093818 tsftu 124115 intval 100] vif (null) 
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: slot 2 [tsf 127119417 tsftu 124140 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127145019 tsftu 124165 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127170618 tsftu 124190 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 127196217 tsftu 124215 intval 100] vif (null) 
ath9k: slot 2 [tsf 127221817 tsftu 124240 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127247418 tsftu 124265 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127272990 tsftu 124290 intval 100] vif (null) 
ath9k: slot 3 [tsf 127298606 tsftu 124315 intval 100] vif (null) 
ath9k: slot 2 [tsf 127324265 tsftu 124340 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127349820 tsftu 124365 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127375409 tsftu 124390 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 127401058 tsftu 124415 intval 100] vif (null) 
ath9k: slot 2 [tsf 127426740 tsftu 124440 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127452218 tsftu 124465 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127477829 tsftu 124490 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 127503419 tsftu 124515 intval 100] vif (null) 
ath9k: slot 2 [tsf 127529017 tsftu 124540 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127554622 tsftu 124565 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127580430 tsftu 124590 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 127605816 tsftu 124615 intval 100] vif (null) 
ath9k: slot 2 [tsf 127631418 tsftu 124640 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127657019 tsftu 124665 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127682619 tsftu 124690 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 127708219 tsftu 124715 intval 100] vif (null) 
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: slot 2 [tsf 127734117 tsftu 124740 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     

ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127759420 tsftu 124765 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127785016 tsftu 124790 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 127810616 tsftu 124815 intval 100] vif (null) 
ath9k: slot 2 [tsf 127836219 tsftu 124840 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127861816 tsftu 124865 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127887418 tsftu 124890 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 127913017 tsftu 124915 intval 100] vif (null) 
ath9k: slot 2 [tsf 127938618 tsftu 124940 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 127964222 tsftu 124965 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c2c349c0                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae7bc0 (ffc12bc0)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae7bc0), link ffc12bc0                       
ath9k: TX complete: skb: c2c349c0                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae7bc0), link (null)                         
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 127989965 tsftu 124990 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128015419 tsftu 125015 intval 100] vif (null) 
ath9k: slot 2 [tsf 128041044 tsftu 125040 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128066618 tsftu 125065 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128092219 tsftu 125090 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128117817 tsftu 125115 intval 100] vif (null) 
ath9k: slot 2 [tsf 128143419 tsftu 125140 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128169018 tsftu 125165 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128194615 tsftu 125190 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128220218 tsftu 125215 intval 100] vif (null) 
ath9k: slot 2 [tsf 128245817 tsftu 125240 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128271414 tsftu 125265 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128297017 tsftu 125290 intval 100] vif (null) 
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128322618 tsftu 125315 intval 100] vif (null) 
ath9k: slot 2 [tsf 128348221 tsftu 125340 intval 100] vif (null) 
ath9k: slot 1 [tsf 128373818 tsftu 125365 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128399418 tsftu 125390 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128425016 tsftu 125415 intval 100] vif (null) 
ath9k: slot 2 [tsf 128450854 tsftu 125440 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128476228 tsftu 125465 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128501820 tsftu 125490 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128527418 tsftu 125515 intval 100] vif (null) 
ath9k: slot 2 [tsf 128553017 tsftu 125540 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128578619 tsftu 125565 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     

ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128604217 tsftu 125590 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128629818 tsftu 125615 intval 100] vif (null) 
ath9k: slot 2 [tsf 128655419 tsftu 125640 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128681018 tsftu 125665 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128706617 tsftu 125690 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128732219 tsftu 125715 intval 100] vif (null) 
ath9k: slot 2 [tsf 128757808 tsftu 125740 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128783417 tsftu 125765 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128809015 tsftu 125790 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128834614 tsftu 125815 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 128860218 tsftu 125840 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128885818 tsftu 125865 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 128911419 tsftu 125890 intval 100] vif (null) 
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 128937018 tsftu 125915 intval 100] vif (null) 
ath9k: slot 2 [tsf 128962617 tsftu 125940 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3b17d80                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae7c50 (ffc12c50)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae7c50), link ffc12c50                       
ath9k: TX complete: skb: c3b17d80                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae7c50), link (null)                         
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 128988219 tsftu 125965 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129013819 tsftu 125990 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 3 [tsf 129039419 tsftu 126015 intval 100] vif (null) 
ath9k: slot 2 [tsf 129065037 tsftu 126040 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 129090614 tsftu 126065 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129116527 tsftu 126090 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129141927 tsftu 126115 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129167420 tsftu 126140 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 129193006 tsftu 126165 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129218617 tsftu 126190 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        

ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129244322 tsftu 126215 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129269817 tsftu 126240 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 129295429 tsftu 126265 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129321021 tsftu 126290 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129346720 tsftu 126315 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129372218 tsftu 126340 intval 100] vif (null) 
ath9k: slot 1 [tsf 129397817 tsftu 126365 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129423419 tsftu 126390 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129449125 tsftu 126415 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129474644 tsftu 126440 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 129500225 tsftu 126465 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129525818 tsftu 126490 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129551770 tsftu 126515 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129577018 tsftu 126540 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 129602626 tsftu 126565 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129628476 tsftu 126590 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129653923 tsftu 126615 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129679404 tsftu 126640 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 129705018 tsftu 126665 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129730617 tsftu 126690 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129756645 tsftu 126715 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129781820 tsftu 126740 intval 100] vif (null) 
ath9k: slot 1 [tsf 129807417 tsftu 126765 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129832991 tsftu 126790 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129858732 tsftu 126815 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129884218 tsftu 126840 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 129909819 tsftu 126865 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 129935418 tsftu 126890 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 129961125 tsftu 126915 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3b1d600                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae7ce0 (ffc12ce0)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae7ce0), link ffc12ce0                       
ath9k: TX complete: skb: c3b1d600                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae7ce0), link (null)                         
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 2 [tsf 129986625 tsftu 126940 intval 100] vif (null) 
ath9k: slot 1 [tsf 130012207 tsftu 126965 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 0 [tsf 130037811 tsftu 126990 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 130063523 tsftu 127015 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 enters power save mode      
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
wlan0_0: STA 00:1c:bf:51:63:34 aid 1 exits power save mode       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3a13b40                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae7d70 (ffc12d70)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae7d70), link ffc12d70                       
ath9k: TX complete: skb: c3a13b40                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                

ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae7d70), link (null)                         
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3a133c0                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae7e00 (ffc12e00)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: slot 2 [tsf 130089018 tsftu 127040 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae7e00), link ffc12e00                       
ath9k: TX complete: skb: c3a133c0                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae7e00), link (null)                         
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 130114616 tsftu 127065 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: Writing ofdmbase=12582412   cckbase=12582712              
ath9k: transmitting packet, skb: c3b1fb40                        
ath9k: qnum: 1, txq depth: 1                                     
ath9k: TXDP[1] = 3ae7e90 (ffc12e90)                              
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: transmitting packet, skb: c3b1fe40                        
ath9k: qnum: 1, txq depth: 2                                     
ath9k: link[1] (ffc12e90)=3ae7f20 (ffc12f20)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b1f540                        
ath9k: qnum: 1, txq depth: 3                                     
ath9k: link[1] (ffc12f20)=3ae7fb0 (ffc12fb0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: tx queue 1 (3ae7f20), link ffc12fb0                       
ath9k: TX complete: skb: c3b1fb40                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae7f20), link ffc12fb0                       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
1                                                                
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae85e0), link ffc13820                       
ath9k: TX complete: skb: c3b1bd80                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: transmitting packet, skb: c3a7a240                        
ath9k: qnum: 1, txq depth: 6                                     
ath9k: link[1] (ffc13820)=3ae88b0 (ffc138b0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3a7ad80                        
ath9k: qnum: 1, txq depth: 7                                     
ath9k: link[1] (ffc138b0)=3ae8940 (ffc13940)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3a7a480                        
ath9k: qnum: 1, txq depth: 8                                     
ath9k: link[1] (ffc13940)=3ae89d0 (ffc139d0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: tx queue 1 (3ae8700), link ffc139d0                       
ath9k: TX complete: skb: c3b1ba80                                
ath9k: TX complete: skb: c3b1b3c0                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae8700), link ffc139d0                       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3a7a6c0                        
ath9k: qnum: 1, txq depth: 7                                     
ath9k: link[1] (ffc139d0)=3ae8a60 (ffc13a60)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b1e900                        
ath9k: qnum: 1, txq depth: 8                                     
ath9k: link[1] (ffc13a60)=3ae8af0 (ffc13af0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b1e180                        
ath9k: qnum: 1, txq depth: 9                                     
ath9k: link[1] (ffc13af0)=3ae8b80 (ffc13b80)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: slot 2 [tsf 130191418 tsftu 127140 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8790), link ffc13b80                       
ath9k: TX complete: skb: c3b1b840                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8820), link ffc13b80                       
ath9k: TX complete: skb: c3b1b0c0                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae88b0), link ffc13b80                       
ath9k: TX complete: skb: c3b1b480                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae8940), link ffc13b80                       
ath9k: TX complete: skb: c3a7a240                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3b19a80                        
ath9k: qnum: 1, txq depth: 6                                     
ath9k: link[1] (ffc13b80)=3ae8c10 (ffc13c10)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b19840                        
ath9k: qnum: 1, txq depth: 7                                     
ath9k: link[1] (ffc13c10)=3ae8ca0 (ffc13ca0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b19540                        
ath9k: qnum: 1, txq depth: 8                                     
ath9k: link[1] (ffc13ca0)=3ae8d30 (ffc13d30)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3afde40                        
ath9k: qnum: 1, txq depth: 9                                     
ath9k: link[1] (ffc13d30)=3ae8dc0 (ffc13dc0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3afdf00                        
ath9k: qnum: 1, txq depth: 10                                    
ath9k: link[1] (ffc13dc0)=3ae8e50 (ffc13e50)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c2dbf0c0                        
ath9k: qnum: 1, txq depth: 11                                    
ath9k: link[1] (ffc13e50)=3ae8ee0 (ffc13ee0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae89d0), link ffc13ee0                       
ath9k: TX complete: skb: c3a7ad80                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: slot 1 [tsf 130217186 tsftu 127165 intval 100] vif c3f3e584
ath9k: Enable TXE on queue: 9                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8a60), link ffc13ee0                       
ath9k: TX complete: skb: c3a7a480                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8af0), link ffc13ee0                       
ath9k: TX complete: skb: c3a7a6c0                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3b1dc00                        
ath9k: qnum: 1, txq depth: 9                                     
ath9k: link[1] (ffc13ee0)=3ae8f70 (ffc13f70)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c2e7a180                        
ath9k: qnum: 1, txq depth: 10                                    
ath9k: link[1] (ffc13f70)=3ae9000 (ffc14000)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c2e7a000                        
ath9k: qnum: 1, txq depth: 11                                    
ath9k: link[1] (ffc14000)=3ae9090 (ffc14090)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b15780                        
ath9k: qnum: 1, txq depth: 12                                    
ath9k: link[1] (ffc14090)=3ae9120 (ffc14120)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8b80), link ffc14120                       
ath9k: TX complete: skb: c3b1e900                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8c10), link ffc14120                       
ath9k: TX complete: skb: c3b1e180                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 0 [tsf 130242729 tsftu 127190 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: tx queue 1 (3ae8d30), link ffc14120                       
ath9k: TX complete: skb: c3b19a80                                
ath9k: TX complete: skb: c3b19840                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: transmitting packet, skb: c3b14b40                        
ath9k: qnum: 1, txq depth: 9                                     
ath9k: link[1] (ffc14120)=3ae91b0 (ffc141b0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b173c0                        
ath9k: qnum: 1, txq depth: 10                                    
ath9k: link[1] (ffc141b0)=3ae9240 (ffc14240)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: tx queue 1 (3ae8d30), link ffc14240                       
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8dc0), link ffc14240                       
ath9k: TX complete: skb: c3b19540                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8e50), link ffc14240                       
ath9k: TX complete: skb: c3afde40                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3afca80                        
ath9k: qnum: 1, txq depth: 9                                     
ath9k: link[1] (ffc14240)=3ae92d0 (ffc142d0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3afccc0                        
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: qnum: 1, txq depth: 10                                    
ath9k: link[1] (ffc142d0)=3ae9360 (ffc14360)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3afc480                        
ath9k: qnum: 1, txq depth: 11                                    
ath9k: link[1] (ffc14360)=3ae93f0 (ffc143f0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3a389c0                        
ath9k: qnum: 1, txq depth: 12                                    
ath9k: link[1] (ffc143f0)=3ae9480 (ffc14480)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: tx queue 1 (3ae8ee0), link ffc14480                       
ath9k: TX complete: skb: c3afdf00                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae8f70), link ffc14480                       
ath9k: TX complete: skb: c2dbf0c0                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3b1ce40                        
ath9k: qnum: 1, txq depth: 11                                    
ath9k: link[1] (ffc14480)=3ae9510 (ffc14510)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b1c780                        
ath9k: qnum: 1, txq depth: 12                                    
ath9k: link[1] (ffc14510)=3ae95a0 (ffc145a0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: slot 3 [tsf 130268323 tsftu 127215 intval 100] vif (null) 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x10000 IER 0x0                                    
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae9000), link ffc145a0                       
ath9k: TX complete: skb: c3b1dc00                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae9090), link ffc145a0                       
ath9k: TX complete: skb: c2e7a180                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        

ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae9120), link ffc145a0                       
ath9k: TX complete: skb: c2e7a000                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae91b0), link ffc145a0                       
ath9k: TX complete: skb: c3b15780                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c39f4480                        
ath9k: qnum: 1, txq depth: 9                                     
ath9k: link[1] (ffc145a0)=3ae9630 (ffc14630)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3fe5540                        
ath9k: qnum: 1, txq depth: 10                                    
ath9k: link[1] (ffc14630)=3ae96c0 (ffc146c0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3fe5000                        
ath9k: qnum: 1, txq depth: 11                                    
ath9k: link[1] (ffc146c0)=3ae9750 (ffc14750)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b1fcc0                        
ath9k: qnum: 1, txq depth: 12                                    
ath9k: link[1] (ffc14750)=3ae97e0 (ffc147e0)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: slot 2 [tsf 130295100 tsftu 127241 intval 100] vif (null) 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae9240), link ffc147e0                       
ath9k: TX complete: skb: c3b14b40                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: AR_IMR 0x918104b4 IER 0x0                                 
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae92d0), link ffc147e0                       
ath9k: TX complete: skb: c3b173c0                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
ath9k: transmitting packet, skb: c3f6ac00                        
ath9k: qnum: 1, txq depth: 11                                    
ath9k: link[1] (ffc147e0)=3ae9870 (ffc14870)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: transmitting packet, skb: c3b1b480                        
ath9k: qnum: 1, txq depth: 12                                    
ath9k: link[1] (ffc14870)=3ae9900 (ffc14900)                     
ath9k: Enable TXE on queue: 1                                    
ath9k: 0xf0010071 => 0x10000                                     
ath9k: disable IER                                               
ath9k: new IMR 0x10000                                           
ath9k: tx queue 1 (3ae9360), link ffc14900                       
ath9k: TX complete: skb: c3afca80                                
ath9k: 0x10000 => 0xf0010071                                     
ath9k: new IMR 0x918104b4                                        
ath9k: enable IER                                                
ath9k: AR_IMR 0x918104b4 IER 0x1                                 
th9k: PDADC (0,   0): a29c 1312100f                              
ath9k: PDADC: Chain 0 | PDADC  28 Value  15 | PDADC  29 Value  16 | 
PDADC  30 Value  18 | PDADC  31 Value  19 |
ath9k: PDADC (0,   0): a2a0 
1a181615                                                                           

ath9k: PDADC: Chain 0 | PDADC  32 Value  21 | PDADC  33 Value  22 | 
PDADC  34 Value  24 | PDADC  35 Value  26 |
ath9k: PDADC (0,   0): a2a4 
22201e1c                                                                           

ath9k: PDADC: Chain 0 | PDADC  36 Value  28 | PDADC  37 Value  30 | 
PDADC  38 Value  32 | PDADC  39 Value  34 |
ath9k: PDADC (0,   0): a2a8 
2d2a2724                                                                           

ath9k: PDADC: Chain 0 | PDADC  40 Value  36 | PDADC  41 Value  39 | 
PDADC  42 Value  42 | PDADC  43 Value  45 |
ath9k: PDADC (0,   0): a2ac 
3a363330                                                                           

ath9k: PDADC: Chain 0 | PDADC  44 Value  48 | PDADC  45 Value  51 | 
PDADC  46 Value  54 | PDADC  47 Value  58 |
ath9k: PDADC (0,   0): a2b0 
4c47433e                                                                           

ath9k: PDADC: Chain 0 | PDADC  48 Value  62 | PDADC  49 Value  67 | 
PDADC  50 Value  71 | PDADC  51 Value  76 |
ath9k: PDADC (0,   0): a2b4 
605b5651                                                                           

ath9k: PDADC: Chain 0 | PDADC  52 Value  81 | PDADC  53 Value  86 | 
PDADC  54 Value  91 | PDADC  55 Value  96 |
ath9k: PDADC (0,   0): a2b8 
6f6f6a65                                                                           

ath9k: PDADC: Chain 0 | PDADC  56 Value 101 | PDADC  57 Value 106 | 
PDADC  58 Value 111 | PDADC  59 Value 111 |
ath9k: PDADC (0,   0): a2bc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  60 Value 111 | PDADC  61 Value 111 | 
PDADC  62 Value 111 | PDADC  63 Value 111 |
ath9k: PDADC (0,   0): a2c0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  64 Value 111 | PDADC  65 Value 111 | 
PDADC  66 Value 111 | PDADC  67 Value 111 |
ath9k: PDADC (0,   0): a2c4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  68 Value 111 | PDADC  69 Value 111 | 
PDADC  70 Value 111 | PDADC  71 Value 111 |
ath9k: PDADC (0,   0): a2c8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  72 Value 111 | PDADC  73 Value 111 | 
PDADC  74 Value 111 | PDADC  75 Value 111 |
ath9k: PDADC (0,   0): a2cc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  76 Value 111 | PDADC  77 Value 111 | 
PDADC  78 Value 111 | PDADC  79 Value 111 |
ath9k: PDADC (0,   0): a2d0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  80 Value 111 | PDADC  81 Value 111 | 
PDADC  82 Value 111 | PDADC  83 Value 111 |
ath9k: PDADC (0,   0): a2d4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  84 Value 111 | PDADC  85 Value 111 | 
PDADC  86 Value 111 | PDADC  87 Value 111 |
ath9k: PDADC (0,   0): a2d8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  88 Value 111 | PDADC  89 Value 111 | 
PDADC  90 Value 111 | PDADC  91 Value 111 |
ath9k: PDADC (0,   0): a2dc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  92 Value 111 | PDADC  93 Value 111 | 
PDADC  94 Value 111 | PDADC  95 Value 111 |
ath9k: PDADC (0,   0): a2e0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  96 Value 111 | PDADC  97 Value 111 | 
PDADC  98 Value 111 | PDADC  99 Value 111 |
ath9k: PDADC (0,   0): a2e4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 100 Value 111 | PDADC 101 Value 111 | 
PDADC 102 Value 111 | PDADC 103 Value 111 |
ath9k: PDADC (0,   0): a2e8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 104 Value 111 | PDADC 105 Value 111 | 
PDADC 106 Value 111 | PDADC 107 Value 111 |
ath9k: PDADC (0,   0): a2ec 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 108 Value 111 | PDADC 109 Value 111 | 
PDADC 110 Value 111 | PDADC 111 Value 111 |
ath9k: PDADC (0,   0): a2f0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 112 Value 111 | PDADC 113 Value 111 | 
PDADC 114 Value 111 | PDADC 115 Value 111 |
ath9k: PDADC (0,   0): a2f4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 116 Value 111 | PDADC 117 Value 111 | 
PDADC 118 Value 111 | PDADC 119 Value 111 |
ath9k: PDADC (0,   0): a2f8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 120 Value 111 | PDADC 121 Value 111 | 
PDADC 122 Value 111 | PDADC 123 Value 111 |
ath9k: PDADC (0,   0): a2fc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 124 Value 111 | PDADC 125 Value 111 | 
PDADC 126 Value 111 | PDADC 127 Value 111 |
ath9k: PDADC (1,1000): b280 
0b0a0909                                                                           

ath9k: PDADC: Chain 1 | PDADC   0 Value   9 | PDADC   1 Value   9 | 
PDADC   2 Value  10 | PDADC   3 Value  11 |
ath9k: PDADC (1,1000): b284 
0f0e0d0c                                                                           

ath9k: PDADC: Chain 1 | PDADC   4 Value  12 | PDADC   5 Value  13 | 
PDADC   6 Value  14 | PDADC   7 Value  15 |
ath9k: PDADC (1,1000): b288 
15141211                                                                           

ath9k: PDADC: Chain 1 | PDADC   8 Value  17 | PDADC   9 Value  18 | 
PDADC  10 Value  20 | PDADC  11 Value  21 |
ath9k: PDADC (1,1000): b28c 
1e1c1917                                                                           

ath9k: PDADC: Chain 1 | PDADC  12 Value  23 | PDADC  13 Value  25 | 
PDADC  14 Value  28 | PDADC  15 Value  30 |
ath9k: PDADC (1,1000): b290 
2a272421                                                                           

ath9k: PDADC: Chain 1 | PDADC  16 Value  33 | PDADC  17 Value  36 | 
PDADC  18 Value  39 | PDADC  19 Value  42 |
ath9k: PDADC (1,1000): b294 
3633302d                                                                           

ath9k: PDADC: Chain 1 | PDADC  20 Value  45 | PDADC  21 Value  48 | 
PDADC  22 Value  51 | PDADC  23 Value  54 |
ath9k: PDADC (1,1000): b298 
0f0e3c39                                                                           

ath9k: PDADC: Chain 1 | PDADC  24 Value  57 | PDADC  25 Value  60 | 
PDADC  26 Value  14 | PDADC  27 Value  15 |
ath9k: PDADC (1,1000): b29c 
14131110                                                                           

ath9k: PDADC: Chain 1 | PDADC  28 Value  16 | PDADC  29 Value  17 | 
PDADC  30 Value  19 | PDADC  31 Value  20 |
ath9k: PDADC (1,1000): b2a0 
1b191716                                                                           

ath9k: PDADC: Chain 1 | PDADC  32 Value  22 | PDADC  33 Value  23 | 
PDADC  34 Value  25 | PDADC  35 Value  27 |
ath9k: PDADC (1,1000): b2a4 
24221f1d                                                                           

ath9k: PDADC: Chain 1 | PDADC  36 Value  29 | PDADC  37 Value  31 | 
PDADC  38 Value  34 | PDADC  39 Value  36 |
ath9k: PDADC (1,1000): b2a8 
2f2c2926                                                                           

ath9k: PDADC: Chain 1 | PDADC  40 Value  38 | PDADC  41 Value  41 | 
PDADC  42 Value  44 | PDADC  43 Value  47 |
ath9k: PDADC (1,1000): b2ac 
3c383532                                                                           

ath9k: PDADC: Chain 1 | PDADC  44 Value  50 | PDADC  45 Value  53 | 
PDADC  46 Value  56 | PDADC  47 Value  60 |
ath9k: PDADC (1,1000): b2b0 
564f4942                                                                           

ath9k: PDADC: Chain 1 | PDADC  48 Value  66 | PDADC  49 Value  73 | 
PDADC  50 Value  79 | PDADC  51 Value  86 |
ath9k: PDADC (1,1000): b2b4 
726b645d                                                                           

ath9k: PDADC: Chain 1 | PDADC  52 Value  93 | PDADC  53 Value 100 | 
PDADC  54 Value 107 | PDADC  55 Value 114 |
ath9k: PDADC (1,1000): b2b8 
87878079                                                                           

ath9k: PDADC: Chain 1 | PDADC  56 Value 121 | PDADC  57 Value 128 | 
PDADC  58 Value 135 | PDADC  59 Value 135 |
ath9k: PDADC (1,1000): b2bc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  60 Value 135 | PDADC  61 Value 135 | 
PDADC  62 Value 135 | PDADC  63 Value 135 |
ath9k: PDADC (1,1000): b2c0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  64 Value 135 | PDADC  65 Value 135 | 
PDADC  66 Value 135 | PDADC  67 Value 135 |
ath9k: PDADC (1,1000): b2c4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 135 | 
PDADC  70 Value 135 | PDADC  71 Value 135 |
ath9k: PDADC (1,1000): b2c8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  72 Value 135 | PDADC  73 Value 135 | 
PDADC  74 Value 135 | PDADC  75 Value 135 |
ath9k: PDADC (1,1000): b2cc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  76 Value 135 | PDADC  77 Value 135 | 
PDADC  78 Value 135 | PDADC  79 Value 135 |
ath9k: PDADC (1,1000): b2d0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  80 Value 135 | PDADC  81 Value 135 | 
PDADC  82 Value 135 | PDADC  83 Value 135 |
ath9k: PDADC (1,1000): b2d4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  84 Value 135 | PDADC  85 Value 135 | 
PDADC  86 Value 135 | PDADC  87 Value 135 |
ath9k: PDADC (1,1000): b2d8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  88 Value 135 | PDADC  89 Value 135 | 
PDADC  90 Value 135 | PDADC  91 Value 135 |
ath9k: PDADC (1,1000): b2dc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  92 Value 135 | PDADC  93 Value 135 | 
PDADC  94 Value 135 | PDADC  95 Value 135 |
ath9k: PDADC (1,1000): b2e0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  96 Value 135 | PDADC  97 Value 135 | 
PDADC  98 Value 135 | PDADC  99 Value 135 |
ath9k: PDADC (1,1000): b2e4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 100 Value 135 | PDADC 101 Value 135 | 
PDADC 102 Value 135 | PDADC 103 Value 135 |
ath9k: PDADC (1,1000): b2e8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 104 Value 135 | PDADC 105 Value 135 | 
PDADC 106 Value 135 | PDADC 107 Value 135 |
ath9k: PDADC (1,1000): b2ec 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 108 Value 135 | PDADC 109 Value 135 | 
PDADC 110 Value 135 | PDADC 111 Value 135 |
ath9k: PDADC (1,1000): b2f0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 112 Value 135 | PDADC 113 Value 135 | 
PDADC 114 Value 135 | PDADC 115 Value 135 |
ath9k: PDADC (1,1000): b2f4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 116 Value 135 | PDADC 117 Value 135 | 
PDADC 118 Value 135 | PDADC 119 Value 135 |
ath9k: PDADC (1,1000): b2f8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 120 Value 135 | PDADC 121 Value 135 | 
PDADC 122 Value 135 | PDADC 123 Value 135 |
ath9k: PDADC (1,1000): b2fc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 124 Value 135 | PDADC 125 Value 135 | 
PDADC 126 Value 135 | PDADC 127 Value 135 |
ath9k: PDADC (2,2000): c280 
0c0b0a09                                                                           

ath9k: PDADC: Chain 2 | PDADC   0 Value   9 | PDADC   1 Value  10 | 
PDADC   2 Value  11 | PDADC   3 Value  12 |
ath9k: PDADC (2,2000): c284 
100f0e0d                                                                           

ath9k: PDADC: Chain 2 | PDADC   4 Value  13 | PDADC   5 Value  14 | 
PDADC   6 Value  15 | PDADC   7 Value  16 |
ath9k: PDADC (2,2000): c288 
15141311                                                                           

ath9k: PDADC: Chain 2 | PDADC   8 Value  17 | PDADC   9 Value  19 | 
PDADC  10 Value  20 | PDADC  11 Value  21 |
ath9k: PDADC (2,2000): c28c 
1d1b1917                                                                           

ath9k: PDADC: Chain 2 | PDADC  12 Value  23 | PDADC  13 Value  25 | 
PDADC  14 Value  27 | PDADC  15 Value  29 |
ath9k: PDADC (2,2000): c290 
2825221f                                                                           

ath9k: PDADC: Chain 2 | PDADC  16 Value  31 | PDADC  17 Value  34 | 
PDADC  18 Value  37 | PDADC  19 Value  40 |
ath9k: PDADC (2,2000): c294 
35312e2b                                                                           

ath9k: PDADC: Chain 2 | PDADC  20 Value  43 | PDADC  21 Value  46 | 
PDADC  22 Value  49 | PDADC  23 Value  53 |
ath9k: PDADC (2,2000): c298 
0f413d39                                                                           

ath9k: PDADC: Chain 2 | PDADC  24 Value  57 | PDADC  25 Value  61 | 
PDADC  26 Value  65 | PDADC  27 Value  15 |
ath9k: PDADC (2,2000): c29c 
14121110                                                                           

ath9k: PDADC: Chain 2 | PDADC  28 Value  16 | PDADC  29 Value  17 | 
PDADC  30 Value  18 | PDADC  31 Value  20 |
ath9k: PDADC (2,2000): c2a0 
1a181615                                                                           

ath9k: PDADC: Chain 2 | PDADC  32 Value  21 | PDADC  33 Value  22 | 
PDADC  34 Value  24 | PDADC  35 Value  26 |
ath9k: PDADC (2,2000): c2a4 
23211e1c                                                                           

ath9k: PDADC: Chain 2 | PDADC  36 Value  28 | PDADC  37 Value  30 | 
PDADC  38 Value  33 | PDADC  39 Value  35 |
ath9k: PDADC (2,2000): c2a8 
2e2b2825                                                                           

ath9k: PDADC: Chain 2 | PDADC  40 Value  37 | PDADC  41 Value  40 | 
PDADC  42 Value  43 | PDADC  43 Value  46 |
ath9k: PDADC (2,2000): c2ac 
3c383532                                                                           

ath9k: PDADC: Chain 2 | PDADC  44 Value  50 | PDADC  45 Value  53 | 
PDADC  46 Value  56 | PDADC  47 Value  60 |
ath9k: PDADC (2,2000): c2b0 
56504942                                                                           

ath9k: PDADC: Chain 2 | PDADC  48 Value  66 | PDADC  49 Value  73 | 
PDADC  50 Value  80 | PDADC  51 Value  86 |
ath9k: PDADC (2,2000): c2b4 
6e68625c                                                                           

ath9k: PDADC: Chain 2 | PDADC  52 Value  92 | PDADC  53 Value  98 | 
PDADC  54 Value 104 | PDADC  55 Value 110 |
ath9k: PDADC (2,2000): c2b8 
80807a74                                                                           

ath9k: PDADC: Chain 2 | PDADC  56 Value 116 | PDADC  57 Value 122 | 
PDADC  58 Value 128 | PDADC  59 Value 128 |
ath9k: PDADC (2,2000): c2bc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  60 Value 128 | PDADC  61 Value 128 | 
PDADC  62 Value 128 | PDADC  63 Value 128 |
ath9k: PDADC (2,2000): c2c0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  64 Value 128 | PDADC  65 Value 128 | 
PDADC  66 Value 128 | PDADC  67 Value 128 |
ath9k: PDADC (2,2000): c2c4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  68 Value 128 | PDADC  69 Value 128 | 
PDADC  70 Value 128 | PDADC  71 Value 128 |
ath9k: PDADC (2,2000): c2c8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  72 Value 128 | PDADC  73 Value 128 | 
PDADC  74 Value 128 | PDADC  75 Value 128 |
ath9k: PDADC (2,2000): c2cc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  76 Value 128 | PDADC  77 Value 128 | 
PDADC  78 Value 128 | PDADC  79 Value 128 |
ath9k: PDADC (2,2000): c2d0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  80 Value 128 | PDADC  81 Value 128 | 
PDADC  82 Value 128 | PDADC  83 Value 128 |
ath9k: PDADC (2,2000): c2d4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  84 Value 128 | PDADC  85 Value 128 | 
PDADC  86 Value 128 | PDADC  87 Value 128 |
ath9k: PDADC (2,2000): c2d8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  88 Value 128 | PDADC  89 Value 128 | 
PDADC  90 Value 128 | PDADC  91 Value 128 |
ath9k: PDADC (2,2000): c2dc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  92 Value 128 | PDADC  93 Value 128 | 
PDADC  94 Value 128 | PDADC  95 Value 128 |
ath9k: PDADC (2,2000): c2e0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  96 Value 128 | PDADC  97 Value 128 | 
PDADC  98 Value 128 | PDADC  99 Value 128 |
ath9k: PDADC (2,2000): c2e4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 100 Value 128 | PDADC 101 Value 128 | 
PDADC 102 Value 128 | PDADC 103 Value 128 |
ath9k: PDADC (2,2000): c2e8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 104 Value 128 | PDADC 105 Value 128 | 
PDADC 106 Value 128 | PDADC 107 Value 128 |
ath9k: PDADC (2,2000): c2ec 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 108 Value 128 | PDADC 109 Value 128 | 
PDADC 110 Value 128 | PDADC 111 Value 128 |
ath9k: PDADC (2,2000): c2f0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 112 Value 128 | PDADC 113 Value 128 | 
PDADC 114 Value 128 | PDADC 115 Value 128 |
ath9k: PDADC (2,2000): c2f4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 116 Value 128 | PDADC 117 Value 128 | 
PDADC 118 Value 128 | PDADC 119 Value 128 |
ath9k: PDADC (2,2000): c2f8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 120 Value 128 | PDADC 121 Value 128 | 
PDADC 122 Value 128 | PDADC 123 Value 128 |
ath9k: PDADC (2,2000): c2fc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 124 Value 128 | PDADC 125 Value 128 | 
PDADC 126 Value 128 | PDADC 127 Value 128 |
ath9k: Getting spur idx 0 is2Ghz. 1 val 
8000                                                                  
ath9k: Reset TX queue: 
0                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
1                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
2                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
3                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TXQ, inactive queue: 
4                                                                            

ath9k: Reset TXQ, inactive queue: 
5                                                                            

ath9k: Reset TXQ, inactive queue: 
6                                                                            

ath9k: Reset TXQ, inactive queue: 
7                                                                            

ath9k: Reset TX queue: 
8                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
9                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: ah->misc_mode 
0xc                                                                                       

ath9k: Enable MIB 
counters                                                                                     

ath9k: Reset ANI state opmode 
3                                                                                

ath9k: ANI 
parameters:                                                                                         

ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, 
ofdmWeakSigDetectOff=0                                      
ath9k: cckWeakSigThreshold=0, firstepLevel=0, 
listenTime=270                                                  
ath9k: cycleCount=-629767946, ofdmPhyErrCount=3, 
cckPhyErrCount=4                                             

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=270           
ath9k: cycleCount=-629767946, ofdmPhyErrCount=3, cckPhyErrCount=4      

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=270           
ath9k: cycleCount=-629767946, ofdmPhyErrCount=3, cckPhyErrCount=4      

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=270           
ath9k: cycleCount=-629767946, ofdmPhyErrCount=3, cckPhyErrCount=4      

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=270           
ath9k: cycleCount=-629767946, ofdmPhyErrCount=3, cckPhyErrCount=4      

ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: 0x81801964 => 0xf0010071                   
ath9k: disable IER                                
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c38626c0         
ath9k: qnum: 1, txq depth: 1                      
ath9k: TXDP[1] = 3aea710 (ffc15710)               
ath9k: Enable TXE on queue: 1                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: tx queue 1 (3aea710), link ffc15710        
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aea710), link ffc15710        
ath9k: TX complete: skb: c38626c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: ANI parameters:                            
ath9k: noiseImmunityLevel=1, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=192           
ath9k: cycleCount=11717398, ofdmPhyErrCount=194293, cckPhyErrCount=0   

ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
: Chain 0 | PDADC  64 Value 111 | PDADC  65 Value 111 | PDADC  66 Value 
111 | PDADC  67 Value 111 |
ath9k: PDADC (0,   0): a2c4 
6f6f6f6f                                                              
ath9k: PDADC: Chain 0 | PDADC  68 Value 111 | PDADC  69 Value 111 | 
PDADC  70 Value 111 | PDADC  71 Value 111 |
ath9k: PDADC (0,   0): a2c8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  72 Value 111 | PDADC  73 Value 111 | 
PDADC  74 Value 111 | PDADC  75 Value 111 |
ath9k: PDADC (0,   0): a2cc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  76 Value 111 | PDADC  77 Value 111 | 
PDADC  78 Value 111 | PDADC  79 Value 111 |
ath9k: PDADC (0,   0): a2d0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  80 Value 111 | PDADC  81 Value 111 | 
PDADC  82 Value 111 | PDADC  83 Value 111 |
ath9k: PDADC (0,   0): a2d4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  84 Value 111 | PDADC  85 Value 111 | 
PDADC  86 Value 111 | PDADC  87 Value 111 |
ath9k: PDADC (0,   0): a2d8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  88 Value 111 | PDADC  89 Value 111 | 
PDADC  90 Value 111 | PDADC  91 Value 111 |
ath9k: PDADC (0,   0): a2dc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  92 Value 111 | PDADC  93 Value 111 | 
PDADC  94 Value 111 | PDADC  95 Value 111 |
ath9k: PDADC (0,   0): a2e0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  96 Value 111 | PDADC  97 Value 111 | 
PDADC  98 Value 111 | PDADC  99 Value 111 |
ath9k: PDADC (0,   0): a2e4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 100 Value 111 | PDADC 101 Value 111 | 
PDADC 102 Value 111 | PDADC 103 Value 111 |
ath9k: PDADC (0,   0): a2e8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 104 Value 111 | PDADC 105 Value 111 | 
PDADC 106 Value 111 | PDADC 107 Value 111 |
ath9k: PDADC (0,   0): a2ec 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 108 Value 111 | PDADC 109 Value 111 | 
PDADC 110 Value 111 | PDADC 111 Value 111 |
ath9k: PDADC (0,   0): a2f0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 112 Value 111 | PDADC 113 Value 111 | 
PDADC 114 Value 111 | PDADC 115 Value 111 |
ath9k: PDADC (0,   0): a2f4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 116 Value 111 | PDADC 117 Value 111 | 
PDADC 118 Value 111 | PDADC 119 Value 111 |
ath9k: PDADC (0,   0): a2f8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 120 Value 111 | PDADC 121 Value 111 | 
PDADC 122 Value 111 | PDADC 123 Value 111 |
ath9k: PDADC (0,   0): a2fc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 124 Value 111 | PDADC 125 Value 111 | 
PDADC 126 Value 111 | PDADC 127 Value 111 |
ath9k: PDADC (1,1000): b280 
0b0a0909                                                                           


ath9k: PDADC: Chain 1 | PDADC   0 Value   9 | PDADC   1 Value   9 | 
PDADC   2 Value  10 | PDADC   3 Value  11 |
ath9k: PDADC (1,1000): b284 
0f0e0d0c                                                                           

ath9k: PDADC: Chain 1 | PDADC   4 Value  12 | PDADC   5 Value  13 | 
PDADC   6 Value  14 | PDADC   7 Value  15 |
ath9k: PDADC (1,1000): b288 
15141211                                                                           

ath9k: PDADC: Chain 1 | PDADC   8 Value  17 | PDADC   9 Value  18 | 
PDADC  10 Value  20 | PDADC  11 Value  21 |
ath9k: PDADC (1,1000): b28c 
1e1c1917                                                                           

ath9k: PDADC: Chain 1 | PDADC  12 Value  23 | PDADC  13 Value  25 | 
PDADC  14 Value  28 | PDADC  15 Value  30 |
ath9k: PDADC (1,1000): b290 
2a272421                                                                           

ath9k: PDADC: Chain 1 | PDADC  16 Value  33 | PDADC  17 Value  36 | 
PDADC  18 Value  39 | PDADC  19 Value  42 |
ath9k: PDADC (1,1000): b294 
3633302d                                                                           

ath9k: PDADC: Chain 1 | PDADC  20 Value  45 | PDADC  21 Value  48 | 
PDADC  22 Value  51 | PDADC  23 Value  54 |
ath9k: PDADC (1,1000): b298 
0f0e3c39                                                                           

ath9k: PDADC: Chain 1 | PDADC  24 Value  57 | PDADC  25 Value  60 | 
PDADC  26 Value  14 | PDADC  27 Value  15 |
ath9k: PDADC (1,1000): b29c 
14131110                                                                           

ath9k: PDADC: Chain 1 | PDADC  28 Value  16 | PDADC  29 Value  17 | 
PDADC  30 Value  19 | PDADC  31 Value  20 |
ath9k: PDADC (1,1000): b2a0 
1b191716                                                                           

ath9k: PDADC: Chain 1 | PDADC  32 Value  22 | PDADC  33 Value  23 | 
PDADC  34 Value  25 | PDADC  35 Value  27 |
ath9k: PDADC (1,1000): b2a4 
24221f1d                                                                           

ath9k: PDADC: Chain 1 | PDADC  36 Value  29 | PDADC  37 Value  31 | 
PDADC  38 Value  34 | PDADC  39 Value  36 |
ath9k: PDADC (1,1000): b2a8 
2f2c2926                                                                           

ath9k: PDADC: Chain 1 | PDADC  40 Value  38 | PDADC  41 Value  41 | 
PDADC  42 Value  44 | PDADC  43 Value  47 |
ath9k: PDADC (1,1000): b2ac 
3c383532                                                                           

ath9k: PDADC: Chain 1 | PDADC  44 Value  50 | PDADC  45 Value  53 | 
PDADC  46 Value  56 | PDADC  47 Value  60 |
ath9k: PDADC (1,1000): b2b0 
564f4942                                                                           

ath9k: PDADC: Chain 1 | PDADC  48 Value  66 | PDADC  49 Value  73 | 
PDADC  50 Value  79 | PDADC  51 Value  86 |
ath9k: PDADC (1,1000): b2b4 
726b645d                                                                           

ath9k: PDADC: Chain 1 | PDADC  52 Value  93 | PDADC  53 Value 100 | 
PDADC  54 Value 107 | PDADC  55 Value 114 |
ath9k: PDADC (1,1000): b2b8 
87878079                                                                           

ath9k: PDADC: Chain 1 | PDADC  56 Value 121 | PDADC  57 Value 128 | 
PDADC  58 Value 135 | PDADC  59 Value 135 |
ath9k: PDADC (1,1000): b2bc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  60 Value 135 | PDADC  61 Value 135 | 
PDADC  62 Value 135 | PDADC  63 Value 135 |
ath9k: PDADC (1,1000): b2c0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  64 Value 135 | PDADC  65 Value 135 | 
PDADC  66 Value 135 | PDADC  67 Value 135 |
ath9k: PDADC (1,1000): b2c4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 135 | 
PDADC  70 Value 135 | PDADC  71 Value 135 |
ath9k: PDADC (1,1000): b2c8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  72 Value 135 | PDADC  73 Value 135 | 
PDADC  74 Value 135 | PDADC  75 Value 135 |
ath9k: PDADC (1,1000): b2cc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  76 Value 135 | PDADC  77 Value 135 | 
PDADC  78 Value 135 | PDADC  79 Value 135 |
ath9k: PDADC (1,1000): b2d0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  80 Value 135 | PDADC  81 Value 135 | 
PDADC  82 Value 135 | PDADC  83 Value 135 |
ath9k: PDADC (1,1000): b2d4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  84 Value 135 | PDADC  85 Value 135 | 
PDADC  86 Value 135 | PDADC  87 Value 135 |
ath9k: PDADC (1,1000): b2d8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  88 Value 135 | PDADC  89 Value 135 | 
PDADC  90 Value 135 | PDADC  91 Value 135 |
ath9k: PDADC (1,1000): b2dc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  92 Value 135 | PDADC  93 Value 135 | 
PDADC  94 Value 135 | PDADC  95 Value 135 |
ath9k: PDADC (1,1000): b2e0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  96 Value 135 | PDADC  97 Value 135 | 
PDADC  98 Value 135 | PDADC  99 Value 135 |
ath9k: PDADC (1,1000): b2e4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 100 Value 135 | PDADC 101 Value 135 | 
PDADC 102 Value 135 | PDADC 103 Value 135 |
ath9k: PDADC (1,1000): b2e8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 104 Value 135 | PDADC 105 Value 135 | 
PDADC 106 Value 135 | PDADC 107 Value 135 |
ath9k: PDADC (1,1000): b2ec 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 108 Value 135 | PDADC 109 Value 135 | 
PDADC 110 Value 135 | PDADC 111 Value 135 |
ath9k: PDADC (1,1000): b2f0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 112 Value 135 | PDADC 113 Value 135 | 
PDADC 114 Value 135 | PDADC 115 Value 135 |
ath9k: PDADC (1,1000): b2f4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 116 Value 135 | PDADC 117 Value 135 | 
PDADC 118 Value 135 | PDADC 119 Value 135 |
ath9k: PDADC (1,1000): b2f8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 120 Value 135 | PDADC 121 Value 135 | 
PDADC 122 Value 135 | PDADC 123 Value 135 |
ath9k: PDADC (1,1000): b2fc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 124 Value 135 | PDADC 125 Value 135 | 
PDADC 126 Value 135 | PDADC 127 Value 135 |
ath9k: PDADC (2,2000): c280 
0c0b0a09                                                                           

ath9k: PDADC: Chain 2 | PDADC   0 Value   9 | PDADC   1 Value  10 | 
PDADC   2 Value  11 | PDADC   3 Value  12 |
ath9k: PDADC (2,2000): c284 
100f0e0d                                                                           

ath9k: PDADC: Chain 2 | PDADC   4 Value  13 | PDADC   5 Value  14 | 
PDADC   6 Value  15 | PDADC   7 Value  16 |
ath9k: PDADC (2,2000): c288 
15141311                                                                           

ath9k: PDADC: Chain 2 | PDADC   8 Value  17 | PDADC   9 Value  19 | 
PDADC  10 Value  20 | PDADC  11 Value  21 |
ath9k: PDADC (2,2000): c28c 
1d1b1917                                                                           

ath9k: PDADC: Chain 2 | PDADC  12 Value  23 | PDADC  13 Value  25 | 
PDADC  14 Value  27 | PDADC  15 Value  29 |
ath9k: PDADC (2,2000): c290 
2825221f                                                                           

ath9k: PDADC: Chain 2 | PDADC  16 Value  31 | PDADC  17 Value  34 | 
PDADC  18 Value  37 | PDADC  19 Value  40 |
ath9k: PDADC (2,2000): c294 
35312e2b                                                                           

ath9k: PDADC: Chain 2 | PDADC  20 Value  43 | PDADC  21 Value  46 | 
PDADC  22 Value  49 | PDADC  23 Value  53 |
ath9k: PDADC (2,2000): c298 
0f413d39                                                                           

ath9k: PDADC: Chain 2 | PDADC  24 Value  57 | PDADC  25 Value  61 | 
PDADC  26 Value  65 | PDADC  27 Value  15 |
ath9k: PDADC (2,2000): c29c 
14121110                                                                           

ath9k: PDADC: Chain 2 | PDADC  28 Value  16 | PDADC  29 Value  17 | 
PDADC  30 Value  18 | PDADC  31 Value  20 |
ath9k: PDADC (2,2000): c2a0 
1a181615                                                                           

ath9k: PDADC: Chain 2 | PDADC  32 Value  21 | PDADC  33 Value  22 | 
PDADC  34 Value  24 | PDADC  35 Value  26 |
ath9k: PDADC (2,2000): c2a4 
23211e1c                                                                           

ath9k: PDADC: Chain 2 | PDADC  36 Value  28 | PDADC  37 Value  30 | 
PDADC  38 Value  33 | PDADC  39 Value  35 |
ath9k: PDADC (2,2000): c2a8 
2e2b2825                                                                           

ath9k: PDADC: Chain 2 | PDADC  40 Value  37 | PDADC  41 Value  40 | 
PDADC  42 Value  43 | PDADC  43 Value  46 |
ath9k: PDADC (2,2000): c2ac 
3c383532                                                                           

ath9k: PDADC: Chain 2 | PDADC  44 Value  50 | PDADC  45 Value  53 | 
PDADC  46 Value  56 | PDADC  47 Value  60 |
ath9k: PDADC (2,2000): c2b0 
56504942                                                                           

ath9k: PDADC: Chain 2 | PDADC  48 Value  66 | PDADC  49 Value  73 | 
PDADC  50 Value  80 | PDADC  51 Value  86 |
ath9k: PDADC (2,2000): c2b4 
6e68625c                                                                           

ath9k: PDADC: Chain 2 | PDADC  52 Value  92 | PDADC  53 Value  98 | 
PDADC  54 Value 104 | PDADC  55 Value 110 |
ath9k: PDADC (2,2000): c2b8 
80807a74                                                                           

ath9k: PDADC: Chain 2 | PDADC  56 Value 116 | PDADC  57 Value 122 | 
PDADC  58 Value 128 | PDADC  59 Value 128 |
ath9k: PDADC (2,2000): c2bc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  60 Value 128 | PDADC  61 Value 128 | 
PDADC  62 Value 128 | PDADC  63 Value 128 |
ath9k: PDADC (2,2000): c2c0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  64 Value 128 | PDADC  65 Value 128 | 
PDADC  66 Value 128 | PDADC  67 Value 128 |
ath9k: PDADC (2,2000): c2c4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  68 Value 128 | PDADC  69 Value 128 | 
PDADC  70 Value 128 | PDADC  71 Value 128 |
ath9k: PDADC (2,2000): c2c8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  72 Value 128 | PDADC  73 Value 128 | 
PDADC  74 Value 128 | PDADC  75 Value 128 |
ath9k: PDADC (2,2000): c2cc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  76 Value 128 | PDADC  77 Value 128 | 
PDADC  78 Value 128 | PDADC  79 Value 128 |
ath9k: PDADC (2,2000): c2d0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  80 Value 128 | PDADC  81 Value 128 | 
PDADC  82 Value 128 | PDADC  83 Value 128 |
ath9k: PDADC (2,2000): c2d4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  84 Value 128 | PDADC  85 Value 128 | 
PDADC  86 Value 128 | PDADC  87 Value 128 |
ath9k: PDADC (2,2000): c2d8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  88 Value 128 | PDADC  89 Value 128 | 
PDADC  90 Value 128 | PDADC  91 Value 128 |
ath9k: PDADC (2,2000): c2dc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  92 Value 128 | PDADC  93 Value 128 | 
PDADC  94 Value 128 | PDADC  95 Value 128 |
ath9k: PDADC (2,2000): c2e0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  96 Value 128 | PDADC  97 Value 128 | 
PDADC  98 Value 128 | PDADC  99 Value 128 |
ath9k: PDADC (2,2000): c2e4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 100 Value 128 | PDADC 101 Value 128 | 
PDADC 102 Value 128 | PDADC 103 Value 128 |
ath9k: PDADC (2,2000): c2e8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 104 Value 128 | PDADC 105 Value 128 | 
PDADC 106 Value 128 | PDADC 107 Value 128 |
ath9k: PDADC (2,2000): c2ec 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 108 Value 128 | PDADC 109 Value 128 | 
PDADC 110 Value 128 | PDADC 111 Value 128 |
ath9k: PDADC (2,2000): c2f0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 112 Value 128 | PDADC 113 Value 128 | 
PDADC 114 Value 128 | PDADC 115 Value 128 |
ath9k: PDADC (2,2000): c2f4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 116 Value 128 | PDADC 117 Value 128 | 
PDADC 118 Value 128 | PDADC 119 Value 128 |
ath9k: PDADC (2,2000): c2f8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 120 Value 128 | PDADC 121 Value 128 | 
PDADC 122 Value 128 | PDADC 123 Value 128 |
ath9k: PDADC (2,2000): c2fc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 124 Value 128 | PDADC 125 Value 128 | 
PDADC 126 Value 128 | PDADC 127 Value 128 |
ath9k: Getting spur idx 0 is2Ghz. 1 val 
8000                                                                  
ath9k: Reset TX queue: 
0                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
1                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
2                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
3                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TXQ, inactive queue: 
4                                                                            

ath9k: Reset TXQ, inactive queue: 
5                                                                            

ath9k: Reset TXQ, inactive queue: 
6                                                                            

ath9k: Reset TXQ, inactive queue: 
7                                                                            

ath9k: Reset TX queue: 
8                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
9                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: ah->misc_mode 
0xc                                                                                       

ath9k: Enable MIB 
counters                                                                                     

ath9k: Reset ANI state opmode 
3                                                                                

ath9k: ANI 
parameters:                                                                                         

ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, 
ofdmWeakSigDetectOff=0                                      
ath9k: cckWeakSigThreshold=0, firstepLevel=0, 
listenTime=97                                                   
ath9k: cycleCount=16117360, ofdmPhyErrCount=1, 
cckPhyErrCount=1                                               

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=97            
ath9k: cycleCount=16117360, ofdmPhyErrCount=1, cckPhyErrCount=1        

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=97            
ath9k: cycleCount=16117360, ofdmPhyErrCount=1, cckPhyErrCount=1        

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=97            
ath9k: cycleCount=16117360, ofdmPhyErrCount=1, cckPhyErrCount=1        

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=97            
ath9k: cycleCount=16117360, ofdmPhyErrCount=1, cckPhyErrCount=1        

ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: 0x81801964 => 0xf0010071                   
ath9k: disable IER                                
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c2dbfc00         
ath9k: qnum: 1, txq depth: 1                      
ath9k: TXDP[1] = 3aeb010 (ffc16010)               
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb010), link ffc16010        
ath9k: TX complete: skb: c2dbfc00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: tx queue 1 (3aeb010), link (null)          
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b170c0         
ath9k: qnum: 1, txq depth: 1                      
ath9k: TXDP[1] = 3aeb0a0 (ffc160a0)               
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb0a0), link ffc160a0        
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb0a0), link ffc160a0        
ath9k: TX complete: skb: c3b170c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3a5f780         
ath9k: qnum: 1, txq depth: 1                      
ath9k: TXDP[1] = 3aeb130 (ffc16130)               
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3a5fd80         
ath9k: qnum: 1, txq depth: 2                      
ath9k: link[1] (ffc16130)=3aeb1c0 (ffc161c0)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aeb1c0), link ffc161c0        
ath9k: TX complete: skb: c3a5f780                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: tx queue 1 (3aeb1c0), link ffc161c0        
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1cb40         
ath9k: qnum: 1, txq depth: 2                      
ath9k: link[1] (ffc161c0)=3aeb250 (ffc16250)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1c0c0         
ath9k: qnum: 1, txq depth: 3                      
ath9k: link[1] (ffc16250)=3aeb2e0 (ffc162e0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1c780         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc162e0)=3aeb370 (ffc16370)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb250), link ffc16370        
ath9k: TX complete: skb: c3a5fd80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb2e0), link ffc16370        
ath9k: TX complete: skb: c3b1cb40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb370), link ffc16370        
ath9k: TX complete: skb: c3b1c0c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         

ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c39f4000         
ath9k: qnum: 1, txq depth: 2                      
ath9k: link[1] (ffc16370)=3aeb400 (ffc16400)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3fe5000         
ath9k: qnum: 1, txq depth: 3                      
ath9k: link[1] (ffc16400)=3aeb490 (ffc16490)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3fe5540         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc16490)=3aeb520 (ffc16520)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb400), link ffc16520        
ath9k: TX complete: skb: c3b1c780                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3afdf00         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc16520)=3aeb5b0 (ffc165b0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3afde40         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc165b0)=3aeb640 (ffc16640)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb490), link ffc16640        
ath9k: TX complete: skb: c39f4000                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3b1b480         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc16640)=3aeb6d0 (ffc166d0)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aeb520), link ffc166d0        
ath9k: TX complete: skb: c3fe5000                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb5b0), link ffc166d0        
ath9k: TX complete: skb: c3fe5540                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3a38600         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc166d0)=3aeb760 (ffc16760)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a38c00         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc16760)=3aeb7f0 (ffc167f0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb640), link ffc167f0        
ath9k: TX complete: skb: c3afdf00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb6d0), link ffc167f0        
ath9k: TX complete: skb: c3afde40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1d300         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc167f0)=3aeb880 (ffc16880)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb760), link ffc16880        
ath9k: TX complete: skb: c3b1b480                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb7f0), link ffc16880        
ath9k: TX complete: skb: c3a38600                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3afe300         
ath9k: qnum: 1, txq depth: 3                      
ath9k: link[1] (ffc16880)=3aeb910 (ffc16910)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3afe600         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc16910)=3aeb9a0 (ffc169a0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1af00         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc169a0)=3aeba30 (ffc16a30)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb880), link ffc16a30        
ath9k: TX complete: skb: c3a38c00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb910), link ffc16a30        
ath9k: TX complete: skb: c3b1d300                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3a7a480         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc16a30)=3aebac0 (ffc16ac0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b15780         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc16ac0)=3aebb50 (ffc16b50)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeb9a0), link ffc16b50        
ath9k: TX complete: skb: c3afe300                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeba30), link ffc16b50        
ath9k: TX complete: skb: c3afe600                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1e0c0         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc174e0)=3aec570 (ffc17570)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3b1ec00         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc17570)=3aec600 (ffc17600)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aec3c0), link ffc17600        
ath9k: TX complete: skb: c39f4000                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aec450), link ffc17600        
ath9k: TX complete: skb: c3fe5540                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aec4e0), link ffc17600        
ath9k: TX complete: skb: c3afde40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3a07300         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc17600)=3aec690 (ffc17690)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a07840         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc17690)=3aec720 (ffc17720)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aec570), link ffc17720        
ath9k: TX complete: skb: c3afdf00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3a07cc0         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc17720)=3aec7b0 (ffc177b0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b14e40         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc177b0)=3aec840 (ffc17840)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aec600), link ffc17840        
ath9k: TX complete: skb: c3b1e0c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aec690), link ffc17840        
ath9k: TX complete: skb: c3b1ec00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1b480         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc17840)=3aec8d0 (ffc178d0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3afe600         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc178d0)=3aec960 (ffc17960)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aec720), link ffc17960        
ath9k: TX complete: skb: c3a07300                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aec7b0), link ffc17960        
ath9k: TX complete: skb: c3a07840                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aec840), link ffc17960        
ath9k: TX complete: skb: c3a07cc0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3afe300         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc17960)=3aec9f0 (ffc179f0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3afe240         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc179f0)=3aeca80 (ffc17a80)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aec8d0), link ffc17a80        
ath9k: TX complete: skb: c3b14e40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1da80         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc17a80)=3aecb10 (ffc17b10)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3b1dc00         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc17b10)=3aecba0 (ffc17ba0)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aec960), link ffc17ba0        
ath9k: TX complete: skb: c3b1b480                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aec9f0), link ffc17ba0        
ath9k: TX complete: skb: c3afe600                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3f6ae40         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc17ba0)=3aecc30 (ffc17c30)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1aa80         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc17c30)=3aeccc0 (ffc17cc0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeca80), link ffc17cc0        
ath9k: TX complete: skb: c3afe300                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aecb10), link ffc17cc0        
ath9k: TX complete: skb: c3afe240                 

ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3a7ad80         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc17cc0)=3aecd50 (ffc17d50)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a7aa80         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc17d50)=3aecde0 (ffc17de0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aecba0), link ffc17de0        
ath9k: TX complete: skb: c3b1da80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aecc30), link ffc17de0        
ath9k: TX complete: skb: c3b1dc00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3862840         
ath9k: qnum: 1, txq depth: 5                      
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: link[1] (ffc17de0)=3aece70 (ffc17e70)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b18840         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc17e70)=3aecf00 (ffc17f00)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b189c0         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc17f00)=3aecf90 (ffc17f90)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aeccc0), link ffc17f90        
ath9k: TX complete: skb: c3f6ae40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aecd50), link ffc17f90        
ath9k: TX complete: skb: c3b1aa80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b17c00         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc17f90)=3aed020 (ffc18020)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aecde0), link ffc18020        
ath9k: TX complete: skb: c3a7ad80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aece70), link ffc18020        
ath9k: TX complete: skb: c3a7aa80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aecf00), link ffc18020        
ath9k: TX complete: skb: c3862840                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1ff00         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc18020)=3aed0b0 (ffc180b0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1fcc0         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc180b0)=3aed140 (ffc18140)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1f0c0         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc18140)=3aed1d0 (ffc181d0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aecf90), link ffc181d0        
ath9k: TX complete: skb: c3b18840                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aed020), link ffc181d0        
ath9k: TX complete: skb: c3b189c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aed0b0), link ffc181d0        
ath9k: TX complete: skb: c3b17c00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b199c0         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc181d0)=3aed260 (ffc18260)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b19180         
ath9k: qnum: 1, txq depth: 5                      
ath9k: <7>ath9k: 0xf0010071 => 0x10000            
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
link[1] (ffc18260)=3aed2f0 (ffc182f0)             
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b193c0         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc182f0)=3aed380 (ffc18380)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aed140), link ffc18380        
ath9k: TX complete: skb: c3b1ff00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aed1d0), link ffc18380        
ath9k: TX complete: skb: c3b1fcc0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1c780         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc18380)=3aed410 (ffc18410)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1c600         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc18410)=3aed4a0 (ffc184a0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c39f4780         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc184a0)=3aed530 (ffc18530)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aed260), link ffc18530        
ath9k: TX complete: skb: c3b1f0c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
omplete: skb: c3a38480                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aed9b0), link ffc18bf0        
ath9k: TX complete: skb: c3b1dc00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aeda40), link ffc18bf0        
ath9k: TX complete: skb: c3b1da80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aedad0), link ffc18bf0        
ath9k: TX complete: skb: c3b15780                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1a180         
ath9k: qnum: 1, txq depth: 4                      
ath9k: link[1] (ffc18bf0)=3aedc80 (ffc18c80)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1a600         
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc18c80)=3aedd10 (ffc18d10)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1aa80         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc18d10)=3aedda0 (ffc18da0)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aedb60), link ffc18da0        
ath9k: TX complete: skb: c3b15b40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aedbf0), link ffc18da0        
ath9k: TX complete: skb: c3f6ae40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3a7aa80         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc18da0)=3aede30 (ffc18e30)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a7ad80         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc18e30)=3aedec0 (ffc18ec0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c38629c0         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc18ec0)=3aedf50 (ffc18f50)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3862780         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc18f50)=3aedfe0 (ffc18fe0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aedc80), link ffc18fe0        
ath9k: TX complete: skb: c3b1af00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aedd10), link ffc18fe0        
ath9k: TX complete: skb: c3b1a180                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b189c0         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc18fe0)=3aee070 (ffc19070)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b18840         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc19070)=3aee100 (ffc19100)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b17e40         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc19100)=3aee190 (ffc19190)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aedda0), link ffc19190        
ath9k: TX complete: skb: c3b1a600                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aede30), link ffc19190        
ath9k: TX complete: skb: c3b1aa80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: tx queue 1 (3aedec0), link ffc19190        
ath9k: TX complete: skb: c3a7aa80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aedf50), link ffc19190        
ath9k: TX complete: skb: c3a7ad80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3a13780         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc19190)=3aee220 (ffc19220)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b19e40         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc19220)=3aee2b0 (ffc192b0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b193c0         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc192b0)=3aee340 (ffc19340)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b19840         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc19340)=3aee3d0 (ffc193d0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aedfe0), link ffc193d0        
ath9k: TX complete: skb: c38629c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee070), link ffc193d0        
ath9k: TX complete: skb: c3862780                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1c600         

ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc193d0)=3aee460 (ffc19460)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1c780         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc19460)=3aee4f0 (ffc194f0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee100), link ffc194f0        
ath9k: TX complete: skb: c3b189c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee190), link ffc194f0        
ath9k: TX complete: skb: c3b18840                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee220), link ffc194f0        
ath9k: TX complete: skb: c3b17e40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee2b0), link ffc194f0        
ath9k: TX complete: skb: c3a13780                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee340), link ffc194f0        
ath9k: TX complete: skb: c3b19e40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c2dbf0c0         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc194f0)=3aee580 (ffc19580)      
ath9k: Enable TXE on queue: 1                     
ath9k: <7>ath9k: 0xf0010071 => 0x10000            
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
transmitting packet, skb: c3afee40                
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc19580)=3aee610 (ffc19610)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3afe600         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc19610)=3aee6a0 (ffc196a0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3afe300         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc196a0)=3aee730 (ffc19730)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3aee460), link ffc19730        
ath9k: TX complete: skb: c3b193c0                 
ath9k: TX complete: skb: c3b19840                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: tx queue 1 (3aee460), link ffc19730        
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3afe900         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc19730)=3aee7c0 (ffc197c0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1b480         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc197c0)=3aee850 (ffc19850)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee4f0), link ffc19850        
ath9k: TX complete: skb: c3b1c600                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee580), link ffc19850        
ath9k: TX complete: skb: c3b1c780                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee610), link ffc19850        
ath9k: TX complete: skb: c2dbf0c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee6a0), link ffc19850        
ath9k: TX complete: skb: c3afee40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b13900         
ath9k: qnum: 1, txq depth: 5                      
ath9k: link[1] (ffc19850)=3aee8e0 (ffc198e0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b136c0         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc198e0)=3aee970 (ffc19970)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b13000         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc19970)=3aeea00 (ffc19a00)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b13f00         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc19a00)=3aeea90 (ffc19a90)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee730), link ffc19a90        
ath9k: TX complete: skb: c3afe600                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee7c0), link ffc19a90        
ath9k: TX complete: skb: c3afe300                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1a600         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc19a90)=3aeeb20 (ffc19b20)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1a180         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc19b20)=3aeebb0 (ffc19bb0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee850), link ffc19bb0        
ath9k: TX complete: skb: c3afe900                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3aee8e0), link ffc19bb0        
ath9k: TX complete: skb: c3b1b480                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
MR 0x918104b4 IER 0x1                             
ath9k: transmitting packet, skb: c39f4000         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc1bd70)=3af0e00 (ffc1be00)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c39f4780         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc1be00)=3af0e90 (ffc1be90)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c39f4cc0         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc1be90)=3af0f20 (ffc1bf20)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a07540         
ath9k: qnum: 1, txq depth: 10                     
ath9k: link[1] (ffc1bf20)=3af0fb0 (ffc1bfb0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0b30), link ffc1bfb0        
ath9k: TX complete: skb: c3afd6c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0bc0), link ffc1bfb0        
ath9k: TX complete: skb: c3afd180                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1d780         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc1bfb0)=3af1040 (ffc1c040)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1dc00         
ath9k: qnum: 1, txq depth: 10                     
ath9k: link[1] (ffc1c040)=3af10d0 (ffc1c0d0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0c50), link ffc1c0d0        
ath9k: TX complete: skb: c3b14540                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0ce0), link ffc1c0d0        
ath9k: TX complete: skb: c3b143c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0d70), link ffc1c0d0        
ath9k: TX complete: skb: c3992f00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0e00), link ffc1c0d0        
ath9k: TX complete: skb: c3992240                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b1af00         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc1c0d0)=3af1160 (ffc1c160)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1ac00         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc1c160)=3af11f0 (ffc1c1f0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1a600         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc1c1f0)=3af1280 (ffc1c280)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b1a180         
ath9k: qnum: 1, txq depth: 10                     
ath9k: link[1] (ffc1c280)=3af1310 (ffc1c310)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0e90), link ffc1c310        
ath9k: TX complete: skb: c39f4000                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0f20), link ffc1c310        
ath9k: TX complete: skb: c39f4780                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3a38480         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc1c310)=3af13a0 (ffc1c3a0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b15e40         
ath9k: qnum: 1, txq depth: 10                     
ath9k: link[1] (ffc1c3a0)=3af1430 (ffc1c430)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af0fb0), link ffc1c430        
ath9k: TX complete: skb: c39f4cc0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1040), link ffc1c430        
ath9k: TX complete: skb: c3a07540                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af10d0), link ffc1c430        
ath9k: TX complete: skb: c3b1d780                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1160), link ffc1c430        
ath9k: TX complete: skb: c3b1dc00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b13f00         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc1c430)=3af14c0 (ffc1c4c0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b13000         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc1c4c0)=3af1550 (ffc1c550)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b136c0         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc1c550)=3af15e0 (ffc1c5e0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3afcf00         
ath9k: qnum: 1, txq depth: 10                     
ath9k: link[1] (ffc1c5e0)=3af1670 (ffc1c670)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af11f0), link ffc1c670        
ath9k: TX complete: skb: c3b1af00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            

ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3a7acc0         
ath9k: qnum: 1, txq depth: 10                     
ath9k: link[1] (ffc1c670)=3af1700 (ffc1c700)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a7aa80         
ath9k: qnum: 1, txq depth: 11                     
ath9k: link[1] (ffc1c700)=3af1790 (ffc1c790)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1280), link ffc1c790        
ath9k: TX complete: skb: c3b1ac00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1310), link ffc1c790        
ath9k: TX complete: skb: c3b1a600                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af13a0), link ffc1c790        
ath9k: TX complete: skb: c3b1a180                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1430), link ffc1c790        
ath9k: TX complete: skb: c3a38480                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af14c0), link ffc1c790        
ath9k: TX complete: skb: c3b15e40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: tx queue 1 (3af1550), link ffc1c790        
ath9k: TX complete: skb: c3b13f00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3b19480         
ath9k: qnum: 1, txq depth: 6                      
ath9k: link[1] (ffc1c790)=3af1820 (ffc1c820)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3b19b40         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc1c820)=3af18b0 (ffc1c8b0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b19840         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc1c8b0)=3af1940 (ffc1c940)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b193c0         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc1c940)=3af19d0 (ffc1c9d0)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3af1670), link ffc1c9d0        
ath9k: TX complete: skb: c3b13000                 
ath9k: TX complete: skb: c3b136c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: tx queue 1 (3af1670), link ffc1c9d0        
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: transmitting packet, skb: c3b16780         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc1c9d0)=3af1a60 (ffc1ca60)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3b189c0         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc1ca60)=3af1af0 (ffc1caf0)      
ath9k: Enable TXE on queue: 1                     
ath9k: tx queue 1 (3af1700), link ffc1caf0        
ath9k: TX complete: skb: c3afcf00                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1790), link ffc1caf0        
ath9k: TX complete: skb: c3a7acc0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1820), link ffc1caf0        
ath9k: TX complete: skb: c3a7aa80                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3862780         
ath9k: qnum: 1, txq depth: 7                      
ath9k: link[1] (ffc1caf0)=3af1b80 (ffc1cb80)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a130c0         
ath9k: qnum: 1, txq depth: 8                      
ath9k: link[1] (ffc1cb80)=3af1c10 (ffc1cc10)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a13600         
ath9k: qnum: 1, txq depth: 9                      
ath9k: link[1] (ffc1cc10)=3af1ca0 (ffc1cca0)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a13780         
ath9k: qnum: 1, txq depth: 10                     
ath9k: link[1] (ffc1cca0)=3af1d30 (ffc1cd30)      
ath9k: Enable TXE on queue: 1                     
ath9k: transmitting packet, skb: c3a13240         
ath9k: qnum: 1, txq depth: 11                     
ath9k: link[1] (ffc1cd30)=3af1dc0 (ffc1cdc0)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af18b0), link ffc1cdc0        
ath9k: TX complete: skb: c3b19480                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1940), link ffc1cdc0        
ath9k: TX complete: skb: c3b19b40                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: transmitting packet, skb: c3afd180         
ath9k: qnum: 1, txq depth: 10                     
ath9k: link[1] (ffc1cdc0)=3af1e50 (ffc1ce50)      
ath9k: Enable TXE on queue: 1                     
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af19d0), link ffc1ce50        
ath9k: TX complete: skb: c3b19840                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: tx queue 1 (3af1a60), link ffc1ce50        
ath9k: TX complete: skb: c3b193c0                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  

ath9k: new IMR 0x918104b4
ath9k: enable IER       
ath9k: AR_IMR 0x918104b4 IER 0x1
ath9k: 0xf0010071 => 0x10000   
ath9k: disable IER             
ath9k: new IMR 0x10000         
ath9k: tx queue 1 (3ae18c0), link ffc0ccb0
ath9k: TX complete: skb: c3a38480        
ath9k: 0x10000 => 0xf0010071             
ath9k: new IMR 0x918104b4                
ath9k: enable IER                        
ath9k: AR_IMR 0x918104b4 IER 0x1         
ath9k: 0xf0010071 => 0x10000             
ath9k: disable IER                       
ath9k: new IMR 0x10000                   
ath9k: 0x10000 => 0xf0010071             
ath9k: new IMR 0x918104b4                
ath9k: enable IER                        
ath9k: AR_IMR 0x918104b4 IER 0x1         
ath9k: transmitting packet, skb: c3afc900
ath9k: qnum: 1, txq depth: 9             
ath9k: link[1] (ffc0ccb0)=3ae1d40 (ffc0cd40)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c2c03e40  
ath9k: qnum: 1, txq depth: 10              
ath9k: link[1] (ffc0cd40)=3ae1dd0 (ffc0cdd0)
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c2c030c0  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0cdd0)=3ae1e60 (ffc0ce60)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c2c03840  
ath9k: qnum: 1, txq depth: 12              
ath9k: link[1] (ffc0ce60)=3ae1ef0 (ffc0cef0)
ath9k: Enable TXE on queue: 1              
ath9k: tx queue 1 (3ae1950), link ffc0cef0 
ath9k: TX complete: skb: c3a38240          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae19e0), link ffc0cef0 
ath9k: TX complete: skb: c3af8000          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: transmitting packet, skb: c3b17600  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0cef0)=3ae1f80 (ffc0cf80)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3b17180  
ath9k: qnum: 1, txq depth: 12              
ath9k: link[1] (ffc0cf80)=3ae2010 (ffc0d010)
ath9k: Enable TXE on queue: 1              
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: AR_IMR 0x10000 IER 0x0              
ath9k: tx queue 1 (3ae1a70), link ffc0d010 
ath9k: TX complete: skb: c3afe0c0          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae1b00), link ffc0d010 
ath9k: TX complete: skb: c3afecc0          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae1b90), link ffc0d010 
ath9k: TX complete: skb: c3afee40          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae1c20), link ffc0d010 
ath9k: TX complete: skb: c3b1f600          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: transmitting packet, skb: c3a5f3c0  
ath9k: qnum: 1, txq depth: 9               
ath9k: link[1] (ffc0d010)=3ae20a0 (ffc0d0a0)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3a5f540  
ath9k: qnum: 1, txq depth: 10              
ath9k: link[1] (ffc0d0a0)=3ae2130 (ffc0d130)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3fe5540  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0d130)=3ae21c0 (ffc0d1c0)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3fe5a80  
ath9k: qnum: 1, txq depth: 12              
ath9k: link[1] (ffc0d1c0)=3ae2250 (ffc0d250)
ath9k: Enable TXE on queue: 1              
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae1cb0), link ffc0d250 
ath9k: TX complete: skb: c3b1bf00          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae1d40), link ffc0d250 
ath9k: TX complete: skb: c3b1b480          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: transmitting packet, skb: c3a7aa80  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0d250)=3ae22e0 (ffc0d2e0)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3a07e40  
ath9k: qnum: 1, txq depth: 12              
ath9k: link[1] (ffc0d2e0)=3ae2370 (ffc0d370)
ath9k: Enable TXE on queue: 1              
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae1dd0), link ffc0d370 
ath9k: TX complete: skb: c3afc900          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae1e60), link ffc0d370 
ath9k: TX complete: skb: c2c03e40          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae1ef0), link ffc0d370 
ath9k: TX complete: skb: c2c030c0          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: AR_IMR 0x10000 IER 0x0              
ath9k: tx queue 1 (3ae1f80), link ffc0d370 

ath9k: TX complete: skb: c2c03840          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: transmitting packet, skb: c3b19840  
ath9k: qnum: 1, txq depth: 9               
ath9k: link[1] (ffc0d370)=3ae2400 (ffc0d400)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3b193c0  
ath9k: qnum: 1, txq depth: 10              
ath9k: link[1] (ffc0d400)=3ae2490 (ffc0d490)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3afd300  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0d490)=3ae2520 (ffc0d520)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3afdb40  
ath9k: qnum: 1, txq depth: 12              
ath9k: link[1] (ffc0d520)=3ae25b0 (ffc0d5b0)
ath9k: Enable TXE on queue: 1              
ath9k: tx queue 1 (3ae2010), link ffc0d5b0 
ath9k: TX complete: skb: c3b17600          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae20a0), link ffc0d5b0 
ath9k: TX complete: skb: c3b17180          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: transmitting packet, skb: c2dbf6c0  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0d5b0)=3ae2640 (ffc0d640)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c2dbf480  
ath9k: qnum: 1, txq depth: 12              
ath9k: link[1] (ffc0d640)=3ae26d0 (ffc0d6d0)
ath9k: Enable TXE on queue: 1              
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae2130), link ffc0d6d0 
ath9k: TX complete: skb: c3a5f3c0          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae21c0), link ffc0d6d0 
ath9k: TX complete: skb: c3a5f540          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae2250), link ffc0d6d0 
ath9k: TX complete: skb: c3fe5540          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae22e0), link ffc0d6d0 
ath9k: TX complete: skb: c3fe5a80          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae2370), link ffc0d6d0 
ath9k: TX complete: skb: c3a7aa80          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: transmitting packet, skb: c2c346c0  
ath9k: qnum: 1, txq depth: 8               
ath9k: link[1] (ffc0d6d0)=3ae2760 (ffc0d760)
ath9k: Enable TXE on queue: 1              
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: transmitting packet, skb: c3b17180  
ath9k: qnum: 1, txq depth: 9               
ath9k: link[1] (ffc0d760)=3ae27f0 (ffc0d7f0)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3b17600  
ath9k: qnum: 1, txq depth: 10              
ath9k: link[1] (ffc0d7f0)=3ae2880 (ffc0d880)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3b17240  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0d880)=3ae2910 (ffc0d910)
ath9k: Enable TXE on queue: 1              
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: AR_IMR 0x10000 IER 0x0              
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae2400), link ffc0d910 
ath9k: TX complete: skb: c3a07e40          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: transmitting packet, skb: c3b15180  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0d910)=3ae29a0 (ffc0d9a0)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3b150c0  
ath9k: qnum: 1, txq depth: 12              
ath9k: link[1] (ffc0d9a0)=3ae2a30 (ffc0da30)
ath9k: Enable TXE on queue: 1              
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae2490), link ffc0da30 
ath9k: TX complete: skb: c3b19840          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae2520), link ffc0da30 
ath9k: TX complete: skb: c3b193c0          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae25b0), link ffc0da30 
ath9k: TX complete: skb: c3afd300          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae2640), link ffc0da30 
ath9k: TX complete: skb: c3afdb40          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: transmitting packet, skb: c3b1c840  
ath9k: qnum: 1, txq depth: 9               
ath9k: link[1] (ffc0da30)=3ae2ac0 (ffc0dac0)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3b1c600  
ath9k: qnum: 1, txq depth: 10              
ath9k: link[1] (ffc0dac0)=3ae2b50 (ffc0db50)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3b1cb40  
ath9k: qnum: 1, txq depth: 11              
ath9k: link[1] (ffc0db50)=3ae2be0 (ffc0dbe0)
ath9k: Enable TXE on queue: 1              
ath9k: transmitting packet, skb: c3b1c6c0  
ath9k: qnum: 1, txq depth: 12              
ath9k: link[1] (ffc0dbe0)=3ae2c70 (ffc0dc70)
ath9k: Enable TXE on queue: 1              
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: tx queue 1 (3ae26d0), link ffc0dc70 
ath9k: TX complete: skb: c2dbf6c0          
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
ath9k: 0xf0010071 => 0x10000               
ath9k: disable IER                         
ath9k: new IMR 0x10000                     
ath9k: 0x10000 => 0xf0010071               
ath9k: new IMR 0x918104b4                  
ath9k: enable IER                          
ath9k: AR_IMR 0x918104b4 IER 0x1           
alue 111 | PDADC  62 Value 111 | PDADC  63 Value 111 |
ath9k: PDADC (0,   0): a2c0 6f6f6f6f                 
ath9k: PDADC: Chain 0 | PDADC  64 Value 111 | PDADC  65 Value 111 | 
PDADC  66 Value 111 | PDADC  67 Value 111 |
ath9k: PDADC (0,   0): a2c4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  68 Value 111 | PDADC  69 Value 111 | 
PDADC  70 Value 111 | PDADC  71 Value 111 |
ath9k: PDADC (0,   0): a2c8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  72 Value 111 | PDADC  73 Value 111 | 
PDADC  74 Value 111 | PDADC  75 Value 111 |
ath9k: PDADC (0,   0): a2cc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  76 Value 111 | PDADC  77 Value 111 | 
PDADC  78 Value 111 | PDADC  79 Value 111 |
ath9k: PDADC (0,   0): a2d0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  80 Value 111 | PDADC  81 Value 111 | 
PDADC  82 Value 111 | PDADC  83 Value 111 |
ath9k: PDADC (0,   0): a2d4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  84 Value 111 | PDADC  85 Value 111 | 
PDADC  86 Value 111 | PDADC  87 Value 111 |
ath9k: PDADC (0,   0): a2d8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  88 Value 111 | PDADC  89 Value 111 | 
PDADC  90 Value 111 | PDADC  91 Value 111 |
ath9k: PDADC (0,   0): a2dc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  92 Value 111 | PDADC  93 Value 111 | 
PDADC  94 Value 111 | PDADC  95 Value 111 |
ath9k: PDADC (0,   0): a2e0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC  96 Value 111 | PDADC  97 Value 111 | 
PDADC  98 Value 111 | PDADC  99 Value 111 |
ath9k: PDADC (0,   0): a2e4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 100 Value 111 | PDADC 101 Value 111 | 
PDADC 102 Value 111 | PDADC 103 Value 111 |
ath9k: PDADC (0,   0): a2e8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 104 Value 111 | PDADC 105 Value 111 | 
PDADC 106 Value 111 | PDADC 107 Value 111 |
ath9k: PDADC (0,   0): a2ec 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 108 Value 111 | PDADC 109 Value 111 | 
PDADC 110 Value 111 | PDADC 111 Value 111 |
ath9k: PDADC (0,   0): a2f0 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 112 Value 111 | PDADC 113 Value 111 | 
PDADC 114 Value 111 | PDADC 115 Value 111 |
ath9k: PDADC (0,   0): a2f4 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 116 Value 111 | PDADC 117 Value 111 | 
PDADC 118 Value 111 | PDADC 119 Value 111 |
ath9k: PDADC (0,   0): a2f8 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 120 Value 111 | PDADC 121 Value 111 | 
PDADC 122 Value 111 | PDADC 123 Value 111 |
ath9k: PDADC (0,   0): a2fc 
6f6f6f6f                                                                           

ath9k: PDADC: Chain 0 | PDADC 124 Value 111 | PDADC 125 Value 111 | 
PDADC 126 Value 111 | PDADC 127 Value 111 |
ath9k: PDADC (1,1000): b280 
0b0a0909                                                                           

ath9k: PDADC: Chain 1 | PDADC   0 Value   9 | PDADC   1 Value   9 | 
PDADC   2 Value  10 | PDADC   3 Value  11 |
ath9k: PDADC (1,1000): b284 
0f0e0d0c                                                                           

ath9k: PDADC: Chain 1 | PDADC   4 Value  12 | PDADC   5 Value  13 | 
PDADC   6 Value  14 | PDADC   7 Value  15 |
ath9k: PDADC (1,1000): b288 
15141211                                                                           

ath9k: PDADC: Chain 1 | PDADC   8 Value  17 | PDADC   9 Value  18 | 
PDADC  10 Value  20 | PDADC  11 Value  21 |
ath9k: PDADC (1,1000): b28c 
1e1c1917                                                                           

ath9k: PDADC: Chain 1 | PDADC  12 Value  23 | PDADC  13 Value  25 | 
PDADC  14 Value  28 | PDADC  15 Value  30 |
ath9k: PDADC (1,1000): b290 
2a272421                                                                           

ath9k: PDADC: Chain 1 | PDADC  16 Value  33 | PDADC  17 Value  36 | 
PDADC  18 Value  39 | PDADC  19 Value  42 |
ath9k: PDADC (1,1000): b294 
3633302d                                                                           

ath9k: PDADC: Chain 1 | PDADC  20 Value  45 | PDADC  21 Value  48 | 
PDADC  22 Value  51 | PDADC  23 Value  54 |
ath9k: PDADC (1,1000): b298 
0f0e3c39                                                                           

ath9k: PDADC: Chain 1 | PDADC  24 Value  57 | PDADC  25 Value  60 | 
PDADC  26 Value  14 | PDADC  27 Value  15 |
ath9k: PDADC (1,1000): b29c 
14131110                                                                           

ath9k: PDADC: Chain 1 | PDADC  28 Value  16 | PDADC  29 Value  17 | 
PDADC  30 Value  19 | PDADC  31 Value  20 |
ath9k: PDADC (1,1000): b2a0 
1b191716                                                                           

ath9k: PDADC: Chain 1 | PDADC  32 Value  22 | PDADC  33 Value  23 | 
PDADC  34 Value  25 | PDADC  35 Value  27 |
ath9k: PDADC (1,1000): b2a4 
24221f1d                                                                           

ath9k: PDADC: Chain 1 | PDADC  36 Value  29 | PDADC  37 Value  31 | 
PDADC  38 Value  34 | PDADC  39 Value  36 |
ath9k: PDADC (1,1000): b2a8 
2f2c2926                                                                           

ath9k: PDADC: Chain 1 | PDADC  40 Value  38 | PDADC  41 Value  41 | 
PDADC  42 Value  44 | PDADC  43 Value  47 |
ath9k: PDADC (1,1000): b2ac 
3c383532                                                                           

ath9k: PDADC: Chain 1 | PDADC  44 Value  50 | PDADC  45 Value  53 | 
PDADC  46 Value  56 | PDADC  47 Value  60 |
ath9k: PDADC (1,1000): b2b0 
564f4942                                                                           

ath9k: PDADC: Chain 1 | PDADC  48 Value  66 | PDADC  49 Value  73 | 
PDADC  50 Value  79 | PDADC  51 Value  86 |
ath9k: PDADC (1,1000): b2b4 
726b645d                                                                           

ath9k: PDADC: Chain 1 | PDADC  52 Value  93 | PDADC  53 Value 100 | 
PDADC  54 Value 107 | PDADC  55 Value 114 |
ath9k: PDADC (1,1000): b2b8 
87878079                                                                           

ath9k: PDADC: Chain 1 | PDADC  56 Value 121 | PDADC  57 Value 128 | 
PDADC  58 Value 135 | PDADC  59 Value 135 |
ath9k: PDADC (1,1000): b2bc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  60 Value 135 | PDADC  61 Value 135 | 
PDADC  62 Value 135 | PDADC  63 Value 135 |
ath9k: PDADC (1,1000): b2c0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  64 Value 135 | PDADC  65 Value 135 | 
PDADC  66 Value 135 | PDADC  67 Value 135 |
ath9k: PDADC (1,1000): b2c4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 135 | 
PDADC  70 Value 135 | PDADC  71 Value 135 |
ath9k: PDADC (1,1000): b2c8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  72 Value 135 | PDADC  73 Value 135 | 
PDADC  74 Value 135 | PDADC  75 Value 135 |
ath9k: PDADC (1,1000): b2cc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  76 Value 135 | PDADC  77 Value 135 | 
PDADC  78 Value 135 | PDADC  79 Value 135 |
ath9k: PDADC (1,1000): b2d0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  80 Value 135 | PDADC  81 Value 135 | 
PDADC  82 Value 135 | PDADC  83 Value 135 |
ath9k: PDADC (1,1000): b2d4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  84 Value 135 | PDADC  85 Value 135 | 
PDADC  86 Value 135 | PDADC  87 Value 135 |
ath9k: PDADC (1,1000): b2d8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  88 Value 135 | PDADC  89 Value 135 | 
PDADC  90 Value 135 | PDADC  91 Value 135 |
ath9k: PDADC (1,1000): b2dc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  92 Value 135 | PDADC  93 Value 135 | 
PDADC  94 Value 135 | PDADC  95 Value 135 |
ath9k: PDADC (1,1000): b2e0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC  96 Value 135 | PDADC  97 Value 135 | 
PDADC  98 Value 135 | PDADC  99 Value 135 |
ath9k: PDADC (1,1000): b2e4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 100 Value 135 | PDADC 101 Value 135 | 
PDADC 102 Value 135 | PDADC 103 Value 135 |
ath9k: PDADC (1,1000): b2e8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 104 Value 135 | PDADC 105 Value 135 | 
PDADC 106 Value 135 | PDADC 107 Value 135 |
ath9k: PDADC (1,1000): b2ec 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 108 Value 135 | PDADC 109 Value 135 | 
PDADC 110 Value 135 | PDADC 111 Value 135 |
ath9k: PDADC (1,1000): b2f0 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 112 Value 135 | PDADC 113 Value 135 | 
PDADC 114 Value 135 | PDADC 115 Value 135 |
ath9k: PDADC (1,1000): b2f4 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 116 Value 135 | PDADC 117 Value 135 | 
PDADC 118 Value 135 | PDADC 119 Value 135 |
ath9k: PDADC (1,1000): b2f8 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 120 Value 135 | PDADC 121 Value 135 | 
PDADC 122 Value 135 | PDADC 123 Value 135 |
ath9k: PDADC (1,1000): b2fc 
87878787                                                                           

ath9k: PDADC: Chain 1 | PDADC 124 Value 135 | PDADC 125 Value 135 | 
PDADC 126 Value 135 | PDADC 127 Value 135 |
ath9k: PDADC (2,2000): c280 
0c0b0a09                                                                           

ath9k: PDADC: Chain 2 | PDADC   0 Value   9 | PDADC   1 Value  10 | 
PDADC   2 Value  11 | PDADC   3 Value  12 |
ath9k: PDADC (2,2000): c284 
100f0e0d                                                                           

ath9k: PDADC: Chain 2 | PDADC   4 Value  13 | PDADC   5 Value  14 | 
PDADC   6 Value  15 | PDADC   7 Value  16 |
ath9k: PDADC (2,2000): c288 
15141311                                                                           

ath9k: PDADC: Chain 2 | PDADC   8 Value  17 | PDADC   9 Value  19 | 
PDADC  10 Value  20 | PDADC  11 Value  21 |
ath9k: PDADC (2,2000): c28c 
1d1b1917                                                                           

ath9k: PDADC: Chain 2 | PDADC  12 Value  23 | PDADC  13 Value  25 | 
PDADC  14 Value  27 | PDADC  15 Value  29 |
ath9k: PDADC (2,2000): c290 
2825221f                                                                           

ath9k: PDADC: Chain 2 | PDADC  16 Value  31 | PDADC  17 Value  34 | 
PDADC  18 Value  37 | PDADC  19 Value  40 |
ath9k: PDADC (2,2000): c294 
35312e2b                                                                           

ath9k: PDADC: Chain 2 | PDADC  20 Value  43 | PDADC  21 Value  46 | 
PDADC  22 Value  49 | PDADC  23 Value  53 |
ath9k: PDADC (2,2000): c298 
0f413d39                                                                           

ath9k: PDADC: Chain 2 | PDADC  24 Value  57 | PDADC  25 Value  61 | 
PDADC  26 Value  65 | PDADC  27 Value  15 |
ath9k: PDADC (2,2000): c29c 
14121110                                                                           

ath9k: PDADC: Chain 2 | PDADC  28 Value  16 | PDADC  29 Value  17 | 
PDADC  30 Value  18 | PDADC  31 Value  20 |
ath9k: PDADC (2,2000): c2a0 
1a181615                                                                           

ath9k: PDADC: Chain 2 | PDADC  32 Value  21 | PDADC  33 Value  22 | 
PDADC  34 Value  24 | PDADC  35 Value  26 |
ath9k: PDADC (2,2000): c2a4 
23211e1c                                                                           

ath9k: PDADC: Chain 2 | PDADC  36 Value  28 | PDADC  37 Value  30 | 
PDADC  38 Value  33 | PDADC  39 Value  35 |
ath9k: PDADC (2,2000): c2a8 
2e2b2825                                                                           

ath9k: PDADC: Chain 2 | PDADC  40 Value  37 | PDADC  41 Value  40 | 
PDADC  42 Value  43 | PDADC  43 Value  46 |
ath9k: PDADC (2,2000): c2ac 
3c383532                                                                           

ath9k: PDADC: Chain 2 | PDADC  44 Value  50 | PDADC  45 Value  53 | 
PDADC  46 Value  56 | PDADC  47 Value  60 |
ath9k: PDADC (2,2000): c2b0 
56504942                                                                           

ath9k: PDADC: Chain 2 | PDADC  48 Value  66 | PDADC  49 Value  73 | 
PDADC  50 Value  80 | PDADC  51 Value  86 |
ath9k: PDADC (2,2000): c2b4 
6e68625c                                                                           

ath9k: PDADC: Chain 2 | PDADC  52 Value  92 | PDADC  53 Value  98 | 
PDADC  54 Value 104 | PDADC  55 Value 110 |
ath9k: PDADC (2,2000): c2b8 
80807a74                                                                           

ath9k: PDADC: Chain 2 | PDADC  56 Value 116 | PDADC  57 Value 122 | 
PDADC  58 Value 128 | PDADC  59 Value 128 |
ath9k: PDADC (2,2000): c2bc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  60 Value 128 | PDADC  61 Value 128 | 
PDADC  62 Value 128 | PDADC  63 Value 128 |
ath9k: PDADC (2,2000): c2c0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  64 Value 128 | PDADC  65 Value 128 | 
PDADC  66 Value 128 | PDADC  67 Value 128 |
ath9k: PDADC (2,2000): c2c4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  68 Value 128 | PDADC  69 Value 128 | 
PDADC  70 Value 128 | PDADC  71 Value 128 |
ath9k: PDADC (2,2000): c2c8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  72 Value 128 | PDADC  73 Value 128 | 
PDADC  74 Value 128 | PDADC  75 Value 128 |
ath9k: PDADC (2,2000): c2cc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  76 Value 128 | PDADC  77 Value 128 | 
PDADC  78 Value 128 | PDADC  79 Value 128 |
ath9k: PDADC (2,2000): c2d0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  80 Value 128 | PDADC  81 Value 128 | 
PDADC  82 Value 128 | PDADC  83 Value 128 |
ath9k: PDADC (2,2000): c2d4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  84 Value 128 | PDADC  85 Value 128 | 
PDADC  86 Value 128 | PDADC  87 Value 128 |
ath9k: PDADC (2,2000): c2d8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  88 Value 128 | PDADC  89 Value 128 | 
PDADC  90 Value 128 | PDADC  91 Value 128 |
ath9k: PDADC (2,2000): c2dc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  92 Value 128 | PDADC  93 Value 128 | 
PDADC  94 Value 128 | PDADC  95 Value 128 |
ath9k: PDADC (2,2000): c2e0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC  96 Value 128 | PDADC  97 Value 128 | 
PDADC  98 Value 128 | PDADC  99 Value 128 |
ath9k: PDADC (2,2000): c2e4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 100 Value 128 | PDADC 101 Value 128 | 
PDADC 102 Value 128 | PDADC 103 Value 128 |
ath9k: PDADC (2,2000): c2e8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 104 Value 128 | PDADC 105 Value 128 | 
PDADC 106 Value 128 | PDADC 107 Value 128 |
ath9k: PDADC (2,2000): c2ec 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 108 Value 128 | PDADC 109 Value 128 | 
PDADC 110 Value 128 | PDADC 111 Value 128 |
ath9k: PDADC (2,2000): c2f0 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 112 Value 128 | PDADC 113 Value 128 | 
PDADC 114 Value 128 | PDADC 115 Value 128 |
ath9k: PDADC (2,2000): c2f4 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 116 Value 128 | PDADC 117 Value 128 | 
PDADC 118 Value 128 | PDADC 119 Value 128 |
ath9k: PDADC (2,2000): c2f8 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 120 Value 128 | PDADC 121 Value 128 | 
PDADC 122 Value 128 | PDADC 123 Value 128 |
ath9k: PDADC (2,2000): c2fc 
80808080                                                                           

ath9k: PDADC: Chain 2 | PDADC 124 Value 128 | PDADC 125 Value 128 | 
PDADC 126 Value 128 | PDADC 127 Value 128 |
ath9k: Getting spur idx 0 is2Ghz. 1 val 
8000                                                                  
ath9k: Reset TX queue: 
0                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
1                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
2                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
3                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TXQ, inactive queue: 
4                                                                            

ath9k: Reset TXQ, inactive queue: 
5                                                                            

ath9k: Reset TXQ, inactive queue: 
6                                                                            

ath9k: Reset TXQ, inactive queue: 
7                                                                            

ath9k: Reset TX queue: 
8                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: Reset TX queue: 
9                                                                                       

ath9k: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 
0x0                                                         
ath9k: ah->misc_mode 
0xc                                                                                       

ath9k: Enable MIB 
counters                                                                                     

ath9k: Reset ANI state opmode 
3                                                                                

ath9k: ANI 
parameters:                                                                                         

ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, 
ofdmWeakSigDetectOff=0                                      
ath9k: cckWeakSigThreshold=0, firstepLevel=0, 
listenTime=273                                                  
ath9k: cycleCount=92921542, ofdmPhyErrCount=5, 
cckPhyErrCount=7                                               

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=273           
ath9k: cycleCount=92921542, ofdmPhyErrCount=5, cckPhyErrCount=7        

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=273           
ath9k: cycleCount=92921542, ofdmPhyErrCount=5, cckPhyErrCount=7        

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=273           
ath9k: cycleCount=92921542, ofdmPhyErrCount=5, cckPhyErrCount=7        

ath9k: ANI parameters:
ath9k: noiseImmunityLevel=0, spurImmunityLevel=0, ofdmWeakSigDetectOff=0
ath9k: cckWeakSigThreshold=0, firstepLevel=0, listenTime=273           
ath9k: cycleCount=92921542, ofdmPhyErrCount=5, cckPhyErrCount=7        

ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: 0x81801964 => 0xf0010071                   
ath9k: disable IER                                
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 

ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: transmitting packet, skb: c3b1ef00         
ath9k: qnum: 1, txq depth: 1                      
ath9k: TXDP[1] = 3ae4650 (ffc0f650)               
ath9k: Enable TXE on queue: 1                     
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: transmitting packet, skb: c3b15e40         
ath9k: qnum: 1, txq depth: 2                      
ath9k: link[1] (ffc0f650)=3ae46e0 (ffc0f6e0)      
ath9k: Enable TXE on queue: 1                     
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 

ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
 > 0x10000                                         
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         

ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            

ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: transmitting packet, skb: c3a13840         
ath9k: qnum: 1, txq depth: 3                      
ath9k: link[1] (ffc0f6e0)=3ae4770 (ffc0f770)      
ath9k: Enable TXE on queue: 1                     
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 

ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 

ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: Writing ofdmbase=12582412   cckbase=12582712
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            

ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: AR_IMR 0x10000 IER 0x0                     
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: receive FIFO overrun interrupt             
ath9k: 0xf0010071 => 0x10000                      
ath9k: disable IER                                
ath9k: new IMR 0x10000                            
ath9k: 0x10000 => 0xf0010071                      
ath9k: new IMR 0x918104b4                         
ath9k: enable IER                                 
ath9k: AR_IMR 0x918104b4 IER 0x1                  
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT                 
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: receive FIFO overrun interrupt
ath9k: 0xf0010071 => 0x10000
ath9k: disable IER
ath9k: new IMR 0x10000
ath9k: 0x10000 => 0xf0010071
ath9k: new IMR 0x918104b4
ath9k: enable IER
ath9k: AR_IMR 0x918104b4 IER 0x1
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: receive FIFO overrun interrupt
ath9k: 0xf0010071 => 0x10000
ath9k: disable IER
ath9k: new IMR 0x10000
ath9k: 0x10000 => 0xf0010071
ath9k: new IMR 0x918104b4
ath9k: enable IER
ath9k: AR_IMR 0x918104b4 IER 0x1
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
ath9k: AR_INTR_SYNC_LOCAL_TIMEOUT






