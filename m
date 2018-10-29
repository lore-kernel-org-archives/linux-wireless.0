Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DC8C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 23:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 954EF2081B
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 23:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TqJelV6C";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TqJelV6C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 954EF2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbeJ3Ilx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 04:41:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbeJ3Ilx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 04:41:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CAA206021A; Mon, 29 Oct 2018 23:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540857050;
        bh=cpAsA9fiU9/CJFuM8kcvFujqc6zr8UJFvoYfdQIcWLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TqJelV6CRJT+7yKHY4jOTX8IqTpLQkiIid4xlpxUEPlZq/v6885idalptbmrFVjBB
         Hb9eOAHw7dsvzv3LktjWovrIIf4B19lj9xgmzxQsCjPn5Q4jpNjgCneIYgRCJK53sq
         vQcx7xN/CEVSPU8Wwx+c94eyzAHszskdzOIzM7UI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 321F86021A;
        Mon, 29 Oct 2018 23:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540857050;
        bh=cpAsA9fiU9/CJFuM8kcvFujqc6zr8UJFvoYfdQIcWLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TqJelV6CRJT+7yKHY4jOTX8IqTpLQkiIid4xlpxUEPlZq/v6885idalptbmrFVjBB
         Hb9eOAHw7dsvzv3LktjWovrIIf4B19lj9xgmzxQsCjPn5Q4jpNjgCneIYgRCJK53sq
         vQcx7xN/CEVSPU8Wwx+c94eyzAHszskdzOIzM7UI=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 29 Oct 2018 16:50:50 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to
 TXQs
In-Reply-To: <8fd3524bfe022ccd2a8b61a3314ed32b@codeaurora.org>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
 <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org>
 <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org>
 <87woq2843q.fsf@toke.dk> <8fd3524bfe022ccd2a8b61a3314ed32b@codeaurora.org>
Message-ID: <5d8415fe50e8505eb62c5a0d1b40bb2a@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-28 15:01, Rajkumar Manoharan wrote:
> On 2018-10-28 08:48, Toke Høiland-Jørgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>> 
>>> 
>>> 4ms         223 (40%)         214 (40%)    109 (10%)       94 (10%)
>>> 
>>> 4ms         337 (90%)         182 (8%)      23 (1%)        30 (1%)
>> 
>> So this looks like it's doing *something*, but not like it's 
>> succeeding
>> in achieving the set percentages. Did you check if the actual airtime
>> values (in debugfs) corresponds to the configured weights?
>> 
> No. Will check that.
> 
Toke,

 From above results, different airtime for each station is reflecting on
output performance. Unfortunately I don't see such tput difference, when
the tx mode is fixed in push-only. Even low weight station is giving 
same
performance. Are you also seeing the same behavior in your setup? Could
you please share your results?

Not sure why low weight station (26us) is consuming more airtime than
higher airtime station. Below result is taken in push-only mode that
means only next_txq() ordering is followed.

cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0/stations/*/airtime
RX: 0 us
TX: 980443 us
Weight: 176
Deficit: VO: 256 us VI: 256 us BE: -91 us BK: 256 us
RX: 0 us
TX: 2008512 us
Weight: 26
Deficit: VO: 238 us VI: 256 us BE: 24 us BK: 256 us
RX: 0 us
TX: 513287 us
Weight: 26
Deficit: VO: 256 us VI: 256 us BE: 1 us BK: 256 us
RX: 0 us
TX: 576746 us
Weight: 26
Deficit: VO: 256 us VI: 256 us BE: 10 us BK: 256 us

-Rajkumar
