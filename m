Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33735 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab1JaNQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 09:16:27 -0400
Message-ID: <4EAE9F9D.2000209@qca.qualcomm.com> (sfid-20111031_141629_877613_40498F47)
Date: Mon, 31 Oct 2011 15:16:13 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/7] ath6kl: Invoke wow suspend/resume calls during PM
 operations
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <1319539047-8756-6-git-send-email-rmani@qca.qualcomm.com> <4EAAAAF6.3090906@qca.qualcomm.com> <4EAE7038.7010306@qca.qualcomm.com>
In-Reply-To: <4EAE7038.7010306@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2011 11:54 AM, Raja Mani wrote:
> On Friday 28 October 2011 06:45 PM, Kalle Valo wrote:
>> On 10/25/2011 01:37 PM, rmani@qca.qualcomm.com wrote:
>>> From: Raja Mani<rmani@qca.qualcomm.com>
>>>
>>> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
>>> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>>> @@ -1606,6 +1606,19 @@ static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
>>>   				 struct cfg80211_wowlan *wow)
>>>   {
>>>   	struct ath6kl *ar = wiphy_priv(wiphy);
>>> +	int ret;
>>> +
>>> +	if (wow&&  ath6kl_cfg80211_ready(ar)&&
>>> +	    test_bit(CONNECTED,&ar->flag)&&
>>> +	    ath6kl_hif_keep_pwr_caps(ar)) {
>>> +
>>> +		/* Flush all non control pkts in Tx path */
>>> +		ath6kl_tx_data_cleanup(ar);
>>> +
>>> +		ret = ath6kl_pm_wow_suspend(ar, wow);
>>> +		if (ret)
>>> +			return ret;
>>> +	}
>>
>> This is now confusing. Some of the suspend logic is now in sdio.c and
>> some here. It's better to have everything in one place, that is in
>> sdio.c. We just need to add an interface so that sdio.c can request the
>> correct suspend mode.
> 
> Do you want me to keep ath6kl_pm_wow_suspend() implementation in 
> cfg80211.c file and move only above code to ath6kl_sdio_suspend() ?

I gave this more thought and in my suspend patches earlier today I added
this function:

int ath6kl_cfg80211_suspend(struct ath6kl *ar,
			    enum ath6kl_cfg_suspend_mode mode)
{
	int ret;

	ath6kl_cfg80211_stop(ar);

	switch (mode) {
	case ATH6KL_CFG_SUSPEND_DEEPSLEEP:
		/* save the current power mode before enabling power save */
		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;

		ret = ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER);
		if (ret) {
			ath6kl_warn("wmi powermode command failed during suspend: %d\n",
				    ret);
		}

		ar->state = ATH6KL_STATE_DEEPSLEEP;

		break;

You can add a new mode for WOW and call your wow functions from that
function. And you need to make changes to ath6kl_sdio_suspend() so that
it will enable WOW in correct cases. Also I added a state variable
ar->state and hopefully we don't need a separate wow state anymore.

Kalle
