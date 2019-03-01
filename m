Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7439FC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 22:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F5082083D
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 22:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+8e6FLl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfCAW0G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 17:26:06 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40985 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfCAW0G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 17:26:06 -0500
Received: by mail-qt1-f195.google.com with SMTP id v10so29705381qtp.8;
        Fri, 01 Mar 2019 14:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=31CcFo6PJH+HjzrgnYp3DXEx991nRCYWmYaRbvo0qkg=;
        b=l+8e6FLl7JM8uFNlQPy7tlRy718ly9R+mITt8T5iWlPqeBFGHf2skZAMETmOOEcrj2
         Ugwp6IZa6rqCf8uY4pldpny307TpylVEKFDRKKrtO3em06PlcJe4V3dzuN77D5bfSnlB
         V43dkAZ3QFiFTbIJJ46MkII2IDmrKBjxKhmpYTm1c1oBQWqe5W6k6gkU+eRpUuaxVcBI
         fQLgM6J4SNzhlhiRozopjl1AdzHP10+7F/vjkhsNq+YeEkjvcGsfpE7vmbWgW6FeVQyY
         9uvHgkCe45f5VXa4ur+/9lmLu6tlKQhW1Cje+YdV5vrZYiGh2bYxP8TEdN/vyympbfgz
         enZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=31CcFo6PJH+HjzrgnYp3DXEx991nRCYWmYaRbvo0qkg=;
        b=IWvv7aqycPGTt+7U7qVsZprHjLjq4cFim+tpwQW1CQW14K2izblPc5ADx6tA941y4q
         V/Lv0enb5Xvk8caTtRukGOHMMKjcpZWAnxR71P6Lw2aSSr5cdRHeDi3t5p42FM5RaZcy
         X39QFRWXYblkE1mVnvdIOx/wWfyFLYqpQNWyUdtEUZoxZyXh86siVa9jIPncDrXVNp4D
         rM7/eUVngOfHXO+Ev8guw3J2cozO4acTfiH9ZvFYHO2EUgiAC7cqIKHAauUrZ9uofHwc
         oyguUaLKFSSnqNVNvJSTAgXj+0SDWZ4Cxjrv94XU511zt2yribjSlX1nevh0foJsxnUB
         CXCw==
X-Gm-Message-State: APjAAAWS8ALTyw8hr2eDIBHJ/Cd1v2mHLKhziBdNjQB1i5U0WUompv7o
        Tb9FjtT02s8KfAlq8ani8P5cMy6PchU=
X-Google-Smtp-Source: APXvYqzvrn/1LSGq3DHp8uuXLECay5W/0DaTWJKkS3xnHf/RSDXY0LZEZ6Riz4/AzfkzZ5/iheu2pA==
X-Received: by 2002:ac8:28a8:: with SMTP id i37mr6057624qti.215.1551479164001;
        Fri, 01 Mar 2019 14:26:04 -0800 (PST)
Received: from [192.168.1.199] (pool-108-28-156-19.washdc.fios.verizon.net. [108.28.156.19])
        by smtp.gmail.com with ESMTPSA id 55sm15771352qtq.25.2019.03.01.14.26.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 14:26:03 -0800 (PST)
Subject: Re: Realtek r8822be kernel module does not negotiate 802.11ac
 connection
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Tony Chuang <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D17AF74C@RTITMBSVM04.realtek.com.tw>
 <b0518665-d5ca-7c94-9808-7cc0cf565814@gmail.com>
 <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
From:   "David R. Bergstein" <david.r.bergstein@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david.r.bergstein@gmail.com; keydata=
 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
 cZPytJop3jxjNbB2ZRfwBXX3FsGBkJ4S2SKQyQ==
Message-ID: <6eb7af74-b1a8-d112-e027-6c14252af994@gmail.com>
Date:   Fri, 1 Mar 2019 17:26:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <e68c6aae-8d71-266a-81fe-d078ac1ef38c@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry,

Thanks for the response and detailed instructions, which allowed me to
build and install the rtw88 kernel module.=C2=A0 I cannot however seem to=
 get
my system to actually use the module.=C2=A0 Just to recap this is an HP O=
men
laptop with secure boot disabled.=C2=A0 Upon boot-up both the new rtw88 a=
nd
old r8822be modules are loaded.=C2=A0 If I unload the r8822be module the =
wifi
network connection gets terminated, even if I unload/reload the rtw88
module.

Is there something else I should be doing prior to invoking rtw88, e.g.,
blacklisting the old module?

Sincerely,

David R. Bergstein

On 3/1/19 12:28 PM, Larry Finger wrote:
> On 2/28/19 8:32 PM, David R. Bergstein wrote:
>> Tony,
>>
>> Thanks for your response.=C2=A0 Can you advise as to the availability =
of the
>> new rtw88 driver?=C2=A0 As it appears to be under development, I could=
 not
>> locate a copy of the code for local compilation.
>
> David,
>
> Use the command 'git clone http://github.com/lwfinger/rtlwifi_new.git
> -b rtw88' to get a copy of the new driver for RTL8822BE and RTL8822CE
> in a stand-alone form. All that is needed is 'cd rtlwifi_new && make
> && sudo make install'. This version will build on kernels v4.4 and
> newer. As I have time, I will be backporting to kernels at least as
> old as 4.0.
>
> I would appreciate your comments and bug reports.
>
> Larry
>
>

