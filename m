Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53461 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1AUEjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 23:39:10 -0500
Message-ID: <4D390DE6.8030507@candelatech.com>
Date: Thu, 20 Jan 2011 20:39:02 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/3] mac80211: Support scanning only current active channel.
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com> <1295547439.3693.46.camel@jlt3.sipsolutions.net> <4D387D25.7080902@candelatech.com> <201101202014.51161.helmut.schaa@googlemail.com>
In-Reply-To: <201101202014.51161.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2011 11:14 AM, Helmut Schaa wrote:
> Am Donnerstag, 20. Januar 2011 schrieb Ben Greear:
>> On 01/20/2011 10:17 AM, Johannes Berg wrote:
>>> Yeah, so maybe it needs some re-work, but I think what you're doing is a
>>> pretty strange hack.
>>
>> If you have time to write some patches, I'll be happy to test them on
>> our ath9k and ath5k systems.
>
> Try this, I only ran a quick test with iwlagn (disable_hw_scan=1), seems to
> work fine. However, I did not think much about it yet ;)

I think it has a few issues, but might be moving in the right direction.

First, it doesn't deal with not calling change-channel on scan completion
if we never left the operating channel.  And doesn't mitigate the off-channel
call when scanning starts.

> @@ -534,6 +536,21 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>   static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
>   						    unsigned long *next_delay)
>   {
> +	struct ieee80211_channel *chan;
> +	chan = local->scan_req->channels[local->scan_channel_idx];
> +
> +	/* remember when we left the operating channel */
> +	local->leave_oper_channel_time = jiffies;
> +
> +	/* advance to the next channel to be scanned */
> +	local->next_scan_state = SCAN_SET_CHANNEL;
> +
> +	/* Scanning operating channel, take the shortcut */
> +	if (chan == local->oper_channel) {
> +		*next_delay = 0;
> +		return;
> +	}

I think here you might need to compare against the current channel, which could be
one we are scanning on before we scan the operating channel, not the oper_channel.


>   static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *local,
> @@ -583,8 +594,10 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
>   	chan = local->scan_req->channels[local->scan_channel_idx];
>
>   	local->scan_channel = chan;
> -	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
> -		skip = 1;
> +
> +	if (chan != local->oper_channel)
> +		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
> +			skip = 1;

Same problem here I think.

I may be mis-understanding what oper_channel implies, however.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
