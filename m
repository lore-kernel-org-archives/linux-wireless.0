Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BF7C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38EF02183F
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbfAGNFw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:05:52 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36250 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730806AbfAGNFv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 08:05:51 -0500
Received: by mail-wm1-f67.google.com with SMTP id p6so845323wmc.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 05:05:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Tq0Lkb6DfvWYfREZjETjbUpmlozCDJDlvYVzu2LfYA=;
        b=kzYuMoC/o1CB0nkfDFWnGTfCLoxt6T+FoWaH1QBxS0mFJIFdmpwR/ItajClWda+WOb
         LchaHIefWTf/3eOi/Uu2LJJdcbTrSSboNmwIfBS90m2MCuUlM387MccFfFGx+6+bRmqp
         52THrjeJBTHeVb2dFom+WERTgcu3shwgTmyiYDQHcDzp01eDFZmkcnSBbR/NyvBIrKQw
         ro5HRKxVZx6jOVrWhSL6nVl4+MWQCzIkjmS/gQIUQV01jB3hQJTJ1Ph8yygWOrvkCwQP
         FVVYhbYS3icNHhqHgUeYT+Y17RsrccioyotryRGhtfxeU7sV5zeAWX0x6I0YNZDSryOa
         PEIw==
X-Gm-Message-State: AJcUukc8/JoHJ/xkYfXDuyZmIcbMi8SF7PsAkAgbH9bKkhTVE0jNxgLf
        Ww9ZZHwU6wk90/VZpavMwSno4iMQJzs=
X-Google-Smtp-Source: ALg8bN6UULjQ8sCDOzYjG3KqjRKR/7deJWOCpJEfod9pE3/VP4rytRkOmPq9gvlh0jJY5zz5rSPnXw==
X-Received: by 2002:a1c:85d2:: with SMTP id h201mr8141984wmd.151.1546866349412;
        Mon, 07 Jan 2019 05:05:49 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id v132sm7658291wme.20.2019.01.07.05.05.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jan 2019 05:05:48 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Use request_firmware_direct for the clm_blob
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20190107113401.6824-1-hdegoede@redhat.com>
 <d6dafb19-4e88-c2c7-9547-2ebd5b4bec2e@broadcom.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <5b365baf-99b3-2033-1f8e-6ca38d6daf42@redhat.com>
Date:   Mon, 7 Jan 2019 14:05:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <d6dafb19-4e88-c2c7-9547-2ebd5b4bec2e@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 07-01-19 12:58, Arend Van Spriel wrote:
> On 1/7/2019 12:34 PM, Hans de Goede wrote:
>> The linux-firmware brcmfmac firmware files contain an embedded table with
>> per country allowed channels and strength info.
>>
>> These versions of the firmware are specially build for linux-firmware,
>> the firmware files directly available from Broadcom / Cypress rely on
>> a separate clm_blob file for this info.
> 
> Hi Hans,
> 
> It is a bit more subtle than how you put it here. It is more of an historical thing.

I know this started as a historical thing and for some of the older
firmwares, the info being embedded is indeed simply a legacy thing.

> The table used to be embedded in firmware only. Much later the clm_blob loading functionality was added so customers could get an updated blob file while using the same firmware. In our router business we still provide firmwares with embedded table. Cypress decided to move to a model in which the firmware contains a null table and needs clm_blob to get things going.

Cypress is actually doing both the old (embedded info) and the new
(separate clm_blob) model for the firmwares which they are now maintaining,
they are still providing updates *with the embedded info, see e.g.:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/brcm?id=253a573936ee2078d206527f3ae845b4dc681269

Where as in their own firmware-distribution:

https://community.cypress.com/docs/DOC-15932
"Cypress Linux WiFi Driver Release (FMAC) [2018-09-28]"

Cypress does the null-table + separate clm_blob file thing and for reasons
which they have never explained they insist on the linux-firmware files and
their own files being different.

The zip file from DOC-15932 link contains a "cypress-firmware-v4.14.52-2018_0928.tar.gz"
which contains LICENCE.cypress from before this commit:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit?id=ba51e861f4444f51e7e83f778575a8146dc514d

which means it has a troublesome termination clause and a README which says:

"
* This LICENCE is different from the LICENCE.Cypress on linux-firmware.git.
* The files under this licence are not intended for linux-firmware.git upstreaming.
"

This also means that linux-firmware is always lagging in firmware
version, missing out on bug and SECURITY fixes, e.g.

Looking at the included brcmfmac4356-pcie.bin file, linux-firmware
has version 7.35.180.176. Where as cypress-firmware-v4.14.52-2018_0928.tar.gz
made available from Cypress directly has a newer version, quoting from their
changelog:

* 4356-pcie
    * --- 7.35.180.190 ---
    * Firmware crash fix
    * MFP bug fix

A "Firmware crash fix" to me sounds like a potential security issue, yet Cypress
is deliberately blocking us from distributing the new version.

Another example is the firmware for the wifi on the Raspberry Pi 3B+ which
is *years* older in linux-firmware.

I must say these whole shenanigans with the firmware causing linux-firmware to
have way too old firmware versions makes me very unhappy. I'm at the point
where I'm telling friends to not buy any hardware with Cypress wifi in there
because of this and because of the *complete* lack of bluetooth firmware.

>> For some unknown reason Broadcom / Cypress refuse to provide the standard
>> firmware files + clm_blob files it uses elsewhere for inclusion into
>> linux-firmware, instead relying on these special builds with the clm_blob
>> info embedded. This means that the linux-firmware firmware versions often
>> lag behind, but I digress.
> 
> Most of them are not special builds and provided to AOSP as well.

They are not the same builds as Cypress is distributing in their SDK and
they are generally anywhere between a bit and a lot older, so to me these
seem to be special builds and not the preferred form of firmware, otherwise
Cypress would be distributing the same builds in their SDK.

Anyways except for the legacy cases seems to all be about how Cypress is
distributing the firmware, so I will drop the Broadcom reference in this
paragraph for v2 of this patch.

>> The brcmfmac driver does support the separate clm_blob file and always
>> tries to load this. Currently we use request_firmware for this. This means
>> that on any standard install, using the standard combo of linux-kernel +
>> linux-firmware, we will get a warning:
>> "Direct firmware load for ... failed with error -2"
>>
>> On top of this, brcmfmac itself prints: "no clm_blob available (err=-2),
>> device may have limited channels available" and we will get a slow
>> fallback to the userspace firmware loading mechanism.
>>
>> This commit fixes both almost any brcmfmac device logging the warning
>> (leaving the brcmfmac info message in pace), as well as the slow and
> 
> 'pace' should probably be 'place' here.

Right, will fix.

>> unnecesary fallback by switching to request_firmware_direct for
>> the clm_blob.
> 
> As Kalle mentioned it is probably better to use the 'nowarn' api.

Ok will also fix for v2.

Regards,

Hans


> 
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
