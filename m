Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49284 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbKZMBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:01:01 -0500
Date: Thu, 26 Nov 2015 14:59:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mb@bu3sch.de
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: (bug report) b43: impossible conditions in debugfs
Message-ID: <20151126115924.GI10556@mwanda> (sfid-20151126_130106_065304_625DEA37)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Michael Buesch,

The patch 6bbc321a96d4: "b43: Add debugfs files for random SHM
access" from Jun 19, 2008, leads to the following static checker
warning:

	drivers/net/wireless/broadcom/b43/debugfs.c:217 shm32write__write_file()
	warn: impossible condition '(mask > 4294967295) => (0-u32max > u32max)'

drivers/net/wireless/broadcom/b43/debugfs.c
   198  static int shm32write__write_file(struct b43_wldev *dev,
   199                                    const char *buf, size_t count)
   200  {
   201          unsigned int routing, addr, mask, set;
   202          u32 val;
   203          int res;
   204  
   205          res = sscanf(buf, "0x%X 0x%X 0x%X 0x%X",
   206                       &routing, &addr, &mask, &set);
   207          if (res != 4)
   208                  return -EINVAL;
   209          if (routing > B43_MAX_SHM_ROUTING)
   210                  return -EADDRNOTAVAIL;
   211          if (addr > B43_MAX_SHM_ADDR)
   212                  return -EADDRNOTAVAIL;
   213          if (routing == B43_SHM_SHARED) {
   214                  if ((addr % 2) != 0)
   215                          return -EADDRNOTAVAIL;
   216          }
   217          if ((mask > 0xFFFFFFFF) || (set > 0xFFFFFFFF))

Both of these conditions are impossible.

   218                  return -E2BIG;
   219  
   220          if (mask == 0)
   221                  val = 0;
   222          else
   223                  val = b43_shm_read32(dev, routing, addr);
   224          val &= mask;
   225          val |= set;
   226          b43_shm_write32(dev, routing, addr, val);
   227  
   228          return 0;
   229  }

See also:
drivers/net/wireless/broadcom/b43/debugfs.c:346 mmio32write__write_file() warn: impossible condition '(mask > 4294967295) => (0-u32max > u32max)'
drivers/net/wireless/broadcom/b43/debugfs.c:346 mmio32write__write_file() warn: impossible condition '(set > 4294967295) => (0-u32max > u32max)'


regards,
dan carpenter
