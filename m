Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB9CC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4B6B205C9
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:09:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G9qdeRlW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F5xvb3g8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405117AbfAPQJ0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:09:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfAPQJZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 11:09:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E874960591; Wed, 16 Jan 2019 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547654964;
        bh=J9RjZg1TmoTi4tdJYxsOyvSggHdaCf6uwJwMlJOWfsE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=G9qdeRlW+oVLlIvjB2qbPLfNowRsfiGhrvvbL662rDElzgGP2PsobDn1142bwPmeS
         DAJWQlPNrh4ssQWlh8n8z8fUswHKh1VEqZ7Y6xfJxRA5JKcMTnWcZQjuXLvsT4lRzG
         b6GHLDaEC63WUKKaL6fVXL6boSwz36c6x/8bUw9w=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 754626024C;
        Wed, 16 Jan 2019 16:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547654963;
        bh=J9RjZg1TmoTi4tdJYxsOyvSggHdaCf6uwJwMlJOWfsE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=F5xvb3g8mllLXGWsm5JLRJffS7iULHM67hVTkxbvIxwwvakLylNIuEaIjMhMt9qGp
         YFM2AWoHcYfsQ6HXaCbaZbvgs/og30fhu3Yt7YXy4zgFnbrh+vbVctha0E+qOm9hpb
         uoOwFTOiQJzpzCih5gJ4G4YEAgxDf7g0fueKEcrw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 754626024C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] mac80211-next: remove duplicated include from virt_wifi.c
References: <1545274285-143886-1-git-send-email-yuehaibing@huawei.com>
        <cfdac00b-ea9a-1805-4668-64e44c523f6d@huawei.com>
Date:   Wed, 16 Jan 2019 18:09:20 +0200
In-Reply-To: <cfdac00b-ea9a-1805-4668-64e44c523f6d@huawei.com>
        (yuehaibing@huawei.com's message of "Wed, 16 Jan 2019 20:24:48 +0800")
Message-ID: <87va2o4ma7.fsf@codeaurora.org>
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
>> Remove duplicated include.
>> 
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/net/wireless/virt_wifi.c | 5 -----
>>  1 file changed, 5 deletions(-)

BTW, the prefix should be "virt_wifi:".

-- 
Kalle Valo
