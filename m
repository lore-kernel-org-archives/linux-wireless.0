Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3D8C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 14:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A9B121473
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 14:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P1YuBy5x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfA2Oys (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 09:54:48 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38920 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfA2Oys (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 09:54:48 -0500
Received: by mail-oi1-f195.google.com with SMTP id i6so16324442oia.6
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 06:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hljnw9rmLEVsLxHf+pTpw/M4BAi4v97s1qt7FARbptk=;
        b=P1YuBy5xPvpe39Iy7UHd/bzl1+79ul8DRvWdT7sTGuJJ8bvTQPmaQo6xW/u5Aaq3aR
         rdoChs4ibDwsXT4IgOli973pEfMhEdcVDQ5ifZaVeUSr/EhDUWrWew9MEa4DGsuhQRW3
         IgU9AFto2MlYKh7LsEHUDRAXbwPvoXdErz+4pMdLgTqtLgGjV1nnQsyH9SUlVIogGi2v
         l+4Q6JbPxGAXoRaP6LZ//dpV6iDwI+6mLYYtZKw5BMVvjSjd+DTu9KhbRUaWFwAyhMmp
         awA6t7Pntvx8AwWt8AFijYKux7hJoHDmPQ2QofE0UZ6ANCi+xcvsj77GAlE0LQYjxX3D
         dZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hljnw9rmLEVsLxHf+pTpw/M4BAi4v97s1qt7FARbptk=;
        b=JI8vs3FLDaS2XVNxUTKVKN8YR6rYxlnRCHmfvfIuhx8D0HY3naevzx0w5S7tHkkyBq
         3GRRKUwSkDP7AgfyzleUtip/SZhkKZVMIepQ1nGTfcf9ysK1YaC/VAqX4Owgmxusn8gP
         au1qbQUJbvO76hW/j66HpejyFfpR5knAX/ju1rYXl9TAFSA4tFFJvw6aOBJpvPztqDim
         MY6TAxksCoeETXbiCCZnWGskfR9ossd/xx5laRv7es8Gu1bD17VA8wnYVgxAkciUpVnz
         1oOciHM7C+HevtW7caIyWZQWFrQxpR/Lk/wtqkzK8ILnrJphc4UtbfZVrANLFbcSNbTz
         l+Pw==
X-Gm-Message-State: AJcUukeqVa4Hl/1XJritky9+EH2V4JT3xTWzTbbIbY0jm4+odRoDt/Ui
        rGr0ns6jiD7LLLqSkPjNEWRyN9yQ
X-Google-Smtp-Source: ALg8bN6a1zYTmjUj2/llyQfzuhd436ZqOUZF7aAMO4LvewFOEr+Fo7wmmsBaDbhPi45X6p0JaT0a+g==
X-Received: by 2002:aca:308c:: with SMTP id w134mr9853125oiw.81.1548773686909;
        Tue, 29 Jan 2019 06:54:46 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id a66sm6430608oib.42.2019.01.29.06.54.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 06:54:45 -0800 (PST)
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
 <8d92c20f-a72f-6ea8-d4c8-61c3c8c9adc9@lwfinger.net>
 <F7CD281DE3E379468C6D07993EA72F84D17981EA@RTITMBSVM04.realtek.com.tw>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <88a9b0f1-e91b-598a-0a93-34b5b2f9161d@lwfinger.net>
Date:   Tue, 29 Jan 2019 08:54:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17981EA@RTITMBSVM04.realtek.com.tw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/28/19 10:03 PM, Tony Chuang wrote:
> 
> 
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org
>> [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Larry Finger
>> Sent: Tuesday, January 29, 2019 11:24 AM
>> To: Tony Chuang
>> Cc: Pkshih; Andy Huang; briannorris@chromium.org; sgruszka@redhat.com;
>> linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
>> wireless network chips
>>
>> On 1/28/19 8:15 PM, Tony Chuang wrote:
>>>> Tony,
>>>>
>>>> I had not tested rtw88 for some time, so I built a kernel with the V3 patches
>> and
>>>> found that rtw88 crashed with a NULL pointer dereference. I did some
>>>> debugging and found that the problem was in routine
>> rtw_chip_efuse_enable()
>>>> where fw->firmware was NULL.
>>>>
>>>
>>> Hi Larry,
>>>
>>> This NULL pointer was found months ago and has been fixed already.
>>> Thanks for your test :).
>>> I am holding the patch to fix it for the next patchsets.
>>>
>>> BTW, since rtw88 has not been accepted, could I send next patch set based on
>>> this patch set as long as I explicitly mark that the next patch is based on the
>> previous one?
>>> Thanks!
>>
>> You need to have that patch in whatever version is merged into the wireless
>> tree. It would not look very good for the initial version to crash every users
>> computer.
>>
>> Yes, I would merge EVERY patch that you have pending into the source and
>> submit V4.
> 
> Hi Larry,
> 
> But here I am holding almost 40 patches, some of them are common major fixes.
> The rest of them are to enhance and stabilize 8822C.
> 
>  From the initial submit to now, 8822C has many fixes. Because we tested
> a lot for developing 8822C and we have many parameter changes for it.
> I am not sure should I merge every patch into the original patch set. We will
> have huge difference to the original patch set, means extra effort for review.
> 
> But I can filter out the less important patches (will be like around 20, still many).
> How do you think?
> Thanks.

As a minimum, you need to add all patches that fix crashes.

Larry

