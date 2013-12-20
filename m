Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58888 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab3LTN52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 08:57:28 -0500
Message-ID: <52B44CA8.9090601@candelatech.com> (sfid-20131220_145731_620789_97B76EDC)
Date: Fri, 20 Dec 2013 05:56:56 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2] ath10k: implement sta_rc_update()
References: <87li09ga42.fsf@kamboji.qca.qualcomm.com> <1387361479-21289-1-git-send-email-michal.kazior@tieto.com> <8761qj3js8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8761qj3js8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2013 02:21 AM, Kalle Valo wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This should fix possible connectivity issues upon
>> changes of channel width, number of streams or
>> SMPS on connected stations.
>>
>> An example trigger would be an action frame with
>> operation mode change notification.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
>> +				 struct ieee80211_vif *vif,
>> +				 struct ieee80211_sta *sta,
>> +				 u32 changed)
>> +{
>> +	struct ath10k *ar = hw->priv;
>> +	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
>> +	u32 chwidth, smps;
>> +	int ret;
>> +
>
> [...]
>
>> +		ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
>> +						WMI_PEER_CHAN_WIDTH, chwidth);
>
> Johannes pointed out (danke!) that sta_rc_update() must be atomic, but
> all these WMI calls can sleep.

Another thing I have noticed, but have not had time to think much about,
is that when the firmware gets out of sync for whatever reason, it can
start just ignoring wmi commands and everything times out.  Trying to
remove station vifs that are not currently in the firmware, perhaps due
to firmware crash, is a good way to hit this.

The system has very slow response to any number of things that
might require rtnl (or probably other locks).  I think we are basically
holding rtnl or other large-scale locks through the wmi calls.

I think a good long-term solution would be to make the firmware smart enough
to return error codes instead of just ignoring (or crashing on) requests it
cannot properly handle.  Maybe handling the wmi commands in a more
asynchronous manner might be a good strategy in the driver...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

