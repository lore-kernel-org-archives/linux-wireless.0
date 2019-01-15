Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48374C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 195F520657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="blJSkPF9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbfAONSQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:18:16 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:43526 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbfAONSP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:18:15 -0500
Received: from [192.168.1.47] (104-235-168-9.evrt.wa.frontiernet.net [104.235.168.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id ACB2640AC0B;
        Tue, 15 Jan 2019 05:18:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com ACB2640AC0B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1547558293;
        bh=6KfWXx4cSAwXnCw8TnF+VoNqzgeP2cbdjkre5yDF7NE=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=blJSkPF9hZQeDyI+FkS6sqo8eqPsZToCrbLHQEuE8tnHf24b/KzJYH6Ohgz5vhcIt
         4o+WRPSzk2KmdeLIUtitZWLGNpocXOxC2fI/QsDczpo5FimSdtJOcST2W0pVJu8vYP
         1m0NJCPCoF0FeUsB8fyWEUwtPPBkvP0ffOoFu5NQ=
Subject: Re: [PATCH] nl80211/cfg80211: Add support to send tx frames at
 specified rate
To:     Johannes Berg <johannes@sipsolutions.net>, vamsin@codeaurora.org
References: <1543838646-3574-1-git-send-email-vamsin@codeaurora.org>
 <89e6532daf4011de2ad0df3dcb8accc42334f31e.camel@sipsolutions.net>
 <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
 <63224d0fc1e978624de9887cb7349c02@codeaurora.org>
 <efe6a7978b1cc6287f122d8e829d8bd318466849.camel@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <dd989de4-6adc-1f46-5384-1d1606682c18@candelatech.com>
Date:   Tue, 15 Jan 2019 05:18:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <efe6a7978b1cc6287f122d8e829d8bd318466849.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 01/15/2019 05:13 AM, Johannes Berg wrote:
> On Tue, 2019-01-08 at 23:19 +0530, vamsin@codeaurora.org wrote:
>
>> Unfortunately, the driver that I am working now is not upstreamed. I
>> would like to check with Ben if he likes to propose a patch ath10k
>> driver that he is working on as I see he is also interested in this
>> feature. Please let me know if it is mandatory or good to have driver
>> implementation.
>
> I'm not sure it really has to be *mandatory*, but if nobody else even
> wants to have support for this (and e.g. iwlwifi cannot even easily do
> this I believe) then what value does something have upstream?

Maybe ath9k could get support for this API?

Likely I'll eventually implement support for ath9k for this API if it is
in the kernel and no one does it first, but not sure when I'd get to it.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
