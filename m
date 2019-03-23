Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B40C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 06:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 916A2218B0
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 06:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hkhTY+fX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hkhTY+fX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfCWGkM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 02:40:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfCWGkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 02:40:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A61A560E75; Sat, 23 Mar 2019 06:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553323211;
        bh=jWtgSAJ85cqMSKVH5O5VAhvBHeO8f6YORAQANB7Ei+4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hkhTY+fXteeBcr04vjyS956EAyZGl4f+mcWFGG5RfCbQRLoM2r0Gb/gTZKyWI2reU
         4PYGNI4IkevN+nAXCg1yy/RyMxj5Q/WewcRhvDtPcbXe7XvIDyaQWE8qGeD/I7FK0U
         ZiDm/jJeg+2do65wg6Ytkjt+4wkK624NY30x3W2U=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 789BC60E75;
        Sat, 23 Mar 2019 06:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553323211;
        bh=jWtgSAJ85cqMSKVH5O5VAhvBHeO8f6YORAQANB7Ei+4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hkhTY+fXteeBcr04vjyS956EAyZGl4f+mcWFGG5RfCbQRLoM2r0Gb/gTZKyWI2reU
         4PYGNI4IkevN+nAXCg1yy/RyMxj5Q/WewcRhvDtPcbXe7XvIDyaQWE8qGeD/I7FK0U
         ZiDm/jJeg+2do65wg6Ytkjt+4wkK624NY30x3W2U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 789BC60E75
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: rtlwifi: fix a potential NULL pointer dereference
References: <20190312075633.573-1-kjlu@umn.edu>
        <AFBB09F8-46AE-4B74-BF53-1045814476B0@umn.edu>
Date:   Sat, 23 Mar 2019 08:40:07 +0200
In-Reply-To: <AFBB09F8-46AE-4B74-BF53-1045814476B0@umn.edu> (Kangjie Lu's
        message of "Fri, 22 Mar 2019 22:59:53 -0500")
Message-ID: <87mulmm6uw.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> writes:

>> On Mar 12, 2019, at 2:56 AM, Kangjie Lu <kjlu@umn.edu> wrote:
>> 
>> In case alloc_workqueue fails, the fix reports the error and
>> returns to avoid NULL pointer dereference.
>> 
>> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>> ---
>> drivers/net/wireless/realtek/rtlwifi/base.c | 5 +++++
>> 1 file changed, 5 insertions(+)
>> 
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c
>> b/drivers/net/wireless/realtek/rtlwifi/base.c
>> index 217d2a7a43c7..ac746c322554 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
>> @@ -448,6 +448,11 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
>> 	/* <2> work queue */
>> 	rtlpriv->works.hw = hw;
>> 	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
>> +	if (unlikely(!rtlpriv->works.rtl_wq)) {
>> +		pr_err("Failed to allocate work queue\n");
>> +		return;
>> +	}
>> +
>
> Can someone review the patch?

wireless-drivers-next is not yet open due to the wireless workshop. Also
you can check the patch status yourself:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
Kalle Valo
