Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaCFVzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 16:55:03 -0500
Date: Fri, 7 Mar 2014 00:54:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: re: rtlwifi: rtl8723be: Add new driver
Message-ID: <20140306215449.GA16213@elgon.mountain> (sfid-20140306_225535_482903_7F77239D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Sorry to bother you about this, because I know we see this same bug
every time we add another Realtek driver and you must be as sick of it
as I am...  :/

The patch a619d1abe20c: "rtlwifi: rtl8723be: Add new driver" from Feb
28, 2014, leads to the following static checker warning:

	drivers/net/wireless/rtlwifi/rtl8723be/phy.c:667 _rtl8723be_store_tx_power_by_rate()
	error: buffer overflow 'rtlphy->tx_power_by_rate_offset[band]' 4 <= 5

drivers/net/wireless/rtlwifi/rtl8723be/phy.c
  646  static void _rtl8723be_store_tx_power_by_rate(struct ieee80211_hw *hw,
   647                                                u32 band, u32 rfpath,
   648                                                u32 txnum, u32 regaddr,
   649                                                u32 bitmask, u32 data)
   650  {
   651          struct rtl_priv *rtlpriv = rtl_priv(hw);
   652          struct rtl_phy *rtlphy = &(rtlpriv->phy);
   653          u8 rate_section = _rtl8723be_get_rate_section_index(regaddr);
   654  
   655          if (band != BAND_ON_2_4G && band != BAND_ON_5G)
   656                  RT_TRACE(rtlpriv, COMP_POWER, PHY_TXPWR,
   657                           "Invalid Band %d\n", band);
   658  
   659          if (rfpath > MAX_RF_PATH)
                             ^^^^^^^^^^^
This should be >= TX_PWR_BY_RATE_NUM_RF.  We should return on error
instead of printing an error and then corrupting memory.

I don't know what to do here to make these bugs go away...

   660                  RT_TRACE(rtlpriv, COMP_POWER, PHY_TXPWR,
   661                           "Invalid RfPath %d\n", rfpath);
   662  
   663          if (txnum > MAX_RF_PATH)
   664                  RT_TRACE(rtlpriv, COMP_POWER, PHY_TXPWR,
   665                           "Invalid TxNum %d\n", txnum);
   666  
   667          rtlphy->tx_power_by_rate_offset[band][rfpath][txnum][rate_section] =
   668                                                                          data;
   669  }

regards,
dan carpenter
