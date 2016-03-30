Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34225 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbcC3MNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 08:13:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lior David <liord@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 2/2] wil6210: add module parameter for alternate interface name
References: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1458590472-677-3-git-send-email-qca_merez@qca.qualcomm.com>
	<87y499dxjf.fsf@kamboji.qca.qualcomm.com>
	<56F3BBB4.6030104@codeaurora.org>
Date: Wed, 30 Mar 2016 15:13:47 +0300
In-Reply-To: <56F3BBB4.6030104@codeaurora.org> (Lior David's message of "Thu,
	24 Mar 2016 12:04:36 +0200")
Message-ID: <87wpok9n9g.fsf@kamboji.qca.qualcomm.com> (sfid-20160330_141356_009088_CAA9FE1E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lior David <liord@codeaurora.org> writes:

>>> +	const char *ifname = alt_ifname ? "wigig%d" : "wlan%d";
>>>  
>>>  	wdev = wil_cfg80211_init(dev);
>>>  	if (IS_ERR(wdev)) {
>>> @@ -160,7 +166,7 @@ void *wil_if_alloc(struct device *dev)
>>>  	ch = wdev->wiphy->bands[IEEE80211_BAND_60GHZ]->channels;
>>>  	cfg80211_chandef_create(&wdev->preset_chandef, ch, NL80211_CHAN_NO_HT);
>>>  
>>> -	ndev = alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, wil_dev_setup);
>>> +	ndev = alloc_netdev(0, ifname, NET_NAME_UNKNOWN, wil_dev_setup);
>>>  	if (!ndev) {
>>>  		dev_err(dev, "alloc_netdev_mqs failed\n");
>>>  		rc = -ENOMEM;
>> 
>> To me this looks like an ugly hack and I hope there is a better way to
>> handle the problem this patch is fixing. I think interface names
>> shouldn't matter from functionality point of view, anything requiring
>> certain naming is broken.
>> 
>> But if the interface name is so important why not use "wigig%d" always?
>> The user space can rename the interface name anyway.
>
> The problem we try to solve is with Android. Android uses hard-coded "wlan0"
> interface name for wifi. We have a platform where wigig(11ad) is used
> alongside wifi(11ac). Both are independent and managed by separate services,
> but started at boot at roughly the same time. Sometimes 11ad will get wlan0
> interface name and 11ac will get wlan1, and wifi will not work.
> We considered using "wigig%d" always as you suggested, but it may break an
> unknown number of existing tools/scripts that rely on wlan0 interface
> name.

I got the idea why this is done, I just don't think that the way the
issue is solved is a good one. Can't you just rename the interface
during boot? Like older Ubuntu versions had a udev rule at
/etc/udev/rules.d/70-persistent-net.rules to name the interfaces (no
idea if it's still available after systemd was taken into use).

> As I see it, it is an issue of classification. Network drivers use a default
> interface name prefix depending on the device type. Ethernet drivers get "eth%d",
> wireless drivers get "wlan%d" and so on. There are even existing drivers
> that give different prefixes based on other conditions, for example see
> drivers/s390/net/ctcm_main.c, ctcm_init_netdevice.
> For our 11ad device, in many platforms it is used as a wifi replacement, so
> the wlan%d name is appropriate, in other platforms it is used as
> a different wireless device for different purposes, so the default "wigig%d"
> prefix seems appropriate.

Every platform works differently, even systemd even has it's own weird
naming scheme:

https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/

I really don't think that we should start working around interface
naming problems by selecting the name with module parameters. But having
"wigig%d" as the default sounds like a good idea to me.

-- 
Kalle Valo
