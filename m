Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E78FC33CAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 17:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4480124699
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 17:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394450AbgAPRyH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:54:07 -0500
Received: from mail.adapt-ip.com ([173.164.178.19]:53824 "EHLO
        mail.adapt-ip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733250AbgAPRyG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 12:54:06 -0500
Received: from localhost (unknown [127.0.0.1])
        by mail.adapt-ip.com (Postfix) with ESMTP id 3C7152F1649;
        Thu, 16 Jan 2020 17:54:05 +0000 (UTC)
X-Virus-Scanned: amavisd-new at web.adapt-ip.com
Received: from mail.adapt-ip.com ([127.0.0.1])
        by localhost (web.adapt-ip.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id veuEyXMcWkfo; Thu, 16 Jan 2020 09:54:03 -0800 (PST)
Received: from [10.1.10.44] (vpn.adapt-ip.com [173.164.178.20])
        (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: thomas@adapt-ip.com)
        by mail.adapt-ip.com (Postfix) with ESMTPSA id 685982F1646;
        Thu, 16 Jan 2020 09:54:03 -0800 (PST)
Subject: Re: [PATCH v2 0/3] fix a STA PS bug and add PS support to
 mac80211_hwsim
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <2b07e86b-9be7-4fc3-ae92-a4f831e585ef@email.android.com>
 <4c2d7cc81e83238512360903f38e12be16c16ed5.camel@sipsolutions.net>
From:   Thomas Pedersen <thomas@adapt-ip.com>
Message-ID: <bd9d68d2-114d-7e7a-000b-d2bf40658e74@adapt-ip.com>
Date:   Thu, 16 Jan 2020 09:54:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4c2d7cc81e83238512360903f38e12be16c16ed5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/15/20 11:54 PM, Johannes Berg wrote:
> On Wed, 2020-01-15 at 23:53 -0800, thomas@adapt-ip.com wrote:
>>
>>> FWIW, I applied your patches yesterday. There was one issue remaining 
>>> uncovered by them, but it wasn't actually related to your patches, just 
>>> related to the test sending too many frames. I sent a workaround to the 
>>> hostap list and also the "mac80211: use more bits for ack_frame_id" to 
>>> the kernel to fix that. 
>>>
>>
>> But in the v3, no frames should actually be buffered unless power save
>> is explicitly enabled on the STA side. Or is this some rrm specific
>> behavior?
> 
> I didn't check whether or not powersave got enabled by default now, I
> sort of assumed it did? But that isn't really bad, almost all real
> devices will have it enabled by default too.

In v2 powersave was enabled by default, but that broke some test
assumptions (and p2p stuff I don't really understand), so v3 disables it
by default: https://lore.kernel.org/linux-wireless/20200114055940.18502-2-thomas@adapt-ip.com/T/#u

-- 
-- thomas
