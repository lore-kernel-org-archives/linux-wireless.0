Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88313C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 07:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 534C2222A1
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 07:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OJaIudQQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OWaPg8at"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392616AbfBNHOr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 02:14:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388265AbfBNHOr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 02:14:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3887F60886; Thu, 14 Feb 2019 07:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550128486;
        bh=A26goeyVUuBZkUJ6Aod7dcHMw1GTO3QqPp59tj67ad0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OJaIudQQlSPOYCcabWuA1haFMOrCq9bNd+R1/NiGkwM7HHRChgAsROIjU6RssW3MY
         m+ICqVi6sOn0tfFpzLki/BoJ3dUSU+4XNegot5x59YI5iBYbwD+UH9ZbUX4+O9Y27V
         TRv0YXN1O9450T9ZfSMQ/HiA/mFEiRofvwOXPSuI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id B8A9760736;
        Thu, 14 Feb 2019 07:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550128485;
        bh=A26goeyVUuBZkUJ6Aod7dcHMw1GTO3QqPp59tj67ad0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OWaPg8at1rvz15DCYg3k51rVkatuRldfDlKFZFZNqDWN807L08g8Odkm4xfOkKYP0
         wrDvprDrjEgoLBsn+kv9CGl+rOvc4w+tlRiyBKm/07B9zWHLqA78QHWyYnUOI+x2lq
         ESLDiE/O0a/3wz5E3ruShrafrfJekzupgiRXVVBY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 14 Feb 2019 12:44:45 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     ath10k@lists.infradead.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] cfg80211/mac80211: Add support for TID specific
 configuration
In-Reply-To: <a7d97b692da245a8b85769d7766ceba7@aphydexm01f.ap.qualcomm.com>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <20190213190135.lp3sg3u3b4mmve7l@bars>
 <a7d97b692da245a8b85769d7766ceba7@aphydexm01f.ap.qualcomm.com>
Message-ID: <cb188f3a7f7250e3b7bc9ec6f68d603e@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sergey,

> Hello Tamizh,
> 
>> Add infrastructure for per TID aggregation/retry count configurations
>> such as retry count and AMPDU aggregation control(disable/enable).
>> In some scenario reducing the number of retry count for a specific
>> data traffic can reduce the latency by proceeding with the next packet
>> instead of retrying the same packet more time. This will be useful
>> where the next packet can resume the operation without an issue.
>> Here added NL80211_CMD_SET_TID_CONFIG to support this operation by
>> accepting retry count and AMPDU aggregation control.
>> This command can accept STA mac addreess to make the configuration
>> station specific rather than applying to all the connected stations to
>> the netdev.
>> 
>> Tamizh chelvam (3):
>>   nl80211: Add netlink attribute for AMPDU aggregation enable/disable
>>   tid conf 3
>>   ath10k: Add support to configure TID specific configuration
>> 
>> Vasanthakumar Thiagarajan (1):
>>   New netlink command for TID specific configuration
> 
> Could you please share your further plans regarding this patch series ?
> Do you plan to send next revision in the forseable future ?
> Or have you decided to abandon this approach ?
> 
I'm working on new patchsets. I will send it in a week.

Thanks,
Tamizh.
