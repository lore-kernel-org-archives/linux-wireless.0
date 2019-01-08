Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364EBC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B3662070B
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K9pWPNpZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K9pWPNpZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfAHRtp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:49:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbfAHRtn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 12:49:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C2A70606FC; Tue,  8 Jan 2019 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546969781;
        bh=eIqLSdqLaHzWwTX8XWQRMZumIOfBPpnWQ5d3q2/75h0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K9pWPNpZvNlnCFmvbPSn+cSzau01vwfR0gOZ0wtkGYjBXAeDIousdB3VckRfScW+b
         W7uBZYWItO5c/fe32JSbX49obnoyGizq680WAqhdiqvIsIefctVJulbtZ3tvDCjx2s
         bnbE5TCRoK/Z+YiZitXZ8gwgaueY2UTBCjzbTD2Y=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 0367960591;
        Tue,  8 Jan 2019 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546969781;
        bh=eIqLSdqLaHzWwTX8XWQRMZumIOfBPpnWQ5d3q2/75h0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K9pWPNpZvNlnCFmvbPSn+cSzau01vwfR0gOZ0wtkGYjBXAeDIousdB3VckRfScW+b
         W7uBZYWItO5c/fe32JSbX49obnoyGizq680WAqhdiqvIsIefctVJulbtZ3tvDCjx2s
         bnbE5TCRoK/Z+YiZitXZ8gwgaueY2UTBCjzbTD2Y=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 08 Jan 2019 23:19:40 +0530
From:   vamsin@codeaurora.org
To:     Ben Greear <greearb@candelatech.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, jouni@codeaurora.org
Subject: Re: [PATCH] nl80211/cfg80211: Add support to send tx frames at
 specified rate
In-Reply-To: <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
References: <1543838646-3574-1-git-send-email-vamsin@codeaurora.org>
 <89e6532daf4011de2ad0df3dcb8accc42334f31e.camel@sipsolutions.net>
 <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
Message-ID: <63224d0fc1e978624de9887cb7349c02@codeaurora.org>
X-Sender: vamsin@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-18 19:15, Ben Greear wrote:
> On 12/18/2018 05:12 AM, Johannes Berg wrote:
>> On Mon, 2018-12-03 at 17:34 +0530, vamsi krishna wrote:
>>> NL80211_CMD_FRAME is used to send frames from userspace. Add support 
>>> to
>>> transmit the frames at a rate specified by userspace when needed.
>>> The drivers shall indicate the support to send frames at rate 
>>> specified
>>> by userspace by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE flag in
>>> wiphy capabilities. The userspace can specify the rate within
>>> %NL80211_ATTR_RATE_INFO attribute while sending %NL80211_CMD_FRAME.
>>> 
>>> NL80211_ATTR_RATE_INFO is a nested attribute and encapsulates the
>>> attributes defined in &enum nl80211_rate_info.
>> 
>> It'd be good if you were to repost this with a driver that uses it.
Unfortunately, the driver that I am working now is not upstreamed. I 
would like to check with Ben if he likes to propose a patch ath10k 
driver that he is working on as I see he is also interested in this 
feature. Please let me know if it is mandatory or good to have driver 
implementation.

>> 
>> Also, please explain why you think userspace needs this? It's not like
>> it can make better rate decisions than the rate control algorithm,
>> right?
Yes, you are correct. Rate control algorithm will continue to be in the 
lower layers only. This is mostly for testing and experimenting 
purposes.

>> 
>>>  	[NL80211_ATTR_SCHED_SCAN_MIN_RSSI] = { .type = NLA_NESTED },
>>> +	[NL80211_ATTR_RATE_INFO] = { .type = NLA_NESTED },
>> 
>> This should use NLA_POLICY_NESTED(nl80211_rate_info_policy)
Thanks for pointing out this MACRO, I used it in my new version of the 
patch.

> 
> I missed the first posting of this patch.  Here are some of my own
> suggestions.
> 
> The wave-2 ath10k firmware has an option to specify tx-power, preamble
> (CCK, OFDM, HT, VHT), bandwidth, mcs, nss and retry-count on a 
> per-packet
> basis.  This is not enabled in the ath10k driver, and I am not certain 
> QCA
> firmware compiles in this option, but I have both ath10k-ct driver and 
> firmware
> able to do this currently.
> 
> For HT and VHT, the mcs is fairly obvious I think.  For CCK and OFDM, 
> the
> mcs is treated as an index into the CCK and OFDM rate tables.
> 
> So, maybe the patch could use these basic constructs instead of the
> different flags/rates for MCS vs VHT_MCS vs HE_MCS?
I am not sure if I understand your comment correctly. If you are 
proposing to remove the different attribute ids for MCS, VHT_MCS and 
HE_MCS, I think that will lead to unnecessary confusion especially as we 
have duplicate indices between different modes(for example between HT 
and VHT). I believe it is better to keep this similar to reporting tx 
and rx rates in NL80211_CMD_GET_STATION in order to avoid problems with 
future technologies like EHT.


> Or, do you want to be able to specify multiple different tx rates per
> frame?  wave-2 firmware that I have seen wouldn't support that, but I
> guess newer stuff
> could?
My intention is to add single rate only.

> Either way, please at least consider adding retry-count and tx-power
> to this API and I
> can tie it into my ath10k-ct driver and firmware API.
Sure, I have added them in the newer version of the patch.

Though I used in-reply-to option with git send-email, still the patch 
that I sent is coming in a new thread @ 
https://patchwork.kernel.org/patch/10752599/ . I am not sure if that is 
because of subject change, I had to change the subject of the patch in 
order to reflect the new additions done to the patch. Could you please 
kindly guide me with the right process to send the new patch.

Thanks,
Vamsi
