Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D92BC282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45AA3218B0
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PQYOcEW0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PQYOcEW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfBGJKK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:10:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfBGJKK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 04:10:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 90708607F4; Thu,  7 Feb 2019 09:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549530609;
        bh=ijna64S13BIR+2xf/ZgtuhbTtbk5hAUKyvcKJDkOO1Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PQYOcEW0MyFuohshvSLEFYiaiDVjvhQnANoW0WqxZl4jQB59DdeEkEWhhkYwyt9mF
         YmujIAQNRaFmDNA11URVL+uhAwP1hjJIAzIJcqhZGgC5Yx3f9P9/gX5QCLNhBAsVZh
         fnkd+S4V+27AvAkbUMsnA7nWcLRVTUzB46ZyZqtY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D1936055C;
        Thu,  7 Feb 2019 09:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549530609;
        bh=ijna64S13BIR+2xf/ZgtuhbTtbk5hAUKyvcKJDkOO1Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PQYOcEW0MyFuohshvSLEFYiaiDVjvhQnANoW0WqxZl4jQB59DdeEkEWhhkYwyt9mF
         YmujIAQNRaFmDNA11URVL+uhAwP1hjJIAzIJcqhZGgC5Yx3f9P9/gX5QCLNhBAsVZh
         fnkd+S4V+27AvAkbUMsnA7nWcLRVTUzB46ZyZqtY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4D1936055C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Add a condtion to fill the LDPC capability correctly
References: <1548999262-25353-1-git-send-email-svishnoi@codeaurora.org>
        <877eefefh3.fsf@kamboji.qca.qualcomm.com>
        <b14e2139c794201664a49d36cc28ab48@codeaurora.org>
Date:   Thu, 07 Feb 2019 11:10:06 +0200
In-Reply-To: <b14e2139c794201664a49d36cc28ab48@codeaurora.org> (Surabhi
        Vishnoi's message of "Wed, 06 Feb 2019 19:21:41 +0530")
Message-ID: <87lg2s9d75.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ lists

Surabhi Vishnoi <svishnoi@codeaurora.org> writes:

> On 2019-02-04 21:02, Kalle Valo wrote:
>> Surabhi Vishnoi <svishnoi@codeaurora.org> writes:
>>
>>> The firmware advertises the LDPC support information for HT in
>>> HT capability info in the wmi service ready event. To provide
>>> granularity, firmware now advertises WMI_HT_CAP_RX_LDPC and
>>> WMI_HT_CAP_TX_LDPC separately. To support LDPC, host should
>>> also check for WMI_HT_CAP_RX_LDPC and WMI_HT_CAP_TX_LDPC in HT
>>> capabilities.
>>>
>>> Add a condition to existing logic in host to know whether firmware
>>> supports LDPC or not.
>>>
>>> Tested HW: WCN3990
>>> Tested SW: WLAN.HL.2.0
>>
>> Can you give exact firmware version you tested, please? I'll add it to
>> the commit log.
>>
>> I'll also fix the typo "condtion" in the title.
>
>
> Hi Kalle,
>
> The Fw version tested are:
> Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1,
> WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1

Thanks. But please do not drop the lists, otherwise patchwork won't see
this.

-- 
Kalle Valo
