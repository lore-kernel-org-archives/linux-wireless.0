Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C3BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 06:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A595B2070D
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 06:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jTYLQRTb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nQHtRkCC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfCMGsg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 02:48:36 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39634 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfCMGsg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 02:48:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6F005609EF; Wed, 13 Mar 2019 06:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552459715;
        bh=dvBL5wXDc6zXnbUKNND4HWxxULOGegqR0cMwlzCuuzY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jTYLQRTbVLfOxEpMtErnCPtPSa3FfN4jxP0nlwiaeL04YZielNlwzZqvcJzWjDGjy
         hvmPkI7VAjN20nf7Ri/WmgQ0MUhDhf2vLCMUqtREIuFNcGOn4M/OnxBIelLTSwNrFB
         6gjke+pxrEfDJwL+/VmimP+sP7tqlokcAemgC/ss=
Received: from x230.qca.qualcomm.com (85-76-44-132-nat.elisa-mobile.fi [85.76.44.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5042C6019F;
        Wed, 13 Mar 2019 06:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552459713;
        bh=dvBL5wXDc6zXnbUKNND4HWxxULOGegqR0cMwlzCuuzY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nQHtRkCC2bpgmFAh+WSUau0D80Re+MHs2OZWVVKQ8Th1zjX+2/drRfN3h1GfXyOXN
         ThyoV5fCeXPhzVQ5JkCvlSzBQzNos4cwEGp9kGSAfv6ePHTqsxqqLASwUhUKeAxcnA
         0A1Py9ONp9XDmxnBVNlHex9pB5DE9Wan7ztu1Fuw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5042C6019F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <yhchuang@realtek.com>
Cc:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sgruszka@redhat.com>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
Date:   Wed, 13 Mar 2019 08:48:27 +0200
In-Reply-To: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
        (yhchuang@realtek.com's message of "Wed, 13 Mar 2019 12:13:49 +0800")
Message-ID: <87wol31d8k.fsf@codeaurora.org>
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

> v8
>
>  - add prefix "rtw_" to *_rates and corresponding *_sizes, otherwise
>    the extern will confuse the linker there are multiple definitions
>    with brcmsmac driver

I tried to explain this already last time, but maybe I wasn't clear
enough so I'll try again: PLEASE do not submit any new versions of rtw88
until I explicitly ask you to send v9. If you post new versions too
frequently it makes the review harder. Reviewing full driver is very
different from reviewing normal patches, the patches are larger and it
takes more time to review.

Also you did not switch to using GENMASK() like I asked.

So no more new versions of rtw88 until everyone have reviewed v8 and I
ask you to send v9.

-- 
Kalle Valo
