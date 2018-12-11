Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE1FC07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 12:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 757C92084C
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 12:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gR0ShGNq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 757C92084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbeLKMmw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 07:42:52 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43974 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbeLKMmv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 07:42:51 -0500
Received: by mail-yb1-f196.google.com with SMTP id d136so2328126ybh.10
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 04:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G+RkxdAFAhKxzARMGYDcYLmRYwrUydi6xnbUzwi+zHI=;
        b=gR0ShGNqkvNRwpadBYQ7R+vq04KnUPrRuDQvpmFY041Pq7i8vRvOrG4F1ftQcwKYUQ
         ruxvHG50HQcJPhIDgRcXBFVXykh5vkWu2AoTbbbPvl0UtZs23IXBzDbNCkjE/ora0x58
         JkFjitteEJ1OhNJKTEEFlZklVHRdsMwAFCPOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G+RkxdAFAhKxzARMGYDcYLmRYwrUydi6xnbUzwi+zHI=;
        b=kOG+MK986+pMnpXmNSHEJEO+YkO33kWhFHp+7BaCU7Qbnxn40scgoWLLXHaVAE3t9R
         /i/xRVqtz7vjCiKsEy/lzqsd6y6fMVgMt9N+Fj/fdcyjEpFStdsLQth2mI2h8GrtSWq2
         RDtM7UgRU8IdQrS8c8cPnnZsT1YCfdIgQm8rh7OFouo+ngDWYk1BQQL38sj7nHwa00aU
         rJEh7pjTIzWQWb7rihYaZGkbSzzHAW9xedn3t3gJ5t8oJ4qa01JN7dY0nwKGpmeeves5
         zN6nbK3ThQgLS2XwSDKRuOeFmQOlgo9UkoJrBKUOrbWTC81MRDi5VBUvL1r3XJew7qGO
         EAYA==
X-Gm-Message-State: AA+aEWbtzFDPiU/lfLs7w5kzUp+R+kptttjlDukFYu/RWzwt6Zid6jIp
        h58yVzxfpNKYeDu6eObMxhCeIl4kEYh+YA==
X-Google-Smtp-Source: AFSGD/XT/yiyyJRipnzB+RWpM9ZjqeqPX4/oTcoU2l3j8hMCl7Wmcq1QZyHC+U0HcRuTQU/6LrFAog==
X-Received: by 2002:a25:b74b:: with SMTP id e11mr15398558ybm.163.1544532169923;
        Tue, 11 Dec 2018 04:42:49 -0800 (PST)
Received: from [10.176.51.60] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j2sm4955742ywa.73.2018.12.11.04.42.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 04:42:49 -0800 (PST)
Subject: Re: [PATCH V4 0/8] brcmfmac: chip related changes
To:     Kalle Valo <kvalo@codeaurora.org>
References: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Cc:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4dca6580-8fa8-b2fb-6f65-86e8791319cf@broadcom.com>
Date:   Tue, 11 Dec 2018 13:42:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <1542786800-146083-1-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/21/2018 8:53 AM, Chi-Hsien Lin wrote:
> This patch series includes various chip-related changes:
> * 43012 support
> * 4373 saverestore support
> * SDIO bus settings
> * 4354 raw chipid

Hi Kalle,

This series [1] is still marked as New in patchwork. Are you planning to 
take them?

Regards,
Arend

[1] https://patchwork.kernel.org/cover/10692067/
