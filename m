Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:55942 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab2FYGyD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 02:54:03 -0400
Message-ID: <4FE80B0B.3000503@tieto.com> (sfid-20120625_085407_547941_341F09E2)
Date: Mon, 25 Jun 2012 08:54:03 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 7/7] mac80211: reuse channels for channel context
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>  <1340280216-18807-8-git-send-email-michal.kazior@tieto.com> <1340285187.4489.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340285187.4489.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-06-21 at 14:03 +0200, Michal Kazior wrote:
>
>> +		if (!ieee80211_channel_types_are_compatible(ctx->conf.channel_type,
>> +							    channel_type,
>> +							&compat_type))
>> +			continue;
>> +		if (ctx->conf.channel_type != compat_type) {
>> +			ctx->conf.channel_type = compat_type;
>> +			drv_change_chantype(local, ctx);
>> +		}
>
> Maybe somehow there's a need to also keep track of the desired channel
> type per vif so it can be recalculated when a vif is removed, not just
> when one is added?

Sounds good.


-- 
Pozdrawiam / Best regards, Michal Kazior.
