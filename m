Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E46C67839
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 20:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDC3020851
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 20:34:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intellastar.com header.i=@intellastar.com header.b="QpYCt73V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDC3020851
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=intellastar.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbeLKUen (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 15:34:43 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38382 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbeLKUem (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 15:34:42 -0500
Received: by mail-qt1-f194.google.com with SMTP id p17so18038449qtl.5
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 12:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intellastar.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4NqXq8l/FDcN9jts4TkZ9xfLuk0Md/9neQSyGtci6us=;
        b=QpYCt73VfrCevT9dEvYOxUmkQGRqBziLamAKyH2bhhMUZLe5JlGzVLXigJwHYRUmtY
         w4g2ibnWF8EHxH0VKHnTt7+ecOCvk6b+355+NHGh4MW2rtXeRxdKwqLu6H6yCxgqoj1U
         Qf5BddHOIsHPPo5a2CcmNGGLIcQIGmeT4/f6+UU/sYRHr7OkagTrLjfGhMgRMxqebZmX
         xWtwGfUTs+8F60Z52thzrN8KxAGLce0bWY4HRhmACkx10hmAPE2qmTi86zmrxpDEysbV
         dt3KwXdhhWHCr4c9jPO8lKtgpGfT1lUCX7ghySEQ6+tUtesHWXcpxZ9zXztzgvSTkFYS
         53Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4NqXq8l/FDcN9jts4TkZ9xfLuk0Md/9neQSyGtci6us=;
        b=Z/dIUTpeB4dcGh55u9L3TPgb2PpzqNWiQOFpwJhUSAJ7IOoQaZNUaNYEsaP18t6S7x
         lh7M0umS3Y2m3BvapcikdvySdKUXpxn5HKqfakC5TPMyZ49JFGJ3TgEC/JlyNVZaCVxv
         kPrkX56VuR2bPXIc5ewgB+urzD/KUYmCDbKVNkSAOWD+CHLN+ldkTuGoA5zA3q1LZSof
         HMqNFGX/DBYkCuzQw5QnBJv8IAV7FwRtqLcv2OzFF88ZTl84P00qTPwhys3+maG+qoFT
         2tQzk9yLBnpD7a5tGzDgKQYrV1rZc/8UbmGhf/SnZomoYFVMXxpRmYvS+MpLdnlShC+H
         FX9A==
X-Gm-Message-State: AA+aEWYaizfGcH/OGebbD7mbY8WklH79zqAdV0JA3xCgSD/6qD5JTvYq
        QcfvCOFSis3jsOKgQeW3eEHMVwfVRoxACLlcjd2m3rtzkO6k51lj7JAzYAeLvDH6JnrTlB3AeMr
        D6tGrWgQgJG3E1u1AnBhH/ojGY22CZjCDnN0MFPQ4gad3Ig9zlCcM2B+bo39Tr8v6/HoM8CZtfr
        rQatU=
X-Google-Smtp-Source: AFSGD/WXpOOa8yJNpRBJE9WhkPxPdyNaPO5QiTiZg2wF/XfcE74sPsIp6vFr27djdETKGl/DkXi5jg==
X-Received: by 2002:a0c:e789:: with SMTP id x9mr198428qvn.245.1544560481388;
        Tue, 11 Dec 2018 12:34:41 -0800 (PST)
Received: from [192.168.110.7] (cpe-67-241-170-88.buffalo.res.rr.com. [67.241.170.88])
        by smtp.gmail.com with ESMTPSA id c12sm12354164qka.42.2018.12.11.12.34.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 12:34:41 -0800 (PST)
Subject: Re: wlcore update breaks on 4.9 and 4.4 kernel branches
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org
References: <43ee432a-c6ab-e23c-616c-b626a5fb4637@intellastar.com>
 <20181202150813.GG221015@sasha-vm>
From:   Dietmar May <dmay@intellastar.com>
Message-ID: <82d68b26-3c95-af35-86bb-c17855da00ce@intellastar.com>
Date:   Tue, 11 Dec 2018 15:34:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181202150813.GG221015@sasha-vm>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sasha,

I've verified that 4.9.143 no longer exhibits this problem.

The revert hasn't shown up in 4.4 yet; but I'll verify once merged there.

Thanks,
Dietmar
------------------------------------------------------------------------
On 12/2/18 10:08 AM, Sasha Levin wrote:
> On Thu, Nov 29, 2018 at 05:56:31PM -0500, Dietmar May wrote:
>> I've run into some problems which appear due to (a) recent patch(es)=20
>> on the wlcore wifi driver.
>>
>> 4.4.160 - commit 3fdd34643ffc378b5924941fad40352c04610294
>> 4.9.131 - commit afeeecc764436f31d4447575bb9007732333818c
>>
>> Earlier versions (4.9.130 and 4.4.159 - tested back to 4.4.49) do not=20
>> exhibit this problem. It is still present in 4.9.141.
>>
>> master as of 4.20.0-rc4 does not exhibit this problem.
>>
>> Basically, during client association when in AP mode (running=20
>> hostapd), handshake may or may not complete following a noticeable=20
>> delay. If successful, then the driver fails consistently in=20
>> warn_slowpath_null during disassociation. If unsuccessful, the wifi=20
>> client attempts multiple times, sometimes failing repeatedly. I've=20
>> had clients unable to connect for 3-5 minutes during testing, with=20
>> the syslog filled with dozens of backtraces. syslog details are below.
>>
>> I'm working on an embedded device with a TI 3352 ARM processor and a=20
>> murata wl1271 module in sdio mode. We're running a fully patched=20
>> ubuntu 18.04 ARM build, with a kernel built from kernel.org's=20
>> stable/linux repo=20
>> <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit=
/?h=3Dlinux-4.9.y&id=3Dafeeecc764436f31d4447575bb9007732333818c>.=20
>> Relevant parts of the kernel config are included below.
>>
>> The commit message states:
>>
>>> /I've only seen this few times with the runtime PM patches enabled=20
>>> so this one is probably not needed before that. This seems to work=20
>>> currently based on the current PM implementation timer. Let's apply=20
>>> this separately though in case others are hitting this issue./
>> We're not doing anything explicit with power management. The device=20
>> is an IoT edge gateway with battery backup, normally running on wall=20
>> power. The battery is currently used solely to shut down the system=20
>> cleanly to avoid filesystem corruption.
>>
>> The device tree is configured to keep power in suspend; but the=20
>> device should never suspend, so in our case, there is no need to call=20
>> wl1271_ps_elp_wakeup() or wl1271_ps_elp_sleep(), as occurs in the patch.
>
> Given that this patch went in through AUTOSEL, I've queued up a revert
> of it (sorry for the trouble!).
>
> I'll link this mail in the revert message. If anyone feels that this
> patch should be in any of the LTS trees then either reply to this thread
> or start a new one on stable@vger.kernel.org.
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
