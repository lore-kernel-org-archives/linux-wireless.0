Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:41568 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932415Ab3CSGom convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 02:44:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: John Rhodes <jrhodes@marvell.com>
Date: Mon, 18 Mar 2013 23:43:48 -0700
Subject: RE: mwifiex frequent "not allowed while suspended" crash on resume
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com> (sfid-20130319_074446_390824_C06036BE)
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
In-Reply-To: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> Hi,
> 
> When the XO-4 with 8787 wireless is woken up due to wake-on-WLAN,
> mwifiex is often unhappy and reports this:
> 
> mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
> mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1) failed: -1

This looks like the same issue with old XO platform where mmc gets timeout.
Do you see "mmc0: Timeout waiting for hardware interrupt" message before mwifiex errors?

> mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
> mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (2) failed: -1
> mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
> mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (3) failed: -1
> mwifiex_sdio mmc0:0001:1: mwifiex_write_data_async failed: 0xFFFFFFFF
> mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
> mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
> mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
> mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
> mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
> mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
> mwifiex_sdio mmc0:0001:1: mwifiex_sdio_host_to_card: no wr_port available
> [...]
> 
> After this flood of messages, the interface is unusable.
> 
> This can be readily reproduced when putting the XO-4 in a loop where
> it goes to sleep due to inactivity, but then wakes up due to an
> incoming ping. The error is hit within an hour or two.
> 
> I think it shows a race where the upper mwifiex layers try to do card
> communication before  mwifiex_sdio_resume() has done its work - there
> is some serialization missing.
> 
> This can be reproduced on every single ping-invoked wakeup if you
> insert a msleep(1000) inside mwifiex_sdio_resume() e.g. here:
> 
> if (!adapter->is_suspended) {
> dev_warn(adapter->dev, "device already resumed\n");
> return 0;
> }
> 
> msleep(1000);
> adapter->is_suspended = false;

WLAN driver expects that the resume handler is called and returned before its interrupt handler is called. Adding a second delay for clearing is_suspended flag almost guarantees the failure of "...not allowed while suspended".

I will think about how to serialize the resume/interrupt sequence.

Thanks,
Bing

> 
> 
> Thanks for any help you can offer.
> Daniel
