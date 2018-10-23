Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EEBC46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 20:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79F78205F4
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 20:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79F78205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbeJXErE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 00:47:04 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:35482 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbeJXErE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 00:47:04 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id CF71B40A5ED;
        Tue, 23 Oct 2018 13:22:04 -0700 (PDT)
Subject: Re: Should we check netif_running in cfg80211_calculate_bi_data?
To:     Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <8c876445-a065-ddb2-4dcf-e922f22a1b7d@candelatech.com>
 <7ac1d7a5f25ebcd44107c3a19e0d8140f37227c6.camel@sipsolutions.net>
 <5e048867-0294-4218-6b2b-bcbcad5be763@candelatech.com>
 <5d6d273615166550749ae68b6eb2ab37f8265b06.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <52037f15-c48f-52fd-255b-dbd6f094ce17@candelatech.com>
Date:   Tue, 23 Oct 2018 13:22:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <5d6d273615166550749ae68b6eb2ab37f8265b06.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/23/2018 12:53 PM, Johannes Berg wrote:
> On Tue, 2018-10-23 at 12:19 -0700, Ben Greear wrote:
>>
>> Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: Assigning beacon-in-gcd to: 240 from wdev: vap39
>> Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: beacon-int-diff, beacon-int-gcd: 240  new-beacon-int: 100
>
> This new-beacon-int 100 seems strange and suspicious. Why is it even
> trying to look at this? Hmm.
>
>> Maybe we need to clear beacon-interval back to 0 on admin down of the wifi dev?
>
> We should be doing this, we should end up in __cfg80211_stop_ap() and
> that does clear it? Hmm... perhaps this _fails_ somehow, and we don't
> clear it in the error path? I suppose we really should make that
> unconditional because there's nothing we can do to recover from that
> error ...

I am suspicious about this...  that is not the same memory location as wdev->beacon_interval,
so maybe this is the thing that is not properly cleared?

if (sdata->vif.type == NL80211_IFTYPE_AP ||
	    sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
		/*
		 * always passing this is harmless, since it'll be the
		 * same value that cfg80211 finds if it finds the same
		 * interface ... and that's always allowed
		 */
		params.new_beacon_int = sdata->vif.bss_conf.beacon_int;
	}

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

