Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58100 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1JTPXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 11:23:04 -0400
Message-ID: <4EA03CCF.6090604@candelatech.com> (sfid-20111020_172309_325486_5B42C148)
Date: Thu, 20 Oct 2011 08:22:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211:  Fix off-channel problem in work task.
References: <1319049876-16243-1-git-send-email-greearb@candelatech.com> <20111020145852.GB2293@redhat.com>
In-Reply-To: <20111020145852.GB2293@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/20/2011 07:58 AM, Stanislaw Gruszka wrote:
> On Wed, Oct 19, 2011 at 11:44:36AM -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> The ieee80211_cfg_on_oper_channel method compared the
>> current hardware config as well as the desired hardware
>> config.  In most cases, this is proper, but when deciding
>> whether to go back on-channel, if the hardware is not
>> configured on-channel, but logically it *should* be
>> on-channel, then we must go on-channel.
>>
>> This patch adds a flag to the ieee80211_cfg_on_oper_channel
>> logic to disable comparing the actual hardware so we do not
>> have to create another tricky method with similar logic.
>>
>> Reported-by: Eliad Peller<eliad@wizery.com>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>
> I much more prefer previous one-line patch from Eliad
> http://news.gmane.org/find-root.php?message_id=%3c1311607763%2d12603%2d3%2dgit%2dsend%2demail%2deliad%40wizery.com%3e
>
> this one seems to provide unneeded code complexity, but
> behaviour i.e. number of channel switches in hardware
> is the same.

I believe it's possible to set tmp_channel to NULL and not actually
change the on/off channel configuration, and my patch should allow us to
skip a hardware config in that case.

However, this might only be possible if we are in this code while
scanning, and currently, I don't believe we can be in this work
code while scanning.

So, his patch is probably good enough for now, and if the scanning change
ever happens, we can do something more like what I have.

Thanks,
Ben

