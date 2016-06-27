Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16883 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbcF0NlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 09:41:12 -0400
Date: Mon, 27 Jun 2016 16:40:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: re: b43: update cordic code to match current specs
Message-ID: <20160627134034.GA4382@mwanda> (sfid-20160627_154116_445948_166EE542)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Rafał Miłecki,

The patch 6f98e62a9f1b: "b43: update cordic code to match current
specs" from Jan 25, 2010, leads to the following static checker
warning:

	drivers/net/wireless/broadcom/b43/phy_lp.c:1803 lpphy_start_tx_tone()
	warn: mask and shift to zero

drivers/net/wireless/broadcom/b43/phy_lp.c
  1800          for (i = 0; i < samples; i++) {
  1801                  sample = b43_cordic(angle);
  1802                  angle += rotation;
  1803                  buf[i] = CORDIC_CONVERT((sample.i * max) & 0xFF) << 8;
  1804                  buf[i] |= CORDIC_CONVERT((sample.q * max) & 0xFF);

The CORDIC_CONVERT() macro is a bit complicated but I made a small test
program to see how it worked and I believe it just sets buf[i] to zero.

  1805          }
  1806  
  1807          b43_lptab_write_bulk(dev, B43_LPTAB16(5, 0), samples, buf);

regards,
dan carpenter
