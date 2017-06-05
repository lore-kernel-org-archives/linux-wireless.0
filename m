Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44351 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751212AbdFEC4l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Jun 2017 22:56:41 -0400
Date: Mon, 5 Jun 2017 12:56:37 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: wsa@the-dreams.de
Cc: linux-wireless@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        kernelnewbies@kernelnewbies.org
Subject: ks7010 firmware upload fail
Message-ID: <20170605025637.GA23011@eros> (sfid-20170605_045658_788018_943E07C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am attempting to test the ks7010 SIDO Wi-Fi driver (drivers/staging/ks7010/).

Currently probing the driver fails because of a firmware upload error.

I am seeking ideas on where to continue troubleshooting this issue.

Test setup:
- Spectec SDW-823 WIFI card (micro SD).
- Raspberry Pi B 1 (kernel 4.9.29) breakout board connected via GPIO pins.
- Driver code from current mainline (commit 453e102db531ac1ffa55f3e03c4907c063125859)
  (with additional debugging output calls).

Debugging thus far:

- define DEBUG in ks7010 and mmc makefiles (core, card, host).

kernel messages from time of fail:

[ 3746.903972] mmc1: starting CMD53 arg 94002004 flags 000001b5
[ 3746.903985] mmc1:     blksz 4 blocks 1 flags 00000100 tsac 1000 ms nsac 0
[ 3746.904077] mmc1: req done (CMD53): 0: 00001000 00000000 00000000 00000000
[ 3746.904090] mmc1:     4 bytes transferred: 0
[ 3746.904114] mmc1: starting CMD53 arg 94000804 flags 000001b5
[ 3746.904126] mmc1:     blksz 4 blocks 1 flags 00000100 tsac 1000 ms nsac 0
[ 3746.904180] mmc1: req done (CMD53): 0: 00001000 00000000 00000000 00000000
[ 3746.904189] mmc1:     4 bytes transferred: 0
[ 3746.912784] ks7010_upload_firmware: updated index to: 6000000
[ 3746.912816] mmc1: starting CMD53 arg 9e000080 flags 000001b5
[ 3746.912831] mmc1:     blksz 512 blocks 128 flags 00000100 tsac 1000 ms nsac 0
[ 3746.916336] mmc1: req done (CMD53): 0: 00001000 00000000 00000000 00000000
[ 3746.916353] mmc1:     65536 bytes transferred: 0
[ 3746.916420] ks7010_upload_firmware: wrote to address 10000 (DATA_WINDOW) 65536 bytes
[ 3746.916429] ks7010_sdio_data_compare: read 65536 bytes from address 10000
[ 3746.916436] debug messages from mmc/core are enabled
[ 3746.916459] mmc1: starting CMD53 arg 1e000080 flags 000001b5
[ 3746.916472] mmc1:     blksz 512 blocks 128 flags 00000200 tsac 1000 ms nsac 0
[ 3746.916575] mmc1: req done (CMD53): 0: 00001000 00000000 00000000 00000000
[ 3746.916588] mmc1:     0 bytes transferred: -84
[ 3746.920029] ks7010_sdio_read: sdio_memcpy_fromio() failed: -84
[ 3746.920100] ks7010: ERROR firmware load failed: 9

Briefly, firmware is uploaded to the card in chunks. Each chunk is
read back from the card to verify the transfer.

CMD53 can be seen to succeed when writing the first chunk to the
card. ks7010_sdio_data_compare() is then called which calls
ks7010_sdio_read() to read back the data written to the card. It is
this call that fails.

(CMD52 appears to be successful as well as CMD53 write).

All function calls (including memory addresses on the card, and kernel
buffer addresses) appear to be correct.

Removing the call to ks7010_sdio_data_compare() leads to an MMC read
error for each successive read (via CMD53) by the driver.

My question is should I be digging further into the MMC code or be doing
something else with the driver code?

Any suggestions, no matter how simple, most appreciated. This is my
first time digging into MMC and my first time really trying to trouble
shoot a kernel issue.

thanks,
Tobin.
