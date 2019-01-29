Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAF2C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 17:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E11CB2184D
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 17:24:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nwl4SLob";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ngo9KhjS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbfA2RYL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:24:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbfA2RYL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 12:24:11 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E6B2F6072E; Tue, 29 Jan 2019 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548782649;
        bh=F33t8xaqp2yZJNDr4KQp50FX/xpByfpJBIb1o8/J2mY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nwl4SLobdAYxJtfAgV2bx+Zy7Ncm2Ydaw5wMAqdno3W0Q6yNhe0cgnGjSwAnlqr6g
         XXCAzIcSUznVFOPW9CLifXMdjgGZViqJ3gJnpWIe4pnV6Rn2IKUBcynla0jzl5lmqJ
         TE04uxjhdDtpEq/ar/y9w0xH2mZvCMGT0+clBY+g=
Received: from x230.qca.qualcomm.com (85-76-40-114-nat.elisa-mobile.fi [85.76.40.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BF633601D1;
        Tue, 29 Jan 2019 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548782647;
        bh=F33t8xaqp2yZJNDr4KQp50FX/xpByfpJBIb1o8/J2mY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ngo9KhjS0nEY5sQWlmY6GuGnXKCip3eadveyTaIlkTOt9thZ0/M4iOjEwCMvDZdBP
         dBVhzUPzsUB9h0pM9gVCIWA6NF9n+28nBWU8RNz+IzXoZe6nItPPz0ibJlouy1Jtnz
         Qk66hJU6RhTDeBS+stlk2WB3+hmeKy8bn6ux6m6c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BF633601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris\@chromium.org" <briannorris@chromium.org>,
        "sgruszka\@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
        <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D1794AAB@RTITMBSVM04.realtek.com.tw>
        <8d92c20f-a72f-6ea8-d4c8-61c3c8c9adc9@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D17981EA@RTITMBSVM04.realtek.com.tw>
        <87lg33uc6o.fsf@purkki.adurom.net>
        <F7CD281DE3E379468C6D07993EA72F84D1798ACF@RTITMBSVM04.realtek.com.tw>
Date:   Tue, 29 Jan 2019 19:23:59 +0200
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1798ACF@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Tue, 29 Jan 2019 13:01:44 +0000")
Message-ID: <871s4vwf68.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> I suggest to look at criticality of the bug and size of the patch. For
>> example, if the bug is a minor and the patch is large you should
>> definitely drop that. And smaller fixes to severe bugs you should
>> definitely again include them.
>> 
>> Just remember to list in the changelog every change you made since
>> previous version.
>> 
>
> Hi Kalle,
>
> One more question, should I merge the trivial patches into the original
> patch set and resend them like [PATCH v4 00/13].
>
> Or should I add them after the 13 patches for people to review easily.
> Such as [PATCH v4 00/21]. Which do you prefer?

I don't have any strong opinion but I prefer the former (13 patches).
Others might think differently.

BTW, I don't if you are aware but I will add the driver to
wireless-drivers-next in commit, so in the end we need to squash these
patches into patch. Only in review it's easier to have them split like
this. But we don't need to worry about that right now, let's focus on
people reviewing the driver first.

-- 
Kalle Valo
