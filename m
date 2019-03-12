Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048F7C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 05:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDAFC2087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 05:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gn/0yTtb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HGLH4e5L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfCLFO0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 01:14:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfCLFO0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 01:14:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5A38760A42; Tue, 12 Mar 2019 05:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552367665;
        bh=NqArjZLLVdEvLnkSY+rayXhGJnxfQymrJSI1s0xEf4Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gn/0yTtbD6BSUgSUjfEXvppa1QU6RELDVQBHC1CzIaeUHYA+DC/NoCLJQljodvC1Q
         dNJaj86S8hrZow/gN/akVUvIXenkpjhPt8rnaNvqfBDBKbnFsY/Z2mA84rpPxGhyyg
         ch5YZCuRkDyK2WirIIW4lVYo8xfU0IPgGJfUv2JE=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C5E36019F;
        Tue, 12 Mar 2019 05:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552367664;
        bh=NqArjZLLVdEvLnkSY+rayXhGJnxfQymrJSI1s0xEf4Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HGLH4e5L7Xvd5aZgaM62R3cgCohIe2xxk9VLF93sen/PTmtEc6CHaZNAhkQglP8/V
         NdLb6khZUOnN7C8YX+FVpGg/sL/beP8vaySeqvAMh+EE+fP/31AzjCuDUg0YgjwldN
         b21RmYLkKC5Uj75tGr72FrW5kDRYMe1xUU0XW/UQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7C5E36019F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <yhchuang@realtek.com>
Cc:     <johannes@sipsolutions.net>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <sgruszka@redhat.com>, <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>
Subject: Re: [PATCH v7 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
Date:   Tue, 12 Mar 2019 07:14:19 +0200
In-Reply-To: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
        (yhchuang@realtek.com's message of "Sat, 9 Mar 2019 21:48:08 +0800")
Message-ID: <87ef7cznbo.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<yhchuang@realtek.com> writes:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> rtw88 now supports RTL8822BE/RTL8822CE now, with basic station mode
> functionalities. The firmware for both can be found at linux-firmware.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> For RTL8822BE: rtw88/rtw8822b_fw.bin
> For RTL8822CE: rtw88/rtw8822c_fw.bin
>
> And for now, only PCI buses (RTL8xxxE) are supported. We will add support
> for USB and SDIO in the future. The bus interface abstraction can be seen
> in this driver such as hci.h. Most of the hardware setting are the same
> except for some TRX path or probing setup should be separated.
>
> Supported:
>
>  * Basic STA/AP/ADHOC mode, and TDLS (STA is well tested)
>
> Missing feature:
>
>  * WOW/PNO
>  * USB & SDIO bus (such as RTL8xxxU/RTL8xxxS)
>  * BT coexistence (8822B/8822C are combo ICs)
>  * Multiple interfaces (for now single STA is better supported)
>  * Dynamic hardware calibrations (to improve/stabilize performance)
>
> Potential problems:
>
>  * static calibration spends too much time, and it is painful for
>    driver to leave IDLE state. And slows down associate process.
>    But reload function are under development, will be added soon!
>  * TRX statictics misleading, as we are not reporting status correctly,
>    or say, not reporting for "every" packet.
>
>
> The next patch set should have BT coexistence code since RTL8822B/C are
> combo ICs, and the driver for BT can be found after Linux Kernel v4.20.
> So it is better to add it first to make WiFi + BT work concurrently.
>
> Although now rtw88 is simple but we are developing more features for it.
> Even we want to add support for more chips such as RTL8821C/RTL8814B.

As we are getting closer to getting the driver accepted first few ground
rules to simplify the review: please don't send a new version until I
explicitly ask for it. Also don't make any changes to the driver unless
explicitly asked by Johannes or me, all other cleanup can be submitted
as followup patches after the driver is accepted.

I applied this now to the pending branch[1] and kbuild bot found one
problem, please fix that in the next version:

tree: https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git pending
head:   d5ae36c5064e6c036d86da20b5835df5225ba9ff
commit: 72a54e89a08d8747360b4c731c41871e22b6d84e [44/54] rtw88: add 8822c tx agc support
config: x86_64-allyesconfig (attached as .config)
compiler: gcc-8 (Debian 8.3.0-2) 8.3.0
reproduce:
        git checkout 72a54e89a08d8747360b4c731c41871e22b6d84e
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

>> ld: drivers/net/wireless/realtek/rtw88/phy.o:(.data+0x360):
>> multiple definition of `cck_rates';
>> drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.o:(.rodata+0x60):
>> first defined here
>> ld: drivers/net/wireless/realtek/rtw88/phy.o:(.data+0x320):
>> multiple definition of `ofdm_rates';
>> drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.o:(.rodata+0xc0):
>> first defined here

-- 
Kalle Valo
