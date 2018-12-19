Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83890C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 12:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49B00204FD
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 12:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IXUcBHoN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IXUcBHoN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbeLSM3K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 07:29:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58806 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbeLSM3K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 07:29:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9F656612E0; Wed, 19 Dec 2018 12:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545222549;
        bh=du1tcPenYjeaYdQh/oxnUE24iC6wLZFDcSoMyXqsqDo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IXUcBHoNl5cjoii/AJz+tsgnbYPBsXwaGFnNPZ9QvLQHisZKvLsSXyuk46dQ/vdni
         uBRV5Z5RIlSxfqQ/0+kXmZrjAoGJ8l7r9K2wy3RHCWRMZ/Ue0BNAm2gYYcG5o+eeeA
         DH9yg7SyTs0AeRwDFueEWX+eaxe9Y8T3WPOYEklc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 34E3C60A74;
        Wed, 19 Dec 2018 12:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545222549;
        bh=du1tcPenYjeaYdQh/oxnUE24iC6wLZFDcSoMyXqsqDo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IXUcBHoNl5cjoii/AJz+tsgnbYPBsXwaGFnNPZ9QvLQHisZKvLsSXyuk46dQ/vdni
         uBRV5Z5RIlSxfqQ/0+kXmZrjAoGJ8l7r9K2wy3RHCWRMZ/Ue0BNAm2gYYcG5o+eeeA
         DH9yg7SyTs0AeRwDFueEWX+eaxe9Y8T3WPOYEklc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 19 Dec 2018 17:59:09 +0530
From:   vjakkam@codeaurora.org
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Allow drivers to advertise supported AKM suites
In-Reply-To: <898d521150250b33b9c1efa42e63efc4bf608e06.camel@sipsolutions.net>
References: <1542368582-3153-1-git-send-email-vjakkam@codeaurora.org>
 <898d521150250b33b9c1efa42e63efc4bf608e06.camel@sipsolutions.net>
Message-ID: <e9f26148a73c5b10192fd12c61d76f14@codeaurora.org>
X-Sender: vjakkam@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-18 18:35, Johannes Berg wrote:
> On Fri, 2018-11-16 at 17:13 +0530, Veerendranath Jakkam wrote:
>> There was no such capability advertisement from the driver and thus 
>> the
>> current user space has to assume the driver to support all the AKMs. 
>> While
>> that may be the case with some drivers (e.g., mac80211-based ones), 
>> there
>> are cfg80211-based drivers that have constraints on which AKMs can be 
>> used.
>> Allow such drivers to advertise the exact set of supported AKMs so 
>> that
>> user space tools can determine what network profile options should be
>> allowed to be configured.
> 
> I think you need to explain here (and probably also in the docs) where
> this actually matters. Clearly with drivers that do it all in userspace
> it doesn't matter - so I guess it's intended for the offload cases?
> 
> Also, it'd be good to know which driver needs/implements this.

This is required by the Wi-Fi driver/solution , where the SME is part of
the driver and does not define separate commands for authentication and
association. The driver we are targeting here is specific to Qualcomm
and the design needs update to support new AKM's. (For EX,this driver
needs an enhancement to trigger NL80211_CMD_EXTERNAL_AUTH for SAE AKM).

This commit addresses the requirement of user space entity to know the
supported AKM's by a specific driver version.

As you have rightly mentioned this capability would also be required for
the cases where an AKM is offloaded to the driver/firmware.


> 
> Finally,
> 
>> +		if (rdev->wiphy.akm_suites)
>> +			if (nla_put(msg, NL80211_ATTR_AKM_SUITES,
>> +				    sizeof(u32) * rdev->wiphy.n_akm_suites,
>> +				    rdev->wiphy.akm_suites))
>> +				goto nla_put_failure;
> 
> That's probably better written as a single if statement.

Thanks . We shall update this in the next version.

> johannes
