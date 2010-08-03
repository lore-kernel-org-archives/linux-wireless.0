Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51111 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0HCE4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 00:56:23 -0400
Message-ID: <4C57A16A.90501@candelatech.com>
Date: Mon, 02 Aug 2010 21:56:10 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ryszard <ryszard99@gmail.com>
CC: Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Subject: Re: virtual access point setup
References: <AANLkTik0Ebk6zcTi29pofUvzmVDmRwi4hthj+66k9-V0@mail.gmail.com>
In-Reply-To: <AANLkTik0Ebk6zcTi29pofUvzmVDmRwi4hthj+66k9-V0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2010 05:09 PM, Ryszard wrote:
> hey ben,
>
> here is a list of actions i've done just now to get the previously
> mentioned stack trace:
> ==============================================
> 1. restart box
> 2. uname -a Linux sknwireless 2.6.32-22-generic #33-Ubuntu SMP Wed Apr
> 28 13:27:30 UTC 2010 i586 GNU/Linux
> 3.lsmod:
> Module                  Size  Used by
> ipt_REDIRECT             917  3
> ipt_MASQUERADE          1407  3
> xt_state                1098  6
> xt_tcpudp               2011  33
> iptable_filter          2271  1
> nf_nat_ftp              1836  0
> iptable_nat             4414  1
> ip_tables               9991  2 iptable_filter,iptable_nat
> nf_nat                 15735  4
> ipt_REDIRECT,ipt_MASQUERADE,nf_nat_ftp,iptable_nat
> x_tables               14299  6
> ipt_REDIRECT,ipt_MASQUERADE,xt_state,xt_tcpudp,iptable_nat,ip_tables
> nf_conntrack_ftp        5381  1 nf_nat_ftp
> nf_conntrack_ipv4      10672  9 iptable_nat,nf_nat
> nf_conntrack           61583  7
> ipt_MASQUERADE,xt_state,nf_nat_ftp,iptable_nat,nf_nat,nf_conntrack_ftp,nf_conntrack_ipv4
> nf_defrag_ipv4          1073  1 nf_conntrack_ipv4
> arc4                    1153  2
> aes_i586                7268  0
> ath5k                 118956  0
> aes_generic            26863  1 aes_i586
> mac80211              206808  1 ath5k
> ath                     7611  1 ath5k
> leds_alix2              1470  0
> geode_aes               4558  0
> cs5535_gpio             2571  0
> cfg80211              125477  3 ath5k,mac80211,ath
> geode_rng               1011  0
> led_class               2864  2 ath5k,leds_alix2
> pata_cs5536             3224  0
> pata_amd                8766  1
> via_rhine              19154  0
> mii                     4381  1 via_rhine
>
> 4. rmmod ath5k
> 5. modprobe ath5k nohwcrypt=1
> 6. syslog shows no stack trace
> 7. iw dev wlan0 interface add sta0 type station
> 8. ifconfig sta0
> sta0      Link encap:Ethernet  HWaddr 00:0b:6b:22:5b:cd
>            BROADCAST MULTICAST  MTU:1500  Metric:1
>            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>
> 9. iwconfig sta0
> sta0      IEEE 802.11abg  ESSID:off/any
>            Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>            Retry  long limit:7   RTS thr:off   Fragment thr:off
>            Encryption key:off
>            Power Management:off
> 10. no syslog stacktrace
> 11. iw dev wlan0 interface add vap0 type __ap
> 12. ifconfig vap0
> vap0      Link encap:Ethernet  HWaddr 00:0b:6b:22:5b:cd
>            BROADCAST MULTICAST  MTU:1500  Metric:1
>            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>
> 13. iwconfig vap0
> vap0      IEEE 802.11abg  Mode:Master  Tx-Power=20 dBm
>            Retry  long limit:7   RTS thr:off   Fragment thr:off
>            Power Management:off
> 14. no syslog stacktrace
> 15. iw dev wlan0 interface add vap1 type __ap
> 16. ifconfig vap1
> vap1      Link encap:Ethernet  HWaddr 00:0b:6b:22:5b:cd
>            BROADCAST MULTICAST  MTU:1500  Metric:1
>            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>            collisions:0 txqueuelen:1000
>            RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
> 17. iwconfig vap1
> vap1      IEEE 802.11abg  Mode:Master  Tx-Power=20 dBm
>            Retry  long limit:7   RTS thr:off   Fragment thr:off
>            Power Management:off
> 18. no syslog stacktrace
> 19. ifconfig vap0 172.16.40.1 up
> SIOCSIFFLAGS: Name not unique on network
> SIOCSIFFLAGS: Name not unique on network
> 20. no syslog stacktrace
> 21 ifconfig vap1 172.16.40.1 up
> SIOCSIFFLAGS: Name not unique on network
> SIOCSIFFLAGS: Name not unique on network
> 22. no syslog stacktrace
> 23. macchanger vap0
> Current MAC: 00:0b:6b:22:5b:cd (Wistron Neweb Corp.)
> Faked MAC:   00:0b:6b:22:5b:ce (Wistron Neweb Corp.)
> 24. no syslog stacktrace
> 25. macchanger vap1
> Current MAC: 00:0b:6b:22:5b:cd (Wistron Neweb Corp.)
> Faked MAC:   00:0b:6b:22:5b:ce (Wistron Neweb Corp.)
> 26. no syslog stacktrace
> 27. ifconfig vap0 172.168.40.1 up
> 28. syslog stacktrace:
> Aug  3 10:04:03 sknwireless kernel: [  908.740408] ------------[ cut
> here ]------------
> Aug  3 10:04:03 sknwireless kernel: [  908.740479] WARNING: at
> /home/skn/wireless/compat-wireless-2.6.32.15/drivers/net/wireless/ath/ath5k/base.c:3221

It appears you are not using our 2.6.31.12 kernel.  Our wifi patches never
made it upstream..so you have to use the kernel from our site to have any
chance of success.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
