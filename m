Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:54643 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999Ab3BTFN5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 00:13:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 19 Feb 2013 21:06:03 -0800
Subject: RE: mwifiex crash when removing interface while scanning
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com> (sfid-20130220_061401_128644_352F63CC)
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> > insmod mwifiex_sdio.ko
> > sleep 1
> > ifconfig eth0 up
> > iwlist eth0 scan &
> > sleep 0.5
> > rmmod mwifiex_sdio
> >
> > It normally runs fine the first time, no errors, but run it again and
> > it terminates with these errors:
> >
> >     mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1
> >     eth0      Failed to read scan data : No such device

After this error message, do you see the sd8787 card is removed from the bus?

"mmc0: card 0001 removed"

> >
> > From this point, things are pretty screwed up. Try to load the driver again...
> >
> > insmod mwifiex_sdio.ko
> > mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
> > mwifiex_sdio mmc0:0001:1: WLAN FW is active
> > mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id
> > (331.391420) = 0xa9, act = 0x0
> > mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
> > mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
> > mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
> > mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
> > mwifiex_sdio mmc0:0001:1: last_cmd_index = 1
> > mwifiex_sdio mmc0:0001:1: last_cmd_id: 00 00 a9 00 00 00 00 00 00 00
> > mwifiex_sdio mmc0:0001:1: last_cmd_act: 00 00 00 00 00 00 00 00 00 00
> > mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 0
> > mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 00 00 00 00 00 00 00 00 00 00
> > mwifiex_sdio mmc0:0001:1: last_event_index = 0
> > mwifiex_sdio mmc0:0001:1: last_event: 00 00 00 00 00 00 00 00 00 00
> > mwifiex_sdio mmc0:0001:1: data_sent=1 cmd_sent=1
> > mwifiex_sdio mmc0:0001:1: ps_mode=0 ps_state=0
> > mwifiex_sdio mmc0:0001:1: cmd timeout
> > mwifiex_sdio: Resetting card...
> > WARNING: driver mwifiex_sdio did not remove its interrupt handler!
> > mmc0: card 0001 removed
> >
> > and it doesn't come back.
> >
> > Let me know how we can help further debugging.
> 
> I will try this test with my SD8787 card and get back to you later.

My card works fine with a Ricoh controller on x86_64 machine. Of course the power is not cut when I remove the mwifiex_sdio module.

I can upgrade my XO-4 to kernel 3.8 if feasible. Please let me know if a HOW-TO doc is available.

Thanks,
Bing

