Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B319C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 628DA20825
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P6Mko4gg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eNXKuCw0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 628DA20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbeKEUiN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 15:38:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbeKEUiM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 15:38:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BF41960741; Mon,  5 Nov 2018 11:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416739;
        bh=TrTfBc/YVajTFeR/nTTqQXv7h4iVdWhYWn6OkzmkAWA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=P6Mko4ggNM0MPvdXaZJdILoret4WZiKLcWusB8/OExbb3wheaDtJsFsENBnnTnimc
         pATPLifoTK4n6FlJJkbZLpv8aMgTPxBNsdUqY9qlNHqL0871h17lG+/ckDaGIMPVIb
         Zv6fsanIpIRnW603BxFdQVUGjxD8JYE4Ox1+KX1U=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2CC1260247;
        Mon,  5 Nov 2018 11:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541416739;
        bh=TrTfBc/YVajTFeR/nTTqQXv7h4iVdWhYWn6OkzmkAWA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eNXKuCw0Ohyh7kAT2JPTqJhpH17XYE8xwPTn6yKGpZBlvoA127N3AOAsZutVrGEAH
         zqzsMFaT5zkH035JmTSOEnpdp/gnI5qHKyfzjH4KG/kPGmH4Jd1am0mSzzHG+HkFXd
         4ygICY8Z9JJUEYO6pp+EP3HsUlWE2pCdIM9jI+pM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2CC1260247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: remove set but not used variable 'new_flags'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1540265234-58050-1-git-send-email-zhongjiang@huawei.com>
References: <1540265234-58050-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105111859.BF41960741@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 11:18:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> new_flags is not used after setting its value. It is safe to remove
> the unused variable.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

53d76f1687ba ath9k: remove set but not used variable 'new_flags'

-- 
https://patchwork.kernel.org/patch/10652679/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

