Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60EF1C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 10:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FBD120674
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 10:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PL9zP4Va";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gQu6bHy6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfDLKJH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 06:09:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfDLKJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 06:09:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 40AAE61378; Fri, 12 Apr 2019 10:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555063746;
        bh=Tf2k6UM3JzvWkA2cMGlvglrZN+Jdbhgn16XGqkrKlt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PL9zP4ValG+uHEj43C4mtEOe9pGjDWlmSx620FK7XNxWVgSOkdreN2ZgvH+xdQInM
         h5esbWctl9nQcjPxAYn865f4vnAhpjn8IPfeId5YlRNVXXegxiC4YMosiDM43pDi0/
         8xproRDAdtn/enX4yCEIWSgc87TigMnkWkCcjBag=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 9E650614B6;
        Fri, 12 Apr 2019 10:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555063744;
        bh=Tf2k6UM3JzvWkA2cMGlvglrZN+Jdbhgn16XGqkrKlt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gQu6bHy6rFqYz/Mf5nFmygg2CH+u5BdAGwkXIVW4lFWgIjkcVh7x+tkDkDmZOKZAP
         cVasoeK54h6Os+M0iETN2Wsbr28FLKEr+xyIMD3RrmoG/5P/YIDeO5EiEInFxFrFvX
         okw38oqgE1x5OG4Y5ffEmAkr/nWxhDwYzwhLyrQk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Apr 2019 18:09:03 +0800
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2] fq: fix fq_tin tx bytes overflow
In-Reply-To: <717acf1bde5507f73436ae7d45d114b34aee1c05.camel@sipsolutions.net>
References: <1552446505-15444-1-git-send-email-yiboz@codeaurora.org>
 (sfid-20190313_040846_202389_4E584F4C)
 <13392e1203be4ddd97c4e0e6b6a6c48ce97aae6f.camel@sipsolutions.net>
 <fa575f93f3936aa3be1cf6b14f87e511@codeaurora.org>
 <717acf1bde5507f73436ae7d45d114b34aee1c05.camel@sipsolutions.net>
Message-ID: <dba1c91baf387a5e44743075ec7efbc2@codeaurora.org>
X-Sender: yiboz@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-09 04:01, Johannes Berg wrote:
> On Mon, 2019-03-18 at 12:59 +0800, Yibo Zhao wrote:
>> 
>> I understand your concern. Yes, I am using high end AP for throughput
>> test. I'd say 1.2 Gbps is not the worst case since we can achieve max
>> 1.4Gbps according to our test. AFAIK, for most throughput cases, 1min 
>> is
>> the minimum requirement. And I think, with more and more high end
>> products(even higher throughput) on the ways to the market, it is 
>> highly
>> possible that 30s is not a safe time before overflow.
> 
> Well, 2 Gbps (goodput) would make it overflow every 16 seconds, so I'm
> not sure where you take the 1 minute from :-) Maybe from 1.2Gbps PHY
> rate.
> 
> But still, the only place we expose this is debugfs, so I'm not really
> sure we want to spend that.
> 
> Note that I'm generally pushing back on statistics right now - I really
> want to put some trace points or eBPF hooks in places that people can
> use to keep their favourite statistics, instead of trying to cover each
> and every use case in the stack itself.

Cool, great!looking forward to that change. :-)
> 
> johannes

-- 
Yibo
