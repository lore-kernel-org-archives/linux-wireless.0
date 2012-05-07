Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34142 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab2EGPMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 11:12:48 -0400
Received: by yenm10 with SMTP id m10so3730935yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 08:12:47 -0700 (PDT)
Message-ID: <4FA7E66B.5090500@lwfinger.net> (sfid-20120507_171251_317473_6E6E2B3A)
Date: Mon, 07 May 2012 10:12:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at net/mac80211/iface.c:162
References: <4FA709B3.4030404@lwfinger.net>  ( sfid-20120507_013135_141792_546F01AB) <1336372450.4325.0.camel@jlt3.sipsolutions.net>  <4FA77FE7.5030303@broadcom.com> <1336390146.4325.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336390146.4325.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 06:29 AM, Johannes Berg wrote:
> On Mon, 2012-05-07 at 09:55 +0200, Arend van Spriel wrote:
>> On 05/07/2012 08:34 AM, Johannes Berg wrote:
>>> On Sun, 2012-05-06 at 18:30 -0500, Larry Finger wrote:
>>>> Hi,
>>>>
>>>> I am getting the following warning from the latest wireless-testing system:
>>>>
>>>>    ------------[ cut here ]------------
>>>>    WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues+0x119/0x130
>>>> [mac80211]()
>>>
>>>
>>>>        if (WARN_ON_ONCE(sdata->vif.hw_queue[i]>= n_queues))
>>>>
>>>> The warning is triggered for i, n_queues, and sdata->vif.hw_queue[i] all equal to 1.
>>>
>>> Is this a driver with just a single queue by any chance? I never tested
>>> that and probably forgot to set those up correctly.
>>>
>>
>> The bug report Larry mentions is with iwlwifi driver:
>>
>> pci, iwlwifi, NETWORK, Centrino Wireless-N 130 BGN
>
> No, the bug report says rtl8187, the user said this happened when
> plugging in the USB device.
>
> I think this will fix it:
>
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -206,8 +206,10 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
>   	for (i = 0; i<  IEEE80211_NUM_ACS; i++) {
>   		if (local->hw.flags&  IEEE80211_HW_QUEUE_CONTROL)
>   			sdata->vif.hw_queue[i] = IEEE80211_INVAL_HW_QUEUE;
> -		else
> +		else if (local->hw.queues>= IEEE80211_NUM_ACS)
>   			sdata->vif.hw_queue[i] = i;
> +		else
> +			sdata->vif.hw_queue[i] = 0;
>   	}
>   	sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
>   }

Yes, this patch fixes the problem.

Reported-and-Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Once you post the patch, I will update that entry at bugzilla.redhat.com.

Thanks,

Larry

