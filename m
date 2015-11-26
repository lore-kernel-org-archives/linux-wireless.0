Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26531 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbKZL7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 06:59:19 -0500
Date: Thu, 26 Nov 2015 14:58:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: zajec5@gmail.com
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: (bug report) b43: precendence error
Message-ID: <20151126115843.GH10556@mwanda> (sfid-20151126_125921_700028_9D3D9652)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ All the old wireless Smatch warnings are showing up as new ones
  because of the path reshuffle in linux-next.  I'm going through and
  reporting the extra suspicious ones.  -dan ]

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

Maybe the intention was:

			buf[i] = (CORDIC_CONVERT(sample.i * max) & 0xFF) << 8;
			buf[i] |= CORDIC_CONVERT((sample.q * max) & 0xFF;

  1805          }
  1806  

regards,
dan carpenter
