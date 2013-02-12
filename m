Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49032 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3BLRnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 12:43:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 12 Feb 2013 18:42:50 +0100
From: michael-dev <michael-dev@fami-braun.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<projekt-wlan@fem.tu-ilmenau.de>
Subject: Re: [PATCHv2 1/1] mac80211: fix WPA with VLAN on AP side with ps-sta
In-Reply-To: <1360687114.29913.5.camel@jlt4.sipsolutions.net>
References: <1360687038-17610-1-git-send-email-michael-dev@fami-braun.de>
 <1360687038-17610-2-git-send-email-michael-dev@fami-braun.de>
 (sfid-20130212_173731_351014_1564560C)
 <1360687114.29913.5.camel@jlt4.sipsolutions.net>
Message-ID: <c35750825fc4c49d07d9d6e232b46623@fami-braun.de> (sfid-20130212_184310_653774_8CDBA907)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

thanks for reviewing.

Am 12.02.2013 17:38, schrieb Johannes Berg:
> [use sdata instead of frame_sdata]

can be done.

>> -		if (!ieee80211_tx_prepare(sdata, &tx, skb))
>> +		frame_sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
>> +		if (!ieee80211_tx_prepare(frame_sdata, &tx, skb))
>>  			break;
> 
> This can now crash the machine.

why? when?
What would be a better approach?

Regards,
  M. Braun

