Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lager.deltatee.com ([207.54.116.66]:55600 "EHLO
	porter.deltatee.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756188Ab0GVSdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:33:16 -0400
Message-ID: <4C488EEA.5020505@deltatee.com>
Date: Thu, 22 Jul 2010 12:33:14 -0600
From: Logan Gunthorpe <logang@deltatee.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: linux-wireless@vger.kernel.org
Subject: wl1271 with atmel-mci
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luciano,

I've had the wl1271 working for the most part on an Atmel 
micro-controller, but I've been fighting with a bug for the past couple 
of days.

The problem happens whenever I try to transmit large packets of data 
(using iperf, or nc, etc) the driver would hang and no longer be able to 
send packets. tx_queue_len in the debugfs would then grow as I tried to 
send packets but nothing would actually be sent to the device. At the 
same time receiving packets would consistently work all of the time.

When this occurred I usually got the following messages:

atmel_mci atmel_mci.0: data CRC error
wl1271: ERROR sdio write failed (-84) - addr 0x14fd8, 1076 bytes, 1

(Note: I added the bit at the end of the wl1271 write failed message in 
order to try and debug this problem.)

Upon further investigation I found that any calls to sdio_writesb with a 
length greater than or equal to 1024 will occasionally fail with a data 
CRC error and this would cause the device to stop working.

I have also found that the following ugly hack in wl1271_sdio_raw_write 
seems to fix the problem:

if (len <= 1000) {
     ret = sdio_writesb(func, addr, buf, len);
} else {
     ret = sdio_writesb(func, addr, buf, 1000);
     ret |= sdio_writesb(func, addr, &buf[1000], len-1000);
}

Based on the above, I am currently thinking there may be a bug in the 
atmel-mci driver that causes this problem. Therefore, I will likely 
contact that driver's maintainer next. I was just hoping to get your 
insight in case there is something I am missing on the wl1271 side.

Thanks,

Logan
