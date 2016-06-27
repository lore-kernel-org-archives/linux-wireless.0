Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38966 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbcF0NWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 09:22:32 -0400
Date: Mon, 27 Jun 2016 16:22:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: re: net: wireless: add brcm80211 drivers
Message-ID: <20160627132221.GA1114@mwanda> (sfid-20160627_152235_409043_CF4CD3C7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Arend van Spriel,

The patch 5b435de0d786: "net: wireless: add brcm80211 drivers" from
Oct 5, 2011, leads to the following static checker warning:

	drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:26460 wlc_phy_rxcal_radio_setup_nphy()
	warn: mask and shift to zero

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
 26452                                  } else {
 26453                                          pi->tx_rx_cal_radio_saveregs[4] =
 26454                                                  read_radio_reg(pi,
 26455                                                          RADIO_2056_RX_LNAA_TUNE
 26456                                                          | RADIO_2056_RX0);
 26457  
 26458                                          offtune_val =
 26459                                                  (pi->tx_rx_cal_radio_saveregs
 26460                                                   [2] & 0xF0) >> 8;

This is obviously nonsense code, but I have no idea what was intended.

 26461                                          offtune_val =
 26462                                                  (offtune_val <= 0x7) ? 0xF : 0;

This is perhaps a bug fix/work around for the earlier line.

 26463  
 26464                                          mod_radio_reg(pi,
 26465                                                        RADIO_2056_RX_LNAA_TUNE |
 26466                                                        RADIO_2056_RX0, 0xF0,
 26467                                                        (offtune_val << 8));
 26468                                  }

regards,
dan carpenter
