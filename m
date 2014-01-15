Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:35256 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaAOR4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 12:56:06 -0500
Received: by mail-qe0-f50.google.com with SMTP id 1so1408912qec.23
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 09:56:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389035380.5891.42.camel@jlt4.sipsolutions.net>
References: <1387477515-3583-1-git-send-email-twpedersen@gmail.com> <1389035380.5891.42.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <twpedersen@gmail.com>
Date: Wed, 15 Jan 2014 09:55:45 -0800
Message-ID: <CAHmEv86K7br1c0ES1N0dWeAoPfJaaiy8+rAXAjoiUOwophhY_A@mail.gmail.com> (sfid-20140115_185624_272025_3E931B84)
Subject: Re: [PATCH v3 1/2] mac80211_hwsim: fix duplicate beacons on TSF adjust
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 6, 2014 at 11:09 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2013-12-19 at 10:25 -0800, Thomas Pedersen wrote:
>> There was some bug when rescheduling the next beacon from
>> the beacon tasklet after adjusting TSF which would cause
>> the beacon timer to trigger twice. Beaconing at "old" TBT
>> (previously scheduled interface TBTT) with new timestamp
>> was incorrect anyway.
>>
>> Instead, reschedule the beacon straight away when
>> adjusting TSF.
>>
>> Signed-off-by: Thomas Pedersen <twpedersen@gmail.com>
>>
>> ---
>> v2:
>>
>>       don't kill hrtimer tasklet if currently running to
>>       avoid deadlock (Johannes)
>>
>>  drivers/net/wireless/mac80211_hwsim.c |   57 +++++++++++++++------------------
>>  1 file changed, 26 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
>> index 9c0cc8d..cf3b9d3 100644
>> --- a/drivers/net/wireless/mac80211_hwsim.c
>> +++ b/drivers/net/wireless/mac80211_hwsim.c
>> @@ -442,17 +442,36 @@ static u64 mac80211_hwsim_get_tsf(struct ieee80211_hw *hw,
>>       return le64_to_cpu(__mac80211_hwsim_get_tsf(data));
>>  }
>>
>> +static void mac80211_hwsim_beacon_sched(struct ieee80211_hw *hw)
>> +{
>> +     struct mac80211_hwsim_data *data = hw->priv;
>> +     u64 tsf = mac80211_hwsim_get_tsf(hw, NULL);
>> +     u32 bcn_int = data->beacon_int;
>> +     u64 until_tbtt;
>> +
>> +     if (!bcn_int)
>> +             return;
>> +
>> +     until_tbtt = bcn_int - do_div(tsf, bcn_int);
>> +     if (!hrtimer_callback_running(&data->beacon_timer.timer) &&
>> +         !test_bit(TASKLET_STATE_RUN, &data->beacon_timer.tasklet.state))
>> +             tasklet_hrtimer_cancel(&data->beacon_timer);
>
> That test_bit() really seems suspicious - there are no other users in
> the tree except for the internal tasklet code... What are you trying to
> do?

I'm trying to avoid calling tasklet_hrtimer_cancel() recursively, that
is, when mac80211_hwsim_beacon_sched() is called from within the
hrtimer tasklet itself. Looking at it again this does seem ugly. Would
it be acceptable to pass a flag to _beacon_sched() indicating whether
a reschedule is taking place from within the tasklet? We could also
have a mac80211_hwsim_beacon_sched() (which would cance the hrtimer
tasklet) and __mac80211_hwsim_beacon_sched() pair, but I'm not sure if
that nomenclature applies here.

Thanks for reviewing.
Thomas
