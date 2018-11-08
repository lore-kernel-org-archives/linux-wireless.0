Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172ABC32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 12:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2C1420818
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 12:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lywDdH/0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aog+HaXt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2C1420818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbeKHWSK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 17:18:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbeKHWSJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 17:18:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 955266085F; Thu,  8 Nov 2018 12:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541680970;
        bh=S/vFTwQgI/cVeiDCU9eDpkbffI2xUPM+RDibZ2xf0XY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lywDdH/00Sy/OhkTdPoUsPGAzvEHkJOSojn6Smyh3upxJbpwcsFl+Akqx3twxFdx5
         wGwjcFf0HHWA5Tf4qsxmYUxF+QRJ1wC7k0U0EHTft3yldHqcVOBoqqVv9B94tVrdKc
         fdGJGR37p+du4Coy+vcJeqMZRCYdcf/wR9aimE0w=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 897C260591;
        Thu,  8 Nov 2018 12:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541680969;
        bh=S/vFTwQgI/cVeiDCU9eDpkbffI2xUPM+RDibZ2xf0XY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aog+HaXtLBP5NDHEbt0n5BFsavTUqthGVERRt/aCsbaBXM0a9bEcK6BXyVvDAcz0r
         /icvh4bWwcA2xOJez2oRCvnr/r2oIErIv29AFdlEtEM9j6KOToIs9obCsmjsUuppoh
         eH/SKBJEjEIMdYc0u1tkeZYYEbv3gCW11xcWZo8A=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 08 Nov 2018 18:12:49 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     ath10k@lists.infradead.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] mac80211: Add api to support configuring TID specific
 configuration
In-Reply-To: <20181106103325.5phrwo2pv2rc26pd@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-4-git-send-email-tamizhr@codeaurora.org>
 <20181106103325.5phrwo2pv2rc26pd@bars>
Message-ID: <a6161336017a59081c24f86a17fee014@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-06 16:03, Sergey Matyukevich wrote:
>> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
>> ---
>>  include/net/mac80211.h    |   40 +++++++++++++++++++++++++
>>  net/mac80211/cfg.c        |   71 
>> +++++++++++++++++++++++++++++++++++++++++++++
>>  net/mac80211/driver-ops.h |   16 ++++++++++
>>  net/mac80211/trace.h      |   34 ++++++++++++++++++++++
>>  4 files changed, 161 insertions(+)
>> 
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index b6cc3e33..7fa7e25 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -1478,6 +1478,35 @@ struct ieee80211_channel_switch {
>>         u8 count;
>>  };
>> 
>> +/*
>> + * enum ieee80211_tid_conf_change - TID change configuration 
>> notification flags
>> + *
>> + * These flags are used with the set_tid_conf() callback
>> + * to indicate which TID configuration parameter changed.
>> + *
>> + * @TID_RETRY_CONF_CHANGED: retry configuration changed.
>> + * @TID_AGGR_CONF_CHANGED: Aggregation config changed for the TID.
>> + */
>> +enum ieee80211_tid_conf_change {
>> +       TID_RETRY_CONF_CHANGED          = BIT(0),
>> +       TID_AGGR_CONF_CHANGED           = BIT(1),
>> +};
> 
> Following your approach, AMSDU support can be added in addition to
> AMPDU. So I would suggest to replace AGGR by AMPDU right away.
> 
>> +
>> +/*
>> + * struct ieee80211_tid_conf - holds the tid configiuration data
>> + * The information provided in the structure is required for the 
>> driver
>> + * to configure TID specific configuration.
>> + * @tid: TID number
>> + * @retry_short: retry count value
>> + * @retry_long: retry count value
>> + * @aggr: enable/disable aggregation
>> + */
>> +struct ieee80211_tid_conf {
>> +       u8 tid;
>> +       int retry_short;
>> +       int retry_long;
>> +       bool aggr;
>> +};
> 
> ditto: aggr -> ampdu
> 
Sure. I'll update in the next version.

Thanks,
Tamizh.
