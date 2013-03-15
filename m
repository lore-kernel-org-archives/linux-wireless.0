Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:48549 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3COWDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 18:03:51 -0400
Received: by mail-qe0-f54.google.com with SMTP id i11so2191061qej.41
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2013 15:03:50 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Mar 2013 16:03:50 -0600
Message-ID: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com> (sfid-20130315_230355_645411_A2767465)
Subject: mwifiex frequent "not allowed while suspended" crash on resume
From: Daniel Drake <dsd@laptop.org>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bing Zhao <bzhao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When the XO-4 with 8787 wireless is woken up due to wake-on-WLAN,
mwifiex is often unhappy and reports this:

mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1) failed: -1
mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2) failed: -1
mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (3) failed: -1
mwifiex_sdio mmc0:0001:1: mwifiex_write_data_async failed: 0xFFFFFFFF
mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
[...]

After this flood of messages, the interface is unusable.

This can be readily reproduced when putting the XO-4 in a loop where
it goes to sleep due to inactivity, but then wakes up due to an
incoming ping. The error is hit within an hour or two.

I think it shows a race where the upper mwifiex layers try to do card
communication before  mwifiex_sdio_resume() has done its work - there
is some serialization missing.

This can be reproduced on every single ping-invoked wakeup if you
insert a msleep(1000) inside mwifiex_sdio_resume() e.g. here:

if (!adapter->is_suspended) {
dev_warn(adapter->dev, "device already resumed\n");
return 0;
}

msleep(1000);
adapter->is_suspended = false;


Thanks for any help you can offer.
Daniel
