Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0585FC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 14:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F6C20871
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 14:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n9DqNr38";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n9DqNr38"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4F6C20871
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbeKKXqf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 18:46:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45802 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbeKKXqf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 18:46:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9FDC260710; Sun, 11 Nov 2018 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541944676;
        bh=c9UxdVnBjcBhumBTou1FwQJ3b4F6xnDO03VsBX5qoug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n9DqNr386NBxp//Yzj09/kQoCzLmUx/3XJxTFZh0+4jT/od49KshWgW7KMtsAOhCh
         AKrUSqpuAANvgtQ/GcsiIYtTxN4qlSUPGvGP7fyvoIGxhFa2xeHve2BW7WVT4G0bhk
         BKkhRFFnnT7PjPBDA+qeXB5xXJMZUZ8bI0G/0zO4=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 4674460710;
        Sun, 11 Nov 2018 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541944676;
        bh=c9UxdVnBjcBhumBTou1FwQJ3b4F6xnDO03VsBX5qoug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n9DqNr386NBxp//Yzj09/kQoCzLmUx/3XJxTFZh0+4jT/od49KshWgW7KMtsAOhCh
         AKrUSqpuAANvgtQ/GcsiIYtTxN4qlSUPGvGP7fyvoIGxhFa2xeHve2BW7WVT4G0bhk
         BKkhRFFnnT7PjPBDA+qeXB5xXJMZUZ8bI0G/0zO4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 11 Nov 2018 19:27:56 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] mac80211: Implement API to configure station specific
 rssi threshold
In-Reply-To: <f1c8ce7daf62c60197da9cc62d550fdc1cac6303.camel@sipsolutions.net>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
 <1539626250-769-3-git-send-email-tamizhr@codeaurora.org>
 <f1c8ce7daf62c60197da9cc62d550fdc1cac6303.camel@sipsolutions.net>
Message-ID: <f3c8d129a8b7dea76febbb5a5adee113@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-09 17:19, Johannes Berg wrote:
> On Mon, 2018-10-15 at 23:27 +0530, Tamizh chelvam wrote:
>> 
>> +		sta_mon_rssi_config_free(sta);
>> +		sta->rssi_hyst = rssi_hyst;
>> +		if (fixed_thold) {
>> +			if (n_rssi_tholds > 2) {
>> +				ret = -EINVAL;
>> +				goto out;
>> +			}
> 
> This might be slightly wrong, you free and then can still return an
> error.
> 
Sure. I'll move the free part after the validation check.

>> +			if (n_rssi_tholds == 1) {
>> +				sta->rssi_low = rssi_tholds[0];
>> +				sta->rssi_high = rssi_tholds[0];
>> +			} else {
>> +				sta->rssi_low = rssi_tholds[0];
>> +				sta->rssi_high = rssi_tholds[1];
>> +			}
>> +		} else {
>> +			const s32 *rssi_tholds;
>> +
>> +			rssi_tholds = kmemdup(rssi_tholds,
>> +					      n_rssi_tholds * sizeof(s32),
>> +					      GFP_KERNEL);
>> +			if (!rssi_tholds) {
>> +				ret = -ENOMEM;
>> +				goto out;
>> +			}
> 
> Similarly here, I guess you should do the allocation (and other error
> checking) before freeing.
> 
ditto, Sure. I'll move the free part after the validation check.

>> +			sta->rssi_tholds = rssi_tholds;
>> +			sta->n_rssi_tholds = n_rssi_tholds;
>> +			ieee80211_update_rssi_config(sta);
> 
> 
> 
>> +struct sta_mon_rssi_config {
>> +};
> 
> Huh?
> 
oops:( I have kept all configuring parameters in sta_info itself, 
mistakenly didn't remove this struct:(
> 
> The commit log also makes it sounds like mac80211 actually *supports*
> this, but clearly that's not the case. However you don't give any data
> to the driver either, did you lose a patch along the way? Previously 
> you
> had patch 5 ("mac80211: Implement functionality to monitor station's
> rssi cross event") and if I remember correctly I said you should squash
> some, but now that's not here?
> 

Thanks,
Tamizh.
