Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21399 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbbERMbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 08:31:50 -0400
Date: Mon, 18 May 2015 15:31:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry.Finger@lwfinger.net
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: re: rtlwifi: rtl8821ae: Move driver from staging to regular tree
Message-ID: <20150518123138.GC32633@mwanda> (sfid-20150518_143153_893565_508E25D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry Finger,

The patch 21e4b0726dc6: "rtlwifi: rtl8821ae: Move driver from staging
to regular tree" from Sep 22, 2014, leads to the following static
checker warning:

	drivers/net/wireless/rtlwifi/rtl8821ae/hw.c:2183 _rtl8821ae_set_media_status()
	warn: masked condition is always false. '(bt_msr & 252) == 3'

drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
  2181          rtl_write_byte(rtlpriv, MSR, bt_msr);
  2182          rtlpriv->cfg->ops->led_control(hw, ledaction);
  2183          if ((bt_msr & 0xfc) == MSR_AP)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^
This condition is never true.  We mask out the 0xfc flags at the
beginning of the function.  MSR_AP is 0x3.

  2184                  rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
  2185          else
  2186                  rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
  2187  
  2188          return 0;
  2189  }

regards,
dan carpenter
