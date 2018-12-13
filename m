Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EB8C67872
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 05:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74DC520870
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 05:37:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74DC520870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbeLMFgU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 00:36:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54845 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbeLMFgU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 00:36:20 -0500
Received: from mail-pg1-f198.google.com ([209.85.215.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1gXJfV-0006sJ-7N
        for linux-wireless@vger.kernel.org; Thu, 13 Dec 2018 05:36:17 +0000
Received: by mail-pg1-f198.google.com with SMTP id x26so570192pgc.5
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 21:36:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fFrlb3KsMLahbgSt4CAK3tYh4PnoLEhBfupxlV6enHY=;
        b=PkaXiF2yiTrBvhDNxpEm7/MnAMOVKTzTgb5Kes6ETX4kEbjZqX5zpIwefOL39cOJTr
         yrzFSMboKHPd/RbImAVKV3I6D1g9845s0MJ5RpQBgOlbginkDgO3slZUklSdZKOdNpJ7
         LRdklp60tAz/rCvP1GSdnxTgUP50q8fY+TrS7ZRT+CtmBAb1WKVk2+eJKeLdvd0e1rHl
         bhsSIxv8YH73U/GvUuovaU+5vSj6v2ri/4y436czr+5s37QHB8t76mH+LCcjBVAecKLH
         tDVNzNvtuD9Jcsw4UbgFnvmt+mpWQF95IcWKNz70U0SZajQCrq456KFJk77isu5tXVLn
         mg+w==
X-Gm-Message-State: AA+aEWbcTQxEUm76uiJuRzfaeCmaYQ0gelU92DG8wlvqAHq8H22PIerv
        p/qQZYLw0nMQali4YBi4kXIQBHK28RMixjV+N+Wk8/dQAz1IprwCT/1E9sb5h+pIdjMo0hSAo+y
        YY/ZAPCqVrtKo6ywvO6dcEcEZaQTbhWObAe5aQ3sJ5w0D
X-Received: by 2002:a63:85c6:: with SMTP id u189mr19906926pgd.156.1544679375816;
        Wed, 12 Dec 2018 21:36:15 -0800 (PST)
X-Google-Smtp-Source: AFSGD/Xrc5/Y3HEMEPWQZ1Q1Zl85qjTSWLu9ee8fKReEBEox0nut/4pjMDFexeCjZbZQl3dANOgIxQ==
X-Received: by 2002:a63:85c6:: with SMTP id u189mr19906912pgd.156.1544679375546;
        Wed, 12 Dec 2018 21:36:15 -0800 (PST)
Received: from 2001-b011-380f-3f3d-a8b0-6af4-8075-4442.dynamic-ip6.hinet.net (2001-b011-380f-3f3d-a8b0-6af4-8075-4442.dynamic-ip6.hinet.net. [2001:b011:380f:3f3d:a8b0:6af4:8075:4442])
        by smtp.gmail.com with ESMTPSA id l5sm735789pgu.86.2018.12.12.21.36.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 21:36:15 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH] rtlwifi: Fix non-working BSS STA mode
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <1544661346.2548.2.camel@realtek.com>
Date:   Thu, 13 Dec 2018 13:36:12 +0800
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A95FEB12-29C5-404D-9C4E-04D1900C4E88@canonical.com>
References: <20181212051335.22580-1-kai.heng.feng@canonical.com>
 <1544661346.2548.2.camel@realtek.com>
To:     Pkshih <pkshih@realtek.com>
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> On Dec 13, 2018, at 08:35, Pkshih <pkshih@realtek.com> wrote:
> 
> On Wed, 2018-12-12 at 13:13 +0800, Kai-Heng Feng wrote:
>> Once BSS STA mode gets started, it can be scanned by other clients but
>> cannot entablish a connection.
>          ^^^ typo: establish
>> 
>> Turns out the set_bcn_reg() and its *_set_beacon_related_registers()
>> callbacks never get called so it has problem beaconing.
>> 
>> Enable the function in rtl_op_bss_info_changed() can make BSS STA mode
>> start to work.
>> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c
>> b/drivers/net/wireless/realtek/rtlwifi/core.c
>> index 4bf7967590ca..11d27a5cc576 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
>> @@ -1054,7 +1054,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw
>> *hw,
>>  					 "BSS_CHANGED_BEACON_ENABLED\n");
>>  
>>  				/*start hw beacon interrupt. */
>> -				/*rtlpriv->cfg->ops->set_bcn_reg(hw); */
>> +				rtlpriv->cfg->ops->set_bcn_reg(hw);
>>  				mac->beacon_enabled = 1;
>>  				rtlpriv->cfg->ops->update_interrupt_mask(hw,
>>  						rtlpriv->cfg->maps
> 
> Which wifi chip do you use? And, please share your test scenario.

It’s Realtek 8723DE, which is currently not supported in mainline so I use rtl8723de in rtlwifi_new [1] to test it out.

The test scenario is simply enable hotspot through network manager, which uses wpa_supplicant to do the work.

[1] https://github.com/lwfinger/rtlwifi_new

Kai-Heng

> 
> Thanks
> 

