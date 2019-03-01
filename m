Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C039C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 17:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B2A720850
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 17:21:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="UiJfBRnX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388088AbfCARVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:21:38 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:52742 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfCARVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 12:21:38 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id AF11740AC0B;
        Fri,  1 Mar 2019 09:21:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com AF11740AC0B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1551460894;
        bh=H60/ozrynDdLs3ad4a6bh2WwYN92bogenaOzECF4KGU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UiJfBRnX0IKa0b3Zwqq0zOk6WCa+d8hj+y4tFqfs6X1bypvepax8hPLjFxWk/7Hwm
         baTfcRotrCs3EaaCS6E3kxllCHUOTmMEz2muBKRlhsCNsdUhxg8ezV+oFwQjjdqcVS
         eWkuTrqhFY4Kqn48aibJAe48z1a6Hbrw7GB3MFfA=
Subject: Re: [PATCH] mac80211: do not call driver wake_tx_queue op during
 reconfig
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
References: <20190301134837.88087-1-nbd@nbd.name>
 <09a12ed0-dd86-2077-9ecb-c62a52186952@candelatech.com>
 <c39a8e18-4a6b-a4db-3b25-c7d9d417d247@nbd.name>
 <3bc506d5-8432-56d4-8588-afe7dea2eba3@nbd.name>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <27da2e1d-9086-2329-e2fc-fc4b0cdd13af@candelatech.com>
Date:   Fri, 1 Mar 2019 09:21:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3bc506d5-8432-56d4-8588-afe7dea2eba3@nbd.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/1/19 8:13 AM, Felix Fietkau wrote:
> On 2019-03-01 17:06, Felix Fietkau wrote:
>> On 2019-03-01 16:29, Ben Greear wrote:
>>> On 3/1/19 5:48 AM, Felix Fietkau wrote:
>>>> There are several scenarios in which mac80211 can call drv_wake_tx_queue
>>>> after ieee80211_restart_hw has been called and has not yet completed.
>>>> Driver private structs are considered uninitialized until mac80211 has
>>>> uploaded the vifs, stations and keys again, so using private tx queue
>>>> data during that time is not safe.
>>>>
>>>> The driver can also not rely on drv_reconfig_complete to figure out when
>>>> it is safe to accept drv_wake_tx_queue calls again, because it is only
>>>> called after all tx queues are woken again.
>>>>
>>>> To fix this, bail out early in drv_wake_tx_queue if local->in_reconfig
>>>> is set.
>>>
>>> This reminded me of a patch I posted back in 2016.  The discussion just sort of
>>> ended on it, but curious if you have a new opinion on it after debugging the
>>> issue in this patch:
>>>
>>> https://patchwork.kernel.org/patch/9457709/
>>>
>>> For what its worth, I've been using the patch above since I posted it, and
>>> it seems to work well for ath9k and ath10k.
>> I agree with what Johannes wrote about that patch. Fixing this could
>> likely be as simple as clearing IEEE80211_SDATA_IN_DRIVER on all
>> interfaces before bringing any of them back up. That way the normal
>> interface add logic applies without nasty special cases.
>> The reconfig code checks for ieee80211_sdata_running (which is
>> unaffected), so I don't think we need to save the previous value of that
>> flag.
> How about this? (untested)
> ---
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1956,7 +1956,6 @@ static void ieee80211_flush_completed_scan(struct ieee80211_local *local,
>   
>   static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
>   {
> -	struct ieee80211_sub_if_data *sdata;
>   	struct ieee80211_chanctx *ctx;
>   
>   	/*
> @@ -1980,9 +1979,6 @@ static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
>   	 */
>   	ieee80211_sched_scan_end(local);
>   
> -	list_for_each_entry(sdata, &local->interfaces, list)
> -		sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
> -
>   	/* Mark channel contexts as not being in the driver any more to avoid
>   	 * removing them from the driver during the shutdown process...
>   	 */
> @@ -2135,6 +2131,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>   
>   	local->started = false;
>   
> +	list_for_each_entry(sdata, &local->interfaces, list)
> +		sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
> +
>   	/*
>   	 * Upon resume hardware can sometimes be goofy due to
>   	 * various platform / driver / bus issues, so restarting
> 

Let me see if anyone (Johannes?) has comments on this...  I can test it out
a bit later if no one suggests changes.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

