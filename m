Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D43C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0AD621736
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SSOkh1iz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OFrawv4Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfAGNX4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:23:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52904 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfAGNXw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 08:23:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 53EF8608D4; Mon,  7 Jan 2019 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546867430;
        bh=F1UHcElavQbPAc7LT23juUziPGpDMn3Soj+i7VU5qVE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SSOkh1izz4j2o7p1C06Hq3z0ODXfMnRKTJ5gdYk9paSI6QAEXRR0eVCGFaaoMEKe8
         fjsvY0SLfn1HC/bSltZdVrBmBSu4Y9mGd0GcMp+2bPaouoblRrz4HqNBJ2O2pkYfFr
         QSfnXlQ1n610k1r7Lz0F1EuqTDDDcmfgsP/4IXlM=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A9F9608BA;
        Mon,  7 Jan 2019 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546867427;
        bh=F1UHcElavQbPAc7LT23juUziPGpDMn3Soj+i7VU5qVE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OFrawv4QysoPdrRBO3c7yhBEMU8bMiCALK94XXhYeFK2v1dMkb+uEGys7TBJUruHp
         WlbowmnXWfXys17IEFiSEbZZZEUGW4quiPktgmqFEADXULNLEw4D11GbWBBo2wMX7/
         Q4wf7RKD3GGTlLBXCC62Duy9IkUs6IoD3z/kNSCU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A9F9608BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "Daniel F. Dickinson" <cshored@thecshore.com>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        chunkeey@gmail.com, Bas Vermeulen <bvermeul@blackstar.nl>
Subject: Re: [PATCH] ath9k: Avoid OF no-EEPROM quirks without qca,no-eeprom
References: <20181222060913.28434-1-cshored@thecshore.com>
        <CAFBinCA3MTO=h9YpB0RkxSNy4ZpeYLOAuKTykAKz+68stAtMsg@mail.gmail.com>
Date:   Mon, 07 Jan 2019 15:23:43 +0200
In-Reply-To: <CAFBinCA3MTO=h9YpB0RkxSNy4ZpeYLOAuKTykAKz+68stAtMsg@mail.gmail.com>
        (Martin Blumenstingl's message of "Sat, 22 Dec 2018 12:08:05 +0100")
Message-ID: <87a7kc7g9s.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> On Sat, Dec 22, 2018 at 7:09 AM Daniel F. Dickinson
> <cshored@thecshore.com> wrote:
>>
>> ath9k_of_init() function[0] was initially written on the assumption that
>> if someone had an explicit ath9k OF node that "there must be something
>> wrong, why would someone add an OF node if everything is fine"[1]
>> (Quoting Martin Blumenstingl <martin.blumenstingl@googlemail.com>)
>>
>> "it turns out it's not that simple. with your requirements I'm now aware
>> of two use-cases where the current code in ath9k_of_init() doesn't work
>> without modifications"[1]
>>
>> The "your requirements" Martin speaks of is the result of the fact that I
>> have a device (PowerCloud Systems CR5000) has some kind of default - not
>> unique mac address - set and requires to set the correct MAC address via
>> mac-address devicetree property, however:
>>
>> "some cards come with a physical EEPROM chip [or OTP] so "qca,no-eeprom"
>> should not be set (your use-case). in this case AH_USE_EEPROM should be
>> set (which is the default when there is no OF node)"[1]
>>
>> The other use case is:
>>
>> the firmware on some PowerMac G5 seems to add a OF node for the ath9k
>> card automatically. depending on the EEPROM on the card AH_NO_EEP_SWAP
>> should be unset (which is the default when there is no OF node). see [3]
>>
>> After this patch to ath9k_of_init() the new behavior will be:
>>
>>     if there's no OF node then everything is the same as before
>>     if there's an empty OF node then ath9k will use the hardware EEPROM
>>       (before ath9k would fail to initialize because no EEPROM data was
>>       provided by userspace)
>>     if there's an OF node with only a MAC address then ath9k will use
>>       the MAC address and the hardware EEPROM (see the case above)
>>     with "qca,no-eeprom" EEPROM data from userspace will be requested.
>>       the behavior here will not change
>> [1]
>>
>> Martin provides additional background on EEPROM swapping[1].
>>
>> Thanks to Christian Lamparter <chunkeey@gmail.com> for all his help on
>> troubleshooting this issue and the basis for this patch.
>>
>> Fixes: 138b41253d9c ("ath9k: parse the device configuration from an OF node")
>>
>> [0]https://elixir.bootlin.com/linux/v4.20-rc7/source/drivers/net/wireless/ath/ath9k/init.c#L615
>> [1]https://github.com/openwrt/openwrt/pull/1645#issuecomment-448027058
>> [2]https://github.com/openwrt/openwrt/pull/1613
>> [3]https://patchwork.kernel.org/patch/10241731/
>
> +Cc Bas Vermeulen: can you please try Daniel's patch on your PowerMac
> G5? I hope that this replaces your "endian_check" module parameter!
>
>> Signed-off-by: Daniel F. Dickinson <cshored@thecshore.com>
>
> Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> (to me the description makes sense, but that said: I contributed some
> of the description)
>
> as well as:
> Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> (on my BT HomeHub 5A - which sets qca,no-eeprom - using OpenWrt, which
> is currently running backports v4.19.7)

Daniel noticed that patchwork dropped Martin's reply, adding it to
patchwork now.

-- 
Kalle Valo
