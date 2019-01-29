Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F771C282CD
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 03:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6688B2084C
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 03:23:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pIjN3gnN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfA2DXv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 22:23:51 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43584 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbfA2DXv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 22:23:51 -0500
Received: by mail-ot1-f65.google.com with SMTP id a11so16644799otr.10
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 19:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Om71heBVFqOy4aW4jj8BrNyvJY/eAdoXy4aqZf+dF0Q=;
        b=pIjN3gnNZ021aikBGi07F+Lk4iHPmb6sXmR/mZzQlG5JO/07uHwHqvm5mDOPw3jklH
         cp0XiWJNoyqwxzTB3N7qzrELirfTNOqmzgLNP6d0sCc9ZSpkulBUQ7nia1AVQNRFXPvN
         MLAcg4ruYkf/4V7ty8LTbePIMCdI4k0p70PZlk7OFQ51HpNSfvJv4WjvFr+VQbViN9sg
         yxf7ZJtHK2dYdA3B7PmXmksQ6qGOICHQS4VbZOcerI0U3TToMQbO24VIai0rY8E35lMH
         w8ndei9T3hSjvofhYtw++U5yy8JzJudrgVMZyq7z7CuQd8BBAhhq/9StoeMXbkgLNojw
         pXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Om71heBVFqOy4aW4jj8BrNyvJY/eAdoXy4aqZf+dF0Q=;
        b=WnEZkwMDoI2QWBY53D5vGBEMbSFHqPEwej97NTwOU2saKIRs4GZSnbrTBsAvWSTJPi
         wy96U05o9/9nZT9LwE9ipfzlnmduv2fN4rWRClEjy+Q+OhRk2sKu+DD80Ncsx2NRQn2F
         p2unAWpzZnaj8a2FdLVP1M4ne21YR7UKXEITXpYSFUqymmM9wqSPeWpg/7ONzEunpDaw
         EiK7olg2bWl4YQ5aB8xoNUFWsd0U0Cyw22tHRjjm81hMdu5K2SUpiSGfXNwCxVIiC/Hr
         qfRnt8SHiEsePJRp/FVps/Qe1LwBFfV20HDjRZyu8ozS1gpXm4Ne/RJoAcodrHUczArs
         AOlA==
X-Gm-Message-State: AJcUukfOx4thoDUQ06NaY7wkPZA4Poee1mX9nbelKxYV5AIUpW8bdDnQ
        LvA+BaaL2j7EIXI1To1SLdza5bY8
X-Google-Smtp-Source: ALg8bN511vg83aqSzaq72ViCkkO70thuGrJeTTqaKLvQ4WeJozORf9LBJ/gHFEgEh8bK/Yc3T7sMJg==
X-Received: by 2002:a9d:460e:: with SMTP id y14mr18971923ote.198.1548732230207;
        Mon, 28 Jan 2019 19:23:50 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v141sm6582048oia.25.2019.01.28.19.23.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 19:23:49 -0800 (PST)
Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
 <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <8d92c20f-a72f-6ea8-d4c8-61c3c8c9adc9@lwfinger.net>
Date:   Mon, 28 Jan 2019 21:23:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/28/19 8:15 PM, Tony Chuang wrote:
>> Tony,
>>
>> I had not tested rtw88 for some time, so I built a kernel with the V3 patches and
>> found that rtw88 crashed with a NULL pointer dereference. I did some
>> debugging and found that the problem was in routine rtw_chip_efuse_enable()
>> where fw->firmware was NULL.
>>
> 
> Hi Larry,
> 
> This NULL pointer was found months ago and has been fixed already.
> Thanks for your test :).
> I am holding the patch to fix it for the next patchsets.
> 
> BTW, since rtw88 has not been accepted, could I send next patch set based on
> this patch set as long as I explicitly mark that the next patch is based on the previous one?
> Thanks!

You need to have that patch in whatever version is merged into the wireless 
tree. It would not look very good for the initial version to crash every users 
computer.

Yes, I would merge EVERY patch that you have pending into the source and submit V4.

Larry

