Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7EFC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 21:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 185252081B
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 21:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQQgUUTz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfBIVDy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 16:03:54 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45233 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfBIVDy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 16:03:54 -0500
Received: by mail-ot1-f67.google.com with SMTP id 32so11571521ota.12
        for <linux-wireless@vger.kernel.org>; Sat, 09 Feb 2019 13:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ceDRGlDKF4bwNMvvxIkEnnaropCtlgce0OaSL/2FqqM=;
        b=HQQgUUTzHe0/2LJQxftSr0oucQebDFC0r19zGWvG9nQ22qcHsndZPElke1adhuBcIU
         f4GUpxVPlQbB7OcSCIdVpTQow8PhKG+Fft8UaaDATO5tj5OZnDRwvABi1Mw0ABPRGard
         7QDkNC2mLY9k2yRjqI9tRKtjousflzieP6lBmSkJBk6laXndhqYlxUpIYui1kRleZ5LF
         W++WJXWY6tEHlbxyWmgLFDF6qZjNCxcFpRgsQcSx+wNpAaq9sjgJtR9v82WxBUJ57koh
         aif+mWApfT4n0s4D+MARicIDOToar1lmjhYgQk1ilBjXzMuQH3oV84ty6enGyiBHxp1M
         Ey7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ceDRGlDKF4bwNMvvxIkEnnaropCtlgce0OaSL/2FqqM=;
        b=siP5x0qqrfj0otk1na7te4gLDPQdfEMaOHVDhI+n5Aoc6IcPrNgITSiYOUWNHt/0Mb
         NaYB7L8IdIxh/z7tm4sNf+5yoW57DAx7R0k+LrmINhiN+FMH60+Oate6drXjZkNpzMbG
         odWF+wFkY8MyKUnEdjfT5etmUK+yglN6BZQ506NVtZ0jlzlfo1Z5fi8Vcz6iL/s+8pPU
         VCNiJ8660Iv772mrdkMtHrBpR7fc5IUCJkYtIP+h7Qs/e4OogQqdAd4ThkZ2/GPobKnP
         SeN3tg4hfgsK4QXhD0fqUDdx3TUP+lGjQFDVrL2P/sbepWlcxXq2s3F/hbkzaPFhACTc
         8P5w==
X-Gm-Message-State: AHQUAuZ4rCquJ+T9ZaKAkwYCGWpVsvIiuMtIA6l2bgzoq4BdCdwbSNbu
        ua48ws2Pp9QPnF4HrcqFbwU=
X-Google-Smtp-Source: AHgI3IYKNbB2oT/O4znPZa0BZBsBtce8HCUWu4i1FMylKKGPR/y8YpvJpUNd5h/WCHAOiGqPCDtoLA==
X-Received: by 2002:a9d:75c5:: with SMTP id c5mr20199644otl.356.1549746233395;
        Sat, 09 Feb 2019 13:03:53 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t67sm2310486oib.44.2019.02.09.13.03.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 13:03:52 -0800 (PST)
Subject: Re: [PATCH 00/13] rtlwifi: Replace old-style license info with SPDX
 form
To:     Joe Perches <joe@perches.com>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com
References: <20190208172209.28530-1-Larry.Finger@lwfinger.net>
 <50b60844f3ac435a41ff99a3043ee10133e30870.camel@perches.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a17f532a-5cfe-3fed-0c13-8e0eff196a44@lwfinger.net>
Date:   Sat, 9 Feb 2019 15:03:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <50b60844f3ac435a41ff99a3043ee10133e30870.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/8/19 9:00 PM, Joe Perches wrote:
> On Fri, 2019-02-08 at 11:21 -0600, Larry Finger wrote:
>> These patches change all the license information from the old-stype format
>> to the newer SPDX format. There are no code changes.
> 
> About some of the removals:
> 
>> Copyright(c) 2009-2012  Realtek Corporation.
> 
> I believe these copyright markings should _not_ be removed.

I thought I did keep the Copyright information. I have now checked twice to 
verify that it was done correctly, and that the original dates were kept. If I 
missed any, I have not found that instance. Please let me know which ones you saw.
> 
>> - * Contact Information:
>> - * wlanfae <wlanfae@realtek.com
>> - * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
>> - * Hsinchu 300, Taiwan.
> 
> Why take out the contact information?  Is it invalid?

Realtek no longer supplies that info with their latest drivers, thus I removed 
it here. That E-mail address is a dummy that people report is never answered - I 
have not personally tried it.

Larry

> 
> 

