Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6511C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 11:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD4C92243E
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 11:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hntP4xtM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dQUhLA6v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD4C92243E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388038AbeKOVWF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 16:22:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52138 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbeKOVWF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 16:22:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0FFB56022B; Thu, 15 Nov 2018 11:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542280481;
        bh=tN+H2304AWgkonGmy+hqLw6zxN6IPc5NE6IoIxBNu94=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hntP4xtMnQt3tsIl1ppyfY0a5tZ/ebrBthXi6gk/MFiKFJe4BUtF4Wf2LaUvZjDkg
         xxXBa3c3NkYsSSTdsWMlKxmpt7Z5o39dhpgUFBoJMxGsDyf5Vradk3S1sb9trO8jdb
         fAZa5WIfTAi5qsShsoMgvDhKWLFLgsr26RiUuUF0=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1D9C96022B;
        Thu, 15 Nov 2018 11:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542280480;
        bh=tN+H2304AWgkonGmy+hqLw6zxN6IPc5NE6IoIxBNu94=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dQUhLA6vn27wkeEp5omQi9TbMVG4vSqbh8ldvuN2GaGb7us540eGBDGIw65Pm0y8V
         vwDmUHyTuOCefNVrCiddUTNTfGrFpZgJdOMVOXEyWORHfPDa6/9+mSperm83Hipuc3
         TluwGP3lTA2QKhrs3LU2JVXkJPOkTYfimSy5PuK4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1D9C96022B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] mac80211_hwsim: Timer should be initialized before device registered
References: <20181017220212.15240-1-vvavrychuk@gmail.com>
        <CAMqC21BvHZeFRv1rkBrRejzytGORtCuBKo6q5FMhQZPHoOcfmg@mail.gmail.com>
Date:   Thu, 15 Nov 2018 13:14:36 +0200
In-Reply-To: <CAMqC21BvHZeFRv1rkBrRejzytGORtCuBKo6q5FMhQZPHoOcfmg@mail.gmail.com>
        (Vasyl Vavrychuk's message of "Thu, 15 Nov 2018 12:08:52 +0200")
Message-ID: <875zwyd23n.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(fixing top posting)

Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com> writes:

> On Thu, Oct 18, 2018 at 1:02 AM Vasyl Vavrychuk
> <vasyl.vavrychuk@globallogic.com> wrote:
>>
>> From: Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
>>
>> Otherwise if network manager starts configuring Wi-Fi interface
>> immidiatelly after getting notification of its creation, we will get
>> NULL pointer dereference:
>>
>>   BUG: unable to handle kernel NULL pointer dereference at           (null)
>>   IP: [<ffffffff95ae94c8>] hrtimer_active+0x28/0x50
>>   ...
>>   Call Trace:
>>    [<ffffffff95ae9997>] ? hrtimer_try_to_cancel+0x27/0x110
>>    [<ffffffff95ae9a95>] ? hrtimer_cancel+0x15/0x20
>>    [<ffffffffc0803bf0>] ? mac80211_hwsim_config+0x140/0x1c0 [mac80211_hwsim]
>>
>> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@globallogic.com>
>
> Does anyone have some feedback about this?

Johannes has applied it six days ago:

https://patchwork.kernel.org/patch/10646105/

https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/commit/?id=a1881c9b8a1edef0a5ae1d5c1b61406fe3402114

To help the maintainers you can check yourself the status from
patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
Kalle Valo
