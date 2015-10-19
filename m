Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36447 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbbJSPK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 11:10:57 -0400
Date: Mon, 19 Oct 2015 18:10:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: re: rtlwifi: rtl8723be: Add new driver
Message-ID: <20151019151045.GA12293@mwanda> (sfid-20151019_171101_274783_077F841A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry Finger,

The patch a619d1abe20c: "rtlwifi: rtl8723be: Add new driver" from Feb
28, 2014, leads to the following static checker warning:

	drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c:1802 _rtl8723be_read_power_value_fromprom()
	warn: why is the last element skipped?

drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
  1770          if (autoload_fail) {
  1771                  RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
  1772                           "auto load fail : Use Default value!\n");
  1773                  for (path = 0; path < MAX_RF_PATH; path++) {
  1774                          /* 2.4G default value */
  1775                          for (group = 0 ; group < MAX_CHNL_GROUP_24G; group++) {
                                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^
Here we go up to the end.

  1776                                  pw2g->index_cck_base[path][group] = 0x2D;
  1777                                  pw2g->index_bw40_base[path][group] = 0x2D;
  1778                          }
  1779                          for (cnt = 0; cnt < MAX_TX_COUNT; cnt++) {
  1780                                  if (cnt == 0) {
  1781                                          pw2g->bw20_diff[path][0] = 0x02;
  1782                                          pw2g->ofdm_diff[path][0] = 0x04;
  1783                                  } else {
  1784                                          pw2g->bw20_diff[path][cnt] = 0xFE;
  1785                                          pw2g->bw40_diff[path][cnt] = 0xFE;
  1786                                          pw2g->cck_diff[path][cnt] = 0xFE;
  1787                                          pw2g->ofdm_diff[path][cnt] = 0xFE;
  1788                                  }
  1789                          }
  1790                  }
  1791                  return;
  1792          }
  1793  
  1794          for (path = 0; path < MAX_RF_PATH; path++) {
  1795                  /*2.4G default value*/
  1796                  for (group = 0; group < MAX_CHNL_GROUP_24G; group++) {
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^
Here we go to the end.

  1797                          pw2g->index_cck_base[path][group] = hwinfo[addr++];
  1798                          if (pw2g->index_cck_base[path][group] == 0xFF)
  1799                                  pw2g->index_cck_base[path][group] = 0x2D;
  1800  
  1801                  }
  1802                  for (group = 0; group < MAX_CHNL_GROUP_24G - 1; group++) {
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Here we skip the last element.  So far as I can see this looks like a
mistake but I don't know the code well.

  1803                          pw2g->index_bw40_base[path][group] = hwinfo[addr++];
  1804                          if (pw2g->index_bw40_base[path][group] == 0xFF)
  1805                                  pw2g->index_bw40_base[path][group] = 0x2D;
  1806                  }


regards,
dan carpenter
