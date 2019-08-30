Return-Path: <SRS0=jb13=W2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEFEC3A59B
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 14:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E5C2341B
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 14:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UXNHJM8h";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UXNHJM8h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfH3OJj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 10:09:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfH3OJj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 10:09:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B458460271; Fri, 30 Aug 2019 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567174178;
        bh=1MAfz7qwOXIyJppxkuXFbcB9rkiU+1Da4fqOdQapEOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXNHJM8h17nXy0V/NOlN/AIcrV62uOgQag83hmBlbRmxia3e3rXZnB+8dFFzMGXkN
         jtIhFGR0KTCMbmSckhZaX+/SHbXUCGi0YJn36NHg9BfWesxsi/fUvJGPmj84R3DVNn
         bOzwP32vBczJVnDKIMXX34nJ7H1bvf8fMXyRxy4g=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 2300060159;
        Fri, 30 Aug 2019 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567174178;
        bh=1MAfz7qwOXIyJppxkuXFbcB9rkiU+1Da4fqOdQapEOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXNHJM8h17nXy0V/NOlN/AIcrV62uOgQag83hmBlbRmxia3e3rXZnB+8dFFzMGXkN
         jtIhFGR0KTCMbmSckhZaX+/SHbXUCGi0YJn36NHg9BfWesxsi/fUvJGPmj84R3DVNn
         bOzwP32vBczJVnDKIMXX34nJ7H1bvf8fMXyRxy4g=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 30 Aug 2019 07:09:38 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Amar Singhal <asinghal@codeaurora.org>, jouni@codeaurora.org,
        linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Subject: Re: [PATCH] cfg80211: Add new helper function for channels
In-Reply-To: <9a9c8024-a9f9-72f9-557a-c185dca9c15c@broadcom.com>
References: <1567115381-7831-1-git-send-email-asinghal@codeaurora.org>
 <01082dca-8d71-c674-1f61-ab5d7e07c007@broadcom.com>
 <6222b9d9d125c4c3a9f60cc0fe73cef2011b9959.camel@sipsolutions.net>
 <9a9c8024-a9f9-72f9-557a-c185dca9c15c@broadcom.com>
Message-ID: <3a609ec7d068dbc97597a0dcb147e839@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-08-30 04:03, Arend Van Spriel wrote:
> On 8/30/2019 12:41 PM, Johannes Berg wrote:
>> On Fri, 2019-08-30 at 12:40 +0200, Arend Van Spriel wrote:
>> 
>>>> +EXPORT_SYMBOL(ieee80211_channel_op_class_to_frequency);
>>> 
>>> The function ieee80211_operating_class_to_band() uses ranges within
>>> switch statement, eg.:
>>> 
>>>           case 128 ... 130:
>>>                   *band = NL80211_BAND_5GHZ;
>>>                   return true;
>> 
>> No that you remind me - how is this new function not just a 
>> composition
>> of the existing ones?
>> 
>> i.e. just convert the op_class to band first, and then (band, channel)
>> to freq?
> 
> yup. that would have my preference actually.

Sigh. I had the same guidance in pre-review:

we already have ieee80211_operating_class_to_band() and 
ieee80211_channel_to_frequency() so all this function should be is

  return ieee80211_channel_to_frequency(chan, 
ieee80211_operating_class_to_band(op_class))

but then again if anybody needs this functionality they can simply call 
those same functions
