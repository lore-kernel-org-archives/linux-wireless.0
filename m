Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24641 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab3DGJk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 05:40:56 -0400
Date: Sun, 7 Apr 2013 12:39:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: re: rtlwifi: rtl8188ee: Add new driver
Message-ID: <20130407093859.GA28809@longonot.mountain> (sfid-20130407_114100_696830_00AFD7B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

I had a question about f0eb856e0b6c: "rtlwifi: rtl8188ee: Add new
driver" from Mar 24, 2013.

drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
  1631          for (path = 0; path < MAX_RF_PATH; path++) {
  1632                  /*2.4G default value*/
  1633                  for (i = 0; i < MAX_CHNL_GROUP_24G; i++) {
  1634                          pwr2g->index_cck_base[path][i] = hwinfo[eadr++];
  1635                          if (pwr2g->index_cck_base[path][i] == 0xFF)
  1636                                  pwr2g->index_cck_base[path][i] = 0x2D;
  1637                  }
  1638                  for (i = 0; i < MAX_CHNL_GROUP_24G-1; i++) {
                                        ^^^^^^^^^^^^^^^^^^^^
We skip the last element of the array.  It's declared on the stack in
the caller function so it just has uninitialized stack data.  It doesn't
look intentional to me.

  1639                          pwr2g->index_bw40_base[path][i] = hwinfo[eadr++];
  1640                          if (pwr2g->index_bw40_base[path][i] == 0xFF)
  1641                                  pwr2g->index_bw40_base[path][i] = 0x2D;
  1642                  }

regards,
dan carpenter

