Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbeIFFjC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 01:39:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 05 Sep 2018 18:06:14 -0700
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Subject: Re: [PATCH v2 2/3] mac80211: support FTM responder
 configuration/statistics
In-Reply-To: <1535967225.3437.27.camel@sipsolutions.net>
References: <1535745418-31336-1-git-send-email-pradeepc@codeaurora.org>
 <1535745418-31336-3-git-send-email-pradeepc@codeaurora.org>
 <1535967225.3437.27.camel@sipsolutions.net>
Message-ID: <f6cb4548de9c5ca228124df1301d2aa0@codeaurora.org> (sfid-20180906_030709_228515_06675F16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-03 02:33, Johannes Berg wrote:
> On Fri, 2018-08-31 at 12:56 -0700, Pradeep Kumar Chitrapu wrote:
>> 
>> + * @ftm_responder: whether to enable fine timing measurement FTM 
>> functionality
> 
> missing "responder" somewhere there :)
> 
>> + * @ftmr_params: configurable lci/civic parameter when enabling FTM 
>> responder.
> 

Hi Johannes,

Thanks for the review..
> Perhaps the *existence* of ftmr_params could indicate that it's 
> enabled?
My understanding is these are only optional parameters. So, I have kept 
ftm_responder
separate from params.
I have tried to fix other review comments and posted v3 patch set.
Please let me know your comments.

Thanks
Pradeep

> 
>> @@ -865,6 +899,20 @@ static int ieee80211_assign_beacon(struct 
>> ieee80211_sub_if_data *sdata,
>>  	if (err == 0)
>>  		changed |= BSS_CHANGED_AP_PROBE_RESP;
>> 
>> +	if (params->ftm_responder) {
> 
> Here you immediately have the problem I talked about in the earlier
> patch ... yes, we don't have drivers that allow disabling it (so should
> probably reject that now), but without it you can *enable* it on the
> fly, but you cannot *disable*, in fact we assume saying "disable" means
> "no change" which is rather confusing.
> 
> johannes
