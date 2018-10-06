Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB2AECDE44
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 20:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67A472087D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 20:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FNH38OoR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67A472087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbeJGDKB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 23:10:01 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45053 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbeJGDKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 23:10:00 -0400
Received: by mail-ot1-f66.google.com with SMTP id p23so4339525otf.11;
        Sat, 06 Oct 2018 13:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dcL+RlUoGjCgWOo7pTl3fXbD3egoBqz8XSrk2L4U8aE=;
        b=FNH38OoR5aHOoSwNdbHaAMIHecgSAwo9a6Uwmqw5aYZhfjIGJ2WBPZtbGmQ9SqkX9t
         9QbkWOk9ROyp2+nG+r9dDKTZzt4z/qyRgxPgmaNWRTSWuWFp9zcxfgl9zP7CaVn5crUx
         Ul44k++EKn7iYjf5+mRfqEfJMVfBGINpySvo/QjrWm8FnWa9z3EFhuCEU5F3+mlVuAxC
         56aX7sGSWBMZ1D3+4b1sk39MGhKjFBCUKFUXsJuDcGxOlna+IaCnza1JZ2sCZmYU6X2K
         Gg6JcM3zCGmWQVgSRpTjqW/WGHaX4Bt3GkYFEO7PRRtkEE69MBcgyo+JXggnhZ50u1PV
         lIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dcL+RlUoGjCgWOo7pTl3fXbD3egoBqz8XSrk2L4U8aE=;
        b=dbos12jxnPsCfyLHxn+pE8ESYSqctJZApE/JM4gHCLnPRoOM2vcjXe9bZjdxwcXzgJ
         LwnJN2csKDmN1R409YqKM1cAP4ugG6RekGvWcj5pcJADgGDdjhHTWmd4c+kpsQdQCTb7
         Il9s9d9ObnotJ1blPYJmdYnMY/AhvuzWd2pibBFWmXtKG2/MlbZ/5pDAKJSvy/YjYPpr
         2a2ZSzgMJSgYuhT9cArCaIEZ2MfSBTv/bCRuViVyxq2+X+tzVjwBd7EOF51GjvzHEeTv
         8FW4hEhGWdRG2kmPbheQlxTE53b7ctlyoL+1kUToX7rl5zveesaUHdfe+YSuQEP5tPGg
         td/w==
X-Gm-Message-State: ABuFfog7+wwRkxpjn/VRQuQZ59u3I3nS2D+5umjJZI2vK0XBjK3b/Ve7
        9EIOKdRQysHstu6js4JoMUGfun1L
X-Google-Smtp-Source: ACcGV60z8ACSU82BRldTox+ibof6DoCHSmdlPd2v3K3x0ebod01TIBkgiOa565Ghe17SAqDM9WdCpw==
X-Received: by 2002:a9d:5809:: with SMTP id r9mr9348189oth.36.1538856323425;
        Sat, 06 Oct 2018 13:05:23 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id r83-v6sm3748447oia.55.2018.10.06.13.05.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Oct 2018 13:05:22 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8821ae: add in a missing break in switch
 statement
To:     Kalle Valo <kvalo@codeaurora.org>,
        Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Tsang-Shian Lin <thlin@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181006184246.29985-1-colin.king@canonical.com>
 <87r2h2euuy.fsf@kamboji.qca.qualcomm.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a5113f03-7ac8-4be6-3d1c-5ba74639121e@lwfinger.net>
Date:   Sat, 6 Oct 2018 15:05:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <87r2h2euuy.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/6/18 2:30 PM, Kalle Valo wrote:
> Colin King <colin.king@canonical.com> writes:
> 
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The switch case RATR_INX_WIRELESS_MC has a missing break, this seems
>> to be unintentional as the setting of variable ret gets overwritten
>> when the case falls through to the following RATR_INX_WIRELESS_AC_5N
>> case.  Fix this by adding in the missing break.
>>
>> Detected by CoverityScan, CID#1167237 ("Missing break in switch")
>>
>> Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 1 +
> 
> Is the fixes line correct? This patch is not for staging.

No, the correct fixes commit is 21e4b0726dc67 (" rtlwifi: rtl8821ae: Move driver 
from staging to regular tree").

This driver was initially placed in staging as it was needed for a special 
project, which is the commit that Colin used. As the patch subject states, the 
driver was later moved to the regular wireless tree.

That break is required, thus ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

thanks,

Larry

