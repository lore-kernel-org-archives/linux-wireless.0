Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D8AC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF944206BA
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mqlbl8IP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iiHrsPG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfCKNsY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:48:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfCKNsY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:48:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8F58E61424; Mon, 11 Mar 2019 13:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552312103;
        bh=PFiLZj8AKJzFMnpVHsjwFZjyjaQIkSvLZHmHolCckt0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Mqlbl8IP7GaJbjsFmkgNZytNULH7DhktNGY3SauzIlpeA3J8nwdVUAHizpyk/t+Am
         YjFHQk1DXv6Q0H92U1cLKF5iLLuNPmRGjqDusBJKkv8Y/ItaNkoqi69rzzRR/D2NMv
         qLXNkr826rb2Q9i/pTG3L0jsGwnyawKPH7O5Zlkw=
Received: from x230.qca.qualcomm.com (87-95-203-65.bb.dnainternet.fi [87.95.203.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 31F4F61424;
        Mon, 11 Mar 2019 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552312101;
        bh=PFiLZj8AKJzFMnpVHsjwFZjyjaQIkSvLZHmHolCckt0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iiHrsPG4g7NObBVkyV50n8b4hyUIce9EeLBQ4SRh4KIEzMQBXGG0e8qY9ycyHymPC
         PDN+z0qT3kZKfLBEv2gO3ezq+SuRIYPk2DpSgZ0tUbF3AJ5523E4rpJEpWbow+O/Jd
         rp47C7/5vK7/rmspz4AF7Sb0iqlkepAtZu8S0Bc8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 31F4F61424
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
Date:   Mon, 11 Mar 2019 15:48:15 +0200
In-Reply-To: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
        (yhchuang@realtek.com's message of "Sat, 9 Mar 2019 21:48:08 +0800")
Message-ID: <87lg1l8qu8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
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

[...]

> Yan-Hsuan Chuang (14):
>   rtw88: main files
>   rtw88: core files
>   rtw88: hci files
>   rtw88: trx files
>   rtw88: mac files
>   rtw88: fw and efuse files
>   rtw88: phy files
>   rtw88: debug files
>   rtw88: chip files
>   rtw88: 8822B init table
>   rtw88: 8822C init table
>   rtw88: Kconfig & Makefile
>   rtw88: add MAINTAINERS entry
>   staging: rtlwifi: remove staging rtlwifi driver

Do note that the staging driver was too big and didn't make it to the
list (and patchwork). But no need to resend or modify that patch, just
an observation.

Or would --find-renames help to make the patch smaller?

-- 
Kalle Valo
