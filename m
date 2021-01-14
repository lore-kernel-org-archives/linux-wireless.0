Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A361C433E9
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Jan 2021 17:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59D523B31
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Jan 2021 17:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbhANR0g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Jan 2021 12:26:36 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:52468 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728957AbhANR0f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jan 2021 12:26:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610645175; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=XM1YMfBnE8uyWCbYGW+mzahVhM+v5GtXtGEBuN14Zpo=;
 b=mjFBaAgjDVnT8cW2GvK2MF7m5u4RRYFwpPG+RKT68IgbAU7E71SQu3gdNerobho/4EG7uyUQ
 YdiKvoYrZ6EIXeUkZtnFbD1IuEQ+0OFJ3ietdQNHXL5Hc9yPeHofTtEMq8Zovnd3uvEW2XaE
 gZpwizfmzthT9t6IQeibtzqhqn8=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60007e91d84bad3547b046b9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 17:25:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 84AF2C433ED; Thu, 14 Jan 2021 17:25:37 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FB97C433CA;
        Thu, 14 Jan 2021 17:25:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FB97C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless -next] rtw88: Delete useless kfree code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201216130442.13869-1-zhengyongjun3@huawei.com>
References: <20201216130442.13869-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <tony0620emma@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114172537.84AF2C433ED@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 17:25:37 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> wrote:

> The parameter of kfree function is NULL, so kfree code is useless, delete it.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

8873e8f56f74 rtw88: Delete useless kfree code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201216130442.13869-1-zhengyongjun3@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