>
> Stanislaw
>
>> ---
>>
>> NOTE:  This is tricky stuff, please do not apply until at
>> least Johannes gets time to review this.
>>
>> :100644 100644 4c3d1f5... 40ca484... M	net/mac80211/ieee80211_i.h
>> :100644 100644 d4ee6d2... 3ead637... M	net/mac80211/main.c
>> :100644 100644 397343a... d1b6b29... M	net/mac80211/scan.c
>> :100644 100644 bf5be22... 62a3357... M	net/mac80211/work.c
>>   net/mac80211/ieee80211_i.h |    3 ++-
>>   net/mac80211/main.c        |   13 ++++++++-----
>>   net/mac80211/scan.c        |   10 +++++-----
>>   net/mac80211/work.c        |   11 +++++++----
>>   4 files changed, 22 insertions(+), 15 deletions(-)
>>
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index 4c3d1f5..40ca484 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -1139,7 +1139,8 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
>>   void ieee80211_sched_scan_stopped_work(struct work_struct *work);
>>
>>   /* off-channel helpers */
>> -bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local);
>> +bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local,
>> +				   bool check_current_hw_cfg);
>>   void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
>>   					bool tell_ap);
>>   void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
>> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
>> index d4ee6d2..3ead637 100644
>> --- a/net/mac80211/main.c
>> +++ b/net/mac80211/main.c
>> @@ -94,11 +94,13 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
>>
>>   /*
>>    * Returns true if we are logically configured to be on
>> - * the operating channel AND the hardware-conf is currently
>> - * configured on the operating channel.  Compares channel-type
>> + * the operating channel and channel-type.
>> + * If the check_current_hw_cfg argument is TRUE,
>> + * the currently configured hardware value is checked
>>    * as well.
>>    */
>> -bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
>> +bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local,
>> +				   bool check_current_hw_cfg)
>>   {
>>   	struct ieee80211_channel *chan, *scan_chan;
>>   	enum nl80211_channel_type channel_type;
>> @@ -126,8 +128,9 @@ bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
>>   		return false;
>>
>>   	/* Check current hardware-config against oper_channel. */
>> -	if ((local->oper_channel != local->hw.conf.channel) ||
>> -	    (local->_oper_channel_type != local->hw.conf.channel_type))
>> +	if (check_current_hw_cfg&&
>> +	    ((local->oper_channel != local->hw.conf.channel) ||
>> +	     (local->_oper_channel_type != local->hw.conf.channel_type)))
>>   		return false;
>>
>>   	return true;
>> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
>> index 397343a..d1b6b29 100644
>> --- a/net/mac80211/scan.c
>> +++ b/net/mac80211/scan.c
>> @@ -216,7 +216,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
>>   	 * current channel, pass the pkt on up the stack so that
>>   	 * the rest of the stack can make use of it.
>>   	 */
>> -	if (ieee80211_cfg_on_oper_channel(sdata->local)
>> +	if (ieee80211_cfg_on_oper_channel(sdata->local, true)
>>   	&&  (channel == sdata->local->oper_channel))
>>   		return RX_CONTINUE;
>>
>> @@ -297,7 +297,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
>>   	local->scanning = 0;
>>   	local->scan_channel = NULL;
>>
>> -	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
>> +	on_oper_chan = ieee80211_cfg_on_oper_channel(local, true);
>>
>>   	if (was_hw_scan || !on_oper_chan)
>>   		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>> @@ -309,7 +309,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
>>   		bool on_oper_chan2;
>>   		ieee80211_configure_filter(local);
>>   		drv_sw_scan_complete(local);
>> -		on_oper_chan2 = ieee80211_cfg_on_oper_channel(local);
>> +		on_oper_chan2 = ieee80211_cfg_on_oper_channel(local, true);
>>   		/* We should always be on-channel at this point. */
>>   		WARN_ON(!on_oper_chan2);
>>   		if (on_oper_chan2&&  (on_oper_chan != on_oper_chan2))
>> @@ -509,7 +509,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>>
>>   	next_chan = local->scan_req->channels[local->scan_channel_idx];
>>
>> -	if (ieee80211_cfg_on_oper_channel(local)) {
>> +	if (ieee80211_cfg_on_oper_channel(local, true)) {
>>   		/* We're currently on operating channel. */
>>   		if (next_chan == local->oper_channel)
>>   			/* We don't need to move off of operating channel. */
>> @@ -587,7 +587,7 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
>>   {
>>   	/* switch back to the operating channel */
>>   	local->scan_channel = NULL;
>> -	if (!ieee80211_cfg_on_oper_channel(local))
>> +	if (!ieee80211_cfg_on_oper_channel(local, true))
>>   		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>>
>>   	/*
>> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
>> index bf5be22..62a3357 100644
>> --- a/net/mac80211/work.c
>> +++ b/net/mac80211/work.c
>> @@ -973,7 +973,8 @@ static void ieee80211_work_work(struct work_struct *work)
>>   			bool tmp_chan_changed = false;
>>   			bool on_oper_chan2;
>>   			enum nl80211_channel_type wk_ct;
>> -			on_oper_chan = ieee80211_cfg_on_oper_channel(local);
>> +			on_oper_chan = ieee80211_cfg_on_oper_channel(local,
>> +								     true);
>>
>>   			/* Work with existing channel type if possible. */
>>   			wk_ct = wk->chan_type;
>> @@ -993,7 +994,8 @@ static void ieee80211_work_work(struct work_struct *work)
>>   			 * happen to be on the same channel as
>>   			 * the requested channel.
>>   			 */
>> -			on_oper_chan2 = ieee80211_cfg_on_oper_channel(local);
>> +			on_oper_chan2 = ieee80211_cfg_on_oper_channel(local,
>> +								      true);
>>   			if (on_oper_chan != on_oper_chan2) {
>>   				if (on_oper_chan2) {
>>   					/* going off oper channel, PS too */
>> @@ -1091,7 +1093,7 @@ static void ieee80211_work_work(struct work_struct *work)
>>   	}
>>
>>   	if (!remain_off_channel&&  local->tmp_channel) {
>> -		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local);
>> +		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local, true);
>>   		local->tmp_channel = NULL;
>>   		/* If tmp_channel wasn't operating channel, then
>>   		 * we need to go back on-channel.
>> @@ -1101,7 +1103,8 @@ static void ieee80211_work_work(struct work_struct *work)
>>   		 * we still need to do a hardware config.  Currently,
>>   		 * we cannot be here while scanning, however.
>>   		 */
>> -		if (ieee80211_cfg_on_oper_channel(local)&&  !on_oper_chan)
>> +		if (ieee80211_cfg_on_oper_channel(local, false)&&
>> +		    !on_oper_chan)
>>   			ieee80211_hw_config(local, 0);
>>
>>   		/* At the least, we need to disable offchannel_ps,
>> --
>> 1.7.3.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
