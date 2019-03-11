Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C629BC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F2FE20657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YxHxXXGD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YxHxXXGD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfCKNOo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:14:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfCKNOo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:14:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9A690602F8; Mon, 11 Mar 2019 13:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552310083;
        bh=PP9jj9/XlC/znWxo2CQ46qahNq+PfFdQnu4lMDDjRv0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YxHxXXGDYSyJDLXAzDa2J2hO0MHf3GiMZWRYcDudMzgQWxr/CmnvCf1oPEFBmk2AB
         pAvr0M5N/SChPcJ+JrASNkKzjRYRGIUPu1ER4eCkB9fh7IBcZ76AtxaxGf9olIjKri
         P8F/9AiKgEo0A6YOMJz3nKi/M1Bit6eUfcdl3DHs=
Received: from x230.qca.qualcomm.com (87-95-203-65.bb.dnainternet.fi [87.95.203.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BEFF2602F8;
        Mon, 11 Mar 2019 13:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552310083;
        bh=PP9jj9/XlC/znWxo2CQ46qahNq+PfFdQnu4lMDDjRv0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YxHxXXGDYSyJDLXAzDa2J2hO0MHf3GiMZWRYcDudMzgQWxr/CmnvCf1oPEFBmk2AB
         pAvr0M5N/SChPcJ+JrASNkKzjRYRGIUPu1ER4eCkB9fh7IBcZ76AtxaxGf9olIjKri
         P8F/9AiKgEo0A6YOMJz3nKi/M1Bit6eUfcdl3DHs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BEFF2602F8
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
        <20190311131100.GA6482@redhat.com>
Date:   Mon, 11 Mar 2019 15:14:38 +0200
In-Reply-To: <20190311131100.GA6482@redhat.com> (Stanislaw Gruszka's message
        of "Mon, 11 Mar 2019 14:11:00 +0100")
Message-ID: <871s3da6yp.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

>> +#define RA_MASK_VHT_RATES_1SS	(0x3ff000 << 0)
>> +#define RA_MASK_VHT_RATES_2SS	(0x3ff000 << 10)
>> +#define RA_MASK_VHT_RATES_3SS	(0x3ff000 << 20)
>
> Result will not fit in 32 bit, ULL marker should be added.

I haven't checked how these are used but IMHO using GENMASK() would be
so much better.

-- 
Kalle Valo
