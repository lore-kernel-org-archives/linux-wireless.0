Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852DDC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 13:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C14F20866
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 13:34:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bn+Zj2t2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g5Oeuktj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C14F20866
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbeKKXXD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 18:23:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbeKKXXD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 18:23:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3C9996081E; Sun, 11 Nov 2018 13:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541943267;
        bh=4Qa3iwY2iTerP5zR6+Z6i0m6VXb2+LKIIuUxORBzEyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bn+Zj2t2/c58KT1DHBrhsh/PGAx6arLEjfeFJYJwCCUi6XsAR60FJRnjRAUUnp3Mw
         tNMTkCEqev8NyNvDF94qR+4LoYKNXMG2WwX4wVcXr5O2QXMmh2v/TxabMYe6yA/6DM
         uzBrMFOpiw5sOR0ACVdX0eIXsOQN7YRYWipOHwWc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3BB2A6071B;
        Sun, 11 Nov 2018 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541943263;
        bh=4Qa3iwY2iTerP5zR6+Z6i0m6VXb2+LKIIuUxORBzEyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g5OeuktjLZCEqyZfkftn6QJ5Q4Gxc4whk38YHKcETHIVCrbngUe0e0aPa32QvHHAK
         VqS7uG1B5Yn8Lf77Jd7l6TQR8QjgSbGcIRdNj0gDmWgzOPOFk+8X7uEzY3eRmjal7q
         vwqHvbt+iXpwgZdV3XweMMFUS7zeyTpmUvRvXufg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 11 Nov 2018 19:04:23 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] cfg80211: Add support to configure station specific
 RSSI threshold for AP mode
In-Reply-To: <ca4bf715537f910af0ee6fa34f6be69b9e24b630.camel@sipsolutions.net>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
 <1539626250-769-2-git-send-email-tamizhr@codeaurora.org>
 <ca4bf715537f910af0ee6fa34f6be69b9e24b630.camel@sipsolutions.net>
Message-ID: <db1302e621ea673a489ced72ecd57219@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


>> +	int	(*set_sta_mon_rssi_config)(struct wiphy *wiphy,
>> +					  struct net_device *dev,
>> +					  const u8 *addr,
>> +					  const s32 *rssi_tholds,
>> +					  u32 rssi_hyst, int rssi_n_tholds,
>> +					  bool fixed_thold);
>>  };
> 
> I think it might be better to pass all the last 4 arguments (rssi
> related ones) as a struct? That's a pattern we typically have elsewhere
> too, and it makes things easier to extend and also easier to pass
> around.
> 
Sure.

>> + * @NL80211_CMD_SET_STA_MON: This command is used to configure 
>> station's
>> + *     connection monitoring notification trigger levels.
>> + * @NL80211_CMD_NOTIFY_STA_MON: This is used as an event to notify
>> + *     the user space that a trigger level was reached for a station.
> 
> Please describe the attributes to use with this.
> 
I'll add that in the next version of patchset
> 
>> + * @NL80211_ATTR_STA_MON_FIXED_THOLD: Flag attribute is used with
>> + *	%NL80211_CMD_SET_STA_MON to indicate driver that the monitoring
>> + *	configuration is fixed limit or a moving range threshold.
> 
> This isn't really clear to me, what does it mean?
> 
Sorry for not clear. This flag introduced to mention the driver that if 
this flag set then don't change the rssi_low and rssi_high limit upon
the station's rssi crossing the configured limit. Keep the rssi_low and 
rssi_high as a fixed limit.

>> +	if (!sta_mon || !(info->attrs[NL80211_ATTR_MAC]))
> 
> Don't really need the parentheses in !(info->...)
> 
Yes, I'll remove it.

>> +	err = nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, sta_mon,
>> +			       nl80211_attr_cqm_policy, info->extack);
> 
> I *think* I made that a proper nested policy, check and then you can
> remove passing it here.
> 
Sure. I'll modify it in the next patchset version.

>> +void
>> +cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
>> +			     enum nl80211_cqm_rssi_threshold_event rssi_event,
>> +			     s32 rssi_level, gfp_t gfp)
>> +{
>> +	struct sk_buff *msg;
>> +
>> +	if (WARN_ON(!peer))
>> +		return;
> 
> Tracing for this might be nice too?
> 
Sure.

Thanks,
Tamizh.
