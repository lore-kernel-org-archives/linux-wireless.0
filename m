Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:32745 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaCMOlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 10:41:25 -0400
Message-ID: <5321C392.6060905@broadcom.com> (sfid-20140313_154130_070943_E799419D)
Date: Thu, 13 Mar 2014 15:41:22 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Giri Prasad <g_pr23@yahoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Dell vostro 1550, BCM 4313 wireless, not connecting to net
References: <1394717956.25634.YahooMailNeo@web194006.mail.sg3.yahoo.com> <5321BCF7.6000509@broadcom.com>
In-Reply-To: <5321BCF7.6000509@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2014 03:13 PM, Arend van Spriel wrote:
> On 03/13/2014 02:39 PM, Giri Prasad wrote:
>>
>>
>> Hello All,
>>
>>  I have a Dell Vostro 1550 laptop. i3 core, 64 bit, 8gb ram etc etc. I had a nic interface, but some how the wired nic is not working. So I am trying to use the BCM 4313 wireless chip, of this system, to connect to the internet.
>>
>>  I have Cent os 6.5 (64 bit) installed with the required libraries and kernel sources, headers etc.
>>
>> I got the source code of the driver, hybrid-v35_64-nodebug-pcoem-6_30_223_141.tar.gz. Extracted the tar, and compiled.
>>
>> Normal compilation errors:
>> # make                                       ## Errors
>> # make API=CFG80211          ## Errors
>>
>> # make API=WEXT     ---------> Compiles fine.
>>
>> # rmmod bcma
>>
>> echo "blacklist bcma" >> /etc/modprobe.d/blacklist.conf
>>
>> # modprobe lib80211
>> # modprobe cfg80211
>> # insmod wl.ko
>>
>> Network Manager shows all surrounding wireless network, and I select my wifi network and enter the key.
>>
>>
>> Authentication required by wireless network (Dialog Box)
>>
>> Passwords or encryption keys are required to access the wireless network 'giri'
>>
>>
>> Wireless security :  WEP 40/128-bit key (HEX or ASCII)
>>
>> Key  :               *********************
>>
>> When I hit the <Connect> button of this dialog box, the network manager shows the rotating signal in the network connection at the top of the Linux desktop status bar. But after a few seconds, once again this dialog-box "Authentication required by wireless network" pops up, and keeps asking me for the key/password.
>>
>> Rhel 6 (64 bit), I built the same driver, and make (only just make - without parameters) for compiling the driver, created the driver, without any problems. Insmod the driver, and upon selecting the wifi network and entering the key, rhel 6 64 bit version, perfectly connected to the net, on this same laptop.
>>
>> Can anyone let me know, why the centos 6.5 kernel/Network Manager is asking for the (wireless security) key every few seconds, again and again, and not connecting to the internet.  And if someone can please inform why a make without parameters and make API=CFG80211, fails to compile, that will be very helpful.
> 
> You are really asking the wrong crowd. Basically, you are using a
> proprietary driver. The compiler errors clearly show those sources are
> outdated and not matching cfg80211 api.
> 
> I can only offer an alternative here. Download a recent backports
> package from [1] and build and install that.

So:

$ make defconfig-brcmsmac
$ make
$ sudo make install

Regards,
Arend

