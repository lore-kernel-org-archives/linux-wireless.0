Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60558 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050Ab3BHKJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 05:09:21 -0500
Received: by mail-bk0-f48.google.com with SMTP id jf20so1576651bkc.21
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 02:09:20 -0800 (PST)
Message-ID: <5114CECD.2040508@cozybit.com> (sfid-20130208_110926_807221_CFEFAAAE)
Date: Fri, 08 Feb 2013 11:09:17 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFCv2 2/3] mac80211: mesh power save doze scheduling
References: <1360151325-6368-1-git-send-email-marco@cozybit.com>  <1360151325-6368-3-git-send-email-marco@cozybit.com>  (sfid-20130206_124915_323291_448699F4) <1360315234.29851.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360315234.29851.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2013 10:20 AM, Johannes Berg wrote:
> On Wed, 2013-02-06 at 12:48 +0100, Marco Porsch wrote:
>
>> For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
>> a timer which triggers a doze call on expiry.
>
> That seems questionable -- drivers are not required to request each
> beacon. I know you only want to make it work on ath9k, but I don't think
> "stretching" the API, without even documenting it, is a good idea.

Currently, we already use ieee80211_beacon_get_tim as time reference for 
mesh sync's adjust_tbtt. And, as far as I know, all mesh-capable drivers 
use the call for each and every beacon.
So what would you recommend: keep using beacon_get and adding 
documentation - or - creating an exported callback for awake_window_start?

>> +static inline void mps_queue_work(struct ieee80211_sub_if_data *sdata,
>> +				  enum mesh_deferred_task_flags flag)
>> +{
>> +	set_bit(flag, &sdata->u.mesh.wrkq_flags);
>> +	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
>> +}
>
> Doing any sort of wakeup from here is also undesirable -- the workqueue
> might actually sometimes be blocked for quite a while, I believe.

Yeah, right. Now that the hrtimer stuff is gone, I will check if the 
remaining contexts allows skipping the work queue for wakeups.

>> +/**
>> + * ieee80211_mps_hw_conf - check conditions for mesh PS and configure driver
>> + *
>> + * @sdata: local mesh subif
>> + */
>> +void ieee80211_mps_hw_conf(struct ieee80211_sub_if_data *sdata)
>> +{
>> +	struct ieee80211_local *local = sdata->local;
>> +	bool enable;
>> +
>> +	enable = mps_hw_conf_check(local);
>> +
>> +	if (local->mps_enabled == enable)
>> +		return;
>> +
>> +	if (enable) {
>> +		mps_hw_conf_sta_prepare(local);
>> +		local->hw.conf.flags |= IEEE80211_CONF_PS;
>> +	} else {
>> +		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
>> +	}
>> +
>> +	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>
> For some reason I thought this was supposed to be covered by the new
> mesh PS callbacks, why do you still need hw conf?
>
> Or wait -- this is only for general enable/disable, depending on the
> other interfaces? I guess that's ok.
>
>> +	/* simple Deep Sleep implementation: only wake up for DTIM beacons */
>> +	if (sta->local_pm == NL80211_MESH_POWER_DEEP_SLEEP)
>> +		skip = tim->dtim_count ? tim->dtim_count : tim->dtim_period;
>> +	/*
>> +	 * determine time to peer TBTT (TSF % beacon_interval = 0).
>> +	 * This approach is robust to delayed beacons.
>> +	 */
>> +	tsf_peer = tsf_local + sta->t_offset;
>> +	nexttbtt_interval = sta->beacon_interval * skip -
>> +			do_div(tsf_peer, sta->beacon_interval * skip);
>> +
>> +	mps_dbg(sta->sdata, "updating %pM next TBTT in %dus (%lldus awake)\n",
>> +		sta->sta.addr, nexttbtt_interval,
>> +		(long long) tsf_local - sta->nexttbtt_tsf);
>> +
>> +	sta->nexttbtt_tsf = tsf_local + nexttbtt_interval;
>> +	sta->nexttbtt_jiffies = jiffies + usecs_to_jiffies(nexttbtt_interval);
>> +
>> +	mod_timer(&sta->nexttbtt_timer, sta->nexttbtt_jiffies +
>> +			usecs_to_jiffies(BEACON_TIMEOUT));
>
> Is that some sort of recovery? jiffies can be up to 20ms (I think, in
> that order of magnitude anyway) inaccurate.

Yeah, that timer just hits as recovery in case a beacon is not received. 
Then it projects the next TBTT and goes to sleep again.

Thanks,
--Marco

