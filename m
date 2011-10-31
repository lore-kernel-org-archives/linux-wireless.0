Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47754 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:55:47 -0400
Message-ID: <4EAE701E.5040204@qca.qualcomm.com> (sfid-20111031_105550_058719_F1D5985E)
Date: Mon, 31 Oct 2011 15:23:34 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] ath6kl: Add new functions to handle wow suspend/resume
 operations
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <1319539047-8756-5-git-send-email-rmani@qca.qualcomm.com> <4EAAA08F.5070905@qca.qualcomm.com>
In-Reply-To: <4EAAA08F.5070905@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 October 2011 06:01 PM, Kalle Valo wrote:
> On 10/25/2011 01:37 PM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> Signed-off-by: Raja Mani<rmani@qca.qualcomm.com>
>
> Empty commit log.
>
>> +int ath6kl_pm_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
>> +{
>> +	struct wmi_set_wow_mode_cmd wakeup_filter_cmd;
>> +	struct wmi_add_wow_pattern_cmd add_pattern_cmd;
>> +	struct wmi_del_wow_pattern_cmd del_pattern_cmd;
>> +	struct wmi_set_host_sleep_mode_cmd hsleep_cmd;
>> +	int i, ret, pos, left;
>> +	u8 mask[WOW_PATTERN_SIZE];
>> +
>> +	if (WARN_ON(!wow))
>> +		return -EINVAL;
>
> Unnecessary null check, wow is non-zero here.
>
>> +		for (pos = 0; pos<  wow->patterns[i].pattern_len;
>> +				pos++) {
>> +			if (wow->patterns[i].mask[pos / 8]&  (0x1<<  (pos % 8)))
>> +				mask[pos] = 0xFF;
>
> This loop needs a comment.
>
>> +	if (ar->tx_pending[ar->ctrl_ep]) {
>> +		left = wait_event_interruptible_timeout(ar->event_wq,
>> +				ar->tx_pending[ar->ctrl_ep] == 0, WMI_TIMEOUT);
>> +		if (left == 0) {
>> +			ret = -ETIMEDOUT;
>> +			goto wow_setup_failed;
>> +		} else if (left<  0) {
>> +			ret = left;
>> +			goto wow_setup_failed;
>
> A warning message for both of these error case would be nice.
>
>> +#define WOW_HOST_REQ_DELAY	500 /* 500 ms */
>
> No point of duplicating the value, "/* ms */" is enough.
>
> Kalle

Will fix all your above comments in V2..