> Gr. AvS
> 
> [1] http://drvbp1.linux-foundation.org/~mcgrof/rel-html/backports/
>> Thanks in advance.
>>
>> Regards,
>> Giri
>>
>> [root@localhost hybrid_wl]#
>> [root@localhost hybrid_wl]# lspci | grep -i Broad
>> 09:00.0 Network controller: Broadcom Corporation BCM4313 802.11bgn Wireless Network Adapter (rev 01)
>>
>>
>> [root@localhost hybrid_wl]# make
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:726: error: ‘struct cfg80211_ibss_params’ has no member named ‘channel’
>>
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1092: error: parameter 2 (‘type’) has incomplete type
>>
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1103: error: ‘TX_POWER_AUTOMATIC’ undeclared (first use in this function)
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1103: error: (Each undeclared identifier is reported only once
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1103: error: for each function it appears in.)
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1105: error: ‘TX_POWER_LIMITED’ undeclared (first use in this function)
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1111: error: ‘TX_POWER_FIXED’ undeclared (first use in this function)
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c: At top level:
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1589: warning: initialization from incompatible pointer type
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1594: warning: initialization from incompatible pointer type
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1595: warning: initialization from incompatible pointer type
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1596: warning: initialization from incompatible pointer type
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1597: warning: initialization from incompatible pointer type
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1598: warning: initialization from incompatible pointer type
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1599: warning: initialization from incompatible pointer type
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c: In function ‘wl_inform_single_bss’:
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1764: error: too few arguments to function ‘ieee80211_channel_to_frequency’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1793: warning: passing argument 1 of ‘cfg80211_put_bss’ from incompatible pointer type
>> include/net/cfg80211.h:3380: note: expected ‘struct wiphy *’ but argument is of type ‘struct cfg80211_bss *’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:1793: error: too few arguments to function ‘cfg80211_put_bss’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c: In function ‘wl_update_bss_info’:
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2046: error: ‘struct cfg80211_bss’ has no member named ‘information_elements’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2047: error: ‘struct cfg80211_bss’ has no member named ‘len_information_elements’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2052: warning: passing argument 1 of ‘cfg80211_put_bss’ from incompatible pointer type
>> include/net/cfg80211.h:3380: note: expected ‘struct wiphy *’ but argument is of type ‘struct cfg80211_bss *’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2052: error: too few arguments to function ‘cfg80211_put_bss’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c: In function ‘wl_bss_roaming_done’:
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2090: warning: passing argument 2 of ‘cfg80211_roamed’ from incompatible pointer type
>> include/net/cfg80211.h:3726: note: expected ‘struct ieee80211_channel *’ but argument is of type ‘u8 *’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2090: warning: passing argument 4 of ‘cfg80211_roamed’ makes pointer from integer without a cast
>> include/net/cfg80211.h:3726: note: expected ‘const u8 *’ but argument is of type ‘s32’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2090: warning: passing argument 5 of ‘cfg80211_roamed’ makes integer from pointer without a cast
>> include/net/cfg80211.h:3726: note: expected ‘size_t’ but argument is of type ‘u8 *’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2090: warning: passing argument 6 of ‘cfg80211_roamed’ makes pointer from integer without a cast
>> include/net/cfg80211.h:3726: note: expected ‘const u8 *’ but argument is of type ‘s32’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2090: error: too few arguments to function ‘cfg80211_roamed’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c: In function ‘wl_bss_connect_done’:
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2122: warning: passing argument 2 of ‘cfg80211_roamed’ from incompatible pointer type
>> include/net/cfg80211.h:3726: note: expected ‘struct ieee80211_channel *’ but argument is of type ‘u8 *’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2122: warning: passing argument 4 of ‘cfg80211_roamed’ makes pointer from integer without a cast
>> include/net/cfg80211.h:3726: note: expected ‘const u8 *’ but argument is of type ‘s32’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2122: warning: passing argument 5 of ‘cfg80211_roamed’ makes integer from pointer without a cast
>> include/net/cfg80211.h:3726: note: expected ‘size_t’ but argument is of type ‘u8 *’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2122: warning: passing argument 6 of ‘cfg80211_roamed’ makes pointer from integer without a cast
>> include/net/cfg80211.h:3726: note: expected ‘const u8 *’ but argument is of type ‘s32’
>> /root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.c:2122: error: too few arguments to function ‘cfg80211_roamed’
>> make[2]: *** [/root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl/src/wl/sys/wl_cfg80211_hybrid.o] Error 1
>> make[1]: *** [_module_/root/Desktop/linux-wireless1/linux-wireless/bcm-4313/hybrid_wl] Error 2
>> make[1]: Leaving directory `/usr/src/kernels/2.6.32-431.el6.x86_64'
>> make: *** [all] Error 2
>>
>> [root@localhost hybrid_wl]# dmesg | tail -20
>> wl 0000:09:00.0: setting latency timer to 64
>> lib80211_crypt: registered algorithm 'TKIP'
>> eth0: Broadcom BCM4727 802.11 Hybrid Wireless Controller 6.30.223.141 (r415941)
>> wl 0000:09:00.0: PCI INT A disabled
>> lib80211_crypt: unregistered algorithm 'TKIP'
>> lib80211_crypt: unregistered algorithm 'NULL'
>> lib80211: common routines for IEEE802.11 drivers
>> lib80211_crypt: registered algorithm 'NULL'
>> cfg80211: Calling CRDA to update world regulatory domain
>> cfg80211: World regulatory domain updated:
>> cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> wl 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
>> wl 0000:09:00.0: setting latency timer to 64
>> lib80211_crypt: registered algorithm 'TKIP'
>> eth0: Broadcom BCM4727 802.11 Hybrid Wireless Controller 6.30.223.141 (r415941)
>>
>> [root@localhost hybrid_wl]# lsmod
>> Module                  Size  Used by
>> lib80211_crypt_tkip     9470  0
>> wl                   4176734  0
>> cfg80211              619515  0
>> lib80211                5127  2 lib80211_crypt_tkip,wl
>> vfat                   10584  1
>>
>>
>> [root@localhost hybrid_wl]# iwconfig
>> lo        no wireless extensions.
>>
>> p1p1      no wireless extensions.
>>
>> pan0      no wireless extensions.
>>
>> eth0      IEEE 802.11  ESSID:""  Nickname:""
>>           Mode:Managed  Frequency:2.462 GHz  Access Point: Not-Associated  
>>           Bit Rate:72 Mb/s   Tx-Power:24 dBm  
>>           Retry min limit:7   RTS thr:off   Fragment thr:off
>>           Encryption key:off
>>           Power Managementmode:All packets received
>>           Link Quality=5/5  Signal level=0 dBm  Noise level=-94 dBm
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>
>>
>>
>> [root@localhost hybrid_wl]# dmesg | tail -20
>> wl 0000:09:00.0: setting latency timer to 64
>> lib80211_crypt: registered algorithm 'TKIP'
>> eth0: Broadcom BCM4727 802.11 Hybrid Wireless Controller 6.30.223.141 (r415941)
>> wl 0000:09:00.0: PCI INT A disabled
>> lib80211_crypt: unregistered algorithm 'TKIP'
>> lib80211_crypt: unregistered algorithm 'NULL'
>> lib80211: common routines for IEEE802.11 drivers
>> lib80211_crypt: registered algorithm 'NULL'
>> cfg80211: Calling CRDA to update world regulatory domain
>> cfg80211: World regulatory domain updated:
>> cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> wl 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
>> wl 0000:09:00.0: setting latency timer to 64
>> lib80211_crypt: registered algorithm 'TKIP'
>> eth0: Broadcom BCM4727 802.11 Hybrid Wireless Controller 6.30.223.141 (r415941)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

