Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4296EC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07A3D223D8
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 10:59:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="apNvGXWM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ro7UkRTT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07A3D223D8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbeKLUwO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 15:52:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbeKLUwO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 15:52:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2B02660881; Mon, 12 Nov 2018 10:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542020370;
        bh=mdzbYohpJbqVs6UYH/ZFv6/E2v6WPOzDGoHljosyf7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=apNvGXWMdXiZ2kPoMMSze010hx0Dur7JsIHDoTZzTTwTcJSgv8VfPgcIsSDkH2iUV
         lwQtEFkakMb8MIixgUlFKYTQmMqDdsVVv7ukAaQeU6s2bL6DXqTzDuEo4i0SRhFqVt
         uRjvXAJUuSKYx69WqoMNe/yg2Ax4M3QoDClZN6JE=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D51A36044B;
        Mon, 12 Nov 2018 10:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542020369;
        bh=mdzbYohpJbqVs6UYH/ZFv6/E2v6WPOzDGoHljosyf7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ro7UkRTTgBbxgxA7Pj9/e6ksf3idbU4brFI/f4WzsEs3dbXCX+wyPdBfHkuSvPEHo
         RplelokqzCeB2D2NI8SM/UOo/1OrJYhNeYOg0lJ0bh+du+sJEtEx1CtM78wDNS52hR
         AdQFNBvT2f8gze9wjNJlYyFbRwOa3vYdr4Ag0eXw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 12 Nov 2018 16:29:29 +0530
From:   Sriram R <srirrama@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Add support to notify radar event info received
 from STA
In-Reply-To: <0322ee25650343fffdcf3fef19cda9090af117fc.camel@sipsolutions.net>
References: <1539940356-1335-1-git-send-email-srirrama@codeaurora.org>
 <0322ee25650343fffdcf3fef19cda9090af117fc.camel@sipsolutions.net>
Message-ID: <772255895b9aaf30b2414111d4f8f4fa@codeaurora.org>
X-Sender: srirrama@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-09 17:34, Johannes Berg wrote:
> On Fri, 2018-10-19 at 14:42 +0530, Sriram R wrote:
> [...]
> 
> This looks fine, but I think it would be nice to have some extended
> netlink error reporting for at least some of these errors:
> 
Sure Johannes, I'll add them in the next patch revision.
>> +	dfs_region = reg_get_dfs_region(wiphy);
>> +	if (dfs_region == NL80211_DFS_UNSET)
>> +		return -EINVAL;
>> +
>> +	err = nl80211_parse_chandef(rdev, info, &chandef);
>> +	if (err)
>> +		return err;
>> +
>> +	err = cfg80211_chandef_dfs_required(wiphy, &chandef, wdev->iftype);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	if (err == 0)
>> +		return -EINVAL;
>> +
>> +	/* Do not process this notification if radar is already detected
>> +	 * by kernel on this channel
>> +	 */
>> +	if (chandef.chan->dfs_state == NL80211_DFS_UNAVAILABLE)
>> +		return -EINVAL;
> 
> And maybe that last one should just return 0?
You're right. I'll return success here.
Thanks,
Sriram.R

> 
> johannes
