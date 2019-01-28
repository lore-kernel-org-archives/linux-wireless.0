Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1261C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 07:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7065C20881
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 07:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kfHJhHN+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SH1hYwrk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfA1HBx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 02:01:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60772 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfA1HBx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 02:01:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 561E160DA8; Mon, 28 Jan 2019 07:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548658912;
        bh=tTaYV7heWr4qAW3neK3p51ucxl/71vKCLNeqeIMU4zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kfHJhHN+z/fZkAOn0LKnkUoalhHWCZaSseppwvH0QHl3Yu+ajvZqgi2AJeF972ood
         zveN28hxAYNhUviQkmmagn/YDPiaoVGgDEISiCrm7K1JQIRD7a469paZc0P8o1WBEA
         Ed1geKw96EI4JtQBS7MyPa+XMlUVrq99gJMv7jok=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 64E0860DA8;
        Mon, 28 Jan 2019 07:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548658910;
        bh=tTaYV7heWr4qAW3neK3p51ucxl/71vKCLNeqeIMU4zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SH1hYwrktDraVK2KBTvFTtlB7BLPM2+uypoIQdSOSvTY8jbzw+UKe/X5XD+tIMK8A
         kO+cMIclvPrWHw666WPDdxzGbGuHCah0yce8bTulFYS+s86qI4iLgiOZFs4Of4dh/A
         /VCXYO5Oqaap+DgjlAAPP46P8jk3IXkYz5/IVgIw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Jan 2019 15:01:50 +0800
From:   yiboz <yiboz@codeaurora.org>
To:     kvalo@qca.qualcomm.com
Cc:     erik.stromdahl@gmail.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: FW: [PATCH] ath10k: fix return value check in wake_tx_q op
In-Reply-To: <c77a1c0961f34ee68b7266444d2207f5@aptaiexm02e.ap.qualcomm.com>
References: <20180506132500.16888-1-erik.stromdahl@gmail.com>
 <6dc00772b826410e930306891fd13ed9@euamsexm01f.eu.qualcomm.com>
 <c77a1c0961f34ee68b7266444d2207f5@aptaiexm02e.ap.qualcomm.com>
Message-ID: <66a74025a23795f305de37989c1b8aa3@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Erik,

We have met performance issue on our two-core system after applying your 
patch. In WDS mode, we found that the peak throughput in TCP-DL and 
UDP-DL dropped more than 10% compared with previous one. And in some 
cases, though throughput stays the same, one CPU usage rises about 20% 
which leads to 10% in total CPU usage. With your change, I think driver 
will try its best to push as many packets as it can. During this time, 
the driver's queue lock will be held for too much time in one CPU and as 
a result, the other CPU will be blocked if it wants to acquired the same 
lock. Working in this way seems not efficiency.

So I think it is better to revert the change till we come up with a new 
solution.

>>  Subject: [PATCH] ath10k: fix return value check in wake_tx_q op
>> 
>>  ath10k_mac_tx_push_txq returns either a postive integer (length) on 
>> success
>>  or a negative error code on error.
>> 
>>  The "if (ret) break;" statement will thus always break out of the 
>> loop
>>  immediately after ath10k_mac_tx_push_txq has returned (making the 
>> loop
>>  pointless).
>> 
>>  A side effect of this fix is that we will iterate the queue until
>>  ath10k_mac_tx_push_txq returns -ENOENT. This will make sure the queue 
>> is
>>  not added back to ar->txqs when it is empty. This could potentially 
>> improve
>>  performance somewhat (I have seen a small improvement with SDIO 
>> devices).
>> 
>>  Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>  ---
>>   drivers/net/wireless/ath/ath10k/mac.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>>  diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>>  b/drivers/net/wireless/ath/ath10k/mac.c
>>  index 3d7119ad7c7a..487a7a7380fd 100644
>>  --- a/drivers/net/wireless/ath/ath10k/mac.c
>>  +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>  @@ -4290,7 +4290,7 @@ static void ath10k_mac_op_wake_tx_queue(struct
>>  ieee80211_hw *hw,
>> 
>>   	while (ath10k_mac_tx_can_push(hw, f_txq) && max--) {
>>   		ret = ath10k_mac_tx_push_txq(hw, f_txq);
>>  -		if (ret)
>>  +		if (ret < 0)
>>   			break;
>>   	}
>>   	if (ret != -ENOENT)
>>  --
>>  2.17.0

-- 
yibo
