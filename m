Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7F4C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 04:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B1D720821
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 04:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kB9tTXZi";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kB9tTXZi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfBEEtV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 23:49:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42556 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfBEEtV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 23:49:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D9607607F4; Tue,  5 Feb 2019 04:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549342159;
        bh=6mYKpIlp1orwkFhoZ3LTRTPbPRB5J000tWXuoficWVU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kB9tTXZiFLAu6bNH5xMPmWuRGIvbSaFpJ8BiOUZP6mZSjNCXgJ01DC6zYjcM4d94N
         0XFiZ5am9zuBvHM5891Rac0nfUQG82+shWaQAIC3PStogUvlPfNYZwrWqvcsoSVgbj
         /WECicB+mfqachOLkuJER5+/TSeCevq5NPnyY8uE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6551860398;
        Tue,  5 Feb 2019 04:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549342159;
        bh=6mYKpIlp1orwkFhoZ3LTRTPbPRB5J000tWXuoficWVU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kB9tTXZiFLAu6bNH5xMPmWuRGIvbSaFpJ8BiOUZP6mZSjNCXgJ01DC6zYjcM4d94N
         0XFiZ5am9zuBvHM5891Rac0nfUQG82+shWaQAIC3PStogUvlPfNYZwrWqvcsoSVgbj
         /WECicB+mfqachOLkuJER5+/TSeCevq5NPnyY8uE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6551860398
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Yu Wang <yyuwang@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>
Subject: Re: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for QCA6174/QCA9377"
References: <20181107185643.240346-1-briannorris@chromium.org>
        <20190204164254.86E0860734@smtp.codeaurora.org>
        <CA+ASDXO4bMY9tWjeKND1+7yBC47XimNEohQEpyA-TZxgS7Xiiw@mail.gmail.com>
Date:   Tue, 05 Feb 2019 06:49:13 +0200
In-Reply-To: <CA+ASDXO4bMY9tWjeKND1+7yBC47XimNEohQEpyA-TZxgS7Xiiw@mail.gmail.com>
        (Brian Norris's message of "Mon, 4 Feb 2019 14:54:27 -0800")
Message-ID: <87pns6dely.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Mon, Feb 4, 2019 at 8:43 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>> Brian Norris <briannorris@chromium.org> wrote:
>>
>> > This reverts commit cfb353c0dc058bc1619cc226d3cbbda1f360bdd3.
>> >
>> > WCN3990 firmware does not yet implement this feature, and so it crashes
>> > like this:
>> >
>> >   fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN RT:207a:PC=b001b4f0
>> >
>> > This feature can be re-implemented with a proper service bitmap or other
>> > feature-discovery mechanism in the future. But it should not break
>> > working boards.
>> >
>> > Fixes: cfb353c0dc05 ("ath10k: add quiet mode support for QCA6174/QCA9377")
>> > Cc: Yu Wang <yyuwang@codeaurora.org>
>> > Cc: Rakesh Pillai <pillair@codeaurora.org>
>> > Cc: Govind Singh <govinds@codeaurora.org>
>> > Cc: <stable@vger.kernel.org>
>> > Signed-off-by: Brian Norris <briannorris@chromium.org>
>>
>> This regression should be fixed by (which is in v4.20):
>>
>> 53884577fbce ath10k: skip sending quiet mode cmd for WCN3990
>>
>> So this revert should not be needed anymore and I'll drop this.
>
> Yes, that seems to work for me. I'll probably replace the revert with
> the above in my downstream. Thanks!
>
> Can't really be fixed now, but it would have been nice to have a Fixes
> tag on that one.

Indeed. Sorry, missed that.

-- 
Kalle Valo
