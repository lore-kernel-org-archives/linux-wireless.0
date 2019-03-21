Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9618C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 12:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 757AB218A1
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 12:54:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SxdhWmsv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d7qD6eLP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfCUMyV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 08:54:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55364 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfCUMyV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 08:54:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DC8A360907; Thu, 21 Mar 2019 12:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553172860;
        bh=hXKe1JxGYtQWPyY7F/Z4ULOJ/vzyqPPpzXvBPAXNu24=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SxdhWmsvjKz59Ymop7LqldyP3lEpjzw8FUNrpPsldQ0hyjge9tmsPBnBS23hwzRV/
         jvOz3M2Hni4EnYa+jDuRebUJD/OfNASr6lwKZLRjYqcp5PiIYsw+QHjrotULE9Oikg
         O8PryjB3fytXtgxyhcIjR2IO/UbzVqq7C3S5WwJU=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9F2256034E;
        Thu, 21 Mar 2019 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553172859;
        bh=hXKe1JxGYtQWPyY7F/Z4ULOJ/vzyqPPpzXvBPAXNu24=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=d7qD6eLP8gixcHVgjYZ5uVcYUbHxo+bw0wANaclfWw4bq+ZT+TrKCBz1/iUvDj3VW
         lh1jgQfBfIm+81xxJl0HMDxdQ+Igeq/MMZ3jJPnKr1JulFgjezLLlX34Em3pvS1mbD
         OaswMh3f8xRrMFDBkHzyzUr/dpw/z1tEDidA/odo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9F2256034E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        <gregkh@linuxfoundation.org>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 00/16] wilc1000: move out of staging
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
        <5ac9d9bb-08e4-c46f-ce0a-40630e1d958e@microchip.com>
Date:   Thu, 21 Mar 2019 14:54:15 +0200
In-Reply-To: <5ac9d9bb-08e4-c46f-ce0a-40630e1d958e@microchip.com> (Ajay
        Kathat's message of "Thu, 21 Mar 2019 12:49:22 +0000")
Message-ID: <871s30pevc.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Ajay.Kathat@microchip.com> writes:

> Hi Kalle/Johannes,
>
> On 2/9/2019 12:42 PM, Ajay Kathat - I15481 wrote:
>> From: Ajay Singh <ajay.kathat@microchip.com>
>> 
>> This patch series is to review and move wilc1000 driver out of staging.
>> Implemented the initial received review comments[1] and submitting the
>> driver again. During this cleanup deleted around 3.3k lines of code.
>> 
>> Below are the major items fixed in recent cleanup:
>>  - remove use of shadow buffer to keep scan result.
>>  - remove internal messaging flow to handle cfg80211_ops.
>>  - make use of cfg80211 provided API.
>>  - use structure for packing firmware commands.
>>  - make use of kernel provided API and macros.
>>  - remove unnecessary logs messages.
>> 
>> Pending action item:
>>  - dynamically add/remove p2p interface.
>> 
>>  This item will take some time, we are planning to take it up after
>>  mainline.
>> 
>>  We hope it can be move out staging in v5.1.
>>  Please review and confirm if it is good to move out.
>
> Do you have any update for this series. Please provide your inputs for
> next step.

rtw88 is taking priority in the new drivers "queue" so I doubt I can
take a look at this in the next few weeks.

-- 
Kalle Valo
