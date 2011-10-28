Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab1J1MUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 08:20:03 -0400
Message-ID: <4EAA9DDC.5090909@qca.qualcomm.com> (sfid-20111028_142008_413740_631CBF87)
Date: Fri, 28 Oct 2011 15:19:40 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/7] ath6kl: Add wmi functions to configure wow mode and
 host sleep mode
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <1319539047-8756-3-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1319539047-8756-3-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2011 01:37 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Empty commit log.

> +static void ath6kl_wmi_relinquish_implicit_pstream_credits(struct wmi *wmi)
> +{
> +	u16 active_tsids;
> +	u8 stream_exist;
> +	int i;
> +
> +	/*
> +	 * Relinquish credits from all implicitly created pstreams
> +	 * since when we go to sleep. If user created explicit
> +	 * thinstreams exists with in a fatpipe leave them intact
> +	 * for the user to delete.
> +	 */
> +	spin_lock_bh(&wmi->lock);
> +	stream_exist = wmi->fat_pipe_exist;
> +	spin_unlock_bh(&wmi->lock);
> +
> +	for (i = 0; i < WMM_NUM_AC; i++) {
> +		if (stream_exist & (1 << i)) {
> +
> +			spin_lock_bh(&wmi->lock);
> +			active_tsids = wmi->stream_exist_for_ac[i];
> +			spin_unlock_bh(&wmi->lock);
> +
> +			/*
> +			 * If there are no user created thin streams
> +			 * delete the fatpipe
> +			 */
> +			if (!active_tsids) {
> +				stream_exist &= ~(1 << i);
> +				/*
> +				 * Indicate inactivity to driver layer for
> +				 * this fatpipe (pstream)
> +				 */
> +				ath6kl_indicate_tx_activity(wmi->parent_dev,
> +							    i, false);
> +			}
> +		}
> +	}
> +
> +	spin_lock_bh(&wmi->lock);
> +	wmi->fat_pipe_exist = stream_exist;
> +	spin_unlock_bh(&wmi->lock);

The locking here doesn't really make sense. For example, any changes to
wmi->fat_pipe_exist during the for loop will be overwritten. Also lock
handling with wmi->stream_exist_for_ac[i] looks fishy.

> +int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi,
> +				  struct wmi_set_host_sleep_mode_cmd *host_mode)

Don't use the struct as a parameter, you could instead provide an enum
like this:

enum ath6kl_host_mode {
	ATH6KL_HOST_MODE_AWAKE,
	ATH6KL_HOST_MODE_ASLEEP,
};

> +{
> +	struct sk_buff *skb;
> +	struct wmi_set_host_sleep_mode_cmd *cmd;
> +	int ret;
> +
> +	if (host_mode->awake == host_mode->asleep)
> +		return -EINVAL;

...and then you can remove this test.

> +int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi,
> +				struct wmi_set_wow_mode_cmd *wow_mode)

I'm sure you can guess what I'm about to say here ;)

Kalle
