Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout9.freenet.de ([195.4.92.99]:48237 "EHLO mout9.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1GUPfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:35:24 -0400
Message-ID: <4E284785.5090503@01019freenet.de> (sfid-20110721_173528_864545_E0AC8190)
Date: Thu, 21 Jul 2011 17:36:37 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com> <201107201536.01392.helmut.schaa@googlemail.com> <CAN=pzdKLtB2yz4-OhKL5gzYF0Qm2weAmNAz-0MqdFuooFNYzwQ@mail.gmail.com> <201107201709.42141.helmut.schaa@googlemail.com> <CAN=pzdL7baXMVORm6CDh4Py773jbFBFkfRUKhjbL0ATZ_yvJmg@mail.gmail.com> <CAGXE3d9HgRvdJModc3hSA25+jLktZJ3i997oq7GfZz4dUJfuvw@mail.gmail.com>
In-Reply-To: <CAGXE3d9HgRvdJModc3hSA25+jLktZJ3i997oq7GfZz4dUJfuvw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Helmut,

I applied your patch to compat-wireless-2011-07-18 on an Intel Core i5
CPU M460 2.53 GHz (quad core) with kernel
kernel-desktop-3.0.rc7-1.1.x86_64 from OpenSuSE and tested with Linksys
WUSB600N v2 (it's a rt3572 chip) on 40MHz / 802.11n . I just run it a
few days ago with the same compat-wireless package and it was totally
unusable.

With your patch, it's surprisingly running now - ok, the performance is
not as good as with rt3572sta and it isn't stable under high load (you
know - netperf and so ...). It just stalls after a few minutes. There
are at this moment no entries in messages. But before, I get an entry:

Jul 21 16:59:42 pc2 kernel: [20443.730419] phy0 ->
rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out,
invoke forced tx handler

The ping-latency is great - about 0.5 ms (rt3572sta: about 0.7 ms). The
performance with netperf is:

			rt3572sta	rt2800usb
supplicant -> hostapd	6.3 M/s		4 M/s
hostapd -> supplicant	7.7 M/s		5.7 M/s


If you could increase the stability under load and if you could increase
the performance a bit more, it would be great!

Some device information from messages:


Jul 21 16:58:20 pc2 kernel: [20361.966847] usb 2-1.1: new high speed USB
device number 8 using ehci_hcd
Jul 21 16:58:20 pc2 kernel: [20362.084522] usb 2-1.1: New USB device
found, idVendor=1737, idProduct=0079
Jul 21 16:58:20 pc2 kernel: [20362.084529] usb 2-1.1: New USB device
strings: Mfr=1, Product=2, SerialNumber=3
Jul 21 16:58:20 pc2 kernel: [20362.084534] usb 2-1.1: Product: Linksys
WUSB600N Wireless-N USB Network Adapter with Dual-Band ver. 2
Jul 21 16:58:20 pc2 kernel: [20362.084538] usb 2-1.1: Manufacturer: Linksys
Jul 21 16:58:20 pc2 mtp-probe: checking bus 2, device 8:
"/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1"
Jul 21 16:58:20 pc2 mtp-probe: bus: 2, device: 8 was not an MTP device
Jul 21 16:58:20 pc2 kernel: [20362.161618] cfg80211: Calling CRDA to
update world regulatory domain
Jul 21 16:58:20 pc2 kernel: [20362.169831] cfg80211: World regulatory
domain updated:
Jul 21 16:58:20 pc2 kernel: [20362.169839] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 21 16:58:20 pc2 kernel: [20362.169841] cfg80211:     (2402000 KHz -
2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 21 16:58:20 pc2 kernel: [20362.169843] cfg80211:     (2457000 KHz -
2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 21 16:58:20 pc2 kernel: [20362.169845] cfg80211:     (2474000 KHz -
2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 21 16:58:20 pc2 kernel: [20362.169847] cfg80211:     (5170000 KHz -
5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 21 16:58:20 pc2 kernel: [20362.169848] cfg80211:     (5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 21 16:58:20 pc2 kernel: [20362.169873] cfg80211: Calling CRDA for
country: DE
Jul 21 16:58:20 pc2 kernel: [20362.176622] cfg80211: Regulatory domain
changed to country: DE
Jul 21 16:58:20 pc2 kernel: [20362.176626] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 21 16:58:20 pc2 kernel: [20362.176629] cfg80211:     (2400000 KHz -
2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 21 16:58:20 pc2 kernel: [20362.176631] cfg80211:     (5150000 KHz -
5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 21 16:58:20 pc2 kernel: [20362.176633] cfg80211:     (5470000 KHz -
5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Jul 21 16:58:20 pc2 kernel: [20362.259525] usb 2-1.1: reset high speed
USB device number 8 using ehci_hcd
Jul 21 16:58:20 pc2 kernel: [20362.372816] phy0 -> rt2x00_set_chip: Info
- Chipset detected - rt: 3572, rf: 0009, rev: 0221.
Jul 21 16:58:20 pc2 kernel: [20362.373070] ieee80211 phy0: Selected rate
control algorithm 'minstrel_ht'
Jul 21 16:58:20 pc2 kernel: [20362.374341] Registered led device:
rt2800usb-phy0::radio
Jul 21 16:58:20 pc2 kernel: [20362.374430] Registered led device:
rt2800usb-phy0::assoc
Jul 21 16:58:20 pc2 kernel: [20362.374470] Registered led device:
rt2800usb-phy0::quality
Jul 21 16:58:20 pc2 kernel: [20362.374850] usbcore: registered new
interface driver rt2800usb
Jul 21 16:58:20 pc2 kernel: [20362.395110] udev[7976]: renamed network
interface wlan0 to wlan1

Jul 21 16:58:35 pc2 kernel: [20376.646437] phy0 ->
rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'.
Jul 21 16:58:35 pc2 kernel: [20376.649110] phy0 ->
rt2x00lib_request_firmware: Info - Firmware detected - version: 0.236.
Jul 21 16:58:35 pc2 kernel: [20376.868997] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
Jul 21 16:58:35 pc2 kernel: [20376.870375] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
Jul 21 16:58:35 pc2 kernel: [20376.871619] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
Jul 21 16:58:35 pc2 kernel: [20376.872867] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
Jul 21 16:58:35 pc2 kernel: [20376.874723] ADDRCONF(NETDEV_UP): wlan1:
link is not ready
Jul 21 16:58:38 pc2 kernel: [20380.335178] wlan1: authenticate with
68:7f:74:fb:39:ee (try 1)
Jul 21 16:58:38 pc2 kernel: [20380.336708] wlan1: authenticated
Jul 21 16:58:38 pc2 kernel: [20380.351817] wlan1: associate with
68:7f:74:fb:39:ee (try 1)
Jul 21 16:58:38 pc2 kernel: [20380.354946] wlan1: RX AssocResp from
68:7f:74:fb:39:ee (capab=0x411 status=0 aid=1)
Jul 21 16:58:38 pc2 kernel: [20380.354953] wlan1: associated
Jul 21 16:58:38 pc2 kernel: [20380.355048] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
Jul 21 16:58:38 pc2 kernel: [20380.356823] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
Jul 21 16:58:38 pc2 kernel: [20380.358414] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 93.
Jul 21 16:58:38 pc2 kernel: [20380.359820] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 46.
Jul 21 16:58:38 pc2 kernel: [20380.385902] ADDRCONF(NETDEV_CHANGE):
wlan1: link becomes ready
Jul 21 16:58:38 pc2 kernel: [20380.385970] cfg80211: Calling CRDA for
country: DE
Jul 21 16:58:38 pc2 kernel: [20380.390979] cfg80211: Regulatory domain
changed to country: DE
Jul 21 16:58:38 pc2 kernel: [20380.390983] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 21 16:58:38 pc2 kernel: [20380.390988] cfg80211:     (2400000 KHz -
2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 21 16:58:38 pc2 kernel: [20380.390993] cfg80211:     (5150000 KHz -
5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 21 16:58:38 pc2 kernel: [20380.390996] cfg80211:     (5470000 KHz -
5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)



wlan1     IEEE 802.11abgn  ESSID:"Hurra"
          Mode:Managed  Frequency:2.412 GHz  Access Point: 11:22:33:44:55:66
          Bit Rate=130 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=47/70  Signal level=-63 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:79   Missed beacon:0


Kind regards,
Andreas


PS
before this patch, I got millions of entries in messages like this,
absolutely no performance (about 1 k/s or nothing):

Jul 20 17:51:18 pc2 kernel: [ 5496.416075] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 63
Jul 20 17:51:18 pc2 kernel: [ 5496.416098] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 0
Jul 20 17:51:18 pc2 kernel: [ 5496.416112] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 1
Jul 20 17:51:18 pc2 kernel: [ 5496.416128] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 3
Jul 20 17:51:18 pc2 kernel: [ 5496.416142] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 4
Jul 20 17:51:18 pc2 kernel: [ 5496.416157] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 6
Jul 20 17:51:18 pc2 kernel: [ 5496.416170] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 7
Jul 20 17:51:18 pc2 kernel: [ 5496.416186] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 9
Jul 20 17:51:18 pc2 kernel: [ 5496.416200] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 10
Jul 20 17:51:18 pc2 kernel: [ 5496.417799] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 12
Jul 20 17:51:18 pc2 kernel: [ 5496.417814] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 14
Jul 20 17:51:18 pc2 kernel: [ 5496.417823] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 15
Jul 20 17:51:18 pc2 kernel: [ 5496.420927] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 16
Jul 20 17:51:18 pc2 kernel: [ 5496.420948] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 17
Jul 20 17:51:18 pc2 kernel: [ 5496.421164] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 19
Jul 20 17:51:18 pc2 kernel: [ 5496.421169] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 20
Jul 20 17:51:18 pc2 kernel: [ 5496.421802] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 22
Jul 20 17:51:18 pc2 kernel: [ 5496.421829] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 23
Jul 20 17:51:18 pc2 kernel: [ 5496.421922] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 25
Jul 20 17:51:18 pc2 kernel: [ 5496.424431] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 26
Jul 20 17:51:18 pc2 kernel: [ 5496.424459] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 27
Jul 20 17:51:18 pc2 kernel: [ 5496.424683] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 29
Jul 20 17:51:18 pc2 kernel: [ 5496.424708] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 30
Jul 20 17:51:18 pc2 kernel: [ 5496.424916] phy0 ->
rt2800usb_txdone_entry_check: Warning - TX status report missed for
queue 2 entry 32

