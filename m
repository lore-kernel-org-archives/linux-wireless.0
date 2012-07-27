Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:62169 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab2G0LpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:45:13 -0400
Message-ID: <50127F46.8030407@tieto.com> (sfid-20120727_134518_266582_BCB6EDF7)
Date: Fri, 27 Jul 2012 13:45:10 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 18/20] mac80211: allow drv_add_chanctx to fail
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>  <1343387816-9414-19-git-send-email-johannes@sipsolutions.net>  <50127E88.6020109@tieto.com> <1343389359.4449.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343389359.4449.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/07/12 13:42, Johannes Berg wrote:
> On Fri, 2012-07-27 at 13:42 +0200, Michal Kazior wrote:
>> On 27/07/12 13:16, Johannes Berg wrote:
>>> --- a/net/mac80211/chan.c
>>> +++ b/net/mac80211/chan.c
>>> @@ -237,7 +237,10 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
>>>
>>>    	list_add(&ctx->list, &local->chanctx_list);
>>>
>>> -	drv_add_chanctx(local, ctx);
>>> +	if (drv_add_chanctx(local, ctx)) {
>>> +		kfree(ctx);
>>
>> We should also do a list_del() here.
>
> Good catch. Or just move the list_add() later?

Yes, that'll work too.


-- Pozdrawiam / Best regards, Michal Kazior.
