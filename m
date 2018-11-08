Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30642C46465
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 12:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1AB2086A
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 12:28:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dA/j5oB8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dA/j5oB8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC1AB2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbeKHWEC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 17:04:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39996 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbeKHWEC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 17:04:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E8BA56081A; Thu,  8 Nov 2018 12:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541680125;
        bh=MjMhEQD0Lx+90u199hMSKiEvwq50aYY6vKfR7/EGv1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dA/j5oB8hgaqvs20s4GcG189cudlE0BP8RhPKBSX0JiBqRquMKMyb5Y3sYDZdbbY7
         jMiX9QroT7do2PzVI2b7DQigcrZO3+tX9vKA1IKT64B0IOMAyhEQOMA645vy3eYxjw
         j0rd6iH8HmFas6JYioi5BVQw3jKfhm7Os/oTObkE=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 7D48460591;
        Thu,  8 Nov 2018 12:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541680125;
        bh=MjMhEQD0Lx+90u199hMSKiEvwq50aYY6vKfR7/EGv1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dA/j5oB8hgaqvs20s4GcG189cudlE0BP8RhPKBSX0JiBqRquMKMyb5Y3sYDZdbbY7
         jMiX9QroT7do2PzVI2b7DQigcrZO3+tX9vKA1IKT64B0IOMAyhEQOMA645vy3eYxjw
         j0rd6iH8HmFas6JYioi5BVQw3jKfhm7Os/oTObkE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 08 Nov 2018 17:58:45 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     ath10k@lists.infradead.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 2/4] nl80211: Add netlink attribute for AMPDU aggregation
 enable/disable
In-Reply-To: <20181106102051.7erib7owjms64knl@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-3-git-send-email-tamizhr@codeaurora.org>
 <20181106102051.7erib7owjms64knl@bars>
Message-ID: <8a8444300c7fc772b0fb219e08c88498@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sergey,

> Hello Tamizh,
> 
>> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
>> ---
>>  include/net/cfg80211.h       |    6 ++++++
>>  include/uapi/linux/nl80211.h |   21 +++++++++++++++++++++
>>  net/wireless/nl80211.c       |   17 +++++++++++++++++
>>  net/wireless/rdev-ops.h      |   15 +++++++++++++++
>>  net/wireless/trace.h         |   23 +++++++++++++++++++++++
>>  5 files changed, 82 insertions(+)
> ...
> 
>> diff --git a/include/uapi/linux/nl80211.h 
>> b/include/uapi/linux/nl80211.h
>> index 9dfcf0a6..7ba0fb7 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -4449,6 +4449,20 @@ enum nl80211_ps_state {
>>   *     the max value should be advertised by the driver through
>>   *     max_data_retry_count. when this attribute is not present, the 
>> driver
>>   *     would use the default configuration.
>> + * @NL80211_ATTR_TID_AMPDU_AGGR_CTRL: Enable/Disable aggregation for 
>> the TID
>> + *     specified in %%NL80211_ATTR_TID. Its type is u8, if the peer 
>> MAC address
>> + *     is passed in %NL80211_ATTR_MAC, the aggregation configuration 
>> is applied
>> + *     to the data frame for the tid to that connected station.
>> + *     Station specific aggregation configuration is valid only for 
>> STA's
>> + *     current connection. i.e. the configuration will be reset to 
>> default when
>> + *     the station connects back after disconnection/roaming.
>> + *     when user-space does not include %NL80211_ATTR_MAC, this 
>> configuration
>> + *     should be treated as per-netdev configuration. This 
>> configuration will
>> + *     be cleared when the interface goes down and on the 
>> disconnection from a
>> + *     BSS. Driver supporting this feature should advertise
>> + *     NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL and supporting per 
>> station
> 
> typo: should be NL80211_EXT_FEATURE_PER_TID_AMPDU_AGGR_CTRL
Sure, I'll update in the next version.
> 
>> + *     aggregation configuration should advertise
>> + *     NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL.
>>   */
> 
> Regards,
> Sergey

Thanks,
Tamizh.
