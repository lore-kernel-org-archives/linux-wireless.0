Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaAFTJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 14:09:47 -0500
Message-ID: <1389035380.5891.42.camel@jlt4.sipsolutions.net> (sfid-20140106_200950_388788_136CF989)
Subject: Re: [PATCH v3 1/2] mac80211_hwsim: fix duplicate beacons on TSF
 adjust
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Mon, 06 Jan 2014 20:09:40 +0100
In-Reply-To: <1387477515-3583-1-git-send-email-twpedersen@gmail.com> (sfid-20131219_192631_841541_A85E52B4)
References: <1387477515-3583-1-git-send-email-twpedersen@gmail.com>
	 (sfid-20131219_192631_841541_A85E52B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-19 at 10:25 -0800, Thomas Pedersen wrote:
> There was some bug when rescheduling the next beacon from
> the beacon tasklet after adjusting TSF which would cause
> the beacon timer to trigger twice. Beaconing at "old" TBT
> (previously scheduled interface TBTT) with new timestamp
> was incorrect anyway.
> 
> Instead, reschedule the beacon straight away when
> adjusting TSF.
> 
> Signed-off-by: Thomas Pedersen <twpedersen@gmail.com>
> 
> ---
> v2:
> 
> 	don't kill hrtimer tasklet if currently running to
> 	avoid deadlock (Johannes)
> 
>  drivers/net/wireless/mac80211_hwsim.c |   57 +++++++++++++++------------------
>  1 file changed, 26 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 9c0cc8d..cf3b9d3 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -442,17 +442,36 @@ static u64 mac80211_hwsim_get_tsf(struct ieee80211_hw *hw,
>  	return le64_to_cpu(__mac80211_hwsim_get_tsf(data));
>  }
>  
> +static void mac80211_hwsim_beacon_sched(struct ieee80211_hw *hw)
> +{
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	u64 tsf = mac80211_hwsim_get_tsf(hw, NULL);
> +	u32 bcn_int = data->beacon_int;
> +	u64 until_tbtt;
> +
> +	if (!bcn_int)
> +		return;
> +
> +	until_tbtt = bcn_int - do_div(tsf, bcn_int);
> +	if (!hrtimer_callback_running(&data->beacon_timer.timer) &&
> +	    !test_bit(TASKLET_STATE_RUN, &data->beacon_timer.tasklet.state))
> +		tasklet_hrtimer_cancel(&data->beacon_timer);

That test_bit() really seems suspicious - there are no other users in
the tree except for the internal tasklet code... What are you trying to
do?

johannes

