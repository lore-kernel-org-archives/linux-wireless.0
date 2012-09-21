Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50861 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2IUJQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 05:16:54 -0400
Message-ID: <505C3083.9090408@qca.qualcomm.com> (sfid-20120921_111659_065807_F8393C4D)
Date: Fri, 21 Sep 2012 12:16:51 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/3] ath6kl: Check for valid rate table index
References: <1348122068-24648-1-git-send-email-rmani@qca.qualcomm.com> <1348122068-24648-2-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1348122068-24648-2-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2012 09:21 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> There are 28 items defined in rate table array 'wmi_rate_tbl'.
> The rate table index (reply->rate_index) in ath6kl_wmi_bitrate_reply_rx()
> func is not checked for the valid max limit index before accessing
> rate table array. There may be some incidents to get memory crashes
> without safe max check. Fix this.
> 
> Found this on code review.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/wmi.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index d5263ff..666f56d 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -1171,6 +1171,9 @@ static int ath6kl_wmi_bitrate_reply_rx(struct wmi *wmi, u8 *datap, int len)
>  		rate = RATE_AUTO;
>  	} else {
>  		index = reply->rate_index & 0x7f;
> +		if (index > (RATE_MCS_7_40 + 1))
> +			return -EINVAL;

Please add WARN_ON_ONCE() to catch this easily:

if (WARN_ON_ONCE(index > (RATE_MCS_7_40 + 1)))
	return -EINVAL;

Kalle
