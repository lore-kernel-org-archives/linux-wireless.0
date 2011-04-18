Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52082 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1DRJLG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 05:11:06 -0400
Message-ID: <4DAC0026.5020905@openwrt.org>
Date: Mon, 18 Apr 2011 11:11:02 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: add a function for setting the TIM bit for
 a specific station
References: <1303055100-38307-1-git-send-email-nbd@openwrt.org> <1303114525.3588.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1303114525.3588.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-18 10:15 AM, Johannes Berg wrote:
> On Sun, 2011-04-17 at 17:45 +0200, Felix Fietkau wrote:
>>  This allows a driver to buffer frames for a PS station and tell mac80211
>>  to wake it up even though mac80211 does not have any buffered frames for
>>  it.
>>  This is necessary for properly handling aggregation related buffering,
>>  in ath9k, because the driver needs to keep its frames in order to keep
>>  track of the Block-ACK window.
>
> Indeed, I thought I'd solved these cases with the WLAN_STA_PS_DRIVER
> thing but that's not true of course because it blocks wakeup until all
> frames have been filtered, which will never happen here. I think I'll
> probably need to implement using this in iwlwifi as well.
>
> The only question I have is how will PS-Poll be handled while an
> aggregation session is active?? Is it even allowed to poll a-MPDUs?
Not sure - polling A-MPDUs may not be allowed, the standard only 
mentions polling MSDU and A-MSDU. We could add a driver callback later 
that mac80211 calls upon receiving a PS-Poll when WLAN_STA_PS_DRIVER_BUF 
is set, which will trigger the release of a single packet and indicate 
in the return status whether it was the last one (from the driver's 
point of view).

- Felix
