Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37383 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756086AbcKVUPX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 15:15:23 -0500
Received: by mail-wm0-f48.google.com with SMTP id t79so44617016wmt.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 12:15:23 -0800 (PST)
Subject: Re: [PATCH] nl80211: provide minimum scheduled scan (plan) interval
To: Johannes Berg <johannes@sipsolutions.net>
References: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com>
 <1479821915.9021.4.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5c249c34-5e8c-093a-c5df-3507cabc8872@broadcom.com> (sfid-20161122_211527_438755_D2DEAA3B)
Date: Tue, 22 Nov 2016 21:06:30 +0100
MIME-Version: 1.0
In-Reply-To: <1479821915.9021.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-11-2016 14:38, Johannes Berg wrote:
> 
>> +		if (wiphy->min_sched_scan_plan_interval &&
>> +		    request->scan_plans[i].interval <
>> +		    wiphy->min_sched_scan_plan_interval)
>> +			return -EINVAL;
>>
> I'm not sure we should break the API that way - just move it up if it's
> smaller?

Are we? Currently, the minimum is not checked in nl80211, but that does
not say anything about the driver which might validate the interval as
well and return an error.

What made me start looking at this is that in brcmfmac the interval in
the request was ignored and a fixed interval was provisioned in the
device. I wanted to fix that but was not sure if I needed to check it
against our firmware min..max range and what the appropriate error
handling should be. If silently changing what user-space is requesting
is fine for this, I am happy to make it so. Preferably in nl80211.

Regards,
Arend
