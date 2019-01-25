Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348A7C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 09:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0317A21855
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 09:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KytezNzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfAYJce (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 04:32:34 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46625 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfAYJce (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 04:32:34 -0500
Received: by mail-yw1-f67.google.com with SMTP id t13so3617544ywe.13
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2019 01:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q8WqyiCAImJmiSZkZPsNeMRFaB2oL2ep5diOK9jt6wI=;
        b=KytezNzS/niaT1sHigzL+mFkmIvp5Ai325LIA8uS7tNg8fxwTsccAecjZvdZshXPqf
         DQZBaqxEYuwklJg92nuYgOBOY3qi2Pxd0QwEJ/grXcbrp5fjhy6VN67smHvaIezzhQL/
         EckT9ubsFP2fa/B9e63DN9OxMJqLwUZZlusqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q8WqyiCAImJmiSZkZPsNeMRFaB2oL2ep5diOK9jt6wI=;
        b=tIjAqvG/+bUEz5fRgMqyW3MKAE32F0eJ0Wm6Z/cNi75TBVaEaw1sPdErk1X11GZgTW
         eTjern2g69Opzfv3xn7Z8/ywCg5+9PSdLRfSHREHB9oj6TxKoZ+O261kUz++/scHLiC+
         2lq6vHPlNxel/HVplMJOPkKVqNu7mZWi0+0KjPBY0sIApjJIE022RI8JV4w0bMZLsLaw
         FPfFIBPUtsWr7UWIGPO4pnHy/+YkpVZr6MGy1u35GO+IxRNwkLoN23QbjkRfelv8KU9s
         d72ewoHfNh5PJRjz0cSR2Ta7px+Z6Uelmg4UqSSQezwsZXks7dnEUqPHCkxbi7dQJlsy
         uGvQ==
X-Gm-Message-State: AJcUuke4TRpEJGfbpgskYwTx75j9s7/916sDendQKgH7d4D4nZ/nlufW
        QFiueZHJArDXmCwKPFPCv5tQtw==
X-Google-Smtp-Source: ALg8bN73ZPCNmliKwSTGxcwOtOxnRT/3DafoA4FAVRxVcESl97RGrlgswEsJuo/t+qxhOFG8DHycag==
X-Received: by 2002:a81:c14c:: with SMTP id e12mr9545941ywl.203.1548408752905;
        Fri, 25 Jan 2019 01:32:32 -0800 (PST)
Received: from [10.177.251.224] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id x133sm13545957ywg.57.2019.01.25.01.32.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 01:32:32 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: support monitor frames with hardware/ucode
 header
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20190122110858.12993-1-zajec5@gmail.com>
 <66fcd804-73f7-ae58-53f5-537ec8cb2802@broadcom.com>
 <9db0a0b702d2f2c28381de17c5b15c68@milecki.pl>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <68e3274a-3794-7508-142a-b6520aee2bd9@broadcom.com>
Date:   Fri, 25 Jan 2019 10:32:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <9db0a0b702d2f2c28381de17c5b15c68@milecki.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/25/2019 10:11 AM, Rafał Miłecki wrote:
> On 2019-01-25 09:51, Arend Van Spriel wrote:
>> On 1/22/2019 12:08 PM, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> The new FullMAC firmwares for 4366b1/4366c0 were supposed to provide
>>> monitor frames with radiotap header but it doesn't seem to be the case.
>>
>> I was not aware that this was supposed to. I did not build a radiotap
>> variant to keep it feature-wise similar to 4366b0 firmware.
> 
> Well, then apparently I got confused :( When you wrote:
> 
> On Mon, 11 Jun 2018 at 12:48, Arend van Spriel 
> <arend.vanspriel@broadcom.com> wrote:
>> Looking into our firmware repo it there are two flags, ie. WL_MONITOR
>> and WL_RADIOTAP. It seems both are set for firmware containing -stamon-
>> feature. Your list below confirms that. I still plan to add indication
>> for WL_RADIOTAP in the "cap" iovar, but a stamon feature check could be
>> used for older firmwares.
> 
> I assumed you'll add "rtap" cap value (to the internal wl code repository?)
> because you mean to release a firmware using it.
> 
> Maybe you just meant it to be for your customers compiling firmwares on
> their own?

and for customer for whom we compile firmwares based on their feature 
requirements. Anyway, I could build a new firmware for 4366b1/4366c0 
including radiotap. However, end-users may get to use firmware that is 
not supporting it.

>>> Testing the latest release resulted in discovering a new format being
>>> used. It seems (almost?) identical to the one known from ucode used in
>>> SoftMAC devices which is most likely the same codebase anyway.
>>
>> I am a bit confused. How many formats are there? It is either ucode
>> format or radiotap, right?
> 
> So far we got two formats:
> 1) 802.11 frames (with frame (sub)type & all addresses)
> 2) 802.11 frames with the radiotap header
> and now we also have:
> 3) 802.11 frames with the ucode header
> 
> For more info please check my original post:
> Research + questions on brcmfmac and support for monitor mode
> https://www.spinics.net/lists/linux-wireless/msg173573.html

I did read that before, but apparently did miss some details.

>>> While radiotap support was meant to be announced with the "rtap" fw
>>> capability string it seems no alternative was added for the hw/ucode
>>> format. It means each firmware requires a feature mapping quirk.
>>
>> I thought we only needed a quirk for the firmware that provide
>> radiotap but do not announce it. For the others we can assume ucode
>> format if monitor mode is supported. Probably missing something.
> 
> 802.11 frames with ucode header is something entirely new, I didn't see any
> Asus/Linksys/Netgear/TP-LINK firmware using it.
> 
> As the old firmwares were providing frames without any header (also making
> it impossible to e.g. read signal strength) we need this new flag to
> distinguish firmwares with ucode header from them.

Right. Thanks for explaining (again).

Regards,
Arend
