Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61787 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCIGAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 01:00:06 -0500
Received: by mail-oa0-f46.google.com with SMTP id i7so5866208oag.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Mar 2014 22:00:05 -0800 (PST)
Message-ID: <531C0363.2090302@lwfinger.net> (sfid-20140309_070012_689067_04BE8AE0)
Date: Sun, 09 Mar 2014 00:00:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi: rtl8723be: Add new driver
References: <20140306215449.GA16213@elgon.mountain>
In-Reply-To: <20140306215449.GA16213@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2014 03:54 PM, Dan Carpenter wrote:
> Hi Larry,
>
> Sorry to bother you about this, because I know we see this same bug
> every time we add another Realtek driver and you must be as sick of it
> as I am...  :/
>
> The patch a619d1abe20c: "rtlwifi: rtl8723be: Add new driver" from Feb
> 28, 2014, leads to the following static checker warning:
>
> 	drivers/net/wireless/rtlwifi/rtl8723be/phy.c:667 _rtl8723be_store_tx_power_by_rate()
> 	error: buffer overflow 'rtlphy->tx_power_by_rate_offset[band]' 4 <= 5
>
> drivers/net/wireless/rtlwifi/rtl8723be/phy.c
>    646  static void _rtl8723be_store_tx_power_by_rate(struct ieee80211_hw *hw,
>     647                                                u32 band, u32 rfpath,
>     648                                                u32 txnum, u32 regaddr,
>     649                                                u32 bitmask, u32 data)
>     650  {
>     651          struct rtl_priv *rtlpriv = rtl_priv(hw);
>     652          struct rtl_phy *rtlphy = &(rtlpriv->phy);
>     653          u8 rate_section = _rtl8723be_get_rate_section_index(regaddr);
>     654
>     655          if (band != BAND_ON_2_4G && band != BAND_ON_5G)
>     656                  RT_TRACE(rtlpriv, COMP_POWER, PHY_TXPWR,
>     657                           "Invalid Band %d\n", band);
>     658
>     659          if (rfpath > MAX_RF_PATH)
>                               ^^^^^^^^^^^
> This should be >= TX_PWR_BY_RATE_NUM_RF.  We should return on error
> instead of printing an error and then corrupting memory.
>
> I don't know what to do here to make these bugs go away...
>
>     660                  RT_TRACE(rtlpriv, COMP_POWER, PHY_TXPWR,
>     661                           "Invalid RfPath %d\n", rfpath);
>     662
>     663          if (txnum > MAX_RF_PATH)
>     664                  RT_TRACE(rtlpriv, COMP_POWER, PHY_TXPWR,
>     665                           "Invalid TxNum %d\n", txnum);
>     666
>     667          rtlphy->tx_power_by_rate_offset[band][rfpath][txnum][rate_section] =
>     668                                                                          data;
>     669  }

Thanks for pointing to these problems.

BTW, what static checker found the problem? I ran the latest Smatch and it did 
not find it.

Larry


