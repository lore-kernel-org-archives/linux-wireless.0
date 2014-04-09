Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.pawisda.de ([213.157.4.156]:38684 "EHLO mail.pawisda.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbaDIUFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 16:05:42 -0400
Message-ID: <5345A814.8090301@sp.consulting.lsexperts.de> (sfid-20140409_220546_166816_4383C826)
Date: Wed, 09 Apr 2014 22:05:40 +0200
From: Stefan Pietsch <stefan.pietsch@lsexperts.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: iwlwifi: Invalid RXON when trying to join IBSS network
References: <534464F9.1080805@sp.consulting.lsexperts.de>	 (sfid-20140408_233636_176148_44D5A66B) <1397029645.4964.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1397029645.4964.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09.04.2014 09:47, Johannes Berg wrote:
> On Tue, 2014-04-08 at 23:07 +0200, Stefan Pietsch wrote:
>> Dear list,
>>
>> trying to join an IBSS network gives me these kernel messages:
>>
>>
>>
>> [  383.857059] iwlwifi 0000:03:00.0: mac/bssid mcast!
> 
> How did you manage to get a multicast address as the BSSID?
> 
> johannes


I changed the BSSID on the remote station.

This seems to make no difference:



[  489.184233] wlan0: Trigger new scan to find an IBSS to join
[  489.320584] wlan0: Selected IBSS BSSID 55:44:33:22:11:00 based on
configured SSID
[  489.381485] iwlwifi 0000:03:00.0: mac/bssid mcast!
[  489.381492] ------------[ cut here ]------------
[  489.381516] WARNING: CPU: 2 PID: 206 at
/build/linux-l673CV/linux-3.13.7/drivers/net/wireless/iwlwifi/dvm/rxon.c:843
iwlagn_commit_rxon+0x551/0xbb0 [iwldvm]()
[  489.381519] Invalid RXON (0x10), channel 1



Regards,
Stefan
