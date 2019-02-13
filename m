Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E829C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 13:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B5A20643
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 13:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cb6ZLmYK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388204AbfBMNBv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:01:51 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:44120 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730946AbfBMNBv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 08:01:51 -0500
Received: by mail-yb1-f193.google.com with SMTP id b15so847202ybn.11
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2019 05:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B0sH/I+ChPykS2ram8qWVJ6mCX37MXOVqHWxeMm8JbI=;
        b=cb6ZLmYKmYgWuVAvL2T4DF3mmuDvheCPgACX7inz3Yivi5/S2Xp5kmB7KrWah0/Q+z
         t3kkr74FI9V+lC8HWE+W9A47liKuoV8yUf0AKkdQmGf/ol85UMs84zSHOmqB7Votjm7S
         5U7jGJTcZ3ela8UfM2nNsjtJl/UHXYyeKgpR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B0sH/I+ChPykS2ram8qWVJ6mCX37MXOVqHWxeMm8JbI=;
        b=C2vpeIdRLARHwt4WKsoWXtQsaVCxgnf55WlTyZm74uUSdYK6q8wKStiyvmi/RaXnfv
         JrQ/NTGyqoQhkNH5mRnmcmS5tZ8SvA6i4T6ZfpGcsUJJC013LJF6FxxKlNEAiD5VxHm6
         vTv8BjtxtuvHDmVazVfk2qhtxbWaXSSQsrByqqT1QYkOQZoH6KTz3BJMY4QYa1SwJ54R
         T1kkttR3msiMUA2okUbFE3yEoV1xlG1+7t+nxZvS+ohSwhw5n1hJAgXpq5k4vwcgHjvl
         2S29bYYiwkZXEYyrRzh+YoIXsaXj7xBMp0tjV45cNpjwY/aVFxiwy8AoO35QM+Ivpzf1
         myqg==
X-Gm-Message-State: AHQUAuYjzi+825RQaJOgGim6kf4mrAwGRIO8VpAWUDbRyyFEJOxZMcIJ
        Qc5Gl8pPxY49PXYuTlp4RhC1AQ==
X-Google-Smtp-Source: AHgI3IaHPHQ1jOVqpqaAKpjXxEQFTgtNi9YHaq5DMuO+Sfju2Cpx1Tnvug1rWkc7WPfejaR0rHM1QQ==
X-Received: by 2002:a25:8507:: with SMTP id w7mr305074ybk.505.1550062910225;
        Wed, 13 Feb 2019 05:01:50 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id e3sm864609ywe.33.2019.02.13.05.01.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 05:01:49 -0800 (PST)
Subject: Re: PROBLEM: Oops - Null pointer dereference in brcm80211/brcmfmac
 [BCM4350]
To:     Aaron Blair <aaron@aaronpb.me>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>
References: <20190212055731.gxy3e3uulztketbf@datkip>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <43fcfb23-9c35-cdf4-18ea-69212612c460@broadcom.com>
Date:   Wed, 13 Feb 2019 14:01:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190212055731.gxy3e3uulztketbf@datkip>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/12/2019 6:57 AM, Aaron Blair wrote:
> I apologise if my report is lacking in detail; it is my first attempt at 
> bug/issue reporting in the kernel.
> Please follow up if something is missing, or more detail/testing is 
> required.
> It is certainly possible for me to provide more oops reports if 
> required, as they generally surface at least once a day.

No apologies needed. I am generally happy with kernel log and short 
context description.

> Thank you.
> 
> [1.] Oops - Null pointer dereference in brcm80211/brcmfmac [BCM4350]
> 
> [2.] Seemingly randomly, when connected to a wireless network, my laptop 
> will begin failing to tx/rx data, and begin repeatedly reporting the 
> following messages in the kernel ring buffer:
> 
> ```
> [18990.872335] brcmfmac: brcmf_cfg80211_get_station: GET STA INFO 
> failed, -12
> [18990.872433] brcmfmac: brcmf_msgbuf_tx_ioctl: Failed to reserve space 
> in commonring
> [18990.872439] brcmfmac: brcmf_cfg80211_get_tx_power: error (-12)
> ```

The "reserve space" issue has been reported before although I have not 
looking into it yet.

> Upon trying to rmmod && modload brcmfmac, I receive the oops dump 
> included below, and am unable to continue using the wireless NIC until I 
> reboot.
> 
> This does not appear to have a pattern, except that it usually happens 
> at least once throughout a day of work.
> 
> It has been happening at least since 4.20.4, but potentially earlier 
> (this machine wasn't in heavy use before then).

I will look into the NULL pointer access.

Regards,
Arend
