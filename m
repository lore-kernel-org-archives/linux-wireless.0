Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DB4C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 12:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7E4A2075B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 12:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wf7VLeKk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Csad5bij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfB0Mnb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:43:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35196 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727967AbfB0Mnb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 07:43:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1314A60767; Wed, 27 Feb 2019 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551271410;
        bh=lFVWMdxPlJ43qxhhnrjOj7s6Xke/IJ1+P0FITzM816E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wf7VLeKkOaCVQ8Iza+uJ0mUtcW0rn4A50+a58rQZJZHEdNF8j2Judm3LDx3UzyZUu
         QZO3MICV5ukP7cocfdPiUvLPKE+T6hEAhppeVmxE0JiAsA1NEd6UZdZUV/+kP0G0GH
         MgF89vj1oMs4oTE9buewwWa4lp+mG5bFB+oQrOj8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 56E7260767;
        Wed, 27 Feb 2019 12:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551271409;
        bh=lFVWMdxPlJ43qxhhnrjOj7s6Xke/IJ1+P0FITzM816E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Csad5bijxmsM64QwiGukGb4LwfzJX0x8GqTAhqR+1RFy2RzFJxtosIKtCyj/ukhSh
         gwoxIEVLebYFZ+5S7+d9bRmjrqjarh0ygttWJVvGaspyJg3fOwRX7eg9A6tfw2Fyof
         CnIpNtoP/9sV4rmT1C6v6+eCA0bnDlKfbeUgMXHk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 27 Feb 2019 18:13:29 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 8/9] ath10k: Add new api to support TID specific
 configuration
In-Reply-To: <20190226123058.yu5brtbu4euwbzxx@bars>
References: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
 <1550813554-11581-9-git-send-email-tamizhr@codeaurora.org>
 <20190226123058.yu5brtbu4euwbzxx@bars>
Message-ID: <eab54b79f171e76e1e1fe7784e98d8ce@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sergey,

>> This patch add ops for set_tid_config to support TID
>> specific configuration. STA information along with the
>> TID config change mask to notify driver that which configuration
>> needs to be applied for this current command.
>> If the STA info not available in the command then the
>> configuration will be applied for all connected stations
>> in the vif. TID specific noack configuration requires
>> aggregation disabled and rate for the data TID packets
>> should be basic rates. So, if the TID already configured
>> with noack policy then driver will ignore the aggregation
>> or TX rate related configuration for the same data TID.
>> In TX rate configuration should be applied with highest
>> preamble configuration(HT rates should not be applied
>> for the station which supports vht rates).
>> 
>> Vif specific TID configuration will be applied for all
>> the connected stations except for the station which
>> already applied with the same configuration for the TID
>> through station specific command. Newly connecting stations
>> will be applied with vif TID configuration which will be stored
>> in ieee80211_vif.
>> 
>> Testing:
>>         * Tested HW: QCA9888
>>         * Tested FW: 10.4-3.5.1-00052
>> 
>> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/core.h |   7 +
>>  drivers/net/wireless/ath/ath10k/mac.c  | 602 
>> ++++++++++++++++++++++++++++-----
>>  2 files changed, 529 insertions(+), 80 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h 
>> b/drivers/net/wireless/ath/ath10k/core.h
>> index 27ec555..c25c426 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -82,6 +82,9 @@
>>  /* Default Airtime weight multipler (Tuned for multiclient 
>> performance) */
>>  #define ATH10K_AIRTIME_WEIGHT_MULTIPLIER  4
>> 
>> +#define ATH10K_MAX_RETRY_COUNT 30
>> +#define ATH10K_MAX_TIDS        8
> 
> Is there any reason why you don't use IEEE80211_TID_MAX here ?
> 
Thanks for pointing this one. Somehow I missed it. I will reuse this 
instead ATH10K_MAX_TIDS in the next patchset.

Thanks,
Tamizh.
