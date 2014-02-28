Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23010 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaB1XRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 18:17:37 -0500
Date: Sat, 1 Mar 2014 02:17:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nbd@openwrt.org
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kbuild@01.org
Subject: re: ath9k: reduce baseband hang detection false positive rate
Message-ID: <20140228231709.GC22115@elgon.mountain> (sfid-20140301_001741_187000_D0E450C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix Fietkau,

The patch d31a36a6d87f: "ath9k: reduce baseband hang detection false
positive rate" from Feb 24, 2014, leads to the following static
checker warning:

	drivers/net/wireless/ath/ath9k/hw.c:1563 ath9k_hw_check_alive()
	info: ignoring unreachable code.

drivers/net/wireless/ath/ath9k/hw.c
  1545          do {
  1546                  reg = REG_READ(ah, AR_OBS_BUS_1);
  1547                  if (reg != last_val)
  1548                          return true;
  1549  
  1550                  last_val = reg;
  1551                  if ((reg & 0x7E7FFFEF) == 0x00702400)
  1552                          continue;
  1553  
  1554                  switch (reg & 0x7E000B00) {
  1555                  case 0x1E000000:
  1556                  case 0x52000B00:
  1557                  case 0x18000B00:
  1558                          continue;
  1559                  default:
  1560                          return true;
  1561                  }
  1562  
  1563                  udelay(1);
                        ^^^^^^^^^
We never hit this recently added delay.

  1564          } while (count-- > 0);

regards,
dan carpenter
