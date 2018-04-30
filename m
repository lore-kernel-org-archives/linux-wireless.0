Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr20057.outbound.protection.outlook.com ([40.107.2.57]:52843
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755211AbeD3Tu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 15:50:56 -0400
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
To: Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
 <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <0c224b54-dd10-576f-944f-2d20d1cb2c46@bowerswilkins.com> (sfid-20180430_215105_491519_22F8DD0A)
Date: Mon, 30 Apr 2018 12:50:40 -0700
MIME-Version: 1.0
In-Reply-To: <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/30/2018 10:45 AM, Sriram R wrote:
> In the 10.4-3.6 firmware branch there's a new DFS Host confirmation
> feature which is advertised using WMI_SERVICE_HOST_DFS_CHECK_SUPPORT flag.
>
> This new features enables the ath10k host to send information to the
> firmware on the specifications of detected radar type. This allows the
> firmware to validate if the host's radar pattern detector unit is
> operational and check if the radar information shared by host matches
> the radar pulses sent as phy error events from firmware. If the check
> fails the firmware won't allow use of DFS channels on AP mode when using
> FCC regulatory region.
What's the main reason you introduce this feature?
What are you trying to solve with this change?
> +#define ATH10K_WMI_DFS_CONF_TIMEOUT_HZ (HZ / 2)
>   
> +static void ath10k_radar_confirmation_work(struct work_struct *work)
> +{
> +	struct ath10k *ar = container_of(work, struct ath10k,
> +					 radar_confirmation_work);
> +	struct ath10k_radar_found_info radar_info;
> +	int ret, time_left;
> +
> +	reinit_completion(&ar->wmi.radar_confirm);
> +
> +	spin_lock_bh(&ar->data_lock);
> +	memcpy(&radar_info, &ar->last_radar_info, sizeof(radar_info));
> +	spin_unlock_bh(&ar->data_lock);
> +
> +	ret = ath10k_wmi_report_radar_found(ar, &radar_info);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to send radar found %d\n", ret);
> +		goto wait_complete;
> +	}
> +
> +	time_left = wait_for_completion_timeout(&ar->wmi.radar_confirm,
> +						ATH10K_WMI_DFS_CONF_TIMEOUT_HZ);
It looks wrong to me in terms of timeout value.
Typical channel closing time in FCC domain is 200ms (excluding control 
signals), but you're waiting for 500ms for response from FW.
> @@ -3765,25 +3834,46 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
>   
>   	ATH10K_DFS_STAT_INC(ar, pulses_detected);
>   
> -	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, NULL)) {
> +	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, &rs)) {
>   		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
>   			   "dfs no pulse pattern detected, yet\n");
>   		return;
>   	}
>   
> -radar_detected:
> -	ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs radar detected\n");
> -	ATH10K_DFS_STAT_INC(ar, radar_detected);
> +	if ((test_bit(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT, ar->wmi.svc_map)) &&
> +	    ar->dfs_detector->region == NL80211_DFS_FCC) {
I feel risky that host drivers have no way to control this new feature 
and totally rely on FW feature mask. We should have a host drivers' 
feature mask such as module param and set it false (don't use) by 
default until it proves safe to use.
> +static void
> +ath10k_wmi_event_dfs_status_check(struct ath10k *ar, struct sk_buff *skb)
> +{
> +	struct wmi_dfs_status_ev_arg status_arg = {};
> +	int ret;
> +
> +	ret = ath10k_wmi_pull_dfs_status(ar, skb, &status_arg);
> +
> +	if (ret) {
> +		ath10k_warn(ar, "failed to parse dfs status event: %d\n", ret);
> +		return;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
> +		   "dfs status event received from fw: %d\n",
> +		   status_arg.status);
> +
> +	/* Even in case of radar detection failure we follow the same
> +	 * behaviour as if radar is detected i.e to switch to a different
> +	 * channel.
> +	 */
> +	if (status_arg.status == WMI_HW_RADAR_DETECTED ||
> +	    status_arg.status == WMI_RADAR_DETECTION_FAIL)
> +		ath10k_radar_detected(ar);
> +	complete(&ar->wmi.radar_confirm);
> +}
What is typical average duration from 
wait_for_completion_timeout(&ar->wmi.radar_confirm) to this completion 
called ?

Thanks,
Peter
