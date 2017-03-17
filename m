Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:36216 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbdCQJdW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 05:33:22 -0400
Received: by mail-qt0-f181.google.com with SMTP id r45so57899182qte.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Mar 2017 02:33:21 -0700 (PDT)
Subject: Re: [RFT] brcmfmac: add support to move wiphy instance into network
 namespace
To: Johannes Berg <johannes@sipsolutions.net>,
        Mark Asselstine <mark.asselstine@windriver.com>
References: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com>
 <124157392.J1GrpqVLd5@yow-masselst-lx1>
 <0343e3c9-baf8-f3b1-8c37-c8b0864bd7e5@broadcom.com>
 <1489742655.2544.4.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1fe602fe-3db0-f533-f176-bed58f7e011c@broadcom.com> (sfid-20170317_103325_930706_FE965A2A)
Date: Fri, 17 Mar 2017 10:33:18 +0100
MIME-Version: 1.0
In-Reply-To: <1489742655.2544.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-3-2017 10:24, Johannes Berg wrote:
> On Fri, 2017-03-17 at 10:06 +0100, Arend Van Spriel wrote:
>> On 16-3-2017 22:51, Mark Asselstine wrote:
>>> On Tuesday, March 14, 2017 9:51:52 PM EDT Arend van Spriel wrote:
>>>> To support network namespace the driver must assure all created
>>>> network interfaces are in the same namespace as the wiphy
>>>> instance.
>>>>
>>>> Reported-by: Mark Asselstine <mark.asselstine@windriver.com>
>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>> ---
>>>> Hi Mark,
>>>>
>>>> Please check this patch. I can not say I am an expert when it
>>>> comes
>>>> to using namespaces. So let me know if it works and I can change
>>>> Reported-by into Tested-by.
>>>
>>> Seems to pass the tests I threw at it. Seems happy with namespaces.
>>
>> I tested it myself and noticed something unexpected. Upon changing
>> from &init_net to brcm-wifi the wdev id has changed from 0x1 to 0x2
>> (see below) and upon going from brcm-wifi to &init_net both interface
>> change their wdev id.
> 
> Interesting. That's clearly a cfg80211 bug, does this help?
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 2e1740c7a8bf..d71d5e90229f 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -1183,7 +1183,15 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>  		INIT_LIST_HEAD(&wdev->mgmt_registrations);
>  		spin_lock_init(&wdev->mgmt_registrations_lock);
>  
> -		wdev->identifier = ++rdev->wdev_id;
> +		/*
> +		 * We get here also when the interface changes network namespaces,
> +		 * as it's registered into the new one, but we don't want it to
> +		 * change ID in that case. Checking if the ID is already assigned
> +		 * works, because 0 isn't considered a valid ID and the memory is
> +		 * 0-initialized.
> +		 */
> +		if (!wdev->identifier)
> +			wdev->identifier = ++rdev->wdev_id;

Given my debug session just a minute ago I would say yes ;-) as this is
where I put wiphy_err() statement. Will give it a quick spin.

Regards,
Arend

>  		list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
>  		rdev->devlist_generation++;
>  		/* can only change netns with wiphy */
> 
> johannes
> 
