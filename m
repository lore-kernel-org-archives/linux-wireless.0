Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36316 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbbHLVxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 17:53:12 -0400
Received: by wicja10 with SMTP id ja10so129211541wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 14:53:10 -0700 (PDT)
Date: Wed, 12 Aug 2015 22:53:09 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: ath9k: fails to connect after removing and adding module
Message-ID: <20150812215309.GA2797@bytefire-computer> (sfid-20150812_235315_560153_4985F3F3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resending because it failed to deliver to linux-wireless)

Hi,

This is the set up on my laptop:

- AR9565 wireless network adapter
- Acer Aspire V5-122P laptop - AMD A6-1450M
- Linux kernel built from sources v4.1.0-rc8

In config I changed CONFIG_ATH9K to be built as module. Here's the
snippet from config file in /boot/ directory:

CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
CONFIG_ATH9K_AHB=y
CONFIG_ATH9K_DEBUGFS=y

Next, I built the kernel and installed it. WiFi worked fine. Then I
removed ath9k module by running modprobe -r ath9k and WiFi went. Then I
added the module back by running modprobe -v ath9k which seemed to go
through fine:

~$ sudo modprobe -v ath9k
insmod
/lib/modules/4.1.0-rc8-task11-dirty/kernel/net/wireless/cfg80211.ko
insmod
/lib/modules/4.1.0-rc8-task11-dirty/kernel/net/mac80211/mac80211.ko
insmod
/lib/modules/4.1.0-rc8-task11-dirty/kernel/drivers/net/wireless/ath/ath.ko
insmod
/lib/modules/4.1.0-rc8-task11-dirty/kernel/drivers/net/wireless/ath/ath9k/ath9k_hw.ko
insmod
/lib/modules/4.1.0-rc8-task11-dirty/kernel/drivers/net/wireless/ath/ath9k/ath9k_common.ko
insmod
/lib/modules/4.1.0-rc8-task11-dirty/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko

However the WiFi failed to connect. Kernel log shows wlan0
deauthenticating by local choice. Here is relevant dmesg output which
includes removal of ath9k:

[ 2381.070339] wlan0: deauthenticating from <AP-MAC-ADDRESS> by local
choice (Reason: 3=DEAUTH_LEAVING)
[ 2381.112740] cfg80211: Calling CRDA to update world regulatory domain
[ 2381.128568] cfg80211: World regulatory domain updated:
[ 2381.128583] cfg80211:  DFS Master region: unset
[ 2381.128589] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[ 2381.128599] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2381.128607] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2381.128614] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2381.128621] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2381.128628] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2381.167390] ath9k: ath9k: Driver unloaded
[ 2437.514472] cfg80211: Calling CRDA to update world regulatory domain
[ 2437.532271] cfg80211: World regulatory domain updated:
[ 2437.532295] cfg80211:  DFS Master region: unset
[ 2437.532301] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[ 2437.532310] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2437.532317] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2437.532324] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2437.532331] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2437.532337] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm), (N/A)
[ 2438.557451] ath: phy0: WB335 1-ANT card detected
[ 2438.564368] ath: phy0: Enable LNA combining
[ 2438.565503] ath: phy0: ASPM enabled: 0x43
[ 2438.565511] ath: EEPROM regdomain: 0x65
[ 2438.565515] ath: EEPROM indicates we should expect a direct regpair
map
[ 2438.565522] ath: Country alpha2 being used: 00
[ 2438.565526] ath: Regpair used: 0x65
[ 2438.567745] ieee80211 phy0: Selected rate control algorithm
'minstrel_ht'
[ 2438.569010] ieee80211 phy0: Atheros AR9565 Rev:1
mem=0xffffc90000800000, irq=34
[ 2438.587718] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 2458.673488] wlan0: authenticate with <AP-MAC-ADDRESS>
[ 2458.688912] wlan0: send auth to <AP-MAC-ADDRESS> (try 1/3)
[ 2458.690924] wlan0: authenticated
[ 2463.694617] wlan0: aborting authentication with <AP-MAC-ADDRESS> by
local choice (Reason: 3=DEAUTH_LEAVING)
[ 2463.702156] wlan0: authenticate with <AP-MAC-ADDRESS>
[ 2463.714400] wlan0: send auth to <AP-MAC-ADDRESS> (try 1/3)
[ 2463.716451] wlan0: authenticated
[ 2468.715271] wlan0: aborting authentication with <AP-MAC-ADDRESS> by
local choice (Reason: 3=DEAUTH_LEAVING)
...and it retries few more times 

Rebooting the machine resolves the issue.

If you need further details, let me know. I've got the set up on my
machine.

Okash
