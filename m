Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28642 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399AbbDPLV4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 07:21:56 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Florian Achleitner <flo@fopen.at>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Avinash Patil" <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Date: Thu, 16 Apr 2015 04:21:50 -0700
Subject: RE: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB768F@SC-VEXCH1.marvell.com> (sfid-20150416_132200_405032_A8DB815E)
References: <3169170.GKjfvNuGRf@r90b40zn>
 <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFC5A9@SC-VEXCH1.marvell.com>
 <1743827.ElKz8IjFhJ@r90b40zn>
In-Reply-To: <1743827.ElKz8IjFhJ@r90b40zn>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Florian,

> On Thursday 16 April 2015 02:30:59 Amitkumar Karwar wrote:
> >[...]
> > We haven't seen this behavior yet. Could you please share complete
> log?
> Logs follow per scenario.
> 
> > > (1)  mwifiex_cmd_timeout_func: Timeout cmd .. Ok, after reset.
> [164276.211216] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1)
> failed:
> -110
> [164276.219198] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2)
> failed:
> -110
> [164286.247400] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func:
> Timeout cmd id = 0x107, act = 0x0 [164286.256501] mwifiex_sdio
> mmc0:0001:1: num_data_h2c_failure = 0 [164286.262593] mwifiex_sdio
> mmc0:0001:1: num_cmd_h2c_failure = 0 [164286.268537] mwifiex_sdio
> mmc0:0001:1: is_cmd_timedout = 1 [164286.274088] mwifiex_sdio
> mmc0:0001:1: num_tx_timeout = 0 [164286.279565] mwifiex_sdio
> mmc0:0001:1: last_cmd_index = 0 [164286.285025] mwifiex_sdio
> mmc0:0001:1: last_cmd_id: 07 01 07 01 07 01 07 01
> 07 01
> [164286.292587] mwifiex_sdio mmc0:0001:1: last_cmd_act: 00 00 00 00 00
> 00 00 00
> 00 00
> [164286.300245] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 4
> [164286.306101] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 07 81 07 81
> 07 81
> 07 81 07 81
> [164286.314097] mwifiex_sdio mmc0:0001:1: last_event_index = 3
> [164286.319757] mwifiex_sdio mmc0:0001:1: last_event: 58 00 58 00 58 00
> 0b 00
> 58 00
> [164286.327180] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
> [164286.333026] mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
> [164286.338698] mwifiex_sdio mmc0:0001:1: cmd timeout [164286.347116]
> mwifiex_sdio mmc0:0001:1: === DRIVER INFO DUMP START=== [164286.348307]
> mwifiex_sdio mmc0:0001:1: SDIO register DUMP START [164286.364842]
> mwifiex_sdio mmc0:0001:1: SDIO Func0 (0x0-0x9): 32 02 02 00 03
> 02 00 02 03 00
> [164286.375346] mwifiex_sdio mmc0:0001:1: SDIO Func1 (0x0-0x9): 00 3f 03
> 03 01
> 00 ff ff 0a 00
> [164286.375995] mwifiex_sdio mmc0:0001:1: SDIO Func1: (0x28) 00 (0x30)
> 00
> (0x34) 07 (0x38) 00 (0x3c) 00
> [164286.376881] mwifiex_sdio mmc0:0001:1: SDIO Func1 (0x60-0x6a): dc fe
> ed 00 1d 00 00 ec ec 00 20 [164286.671632] mwifiex_sdio mmc0:0001:1:
> SDIO Func1 (0x60-0x6a): dc fe 0b 00 3b 00 00 ec ec 00 20 [164286.671788]
> mwifiex_sdio mmc0:0001:1: SDIO register DUMP END [164286.672062]
> mwifiex_sdio mmc0:0001:1: === DRIVER INFO DUMP END=== [164286.672087]
> mwifiex_sdio: Resetting card...
> [164286.755091] mmc0: card 0001 removed
> [164287.957529] mxs-mmc 80010000.ssp: Device reset triggered!
> [164288.628044] mmc0: new high speed SDIO card at address 0001
> [164289.750729] mwifiex_sdio mmc0:0001:1: info: FW download over, size
> 447384 bytes [164289.977539] mwifiex_sdio mmc0:0001:1: WLAN FW is active
> [164290.445054] ieee80211 phy9: ignoring F/W country code US
> [164290.483702] mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0
> (14.66.9.p96)
> [165634.314756] cfg80211: Calling CRDA to update world regulatory domain
> 
> > > (2)  Firmware wakeup failed.. Ok, after reset.
> [230837.497001] mxs-mmc 80010000.ssp: Device reset triggered!
> [230838.189850] mmc0: new high speed SDIO card at address 0001
> [230840.415197] mwifiex_sdio mmc0:0001:1: info: FW download over, size
> 447384 bytes [230840.656847] mwifiex_sdio mmc0:0001:1: WLAN FW is active
> [230841.111489] ieee80211 phy21: ignoring F/W country code US
> [230841.169867] mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0
> (14.66.9.p96)
> [231000.116588] mwifiex_sdio mmc0:0001:1: Firmware wakeup failed
> [231000.122550] mwifiex_sdio mmc0:0001:1: failed to get signal
> information [231000.129544] mwifiex_sdio: Resetting card...
> 
> > > (3) DNLD_CMD: host to card failed. No reset triggered. See patch.
> Without patch:
> 134669.799365] cfg80211: Calling CRDA to update world regulatory domain
> [141183.720924] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1)
> failed:
> -110
> [141183.721405] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2)
> failed:
> -110
> [141183.721893] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (3)
> failed:
> -110
> [141183.722188] mwifiex_sdio mmc0:0001:1: DNLD_CMD: host to card failed
> [178868.935885] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1)
> failed:
> -84
> [178868.936295] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2)
> failed:
> -84
> [178868.936644] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (3)
> failed:
> -84
> [178868.936874] mwifiex_sdio mmc0:0001:1: DNLD_CMD: host to card failed
> [178868.947200] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1)
> failed:
> -110
> [178868.947739] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2)
> failed:
> -110
> [178868.948153] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (3)
> failed:
> -110
> [178868.948451] mwifiex_sdio mmc0:0001:1: DNLD_CMD: host to card failed
> [178906.974145] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1)
> failed:
> -84
> [178906.974544] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2)
> failed:
> -84
> [178906.974890] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (3)
> failed:
> -84
> [178906.975122] mwifiex_sdio mmc0:0001:1: DNLD_CMD: host to card failed
> [178906.985090] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1)
> failed:
> -110
> [178906.985565] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2)
> failed:
> -110
> [178906.986036] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (3)
> failed:
> -110
> [178906.986332] mwifiex_sdio mmc0:0001:1: DNLD_CMD: host to card failed
> [178930.845685] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1)
> failed:
> -84
> [178930.846069] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2)
> failed:
> -84
> [178930.846408] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (3)
> failed:
> -84
> [178930.846638] mwifiex_sdio mmc0:0001:1: DNLD_CMD: host to card failed
> 
> The interface does not work in this state. Note the long times between
> some messages.


"host_to_card, write iomem (1) failed: -110" error indicates that MMC subsystem's sdio_writesb() API failed with timeout error.

WLAN driver or FW has nothing to do with this. This seems to be your MMC host controller/hardware problem. Adding a recovering mechanism in WLAN driver doesn't look correct here. We should rather need to root cause the problem.
Our "DNLD_CMD: host to card failed" error message is displayed for other failures also. As explained earlier, if it's write data port not available problem. It will automatically resolve after sometimes. Triggering reset would be unnecessary for that case.

Regards,
Amitkumar
