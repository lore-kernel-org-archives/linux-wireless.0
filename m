Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36219 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdAELLw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 06:11:52 -0500
Date: Thu, 5 Jan 2017 14:11:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] rtlwifi: Remove some redundant code
Message-ID: <20170105111124.GA4548@elgon.mountain> (sfid-20170105_121156_342772_8BB110A0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry Finger,

The patch c93ac39da006: "rtlwifi: Remove some redundant code" from
Dec 15, 2016, leads to the following static checker warning:

	drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c:326 rtl92d_download_fw()
	warn: curly braces intended?

drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
   306          /* If 8051 is running in RAM code, driver should
   307           * inform Fw to reset by itself, or it will cause
   308           * download Fw fail.*/
   309          /* 8051 RAM code */
   310          if (rtl_read_byte(rtlpriv, REG_MCUFWDL) & BIT(7)) {
   311                  rtl92d_firmware_selfreset(hw);
   312                  rtl_write_byte(rtlpriv, REG_MCUFWDL, 0x00);
   313          }
   314          _rtl92d_enable_fw_download(hw, true);
   315          _rtl92d_write_fw(hw, version, pfwdata, fwsize);
   316          _rtl92d_enable_fw_download(hw, false);
   317          spin_lock_irqsave(&globalmutex_for_fwdownload, flags);
   318          err = _rtl92d_fw_free_to_go(hw);
   319          /* download fw over,clear 0x1f[5] */
   320          value = rtl_read_byte(rtlpriv, 0x1f);
   321          value &= (~BIT(5));
   322          rtl_write_byte(rtlpriv, 0x1f, value);
   323          spin_unlock_irqrestore(&globalmutex_for_fwdownload, flags);
   324          if (err)
   325                  pr_err("fw is not ready to run!\n");
   326                  goto exit;

I guess we could add the braces back.

   327  exit:
   328          err = _rtl92d_fw_init(hw);

Should we even be running _rtl92d_fw_init() if _rtl92d_fw_free_to_go()
fails?  What about preserving the error code?

   329          return err;
   330  }

regards,
dan carpenter
