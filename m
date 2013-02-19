Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65195 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab3BSSIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 13:08:39 -0500
Received: by mail-qc0-f174.google.com with SMTP id z24so2651655qcq.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 10:08:38 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 19 Feb 2013 12:02:27 -0600
Message-ID: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com> (sfid-20130219_190843_461974_6CB4298E)
Subject: mwifiex crash when removing interface while scanning
From: Daniel Drake <dsd@laptop.org>
To: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Testing mwifiex_sdio on XO-4 (8787) on Linux 3.8. In OLPC's use case
we quite regularly will power down the wireless card when it is not
being actively used. This is currently proving problematic.

Here is a test case reproducing one of the failures we are seeing:

First, run this script:

insmod mwifiex_sdio.ko
sleep 1
ifconfig eth0 up
iwlist eth0 scan &
sleep 0.5
rmmod mwifiex_sdio

It normally runs fine the first time, no errors, but run it again and
it terminates with these errors:

    mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1
    eth0      Failed to read scan data : No such device

>From this point, things are pretty screwed up. Try to load the driver again...

insmod mwifiex_sdio.ko
mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
mwifiex_sdio mmc0:0001:1: WLAN FW is active
mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id
(331.391420) = 0xa9, act = 0x0
mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
mwifiex_sdio mmc0:0001:1: last_cmd_index = 1
mwifiex_sdio mmc0:0001:1: last_cmd_id: 00 00 a9 00 00 00 00 00 00 00
mwifiex_sdio mmc0:0001:1: last_cmd_act: 00 00 00 00 00 00 00 00 00 00
mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 0
mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 00 00 00 00 00 00 00 00 00 00
mwifiex_sdio mmc0:0001:1: last_event_index = 0
mwifiex_sdio mmc0:0001:1: last_event: 00 00 00 00 00 00 00 00 00 00
mwifiex_sdio mmc0:0001:1: data_sent=1 cmd_sent=1
mwifiex_sdio mmc0:0001:1: ps_mode=0 ps_state=0
mwifiex_sdio mmc0:0001:1: cmd timeout
mwifiex_sdio: Resetting card...
WARNING: driver mwifiex_sdio did not remove its interrupt handler!
mmc0: card 0001 removed

and it doesn't come back.

Let me know how we can help further debugging.

Thanks
Daniel
