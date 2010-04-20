Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:62558 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0DTF7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 01:59:17 -0400
Received: by qyk9 with SMTP id 9so6874166qyk.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 22:59:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19405.11838.119234.371361@gargle.gargle.HOWL>
References: <1271691883-13133-1-git-send-email-tom.leiming@gmail.com>
	 <19405.11838.119234.371361@gargle.gargle.HOWL>
Date: Tue, 20 Apr 2010 13:59:16 +0800
Message-ID: <y2ud82e647a1004192259nec8aad6dy836b76b2211b6a40@mail.gmail.com>
Subject: Re: [PATCH] ath9k-htc: speedup disconnect handling
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/20 Sujith <Sujith.Manoharan@atheros.com>:
> tom.leiming@gmail.com wrote:
>> This patch detects the disconnect in wmi register write path,
>> then speedup the disconnect handling.
>
> What bug does this fix ? Submission of URBs in the REGOUT pipe
> should not really fail, and if it does, it is indicative of a deeper
> problem and recovery mechanisms are needed.

After the 9271 device is unplugged, you will find your machine hung for
several hundreds of milliseconds.

>
> If you do get WMI failures, can you post the relevant sections
> from the kernel log ?

If ATH_DBG_RESET is enabled, you will find the debug messages
below[1] during disconnecting.  From the messages, the short hang should
be caused by the 'RTC stuck in MAC reset'. Once the patch is applied,
no such issue will happen.

[1], debug messages during 9287 disconnecting

[12873.291066] usb 2-1.3: USB disconnect, address 15
[12873.291800] device: 'ep_01': device_unregister
[12873.291809] PM: Removing info for No Bus:ep_01
[12873.292465] device: 'ep_82': device_unregister
[12873.292472] PM: Removing info for No Bus:ep_82
[12873.292654] device: 'ep_83': device_unregister
[12873.292661] PM: Removing info for No Bus:ep_83
[12873.292828] device: 'ep_04': device_unregister
[12873.292834] PM: Removing info for No Bus:ep_04
[12873.292999] device: 'ep_05': device_unregister
[12873.293431] PM: Removing info for No Bus:ep_05
[12873.293612] device: 'ep_06': device_unregister
[12873.293689] PM: Removing info for No Bus:ep_06
[12873.293868] PM: Removing info for usb:2-1.3:1.0
[12873.294338] bus: 'usb': remove device 2-1.3:1.0
[12873.294373] usb 2-1.3: __pm_runtime_resume()!
[12873.294380] usb 2-1.3: __pm_runtime_resume() returns 1!
[12873.294392] device: 'ath9k-phy12::assoc': device_unregister
[12873.294399] PM: Removing info for No Bus:ath9k-phy12::assoc
[12873.294732] device: 'ath9k-phy12::assoc': device_create_release
[12873.294771] device: 'ath9k-phy12::tx': device_unregister
[12873.294778] PM: Removing info for No Bus:ath9k-phy12::tx
[12873.295676] device: 'ath9k-phy12::tx': device_create_release
[12873.295718] device: 'ath9k-phy12::rx': device_unregister
[12873.295725] PM: Removing info for No Bus:ath9k-phy12::rx
[12873.296316] device: 'ath9k-phy12::rx': device_create_release
[12873.296351] device: 'ath9k-phy12::radio': device_unregister
[12873.296358] PM: Removing info for No Bus:ath9k-phy12::radio
[12873.296701] device: 'ath9k-phy12::radio': device_create_release
[12874.349767] ath: timeout (100000 us) on reg 0x7000: 0xfffffffb &
0x00000003 != 0x00000000
[12874.349774] ath: RTC stuck in MAC reset
[12874.349777] ath: Chip reset failed
[12874.349779] ath: Unable to reset channel (2437 Mhz) reset status -22
[12874.349784] ath: Unable to set channel
[12874.349939] ath: ah->misc_mode 0x4
[12874.350750] ath: Unable to remove station entry for: 00:03:7f:13:02:d3
[12874.352092] phy12: Removed STA 00:03:7f:13:02:d3
[12874.352224] phy12: Destroyed STA 00:03:7f:13:02:d3
[12874.352232] wlan14: deauthenticating from 00:03:7f:13:02:d3 by
local choice (reason=3)
[12874.352494] phy12: device now idle
[12875.177375] ath: timeout (100000 us) on reg 0x7000: 0xfffffffb &
0x00000003 != 0x00000000
[12875.177382] ath: RTC stuck in MAC reset
[12875.988627] ath: timeout (100000 us) on reg 0x7000: 0xfffffffb &
0x00000003 != 0x00000000
[12875.988633] ath: RTC stuck in MAC reset
[12875.988638] ath: AWAKE -> FULL-SLEEP
[12876.000157] PM: Removing info for No Bus:wlan14
[12876.005146] cfg80211: All devices are disconnected, going to
restore regulatory settings
[12876.005157] cfg80211: Restoring regulatory settings
[12876.005175] cfg80211: Calling CRDA to update world regulatory domain
[12876.006494] PM: Removing info for No Bus:rfkill13
[12876.013231] PM: Removing info for No Bus:phy12
[12876.026482] usb 2-1.3: ath9k_htc: USB layer deinitialized
[12876.027680] device: 'ep_00': device_unregister
[12876.027684] PM: Removing info for No Bus:ep_00
[12876.027781] PM: Removing info for usb:2-1.3
[12876.029678] bus: 'usb': remove device 2-1.3
[12876.045047] cfg80211: World regulatory domain updated:
[12876.045051]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[12876.045054]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[12876.045057]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[12876.045060]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[12876.045062]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[12876.045065]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[12876.144805] hub 2-1:1.0: __pm_runtime_suspend()!
[12876.144832] hub 2-1:1.0: __pm_runtime_suspend() returns 0!
[12878.705219] usb 2-1: __pm_runtime_suspend() from workqueue!
[12878.716694] usb 2-1: __pm_runtime_suspend() returns 0!
[12881.705105] usb usb2: __pm_runtime_suspend() from workqueue!
[12881.705175] usb usb2: __pm_runtime_suspend() returns 0!

-- 
Lei Ming
