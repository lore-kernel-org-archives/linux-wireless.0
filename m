Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38722 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729634AbeGaTTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 15:19:22 -0400
Subject: Re: [PATCHv2] ath10k : Fix channel survey dump
To: Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        ath10k@lists.infradead.org
References: <1533039077-1532-1-git-send-email-vnaralas@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <3dd6d368-e54e-d8ba-d538-c48617a575b9@candelatech.com> (sfid-20180731_193804_207264_CD3549DB)
Date: Tue, 31 Jul 2018 10:37:58 -0700
MIME-Version: 1.0
In-Reply-To: <1533039077-1532-1-git-send-email-vnaralas@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2018 05:11 AM, Venkateswara Naralasetty wrote:
> Channel active/busy time are showing incorrect(less than previous or
> sometimes zero) for successive survey dump command.
>
> example:
> Survey data from wlan0
> 	frequency:                      5180 MHz [in use]
> 	channel active time:            54995 ms
> 	channel busy time:              432 ms
> 	channel receive time:           0 ms
> 	channel transmit time:          59 ms
> Survey data from wlan0
> 	frequency:                      5180 MHz [in use]
> 	channel active time:            32592 ms
> 	channel busy time:              254 ms
> 	channel receive time:           0 ms
> 	channel transmit time:          0 ms
>
> This patch fix this issue by assigning 'wmi_bss_survey_req_type'
> as 'WMI_BSS_SURVEY_REQ_TYPE_READ' which accumulate survey data in
> FW and send survey data to driver upon the driver request. Wrap around
> is taken care by FW.
>
> hardware used : QCA9984
> firmware ver  : ver 10.4-3.5.3-00057

Have you tested this on other firmwares?  I am pretty sure that at least
some of them, probably 10.2, will have issues.

Maybe you could make this change specific to certain firmware that
is known to work with the change?

Thanks,
Ben

>
> Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> ---
> v2:
>  * updated commit log.
>
>  drivers/net/wireless/ath/ath10k/mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index f068e2b..db93ab1 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -6837,7 +6837,7 @@ ath10k_mac_update_bss_chan_survey(struct ath10k *ar,
>  				  struct ieee80211_channel *channel)
>  {
>  	int ret;
> -	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR;
> +	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ;
>
>  	lockdep_assert_held(&ar->conf_mutex);
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
