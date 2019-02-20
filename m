Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA833C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 07:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F4E52147A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 07:20:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Uu1LzChJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TKzAsyd1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfBTHUx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 02:20:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56700 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbfBTHUx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 02:20:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3923F602C3; Wed, 20 Feb 2019 07:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550647252;
        bh=Gf6zDiSUTtif9ViUElEI57dYEHVIjgdiXQGrEtX2wkU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uu1LzChJspfpxKE7pq6eJPPgpHzc3Ds76Lch7VNQeUaNkkvr/eNSEDfm8xRIqAQT+
         SK1GMBp3PYEfHf0E6cGV8kIv5Oa/XXIxfBRjw6XmVxMgGdjseRQid+4EyptuyB5l0E
         N9DGWuXm5ye/r2QLmaAg5LQwc8cJs4RL93BSIsDo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 87FD7601D4;
        Wed, 20 Feb 2019 07:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550647251;
        bh=Gf6zDiSUTtif9ViUElEI57dYEHVIjgdiXQGrEtX2wkU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TKzAsyd1sFCiBZUVgMeqBjPgwvHzkD8mMFuAuXm7Di3KYIevJxWtnWmDuWgkRVlof
         I6dkxwNJAx3a3r6VvpMBKLeyrfnM69quAS3AkCecLKAdd1lFILbYtztoDnT6dMf7dq
         QapK68DPwOM7ZCkQpTlnyTMZCVFaEJ4AES2cI78w=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 20 Feb 2019 12:50:51 +0530
From:   dasaris@codeaurora.org
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Sunil Dutt <usdutt@codeaurora.org>,
        Liangwei Dong <liangwei@codeaurora.org>
Subject: Re: [PATCH] cfg80211/nl80211: Offload OWE processing to user space in
 AP mode
In-Reply-To: <20190216041112.zl2kpec2xu5fykjw@bars>
References: <1550258078-13504-1-git-send-email-dasaris@codeaurora.org>
 <20190216041112.zl2kpec2xu5fykjw@bars>
Message-ID: <3b81948a5e2b3a27f2c55d7ea6ee827e@codeaurora.org>
X-Sender: dasaris@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-02-16 09:41, Sergey Matyukevich wrote:
> Hi Srinivas,
> 
>>  include/net/cfg80211.h       | 42 ++++++++++++++++++++++++++
>>  include/uapi/linux/nl80211.h |  7 +++++
>>  net/wireless/nl80211.c       | 72 
>> ++++++++++++++++++++++++++++++++++++++++++++
>>  net/wireless/rdev-ops.h      | 13 ++++++++
>>  net/wireless/trace.h         | 38 +++++++++++++++++++++++
>>  5 files changed, 172 insertions(+)
> 
> ...
> 
>> +void cfg80211_update_owe_info_event(struct net_device *netdev,
>> +                                   struct cfg80211_update_owe_info 
>> *owe_info,
>> +                                   gfp_t gfp)
>> +{
>> +       struct wiphy *wiphy = netdev->ieee80211_ptr->wiphy;
>> +       struct cfg80211_registered_device *rdev = 
>> wiphy_to_rdev(wiphy);
>> +       struct sk_buff *msg;
>> +       void *hdr;
>> +
>> +       trace_cfg80211_update_owe_info_event(wiphy, netdev, owe_info);
>> +
>> +       msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
>> +       if (!msg)
>> +               return;
>> +
>> +       hdr = nl80211hdr_put(msg, 0, 0, 0, 
>> NL80211_CMD_UPDATE_OWE_INFO);
>> +       if (!hdr)
>> +               goto nla_put_failure;
>> +
>> +       if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
>> +           nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
>> +           nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, owe_info->peer))
>> +               goto nla_put_failure;
>> +
>> +       if (nla_put(msg, NL80211_ATTR_IE, owe_info->ie_len, 
>> owe_info->ie))
>> +               goto nla_put_failure;
> 
> Maybe worth adding sanity check if IE length is non-zero ?
> 
> 
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> Regards,
> Sergey

Thanks for the review. owe_info->ie is a mandatory field to be provided 
to the userspace as part of this event. We shall add a sanity check on 
IE length and reject(drop) the request from driver if it is 0. We shall 
update new patchset.

Regards,
Srinivas
