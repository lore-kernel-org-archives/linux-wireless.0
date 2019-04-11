Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5B1C10F11
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 00:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0303620873
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 00:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="deFFNlxX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="deFFNlxX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfDKACF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 20:02:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfDKACF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 20:02:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 789E160F38; Thu, 11 Apr 2019 00:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554940924;
        bh=VoxDw+9BdO8PFLYqdgw9509kHI/h5ytdDsaSMnBvTtQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=deFFNlxX0/6QjtClnqFxDJ1+QUrjrC03D+cNI02sJ2QyRPVf0Nkc6wdThwinVAMFv
         bhVGCo6AIIreArctzzKg9j3WPhaoyOTAK2hJ8erBVFrX+0RJKpWpix0H0EJMTSIORI
         K5ZNHYGHeWrVbmdilwdJ6Y4m5cMBHfdPDe1UOo7o=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 259D160A43;
        Thu, 11 Apr 2019 00:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554940924;
        bh=VoxDw+9BdO8PFLYqdgw9509kHI/h5ytdDsaSMnBvTtQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=deFFNlxX0/6QjtClnqFxDJ1+QUrjrC03D+cNI02sJ2QyRPVf0Nkc6wdThwinVAMFv
         bhVGCo6AIIreArctzzKg9j3WPhaoyOTAK2hJ8erBVFrX+0RJKpWpix0H0EJMTSIORI
         K5ZNHYGHeWrVbmdilwdJ6Y4m5cMBHfdPDe1UOo7o=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Apr 2019 17:02:04 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/3] wireless: Add support to probe unexercised mesh
 link
In-Reply-To: <1ed09282bb0efb801a29d40eca7a09af077ad1d3.camel@sipsolutions.net>
References: <1554318884-22450-1-git-send-email-rmanohar@codeaurora.org>
 <1ed09282bb0efb801a29d40eca7a09af077ad1d3.camel@sipsolutions.net>
Message-ID: <8cb47c1517ab2574c19efae101d6de21@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-09 05:02, Johannes Berg wrote:
> On Wed, 2019-04-03 at 12:14 -0700, Rajkumar Manoharan wrote:
>> Consider below mesh topology.
>> 
>>         MP1
>>        /    \
>>       /      \
>>      MP2 --- MP3
>> 
>> Assume that even though MP1 & MP3 have direct mesh links, the path was
>> established via MP2. (MP1 <-> MP2 <-> MP3). The 1-hop mesh link MP1 
>> <-> MP3
>> never be excercised till the current path is terminated. As of now, 
>> there
>> is no option to send data frame to pick other than primary path. So 
>> mesh
>> link metric between MP1 & MP3 never be updated. This series allows 
>> user
>> to send data to 1-hop mesh peers through unexercised mesh path.
>> 
>> -Rajkumar
>> 
>> v3: Rebased the changes on TOT
> 
> Hmm. Please rebase again, and retest, because I just applied this and 
> it
> doesn't even compile ...
> 
Sure.. will send next version on top of mac80211-next.

-Rajkumar
