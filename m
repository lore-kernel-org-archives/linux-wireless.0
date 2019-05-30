Return-Path: <SRS0=3DzK=T6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41A5C072B1
	for <linux-wireless@archiver.kernel.org>; Thu, 30 May 2019 04:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A777126052
	for <linux-wireless@archiver.kernel.org>; Thu, 30 May 2019 04:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aQPI2/sr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MEaxeEnm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389302AbfE3E7k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 May 2019 00:59:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbfE3E7j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 May 2019 00:59:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A411D60213; Thu, 30 May 2019 04:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559192378;
        bh=1SgeDXWgbQ0KV936oxZHawpgAwsFnvw+M3W5urT1mUI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aQPI2/srpN6qewMq/vZqieIC8Iux3YhEbmlCENYLEtm5Dtk/G1q0WHBiv8gWU9tty
         Wf7IFgWOF14DK3jvM+AbU0AzWYQFJ9IEMX7gLVGEsbfSvxfOXrY0IqqYwx7ebsA4up
         KthpFNVVYQe6kgFKJjjNPjAXvgrQRpSY0F6rfs+k=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 50C7E60213;
        Thu, 30 May 2019 04:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559192377;
        bh=1SgeDXWgbQ0KV936oxZHawpgAwsFnvw+M3W5urT1mUI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MEaxeEnmed/F3fSESFGAbuuwZNg6hk+iTPitU1xNS/BSlPLSAZahGF5vpPitJ05Sz
         sCPPWy4LRUM7N3SVDrlpUcyYMN2hVlq2IUkkW8+nK0ExY1j0tagnSnbrEiNQ7rhRGY
         YDrnStmCsLc8NChvqOT5pSx9B7W9xBHMUSnOxvX0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 50C7E60213
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] rtw88: resolve order of tx power setting routines
References: <1559116487-5244-1-git-send-email-yhchuang@realtek.com>
        <1559116487-5244-2-git-send-email-yhchuang@realtek.com>
        <f5bd9ab0-c32c-dcc6-9451-09e6b7f50a96@lwfinger.net>
        <F7CD281DE3E379468C6D07993EA72F84D17FABBF@RTITMBSVM04.realtek.com.tw>
Date:   Thu, 30 May 2019 07:59:34 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17FABBF@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Thu, 30 May 2019 02:29:10 +0000")
Message-ID: <87v9xspmfd.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> -----Original Message-----
>> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry Finger
>> Sent: Wednesday, May 29, 2019 11:17 PM
>> To: Tony Chuang; kvalo@codeaurora.org
>> Cc: linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH 01/11] rtw88: resolve order of tx power setting routines
>> 
>> On 5/29/19 2:54 AM, yhchuang@realtek.com wrote:
>> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> >
>> > Some functions that should be static are unnecessarily exposed, remove
>> > their declaration in header file phy.h.
>> >
>> > After resolving their declaration order, they can be declared as static.
>> > So this commit changes nothing except the order and marking them static.
>> >
>> > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> 
>> This patch does not apply. Using quilt to see what is wrong, there are 6
>> changes
>> that have already been applied.
>> 
>> Larry
>> 
>
>
> These patches are based on
>
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/kvalo/wireless-drivers
> branch master
>
> commit 6aca09771db4277a78853d6ac680d8d5f0d915e3
> Author: YueHaibing <yuehaibing@huawei.com>
> Date:   Sat May 4 18:32:24 2019 +0800
>
>     rtw88: Make some symbols static
>
>
> It should apply, did I miss something?

I keep the bar high and take to wireless-drivers only patches which fix
important, user visible problems. Everything else goes to
wireless-drivers-next. So you should use wireless-drivers-next as the
baseline for all regular patches.

-- 
Kalle Valo
