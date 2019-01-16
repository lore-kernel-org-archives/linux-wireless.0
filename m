Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D36BC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629082082F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:09:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WvYkJq4x";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WvYkJq4x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405165AbfAPQJt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:09:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52308 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfAPQJs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 11:09:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E15E3607CA; Wed, 16 Jan 2019 16:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547654987;
        bh=yM48XHJ0z+2xCKDJGRqIX+6I6NIZW06wf1tsQT1MKtc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WvYkJq4xe1lZT2ge07FnF/TAMk1KvJ2LgN180YrPRYBJ+ZFprDh5SYCkG10Cp0Qh2
         pO9GZ8wx0Rm7T1xTOSEXMUI1nXE5sC844uxdGelUibErPQAF00weoKExAOhwr1HRy8
         u6AK+jLcSnFTc71EkAC5FkPg0bN1z7dnKsqnYsZM=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7AECD6024C;
        Wed, 16 Jan 2019 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547654987;
        bh=yM48XHJ0z+2xCKDJGRqIX+6I6NIZW06wf1tsQT1MKtc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WvYkJq4xe1lZT2ge07FnF/TAMk1KvJ2LgN180YrPRYBJ+ZFprDh5SYCkG10Cp0Qh2
         pO9GZ8wx0Rm7T1xTOSEXMUI1nXE5sC844uxdGelUibErPQAF00weoKExAOhwr1HRy8
         u6AK+jLcSnFTc71EkAC5FkPg0bN1z7dnKsqnYsZM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7AECD6024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] mac80211-next: remove set but not used variable 'w_priv'
References: <1545274318-144187-1-git-send-email-yuehaibing@huawei.com>
        <65a8caf2-98c0-cf43-f63b-d89ed556111f@huawei.com>
Date:   Wed, 16 Jan 2019 18:09:44 +0200
In-Reply-To: <65a8caf2-98c0-cf43-f63b-d89ed556111f@huawei.com>
        (yuehaibing@huawei.com's message of "Wed, 16 Jan 2019 20:24:23 +0800")
Message-ID: <87r2dc4m9j.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> writes:

> ping...
>
> On 2018/12/20 10:51, YueHaibing wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>> 
>> drivers/net/wireless/virt_wifi.c: In function 'virt_wifi_net_device_stop':
>> drivers/net/wireless/virt_wifi.c:432:31: warning:
>>  variable 'w_priv' set but not used [-Wunused-but-set-variable]
>> 
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Same here, the prefix should be "virt_wifi:".

-- 
Kalle Valo
