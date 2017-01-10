Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33614 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757710AbdAJQTB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 11:19:01 -0500
Received: by mail-oi0-f65.google.com with SMTP id j15so17574187oih.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2017 08:19:01 -0800 (PST)
Subject: Re: [bug report] rtlwifi: Remove some redundant code
To: Kalle Valo <kvalo@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20170105111124.GA4548@elgon.mountain>
 <8737grjaje.fsf@purkki.adurom.net>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <fa0f2462-d3db-e0bb-2562-16d56cdfec7c@lwfinger.net> (sfid-20170110_171907_098300_F517233B)
Date: Tue, 10 Jan 2017 10:18:58 -0600
MIME-Version: 1.0
In-Reply-To: <8737grjaje.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2017 07:43 AM, Kalle Valo wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>
>> Hello Larry Finger,
>>
>> The patch c93ac39da006: "rtlwifi: Remove some redundant code" from
>> Dec 15, 2016, leads to the following static checker warning:
>>
>> 	drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c:326 rtl92d_download_fw()
>> 	warn: curly braces intended?
>>
>> drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
>>    306          /* If 8051 is running in RAM code, driver should
>>    307           * inform Fw to reset by itself, or it will cause
>>    308           * download Fw fail.*/
>>    309          /* 8051 RAM code */
>>    310          if (rtl_read_byte(rtlpriv, REG_MCUFWDL) & BIT(7)) {
>>    311                  rtl92d_firmware_selfreset(hw);
>>    312                  rtl_write_byte(rtlpriv, REG_MCUFWDL, 0x00);
>>    313          }
>>    314          _rtl92d_enable_fw_download(hw, true);
>>    315          _rtl92d_write_fw(hw, version, pfwdata, fwsize);
>>    316          _rtl92d_enable_fw_download(hw, false);
>>    317          spin_lock_irqsave(&globalmutex_for_fwdownload, flags);
>>    318          err = _rtl92d_fw_free_to_go(hw);
>>    319          /* download fw over,clear 0x1f[5] */
>>    320          value = rtl_read_byte(rtlpriv, 0x1f);
>>    321          value &= (~BIT(5));
>>    322          rtl_write_byte(rtlpriv, 0x1f, value);
>>    323          spin_unlock_irqrestore(&globalmutex_for_fwdownload, flags);
>>    324          if (err)
>>    325                  pr_err("fw is not ready to run!\n");
>>    326                  goto exit;
>>
>> I guess we could add the braces back.
>>
>>    327  exit:
>>    328          err = _rtl92d_fw_init(hw);
>>
>> Should we even be running _rtl92d_fw_init() if _rtl92d_fw_free_to_go()
>> fails?  What about preserving the error code?
>>
>>    329          return err;
>>    330  }
>
> A possible fix but which doesn't seem to address all your concerns:
>
> [next] rtlwifi: rtl8192de: fix missing curly braces
>
> https://patchwork.kernel.org/patch/9506837/

Strange, but Gmail put that patch in my spam. In any case, it is better to 
remove the goto. Adding the braces back leaves a goto just before the target. 
The compiler does the right thing, but it should be fixed.

Larry
