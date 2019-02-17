Return-Path: <SRS0=gO0h=QY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C944C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 15:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EB0218DE
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 15:56:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y/reBkqW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QdR5iU+e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfBQP4b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Feb 2019 10:56:31 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37374 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfBQP4a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Feb 2019 10:56:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4893D608CC; Sun, 17 Feb 2019 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550418989;
        bh=zXxs0oIAWu8irHmNasQpmQyZe0Kh9Ycxt+8cHVo2JAA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y/reBkqWdVJNuzv/J+NvR2dTPEOSo1a6gF1qFHtln7Nr65PIGjHQd3BvmtGQCqI3g
         6obh+WPuRHLV9E7G17hxc+QHGYkkSq/XpYwc86PmM2oI0qRajLDnfKw9uXDkIMnm9V
         WQ/R4IKbAESCciEfGlZQifbId4Ph6CbWJqjSfEQI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 03C23602C3;
        Sun, 17 Feb 2019 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550418987;
        bh=zXxs0oIAWu8irHmNasQpmQyZe0Kh9Ycxt+8cHVo2JAA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QdR5iU+e0377Y9T6VDftiCCHoQ1cSvCWNdEi8eoxNQO7B9+pmXOQ9Kj/H3L8/C4HF
         E/tpJHZU658XcIzEQk8F+WQWd/2ETUYtWOb4oKeQa1Tf3e/z+heW/3NU7AN1BndirA
         L6N3f61uEwvBsV+F0tVWRFFJdJ9AFnj6436ISeJg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 17 Feb 2019 07:56:26 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, kevinhayes@google.com,
        julanhsu@google.com
Subject: Re: [PATCH 2/2] mac80211: probe unexercised mesh links
In-Reply-To: <0541dec472c83b173a486a924983a450ede7e923.camel@sipsolutions.net>
References: <1550152570-13051-1-git-send-email-rmanohar@codeaurora.org>
 <1550152570-13051-3-git-send-email-rmanohar@codeaurora.org>
 <0541dec472c83b173a486a924983a450ede7e923.camel@sipsolutions.net>
Message-ID: <450ec5f3d2a4e7122ca03dbc714da45c@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-02-15 02:44, Johannes Berg wrote:
>>  void __ieee80211_subif_start_xmit(struct sk_buff *skb,
>>  				  struct net_device *dev,
>> -				  u32 info_flags);
>> +				  u32 info_flags,
>> +				  u32 ctrl_flags);
> 
> I'd feel better if we could avoid all this, but if you really can't 
> then
> I guess we should split this out to a separate patch.
> 
Hmm.. I don't see any options other than this. no free slot in 
info_flags.
Will split this change.

>> 
>> +	/* Allow injected packets to bypass mesh routing */
>> +	if (info->control.flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP)
> 
> unlikely?
> 
>> +int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device 
>> *dev,
>> +			      const u8 *dest, const u8 *buf, size_t len)
>> +{
>> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +	struct ieee80211_local *local = sdata->local;
>> +	struct sta_info *sta;
>> +	struct sk_buff *skb;
>> +	struct ethhdr *ehdr;
>> +
>> +	if (len < sizeof(*ehdr))
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&local->sta_mtx);
>> +	sta = sta_info_get_bss(sdata, dest);
>> +	mutex_unlock(&local->sta_mtx);
>> +
>> +	if (!sta)
>> +		return -ENOENT;
> 
> better add a comment here that the locking is fine because you only
> check *existence* and don't use the sta pointer for anything else
> 
>> +	ehdr = (struct ethhdr *)buf;
>> +	if (!ether_addr_equal(ehdr->h_dest, dest) ||
> 
> that check could be in cfg80211, but then why even bother passing the
> "dest" separately?
> 
>> +	    !ether_addr_equal(ehdr->h_source, sdata->vif.addr) ||
> 
> probably this one too
> 
>> +	    is_multicast_ether_addr(ehdr->h_dest))
> 
> this one too
> 
Will move all the condition checks to cfg80211.

> But also, ehdr isn't packed I think, you might have alignment issues
> here as you don't know how the netlink message looks like? I think?
> 
>> +	if (ehdr->h_proto != htons(ETH_P_802_3))
>> +		return -EINVAL;
> 
> same here
> 
>> +	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);
> 
> you should make it a bit bigger so header conversion will fit, I guess?
> 
Hmm. I thought ieee80211_skb_resize in build_hdr will take care of it.

-Rajkumar
