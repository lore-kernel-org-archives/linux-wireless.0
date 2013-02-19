Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:52010 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934876Ab3BSXcC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 18:32:02 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 19 Feb 2013 15:31:40 -0800
Subject: RE: mwifiex crash when removing interface while scanning
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com> (sfid-20130220_003206_853386_C8A65B79)
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
In-Reply-To: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> Hi,
> 
> Testing mwifiex_sdio on XO-4 (8787) on Linux 3.8. In OLPC's use case
> we quite regularly will power down the wireless card when it is not
> being actively used. This is currently proving problematic.

I have an XO-4. Perhaps I can update to kernel 3.8?

> 
> Here is a test case reproducing one of the failures we are seeing:
> 
> First, run this script:
> 
> insmod mwifiex_sdio.ko
> sleep 1
> ifconfig eth0 up
> iwlist eth0 scan &
> sleep 0.5
> rmmod mwifiex_sdio
> 
> It normally runs fine the first time, no errors, but run it again and
> it terminates with these errors:
> 
>     mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1
>     eth0      Failed to read scan data : No such device
> 
> From this point, things are pretty screwed up. Try to load the driver again...
> 
> insmod mwifiex_sdio.ko
> mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
> mwifiex_sdio mmc0:0001:1: WLAN FW is active
> mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id
> (331.391420) = 0xa9, act = 0x0
> mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
> mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
> mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
> mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
> mwifiex_sdio mmc0:0001:1: last_cmd_index = 1
> mwifiex_sdio mmc0:0001:1: last_cmd_id: 00 00 a9 00 00 00 00 00 00 00
> mwifiex_sdio mmc0:0001:1: last_cmd_act: 00 00 00 00 00 00 00 00 00 00
> mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 0
> mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 00 00 00 00 00 00 00 00 00 00
> mwifiex_sdio mmc0:0001:1: last_event_index = 0
> mwifiex_sdio mmc0:0001:1: last_event: 00 00 00 00 00 00 00 00 00 00
> mwifiex_sdio mmc0:0001:1: data_sent=1 cmd_sent=1
> mwifiex_sdio mmc0:0001:1: ps_mode=0 ps_state=0
> mwifiex_sdio mmc0:0001:1: cmd timeout
> mwifiex_sdio: Resetting card...
> WARNING: driver mwifiex_sdio did not remove its interrupt handler!
> mmc0: card 0001 removed
> 
> and it doesn't come back.
> 
> Let me know how we can help further debugging.

I will try this test with my SD8787 card and get back to you later.

Thanks,
Bing

> 
> Thanks
> Daniel
