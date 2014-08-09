Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35123 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaHIKD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 06:03:29 -0400
MIME-Version: 1.0
Date: Sat, 9 Aug 2014 12:03:28 +0200
Message-ID: <CAKfDRXgSg5Dpz=Ubv9=V6uGVOKYD1+nckFvep+M=vM8nNJGZqw@mail.gmail.com> (sfid-20140809_120336_752567_B980ADC9)
Subject: ar71xx: Problems with USB WIFI dongles
From: Kristian Evensen <kristian.evensen@gmail.com>
To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am currently working on a small project and I have come across a
problem I have not been able to solve myself. My setup is as
following, I have a TP-LINK WDR4300 (so ar71xx) router that will be
used as an access point to share a WAN connection. The WAN connection
is a different wifi. My idea is to use the two on-board wifis as AP (I
want both 2.4 GHz and 5Ghz), and then use a USB wifi dongle for the
WAN connection. I run OpenWRT and the most recent kernel available
(3.14.12). The problems were also present on 3.10 kernels.

When configuring this setup, two problems occur:

1) I have tested with several different USB wifi dongles, some using
Realtek chipset (rl8192cu driver) and others using Atheros chipset
(ath9k_htc driver). The WDR4300 on-board wifi is also Atheros (ath9k
driver), and when I use a device from a different "family" (i.e., the
Realtek-dongles), the wifi authentication always times out. If I
disable the on-board wifi, the Realtek dongle works as expected
(connection to WAN wifi can be established). Is there a known problem
mixing different Wifi drivers on the ar71xx-platform/WDR4300, or am I
doing something wrong?

2) When disconnecting any WIFI dongle, I always get a kernel oops.
This happens irrespective of if the dongle is active (for example
connected to network) or if I have just connected it to the router.
The kernel oops looks like the following (the crash happens at the
same place independent of device):

