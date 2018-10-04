Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69404C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 17:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 327952084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 17:32:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KW1zrQH2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZBwc8Gug"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 327952084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbeJEA0h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 20:26:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbeJEA0h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 20:26:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5AF9A60B26; Thu,  4 Oct 2018 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538674341;
        bh=HZWlOqY/B1+e/EPI2N+IOOsiuro4QsN6HtDutWSQ+WY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KW1zrQH2PgGwmwuXlMaRAViXXOSVGDD1z88Evv0wrKPCtvH9ykWz3+P0kNWQPkML8
         R5a/BqK8tgrY6DytaHiWci4Tf20GO3d+w4gi/xFHI1xu+GN7Aux+UHz0ONgwCm3ZW6
         GEVVPtmaCiRnCuFRcYqJYYQQjJWXKp/eO3i3ozmQ=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id C3B1460BE8;
        Thu,  4 Oct 2018 17:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538674340;
        bh=HZWlOqY/B1+e/EPI2N+IOOsiuro4QsN6HtDutWSQ+WY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZBwc8Gugq8wNBYDa1PcwDbKcrQuvrrfRSu7LY5WDPixLzgJk5MtKrTs4X59UfUfVT
         rN88g7rzIT2M61rqkaAUlI4EMDsemX8gVrI+W+vVNi8miPYF7Gyy4+B8noGM5DvHy1
         2NGRBd87Ad8GZ28BwO2RovJGGUUc3QPLSzJtW6WY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 04 Oct 2018 23:02:20 +0530
From:   bankita@codeaurora.org
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Add per peer statistics to compute FCS error
 rate
In-Reply-To: <1538389142.3126.29.camel@sipsolutions.net>
References: <1538060517-32208-1-git-send-email-jouni@codeaurora.org>
 <1538389142.3126.29.camel@sipsolutions.net>
Message-ID: <a4d0af139d550a248ecd280798bbdd2a@codeaurora.org>
X-Sender: bankita@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-01 15:49, Johannes Berg wrote:
> On Thu, 2018-09-27 at 18:01 +0300, Jouni Malinen wrote:
>> From: Ankita Bajaj <bankita@codeaurora.org>
>> 
>> Add support for drivers to report the total number of MPDUs received
>> and the number of MPDUs received with an FCS error from a specific
>> peer. These counters will be incremented only when the TA of the
>> frame matches the MAC address of the peer irrespective of FCS
>> error.

We do have rx_packets field but it is for MMPDUs and MSDUs which might 
not reflect the number of MPDUs in all cases. Hence we introduced new 
field for MPDU count.

> Hmm. The error one seems mostly reasonable, I guess, but do we really
> not having anything that's the total number of MPDUs already?
> 
> And then, I guess, what exactly would you want there? We might not
> always even be able to provide that?

> I'm also left wondering what the application here is -

These two fields together will help to find bad rx link with a specific 
peer. This information can be used for example to steer the client to a 
different BSS.

Ankita
