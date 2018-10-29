Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3889BC0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6E1920657
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:56:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T0sgtnMF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HM6q3WKZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6E1920657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbeJ2XpP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 19:45:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49040 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbeJ2XpP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 19:45:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 310F8602BD; Mon, 29 Oct 2018 14:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540824976;
        bh=Pq1b7QRDSf3ZY8Cdnh+3LrICxWodgp6OgNBvW/ekfzs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=T0sgtnMF/AAn4ITROhc+nsiluQl2IVvtWuHWNmDdRgnHUE/ysGxppzOLJbZAflI5H
         cB3zrC13vX3Xd0pgtGfjZC8BhFY6F9ZafOInqd2RW+VZBzcmgWzrlKVm3jSbMo37P8
         kSPsLv6A2NZuYxtkwtGHq/7Stji9BN5T5pzL2QjM=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA5F160159;
        Mon, 29 Oct 2018 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540824975;
        bh=Pq1b7QRDSf3ZY8Cdnh+3LrICxWodgp6OgNBvW/ekfzs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HM6q3WKZ/ukJkDAN9nnoB+aYVcwnglnXfNwP3XUwYBbWJAnKmMdS0hATzdgY76Lr6
         UREOwwimmrSARCVl0o3YCVCmrePQDFla/KtAagOpH+ohKqTyZqqP+pQ+LhpwWADQqO
         O+Xh/ONDCoUDzBdl9sqEvC/pC89JbYpmxAbalg9c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA5F160159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
In-Reply-To: <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com> (Ajay
        Singh's message of "Tue, 9 Oct 2018 17:14:23 +0530")
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
        <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
        <1539008417.3687.57.camel@sipsolutions.net>
        <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
        <1539081379.3687.112.camel@sipsolutions.net>
        <1d77cb4d-92c9-0ea4-bdd3-f16a2421406f@microchip.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
Date:   Mon, 29 Oct 2018 16:56:10 +0200
Message-ID: <87r2g8er91.fsf@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ajay Singh <ajay.kathat@microchip.com> writes:

> On 10/9/2018 4:06 PM, Johannes Berg wrote:
>> On Tue, 2018-10-09 at 16:04 +0530, Ajay Singh wrote:
>>
>>>>> +typedef void (*wilc_remain_on_chan_expired)(void *, u32);
>>>>> +typedef void (*wilc_remain_on_chan_ready)(void *);
>>> I think as per coding style the typedef for function pointer are allowed.
>> True, I guess, but why do you need them?
>
> Actually these function pointer are used in multiple places i.e inside
> the struct and also for passing as the argument for the function. So i
> think its better to keep them as typedef to simplify and avoid any 'line
> over 80 chars' checkpatch issue. But anyway if you suggest we can modify
> to remove these typedefs .

Please remove them, they just make the code harder to read.

-- 
Kalle Valo
