Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from musca.uberspace.de ([95.143.172.200]:55728 "EHLO
	musca.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbbI0QoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 12:44:13 -0400
In-Reply-To: 52BDE9DC.5040206@msgid.tls.msk.ru
To: linux-wireless@vger.kernel.org
From: Jonathan Biegert <azrdev@qrdn.de>
Subject: Re: BCM4313 & brcmsmac: only semi-working?
Message-ID: <56081B48.4090802@qrdn.de> (sfid-20150927_184421_138906_FD531CED)
Date: Sun, 27 Sep 2015 18:37:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've got a Lenovo Thinkpad Edge E135 (from Germany) which came with the
same WiFi-Chip the OP has [1], a BCM4313. I'd like to help debugging so
this chip will finally work properly.

Similary to the OP, the device frequently stalls after some time of use.
On my system [2], this means wpa_supplicant reports an association, but
subsequently no DHCP lease can be obtained. Once this state is reached,
it stays like that. Sometimes unloading the kernel module(s) helps,
sometimes only unload,suspend (S3),load.
Since reading in this thread about bluetooth-issues, I reduced the pain
with the card by disabling bluetooth [5].
I'm still not sure if the error is totally reproducible, I hope so for
debugging.

Please instruct me what/how to generate debug info, apart from [5] and [6].
When responding, please Cc me, I'm not subscribed.

  Jonathan Biegert

[1] lspci -v -nnk
02:00.0 Network controller [0280]: Broadcom Corporation BCM4313
802.11bgn Wireless Network Adapter [14e4:4727] (rev 01)
        Subsystem: Broadcom Corporation Device [14e4:0608]
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at f0a00000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [58] Vendor Specific Information: Len=78 <?>
        Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [d0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel
        Capabilities: [160] Device Serial Number 00-00-9d-ff-ff-48-20-68
        Capabilities: [16c] Power Budgeting <?>
        Kernel driver in use: bcma-pci-bridge
        Kernel modules: bcma

[2] Archlinux, currently kernel 4.1.6 (distro default), no
NetworkManager, only dhcpcd which starts wpa_supplicant on demand [3].

[3] dhcpcd hook:
<http://roy.marples.name/projects/dhcpcd/artifact/7e81b56d47ff681b>

[4] rfkill list
0: tpacpi_bluetooth_sw: Bluetooth
        Soft blocked: yes
        Hard blocked: no
20: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
21: hci0: Bluetooth
        Soft blocked: yes
        Hard blocked: no

[5] cat /sys/kernel/debug/brcmsmac/bcma0:1/hardware
chipnum 0x4313
chiprev 0x1
chippackage 0x8
corerev 0x18
boardid 0x608
boardvendor 0x14e4
boardrev P109
boardflags 0x402201
boardflags2 0x884
ucoderev 0x262032c
radiorev 0x1
phytype 0x8
phyrev 0x1
anarev 0xa
nvramrev 8

[6] Kernel log (journalctl -k) from a stall, augmented with some related
journal messages:

> 16:00:12 larsa dhcpcd[13130]: wlan0: carrier lost
> 16:00:12 larsa kernel: brcmsmac bcma0:1: brcmsmac: brcms_ops_bss_info_changed: disassociated
> 16:00:12 larsa kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
> 16:00:12 larsa kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: false (implement)
> 16:00:12 larsa kernel: cfg80211: Exceeded CRDA call max attempts. Not calling CRDA
> 16:00:13 larsa kernel: wlan0: authenticate with b0:48:7a:d1:6c:0c
> 16:00:13 larsa kernel: wlan0: send auth to b0:48:7a:d1:6c:0c (try 1/3)
> 16:00:13 larsa kernel: wlan0: send auth to b0:48:7a:d1:6c:0c (try 2/3)
> 16:00:14 larsa kernel: wlan0: send auth to b0:48:7a:d1:6c:0c (try 3/3)
> 16:00:14 larsa kernel: wlan0: authentication with b0:48:7a:d1:6c:0c timed out
> 16:00:15 larsa kernel: wlan0: authenticate with b0:48:7a:d1:6c:0c
> 16:00:15 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 1/3)
> 16:00:15 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 2/3)
> 16:00:15 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 3/3)
> 16:00:16 larsa kernel: wlan0: authentication with b0:48:7a:d1:6c:0c timed out
> 16:00:18 larsa kernel: wlan0: authenticate with b0:48:7a:d1:6c:0c
> 16:00:18 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 1/3)
> 16:00:18 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 2/3)
> 16:00:18 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 3/3)
> 16:00:18 larsa kernel: wlan0: authentication with b0:48:7a:d1:6c:0c timed out
> 16:00:30 larsa kernel: wlan0: authenticate with b0:48:7a:d1:6c:0c
> 16:00:30 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 1/3)
> 16:00:30 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 2/3)
> 16:00:31 larsa kernel: wlan0: direct probe to b0:48:7a:d1:6c:0c (try 3/3)
> 16:00:31 larsa kernel: wlan0: authentication with b0:48:7a:d1:6c:0c timed out
> 16:00:54 larsa kernel: wlan0: authenticate with b0:48:7a:d1:6c:0c
> 16:00:54 larsa kernel: wlan0: send auth to b0:48:7a:d1:6c:0c (try 1/3)
> 16:00:54 larsa kernel: wlan0: authenticated
> 16:00:54 larsa kernel: wlan0: associate with b0:48:7a:d1:6c:0c (try 1/3)
> 16:00:54 larsa kernel: wlan0: RX AssocResp from b0:48:7a:d1:6c:0c (capab=0x431 status=0 aid=3)
> 16:00:54 larsa kernel: brcmsmac bcma0:1: brcmsmac: brcms_ops_bss_info_changed: associated
> 16:00:54 larsa kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: true (implement)
> 16:00:54 larsa kernel: wlan0: associated
> 16:00:54 larsa kernel: cfg80211: Calling CRDA to update world regulatory domain
> 16:00:54 larsa kernel: brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 159/256 dur 1778/1504
> 16:00:55 larsa kernel: brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 159/256 dur 1778/1504
> 16:00:56 larsa kernel: brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 159/256 dur 1778/1504
> 16:00:56 larsa kernel: brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 137/256 dur 1602/1504
> 16:00:56 larsa dhcpcd[13130]: wlan0: carrier acquired
> 16:00:56 larsa kernel: brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 153/256 dur 1730/1504
> 16:00:57 larsa kernel: cfg80211: Calling CRDA to update world regulatory domain
> 16:00:57 larsa kernel: brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 153/256 dur 1730/1504
> 16:00:58 larsa kernel: brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 153/256 dur 1730/1504
> 16:00:59 larsa dhcpcd[13130]: wlan0: carrier lost
> 16:00:59 larsa kernel: wlan0: deauthenticated from b0:48:7a:d1:6c:0c (Reason: 2=PREV_AUTH_NOT_VALID)
> 16:00:59 larsa kernel: brcmsmac bcma0:1: brcmsmac: brcms_ops_bss_info_changed: disassociated
> 16:00:59 larsa kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: false (implement)