[  429.730000] usb 1-1.1.5.4: USB disconnect, device number 10
[  429.760000] CPU 0 Unable to handle kernel paging request at virtual
address 00100104, epc == 86e93018, ra == 86e93010
[  429.770000] Oops[#1]:
[  429.770000] CPU: 0 PID: 292 Comm: khubd Not tainted 3.14.12 #4
[  429.770000] task: 878ad770 ti: 87b0c000 task.ti: 87b0c000
[  429.770000] $ 0   : 00000000 00000000 00200200 00100100
[  429.770000] $ 4   : 87b0dce0 87b0dee0 80350000 00000008
[  429.770000] $ 8   : 00090040 86a6a080 00000020 00090040
[  429.770000] $12   : 00000013 0000000e 00000007 00000001
[  429.770000] $16   : 85cc91a0 87b0dcd8 00100100 85cc91a8
[  429.770000] $20   : 85cc91a0 00200200 86948000 87b41838
[  429.770000] $24   : 80327df0 8010fe04
[  429.770000] $28   : 87b0c000 87b0dcc8 00000000 86e93010
[  429.770000] Hi    : 00000350
[  429.770000] Lo    : 00000006
[  429.770000] epc   : 86e93018
ieee80211_remove_interfaces+0x128/0x1b4 [mac80211]
[  429.770000]     Not tainted
[  429.770000] ra    : 86e93010
ieee80211_remove_interfaces+0x120/0x1b4 [mac80211]
[  429.770000] Status: 1100dc03 KERNEL EXL IE
[  429.770000] Cause : 0080000c
[  429.770000] BadVA : 00100104
[  429.770000] PrId  : 0001974c (MIPS 74Kc)
[  429.770000] Modules linked in: ath9k rtl8192se rtl8192de rtl8192cu
rtl8192ce ath9k_htc ath9k_common rtl_usb rtl_pci pppoe ppp_async
option iptable_nat ath9k_hw ath usb_wwan smsc95xx rtlwifi rtl8187
rt73usb rt2x00usb rt2x00lib rndis_host qmi_wwan pppox ppp_generic
nf_nat_ipv4 nf_conntrack_ipv4 mac80211 ipt_MASQUERADE huawei_cdc_ncm
cfg80211 cdc_ncm cdc_ether ax88179_178a asix xt_time xt_tcpudp
xt_tcpmss xt_string xt_statistic xt_state xt_recent xt_quota
xt_pkttype xt_owner xt_nfacct xt_nat xt_multiport xt_mark xt_mac
xt_limit xt_length xt_id xt_hl xt_helper xt_ecn xt_dscp xt_conntrack
xt_connmark xt_connlimit xt_connbytes xt_comment xt_addrtype xt_TCPMSS
xt_REDIRECT xt_NFQUEUE xt_LOG xt_HL xt_DSCP xt_CT xt_CLASSIFY
usbserial usbnet ts_kmp ts_fsm ts_bm slhc rtl8192c_common
nfnetlink_queue nfnetlink_acct nf_nat_irc nf_nat_ftp nf_nat
nf_defrag_ipv4 nf_conntrack_irc nf_conntrack_ftp iptable_raw
iptable_mangle iptable_filter ipt_REJECT ipt_ECN ipheth ip_tables
crc16 crc_itu_t crc_ccitt compat cdc_wdm cdc_acm act_connmark
act_skbedit act_mirred em_u32 cls_u32 cls_tcindex cls_flow cls_route
cls_fw sch_hfsc sch_ingress ledtrig_usbdev ip6t_REJECT ip6table_raw
ip6table_mangle ip6table_filter ip6_tables x_tables nf_conntrack_ipv6
nf_defrag_ipv6 ifb ipv6 eeprom_93cx6 arc4 crypto_blkcipher
ehci_platform ehci_hcd gpio_button_hotplug usbcore nls_base usb_common
mii
[  429.770000] Process khubd (pid: 292, threadinfo=87b0c000,
task=878ad770, tls=00000000)
[  429.770000] Stack : 85cc93a0 86f69350 00000000 00000000 87b0dcd8
87b0dcd8 00100100 00200200
[  429.770000]  86948000 85cc8ae0 85cc9460 86b9fa20 86f69350 00000000
00000000 86e80fac
[  429.770000]  00000004 85cc8ae0 85cc9460 86b9fa20 85cc8ae0 86e14ddc
87b0dd1c 87b0bbd0
[  429.770000]  86b9fa20 86948000 86b9fa20 86948000 86b9fa00 87b2c580
879ff000 800def9c
[  429.770000]  87b39180 80131108 86b9fa20 86f69350 87b39180 879ff000
86b9fa00 8008d734
[  429.770000]  ...
[  429.770000] Call Trace:
[  429.770000] [<86e93018>] ieee80211_remove_interfaces+0x128/0x1b4 [mac80211]
[  429.770000] [<86e80fac>] ieee80211_unregister_hw+0x3c/0xe4 [mac80211]
[  429.770000] [<86e14ddc>] rtl_usb_disconnect+0x4c/0xf4 [rtl_usb]
[  429.770000] [<87b2c580>] usb_deregister+0x228/0x2ec [usbcore]
[  429.770000] [<8008d734>] __device_release_driver+0x6c/0xd0
[  429.770000] [<80117f64>] device_release_driver+0x28/0x40
[  429.770000] [<800edffc>] bus_remove_device+0xec/0x120
[  429.770000] [<801176fc>] device_del+0x110/0x170
[  429.770000] [<87b2ad58>] usb_disable_device+0xb0/0x1d8 [usbcore]
[  429.770000] [<87b22920>] usb_disconnect+0xac/0x408 [usbcore]
[  429.770000] [<87b24a68>] usb_reset_device+0xd28/0x15c8 [usbcore]
[  429.770000] [<80121c0c>] do_exit+0x72c/0x744
[  429.770000]
[  429.770000]
[  429.770000] Code: 27a40018  8fa2001c  8fa30018 <ac620004> ac430000
8fb00010  3c030010  3c020020  24630100
[  430.110000] ---[ end trace 6ca2573cb8fc44d5 ]---

Has anyone else experienced this or have an idea of how to fix it? My
knowledge of wifi in general and the wireless stack in Linux is very
limited, so I am not quite sure where to start.

When testing the same setup on a router based on a different SoC
(WRT1900AC, Marvell Armada XP/370) I do not see any of these problems.
Disconnecting wifi dongles works as expected, while any dongle can be
used together with the on-board wifi. The same applies to my laptop
(running kernel 3.16).

Thanks in advance for any help,
Kristian
