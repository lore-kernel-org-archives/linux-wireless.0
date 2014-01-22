Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:60011 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaAVKrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:47:23 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: zhuyj <zyjzyj2000@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Wed, 22 Jan 2014 10:47:19 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C3358@ALA-MBB.corp.ad.wrs.com> (sfid-20140122_114727_280003_83565595)
References: <52DF947E.40800@gmail.com>,<52DF9E62.7080301@gmail.com>
In-Reply-To: <52DF9E62.7080301@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

root@WR-IntelligentDevice:~# lspci -v | grep 6205
01:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] (rev 34)
        Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN
root@WR-IntelligentDevice:~#


Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: zhuyj [zyjzyj2000@gmail.com]
Sent: Wednesday, January 22, 2014 6:33 PM
To: linux-wireless@vger.kernel.org
Cc: zhuyj; Liu, Bopeng
Subject: Re: 802.11a is supported in AP mode or not?

Hi, maintainers

The kernel version:

uname -a
Linux wind-desktop 3.13.0-test-iwlwifi #1 SMP Mon Jan 20 18:54:22 CST
2014 x86_64 x86_64 x86_64 GNU/Linux

Any reply is appreciated.

Best Regards!
Zhu Yanjun
On 01/22/2014 05:50 PM, zhuyj wrote:
> Hi, maintainers
>
> I made tests on ubuntu 13.10. I followed these steps.
> From the following logs, we can see 802.11a is not supported in
> channel list.
> I want to know whether 802.11a supports this or not? Or 802.11a is not
> used in this?
> Chip is 6205. lspci -vvv is as below.
>
> Thanks a lot.
> Zhu Yanjun
>
> 1. installed ubuntu 13.10 client
>
> 2. git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> linux-git
>
> 3. apt-get install kernel-package
>
> 4. make-kpkg --initrd --append-to-version=-test-iwlwifi kernel_image
> kernel-headers
>
> 5. dpkg -i linux-headers-
>   dpkg -i linux-images-
>
> 6.reboot ubuntu 13.10
>
> 7.    $ vi /etc/hostapd.conf
>     interface=wlan0
>     driver=nl80211
>     logger_syslog=-1
>     logger_syslog_level=2
>     logger_stdout=-1
>     logger_stdout_level=2
>     dump_file=/tmp/hostapd.dump
>     ctrl_interface=/var/run/hostapd
>     ctrl_interface_group=0
>     ssid=test
>     country_code=US
>     hw_mode=a
>     channel=2
>     beacon_int=100
>     dtim_period=2
>     max_num_sta=255
>     rts_threshold=2347
>     fragm_threshold=2346
>     macaddr_acl=0
>     auth_algs=3
>     ignore_broadcast_ssid=0
>     wmm_enabled=1
>     wmm_ac_bk_cwmin=4
>     wmm_ac_bk_cwmax=10
>     wmm_ac_bk_aifs=7
>     wmm_ac_bk_txop_limit=0
>     wmm_ac_bk_acm=0
>     wmm_ac_be_aifs=3
>     wmm_ac_be_cwmin=4
>     wmm_ac_be_cwmax=10
>     wmm_ac_be_txop_limit=0
>     wmm_ac_be_acm=0
>     wmm_ac_vi_aifs=2
>     wmm_ac_vi_cwmin=3
>     wmm_ac_vi_cwmax=4
>     wmm_ac_vi_txop_limit=94
>     wmm_ac_vi_acm=0
>     wmm_ac_vo_aifs=2
>     wmm_ac_vo_cwmin=2
>     wmm_ac_vo_cwmax=3
>     wmm_ac_vo_txop_limit=47
>     wmm_ac_vo_acm=0
>     eap_server=0
>     wpa=2
>     wpa_passphrase=12345678
>     wpa_key_mgmt=WPA-PSK
>     wpa_pairwise=TKIP CCMP
>     wpa_group_rekey=600
>     wpa_gmk_rekey=86400
>
> 8. hostapd -B /etc/hostapd.conf -dd
> random: Trying to read entropy from /dev/random
> Configuration file: /etc/hostapd.conf
> ctrl_interface_group=0
> nl80211: interface wlan0 in phy phy0
> rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
> nl80211: Using driver-based off-channel TX
> nl80211: Register frame command failed (type=208): ret=-114 (Operation
> already in progress)
> nl80211: Register frame match - hexdump(len=2): 04 0a
> nl80211: Failed to register Action frame processing - ignore for now
> nl80211: Add own interface ifindex 3
> nl80211: Set mode ifindex 3 iftype 3 (AP)
> nl80211: Create interface iftype 6 (MONITOR)
> nl80211: New interface mon.wlan0 created: ifindex=4
> nl80211: Add own interface ifindex 4
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Regulatory information - country=00
> nl80211: 2402-2472 @ 40 MHz
> nl80211: 2457-2482 @ 40 MHz
> nl80211: 2474-2494 @ 20 MHz
> nl80211: 5170-5250 @ 40 MHz
> nl80211: 5735-5835 @ 40 MHz
> nl80211: Added 802.11b mode based on 802.11g information
> Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=15 dBm
> wlan0: IEEE 802.11 Configured channel (1) not found from the channel
> list of current mode (2) IEEE 802.11a
> wlan0: IEEE 802.11 Hardware does not support configured channel
> Could not select hw_mode and channel. (-4)
> wlan0: Unable to setup interface.
> Flushing old station entries
> Deauthenticate all stations
> rmdir[ctrl_interface]: No such file or directory
> nl80211: Remove interface ifindex=4
> netlink: Operstate: linkmode=0, operstate=6
> nl80211: Set mode ifindex 3 iftype 2 (STATION)
>
> lspci -vvv
>
> 01:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205
> [Taylor Peak] (rev 34)
>     Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 0, Cache Line Size: 64 bytes
>     Interrupt: pin A routed to IRQ 45
>     Region 0: Memory at f7500000 (64-bit, non-prefetchable) [size=8K]
>     Capabilities: [c8] Power Management version 3
>         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Address: 00000000fee003d8  Data: 0000
>     Capabilities: [e0] Express (v1) Endpoint, MSI 00
>         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <512ns, L1 unlimited
>             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
>             MaxPayload 128 bytes, MaxReadReq 128 bytes
>         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <4us, L1 <32us
>             ClockPM+ Surprise- LLActRep- BwNot-
>         LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>             ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>     Capabilities: [100 v1] Advanced Error Reporting
>         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap-
> ChkEn-
>     Capabilities: [140 v1] Device Serial Number a0-88-b4-ff-ff-70-91-20
>     Kernel driver in use: iwlwifi
>
>

