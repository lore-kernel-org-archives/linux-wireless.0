Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732534AbeHPEnO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 00:43:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 15 Aug 2018 18:48:18 -0700
From: pradeepc@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] nl80211: add support to configure FTM responder
 functionality
In-Reply-To: <1534334948.3547.39.camel@sipsolutions.net>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
 <1534293018-4930-2-git-send-email-pradeepc@codeaurora.org>
 <1534334948.3547.39.camel@sipsolutions.net>
Message-ID: <15c381ce743aedca37f3eea67975f841@codeaurora.org> (sfid-20180816_034823_111864_DCEB0CD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-15 05:09, Johannes Berg wrote:
> On Tue, 2018-08-14 at 17:30 -0700, Pradeep Kumar Chitrapu wrote:
>> 
>> +	int ftm_responder;
> 
> bool
> 
>> + * @NL80211_ATTR_FTM_RESPONDER: attribute which user-space can 
>> include in
>> + *	%NL80211_CMD_START_AP to enable(1) or disable(0) fine timing 
>> measurement
>> + *	(FTM) responder functionality.  If not set, it means don't care 
>> and
>> + *	the device will decide what to use.
> 
> Why 0/1 instead of a flag attribute?
Using FLAG attribute may create uncertainty to userspace especially when 
flag attribute
is not set and the driver supports capability, instead of 
assuming/relying on the default
behavior of driver/firmware.

> 
> Also, I think you need the attributes (LCI/Civic location)?
> 
> johannes
