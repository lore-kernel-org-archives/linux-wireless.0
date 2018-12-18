Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F24AC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDDFB21841
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:45:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="YOhUZpiT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbeLRNpm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:45:42 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:33502 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbeLRNpl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 08:45:41 -0500
Received: from [192.168.1.47] (104-235-168-9.evrt.wa.frontiernet.net [104.235.168.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 0C18D40A626;
        Tue, 18 Dec 2018 05:45:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com 0C18D40A626
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1545140739;
        bh=1JbsUTKBwqLyIzAEBWSzPtwAsMQZ0Wi0ux9FzuHQ7jo=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=YOhUZpiTzAlaQbhRjb6mwA6ojc3g9nZ0I1gL0rLyIcoL76WJ3KInoEw7+MCf5xl/i
         Wc6sCwN+nc5aO0B8DKx3CJ9IFqiuCzB/jZpcKeG98bU02aFmGvxcbw8K279eLrU2LB
         D4TO5CAVpjBTekv0O11bV4BosHA88gIY2TzG3Zvw=
Subject: Re: [PATCH] nl80211/cfg80211: Add support to send tx frames at
 specified rate
To:     Johannes Berg <johannes@sipsolutions.net>,
        vamsi krishna <vamsin@codeaurora.org>
References: <1543838646-3574-1-git-send-email-vamsin@codeaurora.org>
 <89e6532daf4011de2ad0df3dcb8accc42334f31e.camel@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
Date:   Tue, 18 Dec 2018 05:45:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <89e6532daf4011de2ad0df3dcb8accc42334f31e.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 12/18/2018 05:12 AM, Johannes Berg wrote:
> On Mon, 2018-12-03 at 17:34 +0530, vamsi krishna wrote:
>> NL80211_CMD_FRAME is used to send frames from userspace. Add support to
>> transmit the frames at a rate specified by userspace when needed.
>> The drivers shall indicate the support to send frames at rate specified
>> by userspace by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE flag in
>> wiphy capabilities. The userspace can specify the rate within
>> %NL80211_ATTR_RATE_INFO attribute while sending %NL80211_CMD_FRAME.
>>
>> NL80211_ATTR_RATE_INFO is a nested attribute and encapsulates the
>> attributes defined in &enum nl80211_rate_info.
>
> It'd be good if you were to repost this with a driver that uses it.
>
> Also, please explain why you think userspace needs this? It's not like
> it can make better rate decisions than the rate control algorithm,
> right?
>
>>  	[NL80211_ATTR_SCHED_SCAN_MIN_RSSI] = { .type = NLA_NESTED },
>> +	[NL80211_ATTR_RATE_INFO] = { .type = NLA_NESTED },
>
> This should use NLA_POLICY_NESTED(nl80211_rate_info_policy)

I missed the first posting of this patch.  Here are some of my own
suggestions.

The wave-2 ath10k firmware has an option to specify tx-power, preamble
(CCK, OFDM, HT, VHT), bandwidth, mcs, nss and retry-count on a per-packet
basis.  This is not enabled in the ath10k driver, and I am not certain QCA
firmware compiles in this option, but I have both ath10k-ct driver and firmware
able to do this currently.

For HT and VHT, the mcs is fairly obvious I think.  For CCK and OFDM, the
mcs is treated as an index into the CCK and OFDM rate tables.

So, maybe the patch could use these basic constructs instead of the
different flags/rates for MCS vs VHT_MCS vs HE_MCS?

Or, do you want to be able to specify multiple different tx rates per
frame?  wave-2 firmware that I have seen wouldn't support that, but I guess newer stuff
could?

Either way, please at least consider adding retry-count and tx-power to this API and I
can tie it into my ath10k-ct driver and firmware API.

As for purpose, I use this for testing, though someone could probably use the
API to make it use a somewhat minimal rate-ctrl in the kernel instead of firmware if they wanted
(ignoring the complexities of MU-MIMO and such).

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
