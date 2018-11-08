Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB7AECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 17:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 538C12081C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 17:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EY8HLHyW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YvBfiBE0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 538C12081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbeKIDX7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 22:23:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbeKIDX7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 22:23:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 962BC6074F; Thu,  8 Nov 2018 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541699243;
        bh=JvNUhfliZxR4nVTtqCE070Zw+o3u99Ock1Gvvwd+S2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EY8HLHyWFpzDjPXKvwNuwek3IXGI9OY7zpN3N8u2BzZg3NrCcPrDfuTo9Z8GlSO/p
         jDCkozt0EgTsqg8dnLmCA6mLNIim09RGcYz752jwDLU7ppI1t/conv0mUe11UZrLuA
         7wBsiZx/w7cCJqlOViQWZOW8o6E3RHNLWtAKaO3A=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id B49BA6074F;
        Thu,  8 Nov 2018 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541699242;
        bh=JvNUhfliZxR4nVTtqCE070Zw+o3u99Ock1Gvvwd+S2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YvBfiBE0/AQDUo+mINS8ZreNtV1KuYg5x/c8PgY9cvd1FQBRzcPrwAQtK4n+afiwo
         50MyfURAxszDr8kdyQqAz3X2a+6Sac0o3EDA813B07NwpnZqVlWQyU+N0Y1bUHGjaX
         8mFNmg4oJ8wSNG7YBhtcUl61HUc/ttuXhAxvGkls=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 08 Nov 2018 23:17:22 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     ath10k@lists.infradead.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
In-Reply-To: <20181107140552.zfuusbapgqjumoln@bars>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
 <20181107140552.zfuusbapgqjumoln@bars>
Message-ID: <0b75171a7777bd25e203240a3a119cb5@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> Hello Tamizh,
> 
>> Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
>> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
>> ---
>>  include/net/cfg80211.h       |   14 +++++++
>>  include/uapi/linux/nl80211.h |   69 +++++++++++++++++++++++++++++++++
>>  net/wireless/nl80211.c       |   86 
>> ++++++++++++++++++++++++++++++++++++++++++
>>  net/wireless/rdev-ops.h      |   15 ++++++++
>>  net/wireless/trace.h         |   27 +++++++++++++
>>  5 files changed, 211 insertions(+)
> 
> ...
> 
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index d744388..d386ad7 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
> 
> ...
> 
>> +static int nl80211_set_tid_config(struct sk_buff *skb,
>> +                                 struct genl_info *info)
>> +{
>> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +       struct nlattr *attrs[NL80211_ATTR_TID_MAX + 1];
>> +       struct nlattr *tid;
>> +       struct net_device *dev = info->user_ptr[1];
>> +       const char *peer = NULL;
>> +       u8 tid_no;
>> +       int ret = -EINVAL, retry_short = -1, retry_long = -1;
>> +
>> +       tid = info->attrs[NL80211_ATTR_TID_CONFIG];
>> +       if (!tid)
>> +               return -EINVAL;
>> +
>> +       ret = nla_parse_nested(attrs, NL80211_ATTR_TID_MAX, tid,
>> +                              nl80211_attr_tid_policy, info->extack);
>> +       if (ret)
>> +               return ret;
>> +
>> +       if (!attrs[NL80211_ATTR_TID])
>> +               return -EINVAL;
>> +
>> +       if (attrs[NL80211_ATTR_TID_RETRY_SHORT]) {
>> +               retry_short = 
>> nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_SHORT]);
>> +               if (!retry_short ||
>> +                   retry_short > rdev->wiphy.max_data_retry_count)
>> +                       return -EINVAL;
>> +       }
>> +
>> +       if (attrs[NL80211_ATTR_TID_RETRY_LONG]) {
>> +               retry_long = 
>> nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_LONG]);
>> +               if (!retry_long ||
>> +                   retry_long > rdev->wiphy.max_data_retry_count)
>> +                       return -EINVAL;
>> +       }
>> +
>> +       tid_no = nla_get_u8(attrs[NL80211_ATTR_TID]);
>> +       if (tid_no >= IEEE80211_FIRST_TSPEC_TSID)
>> +               return -EINVAL;
>> +
>> +       if (info->attrs[NL80211_ATTR_MAC])
>> +               peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
>> +
>> +       if (nla_get_flag(attrs[NL80211_ATTR_TID_RETRY_CONFIG])) {
> 
> Do we really need this additional flag to indicate retry data ?
> Maybe we can simply check retry attrs or even retry data, e.g.:

Yes, because this implementation gives provision to set default retry 
count for TID traffic type for a station.
Since we use single NL command for all TID configurations, this flag 
will be useful to notify the driver about
retry TID configuration change.
> 
> if (attrs[NL80211_ATTR_TID_RETRY_LONG] ||
>     attrs[NL80211_ATTR_TID_RETRY_SHORT]) {
>     ...
> 
> if ((retry_short > 0) || (retry_long > 0)) {
>     ...
> 
>> +               if (!wiphy_ext_feature_isset(
>> +                               &rdev->wiphy,
>> +                               
>> NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG))
>> +                       return -EOPNOTSUPP;
>> +
>> +               if (peer && !wiphy_ext_feature_isset(
>> +                               &rdev->wiphy,
>> +                               
>> NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG))
>> +                       return -EOPNOTSUPP;
>> +
>> +               if (!rdev->ops->set_data_retry_count ||
>> +                   !rdev->wiphy.max_data_retry_count)
>> +                       return -EOPNOTSUPP;
>> +
>> +               ret = rdev_set_data_retry_count(rdev, dev, peer, 
>> tid_no,
>> +                                               retry_short, 
>> retry_long);
>> +       }
>> +
>> +       return ret;
>> +}
> 
> Regards,
> Sergey

Thanks,
Tamizh.
