Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1FCC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F5521773
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O3kUeYPk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Oi++AICr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfCKNca (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:32:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39234 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbfCKNc3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:32:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9082460A43; Mon, 11 Mar 2019 13:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552311148;
        bh=lt65+wzeNu71Y5ayWZTdwubAyJv/UMRnkypjIbhfwV8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=O3kUeYPk9zjFAyCcnGtwKCs5LI3sa5fmcW6x6bcGehSkaTD+Y9ktO8edB3xCPDvql
         U97wWaDI6+PTYWp4jcx/6ba7Uzi28rlehCRj7E0CTkv3FvDXpNsyOTisNVnEarnsUK
         y6oAbP3ah/Ayi2fQKlvwumPNrgD3GItCtJk3/eqs=
Received: from x230.qca.qualcomm.com (87-95-203-65.bb.dnainternet.fi [87.95.203.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E317B602F8;
        Mon, 11 Mar 2019 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552311146;
        bh=lt65+wzeNu71Y5ayWZTdwubAyJv/UMRnkypjIbhfwV8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Oi++AICrhBI5aZTvu6GI5p1dLszl5rWeq6uBsYvUycgwDOMgZOkHKT9zpb8Uu1nly
         kc1ihccXbRYYRc+83glHv7xYtGFRgB8LwyIeybZXsjGJmpy7pZm0uGrkLWNRIduU8w
         rjjBDdA/Uc636w3RTHxXqgb0kZdg+lAkt/nv+4u0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E317B602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     yhchuang@realtek.com, johannes@sipsolutions.net,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        briannorris@chromium.org
Subject: Re: [PATCH v7 01/14] rtw88: main files
References: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
        <1552139302-20476-2-git-send-email-yhchuang@realtek.com>
        <20190311131100.GA6482@redhat.com> <871s3da6yp.fsf@codeaurora.org>
        <20190311131939.GB6089@redhat.com>
Date:   Mon, 11 Mar 2019 15:32:21 +0200
In-Reply-To: <20190311131939.GB6089@redhat.com> (Stanislaw Gruszka's message
        of "Mon, 11 Mar 2019 14:19:40 +0100")
Message-ID: <87pnqx8rkq.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Mon, Mar 11, 2019 at 03:14:38PM +0200, Kalle Valo wrote:
>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> 
>> >> +#define RA_MASK_VHT_RATES_1SS	(0x3ff000 << 0)
>> >> +#define RA_MASK_VHT_RATES_2SS	(0x3ff000 << 10)
>> >> +#define RA_MASK_VHT_RATES_3SS	(0x3ff000 << 20)
>> >
>> > Result will not fit in 32 bit, ULL marker should be added.
>> 
>> I haven't checked how these are used but IMHO using GENMASK() would be
>> so much better.
>
> GENMASK_ULL() in this case :-)

Good point :)

-- 
Kalle Valo
