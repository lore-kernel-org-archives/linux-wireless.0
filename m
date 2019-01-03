Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4893C43612
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 19:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82550217F5
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 19:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intellastar.com header.i=@intellastar.com header.b="J3RMP1ro"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfACT1H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 14:27:07 -0500
Received: from mail-qt1-f180.google.com ([209.85.160.180]:34552 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfACT1H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 14:27:07 -0500
Received: by mail-qt1-f180.google.com with SMTP id r14so38154961qtp.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2019 11:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intellastar.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=N6YqNEQmcX6dri4b8/tWYImJecUL1xKHXfTVswaWjnE=;
        b=J3RMP1rocwWAkgxjJTh12ZqZZwYMWW3lFrBc8tbYF4MTbQAlOfIEj5w0eloZ7uvtxh
         JpfJrnjmf0nouSqhSiln6/7iNrG8EtMcULfdToytdxniyOtfo+wOpYvLhQxkHzazvVE6
         xssruIA6NQiaS0OZFRYPzDWWMLD5o8u6lJ7zytaYIuqGfKcNBsAt1dIt5JpINI9bOcgl
         bQw1j2TlwCP3m1Vsj/v3oa2pzPnTddnTMEz5WGofZ/SZAHDJRTWae1z1aJpzyWiwZTge
         yW3nuoOrlesR5ZV2tsCG0p51+v7R8Pp2zSeNk6qL1gK60Jxl6E1HxegsxJSeSNMgu/mH
         bz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=N6YqNEQmcX6dri4b8/tWYImJecUL1xKHXfTVswaWjnE=;
        b=hV4mdkQHQZzV7W1NzeWKf1J0nr6q7E+qgHFG14vtCtciy851+kRpxsfcYPveFP0Hbu
         TCwe4NI7rNc4K1eM2fTRszHUDEFQxiwICcqM0LidzxKMT0ZPhZCmvRJofGLoBeB4qFhY
         SO0BIRfRf/Xq36/5wlBXTHVqsOmJHJVp9oopUSgT7AwD5duW+jWG1uLTX+/VSGX+wg/c
         0joESxqKWHRAfpMSTx5WFI2hVe/Ag0IJYxQp9EXD/7e47/aIY0jFQTeHTKSoNrbF49XD
         6SqHE/xeWPs0g5pve4djus8La2Tx1vCDxR8sl1CKlgM33Hrsi3PY9Qqp1ThU5+TbshsB
         AH5g==
X-Gm-Message-State: AJcUukf8U3OX/4qWnYAmkZfvXSJRFpARX8g/yoI5swIoFuZ6cUX2eep9
        qIxuFWnSaahXPmzdsZnHIyM9eF1D+OJ2r8+97miaH0c8XBt/E7eT7jUAcX0MoruhCwn7n6pu33Y
        5d0IKm4FDhwGFVb1bd613CgArazaLhA/pmkzcHxgDNXTW/lkQkIlN7Yz7hhwBVJtZSQjWd6ptpd
        sf/qM=
X-Google-Smtp-Source: AFSGD/VF+pw7B4/xUPjj92l9ofHoMY0YzvwbeWmGzPcdiY8OejUwGFd4WTDl2jrJAuxfR/ukEFWPsQ==
X-Received: by 2002:ac8:27c8:: with SMTP id x8mr46321139qtx.352.1546543625992;
        Thu, 03 Jan 2019 11:27:05 -0800 (PST)
Received: from [192.168.110.7] (cpe-67-241-170-88.buffalo.res.rr.com. [67.241.170.88])
        by smtp.gmail.com with ESMTPSA id 126sm22411714qkj.70.2019.01.03.11.27.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Jan 2019 11:27:05 -0800 (PST)
Subject: Re: wlcore update breaks on 4.9 and 4.4 kernel branches
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org
References: <43ee432a-c6ab-e23c-616c-b626a5fb4637@intellastar.com>
 <20181202150813.GG221015@sasha-vm>
 <72dcddb8-a44a-d50c-bae6-c51180e53cc8@intellastar.com>
 <20181212064051.GA2746@sasha-vm>
From:   Dietmar May <dmay@intellastar.com>
Message-ID: <be76fc93-5bbc-9e00-3091-a57d13f2e485@intellastar.com>
Date:   Thu, 3 Jan 2019 14:27:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181212064051.GA2746@sasha-vm>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sasha,

I've just confirmed that this problem is no longer present in 4.4.169=20
either, as expected.

Sorry for the delay - we're on 4.9, so the 4.4 branch doesn't impact us.

Just wanted to let you know so you have full closure on this issue.

Dietmar

------------------------------------------------------------------------
On 12/12/18 1:40 AM, Sasha Levin wrote:
> On Tue, Dec 11, 2018 at 03:29:31PM -0500, Dietmar May wrote:
>> Sasha,
>>
>> I've verified that 4.9.143 no longer exhibits this problem.
>
> Thanks for confirming!
>
>> The revert hasn't shown up in 4.4 yet; but I'll verify once merged=20
>> there.
>
> There was no 4.4 release yet; it's coming, I promise :)
>
> --=20
> Thanks,
> Sasha

--=20
This email and any information disclosed in connection herewith, whether=20
written or oral, is the property of Intellastar LLC, and is intended only=
=20
for the person or entity to which it is addressed. This email may contain=
=20
information that is privileged confidential or otherwise protected from=20
disclosure. Distributing or copying any information contained in this email=
=20
to anyone other than the intended recipient is strictly prohibited.=C2=A0
