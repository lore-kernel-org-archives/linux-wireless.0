Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47776 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab0HCAJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 20:09:14 -0400
Received: by eya25 with SMTP id 25so1463776eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 17:09:12 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 3 Aug 2010 10:09:11 +1000
Message-ID: <AANLkTik0Ebk6zcTi29pofUvzmVDmRwi4hthj+66k9-V0@mail.gmail.com>
Subject: virtual access point setup
From: Ryszard <ryszard99@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hey ben,

here is a list of actions i've done just now to get the previously
mentioned stack trace:
==============================================
1. restart box
2. uname -a Linux sknwireless 2.6.32-22-generic #33-Ubuntu SMP Wed Apr
28 13:27:30 UTC 2010 i586 GNU/Linux
3.lsmod:
Module                  Size  Used by
ipt_REDIRECT             917  3
ipt_MASQUERADE          1407  3
xt_state                1098  6
xt_tcpudp               2011  33
iptable_filter          2271  1
nf_nat_ftp              1836  0
iptable_nat             4414  1
ip_tables               9991  2 iptable_filter,iptable_nat
nf_nat                 15735  4
ipt_REDIRECT,ipt_MASQUERADE,nf_nat_ftp,iptable_nat
x_tables               14299  6
ipt_REDIRECT,ipt_MASQUERADE,xt_state,xt_tcpudp,iptable_nat,ip_tables
nf_conntrack_ftp        5381  1 nf_nat_ftp
nf_conntrack_ipv4      10672  9 iptable_nat,nf_nat
nf_conntrack           61583  7
ipt_MASQUERADE,xt_state,nf_nat_ftp,iptable_nat,nf_nat,nf_conntrack_ftp,nf_conntrack_ipv4
nf_defrag_ipv4          1073  1 nf_conntrack_ipv4
arc4                    1153  2
aes_i586                7268  0
ath5k                 118956  0
aes_generic            26863  1 aes_i586
mac80211              206808  1 ath5k
ath                     7611  1 ath5k
leds_alix2              1470  0
geode_aes               4558  0
cs5535_gpio             2571  0
cfg80211              125477  3 ath5k,mac80211,ath
geode_rng               1011  0
led_class               2864  2 ath5k,leds_alix2
pata_cs5536             3224  0
pata_amd                8766  1
via_rhine              19154  0
mii                     4381  1 via_rhine

4. rmmod ath5k
5. modprobe ath5k nohwcrypt=1
6. syslog shows no stack trace
7. iw dev wlan0 interface add sta0 type station
8. ifconfig sta0
sta0      Link encap:Ethernet  HWaddr 00:0b:6b:22:5b:cd
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

9. iwconfig sta0
sta0      IEEE 802.11abg  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
10. no syslog stacktrace
11. iw dev wlan0 interface add vap0 type __ap
12. ifconfig vap0
vap0      Link encap:Ethernet  HWaddr 00:0b:6b:22:5b:cd
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

