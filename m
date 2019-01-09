Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5E1C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 15:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEE8E206BA
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 15:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S8GLL8FH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jJZmqFjP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbfAIPft (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 10:35:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60580 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729829AbfAIPfs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 10:35:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 048576079B; Wed,  9 Jan 2019 15:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547048148;
        bh=pL/3QeFf79x1FwKqTOvz6TZoikm2yMSmRYKvtVNLmbc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S8GLL8FHc1IYCs2Lgpk9se+4NrwlORFFggJhk5qrm5LNVZBiYLTwrT8RWz7DR3oIG
         O6L+12T9pUhhQlXsvd3GFm1A/mmD8GsAr8UD8iN+Gwo8DfM+26zf7AwiLZotU5Y/LB
         aTQqCO9GlzzCenrM6zcucGuib2j0ypHCtRQFA4WM=
Received: from x230.qca.qualcomm.com (87-93-131-103.bb.dnainternet.fi [87.93.131.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2980660300;
        Wed,  9 Jan 2019 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547048147;
        bh=pL/3QeFf79x1FwKqTOvz6TZoikm2yMSmRYKvtVNLmbc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jJZmqFjPoW1iLM9LqiLmVbHzgi83Y/IJ9Uo08AJJwTi0lgbso+OZqZH2cW68kdTTy
         26TYNQo0kdiujWD+iU1JEoTL0PXtjOpSxlNj1IxBwfe94W4Nbdhg41z/GgkTcW5KzG
         yBe22XCOPacYafVDf2AVkudPl+9jr3n5kpR+FJrM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2980660300
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Rakesh Parmar <rakeshp@marvell.com>, James Cao <jcao@marvell.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Not able to see patches in patchwork
References: <CY4PR18MB12372AF071013F01A0DE6A32A08A0@CY4PR18MB1237.namprd18.prod.outlook.com>
        <87ef9nqdea.fsf@kamboji.qca.qualcomm.com>
        <CY4PR18MB1237311E8A5B1D719BB48EB5A08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
Date:   Wed, 09 Jan 2019 17:35:43 +0200
In-Reply-To: <CY4PR18MB1237311E8A5B1D719BB48EB5A08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
        (Ganapathi Bhat's message of "Wed, 9 Jan 2019 15:01:39 +0000")
Message-ID: <87imyxdesw.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ganapathi Bhat <gbhat@marvell.com> writes:

>> Ganapathi Bhat <gbhat@marvell.com> writes:
>> 
>> > I am not able to see the patch sent to
>> > 'linux-wireless.vger.kernel.org', in
>> > https://patchwork.kernel.org/project/linux-wireless/list/
>> >
>> > Let me know if you received my patch, named "mwifiex: add support for
>> > sd8977 chipset"
>> 
>> When did you submit it?
>
> I did submit it couple of weeks before, using 'git send-mail' utility.
>
>> I don't see such email on linux-wireless list. 
>> I  recommend resubmitting the patch as v2.
>
> Ok. I have sent v2 using my GUI mail client. Now we could see in the linux-wireless list.

I can confirm, I also see the patch now:

https://patchwork.kernel.org/patch/10754283/


-- 
Kalle Valo
