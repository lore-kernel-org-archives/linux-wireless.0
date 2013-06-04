Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43604 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3FDNLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 09:11:05 -0400
MIME-Version: 1.0
Message-ID: <20130604130955.GA13788@debian> (sfid-20130604_151109_997562_EA8EE2C1)
Date: Tue, 4 Jun 2013 06:09:55 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: pizza@shaftnet.org
Cc: linux-wireless@vger.kernel.org
Subject: re: cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Solomon Peachy,

The patch a910e4a94f69: "cw1200: add driver for the ST-E CW1100 &
CW1200 WLAN chipsets" from May 24, 2013, has poor input validation
so the user could write to arbitrary memory.

Also I think this API looks like things which should be done with
normal ioctls.  This driver only lets you load the firmware using a
very ugly custom debugfs interface?

drivers/net/wireless/cw1200/debug.c
   454  
   455          if (!count)
   456                  goto done;
   457  
   458          if (copy_from_user(etf->buf + etf->written, user_buf + written,
   459                             count)) {

"count" isn't capped so we could overwrite etf->written on the first
write and then write to arbitrary memery on the second write.

   460                  pr_err("copy_from_user (payload %zu) failed\n", count);
   461                  return -EFAULT;
   462          }

regards,
dan carpenter

