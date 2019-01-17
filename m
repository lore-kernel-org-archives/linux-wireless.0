Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54123C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 06:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D1E120657
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 06:50:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VrpLbHAY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DDDB3QDD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfAQGuz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 01:50:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51948 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfAQGuz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 01:50:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 97AE4604B4; Thu, 17 Jan 2019 06:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547707854;
        bh=wfQVS7uPB4VwPjCmn+kIsJKOAE/qWlU2Wp8lDYZOKss=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VrpLbHAY5EKnv9u+Ol3OdUe7NhDMIrgLPtnyAFtijhpXM8sm+X/c+yUatTal/8JYL
         dKSlYOB0iFRZieIsBuX9/vvPsSGg7VKnY+1Liaqhl3PYT5j28oSrVKeX7eLpTnRxKM
         cD26Njp9aL9DX8eplE2QgNEJTqofAzSDd3O/Gwb0=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BB4A9604B4;
        Thu, 17 Jan 2019 06:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547707853;
        bh=wfQVS7uPB4VwPjCmn+kIsJKOAE/qWlU2Wp8lDYZOKss=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DDDB3QDDr7aS6zuVzyHbgnHMZeQftL90A8BOFq/ngZI38Rue4G0FOtFW0j6HSuPEP
         8q9Mme2ByH8ZICXHt4kgVNyy5yn0lRyIgEv5DryqVksFBvw/pZQukk2w7ICTE7Co5j
         IKplVqvLzAJZVHAqmX3dps0kzwchLQtDCHLM+6xI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BB4A9604B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     Seth Forshee <seth.forshee@canonical.com>,
        wireless-regdb@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: update 60ghz band rules for us
References: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
        <CABPxzYK+Tu678C=84i3+67gA1EBw_pG3cJ1y1ZvWZobU6iS8Dg@mail.gmail.com>
Date:   Thu, 17 Jan 2019 08:50:49 +0200
In-Reply-To: <CABPxzYK+Tu678C=84i3+67gA1EBw_pG3cJ1y1ZvWZobU6iS8Dg@mail.gmail.com>
        (Krishna Chaitanya's message of "Wed, 16 Jan 2019 14:09:05 +0530")
Message-ID: <87lg3j6aly.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Krishna Chaitanya <chaitanya.mgit@gmail.com> writes:

> On Tue, Dec 18, 2018 at 1:38 PM <chaitanya.mgit@gmail.com> wrote:
>>
>> From: Chaitanya Tata <Chaitanya.Mgit@gmail.com>
>>
>> Include channels 4, 5 & 6 for US in 60GHz band. FCC extended the
>> 57-64GHz band till 71GHz with almost same rules.
>> ---
>>  db.txt | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/db.txt b/db.txt
>> index fa5c0e0..ae650dd 100644
>> --- a/db.txt
>> +++ b/db.txt
>> @@ -1280,9 +1280,9 @@ country US: DFS-FCC
>>         (5490 - 5730 @ 160), (23), DFS
>>         (5735 - 5835 @ 80), (30)
>>         # 60g band
>> -       # reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
>> -       # channels 1,2,3, EIRP=40dBm(43dBm peak)
>> -       (57240 - 63720 @ 2160), (40)
>> +       # reference: section IV-D https://docs.fcc.gov/public/attachments/FCC-16-89A1.pdf
>> +       # channels 1-6 EIRP=40dBm(43dBm peak)
>> +       (57240 - 71000 @ 2160), (40)
>>
>>  country UY: DFS-FCC
>>         (2402 - 2482 @ 40), (20)
>>
> Kalle/Seth,
>
> Any update on this? Patchwork shows its delegated to you(may be by default).

Seth doesn't use patchwork so I just delegate regdb patches to myself
and then mark them as 'Not Applicaple'.

-- 
Kalle Valo