13. iwconfig vap0
vap0      IEEE 802.11abg  Mode:Master  Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
14. no syslog stacktrace
15. iw dev wlan0 interface add vap1 type __ap
16. ifconfig vap1
vap1      Link encap:Ethernet  HWaddr 00:0b:6b:22:5b:cd
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
17. iwconfig vap1
vap1      IEEE 802.11abg  Mode:Master  Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
18. no syslog stacktrace
19. ifconfig vap0 172.16.40.1 up
SIOCSIFFLAGS: Name not unique on network
SIOCSIFFLAGS: Name not unique on network
20. no syslog stacktrace
21 ifconfig vap1 172.16.40.1 up
SIOCSIFFLAGS: Name not unique on network
SIOCSIFFLAGS: Name not unique on network
22. no syslog stacktrace
23. macchanger vap0
Current MAC: 00:0b:6b:22:5b:cd (Wistron Neweb Corp.)
Faked MAC:   00:0b:6b:22:5b:ce (Wistron Neweb Corp.)
24. no syslog stacktrace
25. macchanger vap1
Current MAC: 00:0b:6b:22:5b:cd (Wistron Neweb Corp.)
Faked MAC:   00:0b:6b:22:5b:ce (Wistron Neweb Corp.)
26. no syslog stacktrace
27. ifconfig vap0 172.168.40.1 up
28. syslog stacktrace:
Aug  3 10:04:03 sknwireless kernel: [  908.740408] ------------[ cut
here ]------------
Aug  3 10:04:03 sknwireless kernel: [  908.740479] WARNING: at
/home/skn/wireless/compat-wireless-2.6.32.15/drivers/net/wireless/ath/ath5k/base.c:3221
ath5k_bss_info_changed+0x1a6/0x1b0 [ath5k]()
Aug  3 10:04:03 sknwireless kernel: [  908.740508] Modules linked in:
ipt_REDIRECT ipt_MASQUERADE xt_state xt_tcpudp iptable_filter
nf_nat_ftp iptable_nat ip_tables nf_nat x_tables nf_conntrack_ftp
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 arc4 aes_i586 ath5k
aes_generic mac80211 ath leds_alix2 geode_aes cs5535_gpio cfg80211
geode_rng led_class pata_cs5536 pata_amd via_rhine mii
Aug  3 10:04:03 sknwireless kernel: [  908.740683] Pid: 3711, comm:
ifconfig Not tainted 2.6.32-22-generic #33-Ubuntu
Aug  3 10:04:03 sknwireless kernel: [  908.740701] Call Trace:
Aug  3 10:04:03 sknwireless kernel: [  908.740739]  [<c014c3d2>]
warn_slowpath_common+0x72/0xa0
Aug  3 10:04:03 sknwireless kernel: [  908.740785]  [<d09d6406>] ?
ath5k_bss_info_changed+0x1a6/0x1b0 [ath5k]
Aug  3 10:04:03 sknwireless kernel: [  908.740829]  [<d09d6406>] ?
ath5k_bss_info_changed+0x1a6/0x1b0 [ath5k]
Aug  3 10:04:03 sknwireless kernel: [  908.740861]  [<c014c41a>]
warn_slowpath_null+0x1a/0x20
Aug  3 10:04:03 sknwireless kernel: [  908.740904]  [<d09d6406>]
ath5k_bss_info_changed+0x1a6/0x1b0 [ath5k]
Aug  3 10:04:03 sknwireless kernel: [  908.741012]  [<d0946bda>]
ieee80211_bss_info_change_notify+0x9a/0x1b0 [mac80211]
Aug  3 10:04:03 sknwireless kernel: [  908.741058]  [<d09d6260>] ?
ath5k_bss_info_changed+0x0/0x1b0 [ath5k]
Aug  3 10:04:03 sknwireless kernel: [  908.741134]  [<d0951d58>]
ieee80211_open+0x2a8/0x7d0 [mac80211]
Aug  3 10:04:03 sknwireless kernel: [  908.741238]  [<c04c3ec2>]
dev_open+0x92/0xf0
Aug  3 10:04:03 sknwireless kernel: [  908.741268]  [<c058b866>] ?
_spin_unlock_bh+0x16/0x20
Aug  3 10:04:03 sknwireless kernel: [  908.741296]  [<c04c1a2f>] ?
dev_set_rx_mode+0x2f/0x40
Aug  3 10:04:03 sknwireless kernel: [  908.741325]  [<c04c3739>]
dev_change_flags+0x139/0x1b0
Aug  3 10:04:03 sknwireless kernel: [  908.741360]  [<c0515f0a>]
devinet_ioctl+0x54a/0x5a0
Aug  3 10:04:03 sknwireless kernel: [  908.741389]  [<c04c512f>] ?
dev_ioctl+0x2af/0x720
Aug  3 10:04:03 sknwireless kernel: [  908.741422]  [<c0517065>]
inet_ioctl+0x95/0xb0
Aug  3 10:04:03 sknwireless kernel: [  908.741450]  [<c04b237d>]
sock_ioctl+0x6d/0x270
Aug  3 10:04:03 sknwireless kernel: [  908.741475]  [<c04b2310>] ?
sock_ioctl+0x0/0x270
Aug  3 10:04:03 sknwireless kernel: [  908.741501]  [<c0216231>]
vfs_ioctl+0x21/0x90
Aug  3 10:04:03 sknwireless kernel: [  908.741526]  [<c058955c>] ?
schedule+0x44c/0x840
Aug  3 10:04:03 sknwireless kernel: [  908.741553]  [<c0216519>]
do_vfs_ioctl+0x79/0x310
Aug  3 10:04:03 sknwireless kernel: [  908.741578]  [<c0216817>]
sys_ioctl+0x67/0x80
Aug  3 10:04:03 sknwireless kernel: [  908.741607]  [<c01033ec>]
syscall_call+0x7/0xb
Aug  3 10:04:03 sknwireless kernel: [  908.741628] ---[ end trace
c6a7c8dea11614de ]---
Aug  3 10:04:13 sknwireless kernel: [  919.169554] vap0: no IPv6 routers present
29. ifconfig vap1 172.168.40.1 up
SIOCSIFFLAGS: Name not unique on network
SIOCSIFFLAGS: Name not unique on network
30. macchanger vap1
Current MAC: 00:0b:6b:22:5b:ce (Wistron Neweb Corp.)
Faked MAC:   00:0b:6b:22:5b:cf (Wistron Neweb Corp.)
31. ifconfig vap1 172.168.40.1 up
32. no additional stack trace in syslog
==============================================

i'm doing this remote right now and dont have access to a wireless
client to attempt to get a lease (after running hostapd of course).
is this information relevant/useful to you? is there anything else
you'd like me to do?
regs
R
