Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FB7C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 21:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9372D222C9
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 21:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fk/5KtZ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbfAEVe2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 16:34:28 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46033 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfAEVe2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 16:34:28 -0500
Received: by mail-ot1-f66.google.com with SMTP id 32so34877475ota.12;
        Sat, 05 Jan 2019 13:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zfWxANLBUPJ8evDSjGuZTdYUSDIc7pYm4pIr+uAx76I=;
        b=Fk/5KtZ32TBfT61GcMr4i2WQmXDHuUqDn1g86ytQCxzX5NlO+NjLa9YRH+9yMeBtyt
         svfNWjdGXUJAJQliGjsKyzVTNlS+i33k5Ynyk+ONURrsXb1MBwTYxu2ZQrobbaec2UMG
         usPJRh38rL/NHdvhVoL9a1fq5gFY0KBaFTCT8C5emQEoj6CCxJjsQdvjlmudHmvbUywG
         3/PO4zsPo7zDMbj1ojwhWTHZuaX5ZQiBPY0d0bJT0ca6tppzLs9MvvKsO0jM0WxVboEf
         9KjLEHYlKLp1Mhg3KhFsea73bKUanjTCyVPKuvqkXPqIUxa69J2Uo0tfu1gOZ5k41I5T
         xC3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zfWxANLBUPJ8evDSjGuZTdYUSDIc7pYm4pIr+uAx76I=;
        b=eT+G6GZiMOlOkHfBT28E1KbxgSTeJNx4DNzSdvCZruwDboDvsloLADVxJfs3QZwKD9
         PbPvLsy4teYH2kyXICCpyCX+VMzkpbWA49j5mIpwiL09sHSV+ilY7k/dEeKZ/LN7UWyQ
         UALUOyMS7kPsScq6/LWMlEw8qvEYmShNz3JynLLCGyNJqNoDuk/U2kbx1WcZr6xCGfOM
         E8YUdu2DPYPhmGjDaeC8Yk57LpzBMnqQlnGeTk7u2RmcnIBMmygY6D/1EWvw81NEZfKB
         ug6U0tRBTUF9t+oJVqJC/vTWIGMEkAtSKFCAEctfkFnPpP35exw8uhdM1gThueLr85Jn
         NiBg==
X-Gm-Message-State: AJcUukeAzpE1IKa2WbIkv74Cv4YKPCkDLKx7+X9kMa3MkwaEs86u0tZ9
        +HawCiAsS+id+7r4z6zfJtidK0mu
X-Google-Smtp-Source: ALg8bN78cGVh5z7txfFUUN37fqVwpELnJruNcrtElNxtK0OcgYlR9uRlI0Kwp7Dh/0QcHi/XpdTG8g==
X-Received: by 2002:a9d:17c6:: with SMTP id j64mr40114684otj.357.1546724067451;
        Sat, 05 Jan 2019 13:34:27 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id m89sm30876221otc.35.2019.01.05.13.34.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Jan 2019 13:34:26 -0800 (PST)
Subject: Re: [PATCH v2 0/4] rtlwifi: Fix issues with rtl8723ae
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <DB7PR07MB53536F93922110AAB221480AE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4a34b41e-1c18-14af-b398-396dfd9823d7@lwfinger.net>
Date:   Sat, 5 Jan 2019 15:34:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <DB7PR07MB53536F93922110AAB221480AE48F0@DB7PR07MB5353.eurprd07.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/5/19 12:38 PM, Bernd Edlinger wrote:
> Currently the rtl8723ae driver is broken (since v4.7).
> 
> Connection to AP is lost very often, especially when
> the signal level is not very good.
> 
> The main issue is the power save mode is basically
> not working, and seems to trigger a firmware bug.
> So I had to take out the FW LPS mode handling.
> 
> While debugging the driver I found a couple related issues,
> for instance that the signal level in dm.undec_sm_pwdb
> is no longer accurate (may be even much too high) when no more
> packets are received, and it increases the likelihood to receive
> something if the input gain is set to maximum.
> 
> The patch was tested with the rtl8723ae PCI card in my laptop
> against a FRITZ!Box 7590 AP -- the WiFi connection works now
> very reliable for me.
> 
> V2 of the patch adjusts the defaults of swlps and fwlps module
> parameters to match the firmware capabilities instead of removing
> the whole code, so it can be easily re-activated once a firmware
> update is available.
> 
> 
> Bernd Edlinger (4):
>    rtlwifi: rtl8723ae: Take the FW LPS mode handling out
>    rtlwifi: rtl8723ae: Don't use dm.undec_sm_pwdb for input gain control
>         when no beacon was received in the connected state
>    rtlwifi: rtl8723ae: Re-introduce
>      rtl8723e_dm_refresh_rate_adaptive_mask
>    rtlwifi: Move the clearing of rtlpriv->link_info.num_rx_inperiod in
>       rtl_watchdog_wq_callback a few lines down

The subject on all 4 of these need to be modified. Only the first line will be 
shown as the "subject", which will not make much sense.

In addition, you need to include the changes in the cover letter, and in the 
actual patch after the --- line. In that section, you mention what changes were 
made in each revision, then follow with another --- line. That info is there for 
the maintainers - it will be stripped before the patch is merged.

Larry

