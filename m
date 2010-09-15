Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36685 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0IOB4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 21:56:52 -0400
Received: by pwi3 with SMTP id 3so16222pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 18:56:52 -0700 (PDT)
MIME-Version: 1.0
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 11:56:32 +1000
Message-ID: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com>
Subject: [ath5k] Incorrect value for ACK_TIMEOUT
To: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the 802.11-2007 spec document, the ACKTimeout value is
(Section 9.2.8 ACK procedure):
ACKTimeout = aSIFSTime + aSlotTime + aPHY-RX-START-Delay

>From Table 17-15—OFDM PHY characteristics, the values are:
aSIFSTime = 16
aSlotTime = 9
aPHY-RX-START-Delay = 25

Therefore, ACKTimeout = 50

In the driver source, this appears to be initialised to:

$$ ath5k.h
#define AR5K_INIT_ACK_CTS_TIMEOUT		1024

$$ reg.h
/*
 * ACK/CTS timeout register
 */
#define AR5K_TIME_OUT		0x8014			/* Register Address */
#define AR5K_TIME_OUT_ACK	0x00001fff	/* ACK timeout mask */
#define AR5K_TIME_OUT_ACK_S	0
#define AR5K_TIME_OUT_CTS	0x1fff0000	/* CTS timeout mask */
#define AR5K_TIME_OUT_CTS_S	16

Taking the value of the register (1024), masking it with the ACK
Timeout Mask (0x1fff) and dividing it by the clock rate (40), we get a
much smaller ACK Timeout value:
1024 & 0x1fff = 1024
1024/40 = 25us


Am I understanding this right? Is the driver actually setting the ACK
Timeout to be much smaller than even a DIFS, let alone matching the
spec?



Thanks,

--
Jonathan Guerin
