Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35062 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaJINhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 09:37:12 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so13170754wid.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 06:37:11 -0700 (PDT)
Received: from wks001.net.isedev.eu ([2a01:e34:ec00:2830:c617:feff:fe63:e124])
        by mx.google.com with ESMTPSA id d6sm5633614wiz.0.2014.10.09.06.37.09
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Oct 2014 06:37:10 -0700 (PDT)
From: ISE Development <isedev@gmail.com>
To: linux-wireless@vger.kernel.org
Reply-To: isedev@gmail.com
Subject: BCM4312 / b43 DMA transmission sequence errors
Date: Thu, 09 Oct 2014 15:37:09 +0200
Message-ID: <5048348.6LQ0j9FUOS@wks001.net.isedev.eu> (sfid-20141009_153716_597222_B6D2B889)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In March 2013, I submitted a patch to workaround some DMA transmission sequence errors (see mailing list archive for messages with the same title as this one). The patch allowed the b43 driver to recover gracefully from out of sequence txstatus responses from the hardware (BCM4312 in my case). 

I have recently been looking into the problem further and have noticed the correlation below. Currently, this means nothing to me but I am sharing it in the hope that somebody with greater knowledge of the b43 driver, firmware and/or underlying devices might have an epiphany.

On a Fedora 20 system, I rebuilt the driver with CONFIG_B43_DEBUG enabled and modified the out of sequence workaround code in b43_dma_handle_txstatus() slightly to report every error and include the txstatus cookie and sequence number in the debug message.

I then correlated the debug messages with the debugfs txstatus contents:

Debug message:
[ 2830.717129] b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 138, but got 134 (cookie: 0x2086, seq: 0x01C3).
[ 2830.919202] b43-phy0 debug: Skip on DMA ring 1 slot 138 (cookie: 0x208C, seq: 0x01C4).

/sys/kernel/debug/b43/txstatus:
074 | 0x2084 | 0x01C1 | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
075 | 0x2086 | 0x01C2 | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
076 | 0x2088 | 0x01C3 | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 0
077 | 0x2086 | 0x01C3 | 0x00 | 0x0 | 0x0 | 4 | 0 | 0 | 0 | 0
078 | 0x208C | 0x01C4 | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
079 | 0x208E | 0x01C5 | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 0

-> Two txstatus reports for frame 0x01C3, the second indicating suppression (channel mismatch) and containing a wrong (but valid) cookie value.
-> The hardware does not report on whatever was sent with cookie 0x208A (slot 138).

--
Debug message:
[ 3097.631000] b43-phy0 debug: Skip on DMA ring 1 slot 138 (cookie: 0x208C, seq: 0x03C0).

/sys/kernel/debug/b43/txstatus:
019 | 0x2086 | 0x03BE | 0x00 | 0x2 | 0x0 | 0 | 0 | 0 | 0 | 1
020 | 0x2088 | 0x03BF | 0x00 | 0x2 | 0x0 | 0 | 0 | 0 | 0 | 1
021 | 0xABC4 | 0x03BF | 0x00 | 0xF | 0x3 | 4 | 0 | 1 | 0 | 1
022 | 0x208C | 0x03C0 | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
023 | 0x208E | 0x03C1 | 0x00 | 0x3 | 0x0 | 0 | 0 | 0 | 0 | 1

-> Two txstatus reports for frame 0x03BF, the second indicating suppression (channel mismatch) and containing a wrong (and invalid) cookie value. The second report is dropped in b43_handle_txstatus() as the intermediate flag is set (hence, no invalid cookie debug message).
-> Again, the hardware has dropped whatever was sent with cookie 0x208A (slot 138).

--
Debug message:
[ 3157.342173] b43-phy0 debug: Skip on DMA ring 1 slot 138 (cookie: 0x208C, seq: 0x04BE).

/sys/kernel/debug/b43/txstatus:
076 | 0x2084 | 0x04BB | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
077 | 0x2086 | 0x04BC | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
078 | 0x2088 | 0x04BD | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
079 | 0x9A39 | 0x04BD | 0x00 | 0x5 | 0xC | 4 | 1 | 1 | 1 | 0
080 | 0x208C | 0x04BE | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
081 | 0x208E | 0x04BF | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1

-> Same pattern (channel mismatch suppression for slot 136 and no report for slot 138).

--
Debug message:
[ 3208.562873] b43-phy0 debug: TX-status contains invalid cookie: 0x2973
[ 3209.064515] b43-phy0 debug: Skip on DMA ring 1 slot 208 (cookie: 0x20D2, seq: 0x04E0).

/sys/kernel/debug/b43/txstatus:
096 | 0x20CC | 0x04DE | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
097 | 0x20CE | 0x04DF | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1
098 | 0x2973 | 0x04DF | 0x00 | 0x2 | 0x3 | 4 | 0 | 0 | 0 | 0
099 | 0x20D2 | 0x04E0 | 0x00 | 0x1 | 0x0 | 0 | 0 | 0 | 0 | 1

-> Same pattern as first case above, but this time the cookie is invalid. Also, now slots 206 (suppressed) / 208 (dropped).


On my system, these errors only occur for slots 136/138 and 206/208. The large majority of errors (80-90%) are on slots 136/138.

Every such error (invalid cookie, DMA skip, out of order TX status) that I have analysed is associated with a channel mismatch suppression response from the firmware/hardware.

-- isedev
