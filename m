Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46860 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1EJWcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 18:32:25 -0400
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: "gregkh\@suse.de" <gregkh@suse.de>,
	"devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Naveen Singh <Naveen.Singh@Atheros.com>
Subject: Re: [PATCH 1/2] ath6kl: iw dev wlan0 link implementation
References: <20110510044023.29589.38450.stgit@localhost6.localdomain6>
	<20110510120243.GA2017@senthil-lnx.users.atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 11 May 2011 01:32:20 +0300
In-Reply-To: <20110510120243.GA2017@senthil-lnx.users.atheros.com> (Senthil Balasubramanian's message of "Tue\, 10 May 2011 17\:32\:43 +0530")
Message-ID: <87liyefaq3.fsf@purkki.adurom.net> (sfid-20110511_003231_075473_5C26941A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Senthil Balasubramanian <senthilkumar@atheros.com> writes:

> On Tue, May 10, 2011 at 10:10:23AM +0530, Kalle Valo wrote:
>> From: Naveen Singh <nsingh@atheros.com>
>> 
>> implementing the cfg ops that gets called when iw dev wlan0
>> link is issued by user. The ops that needs to be implemented
>> is get_station.
>> 
>> kvalo: check the mac address and fix style issues

[...]

>> +int ar6k_get_station(struct wiphy *wiphy, struct net_device *dev,
>> +		     u8 *mac, struct station_info *sinfo)
>> +{
>> +	struct ar6_softc *ar = ar6k_priv(dev);
>> +	u8 mcs, ret, timeout = false;
>> +
>> +	if (compare_ether_addr(mac, ar->arBssid))
>
> this may result in unaligned memeory access on some platforms as mac
> may not be 2 byte aligned. This is the case with the caller as per
> cfg80211_wext_giwrate() and cfg80211_wireless_stats().

I didn't think of this. I'll change it to use memcmp() instead.

>> +	wait_event_interruptible_timeout(arEvent,
>> +					 ar->statsUpdatePending == false,
>> +					 wmitimeout * HZ);
>> +
>> +	if (signal_pending(current)) {
>
> wait_event_interruptible_tiemout() itself checks for signal_pending
> and so this is not necessary. You can check for the return status of
> wait_event_interruptible_timeout() to know whether the task was
> interrupted by a signal.

Will fix.

>> +		timeout = true;
>> +		AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
>> +				("ar6000 : WMI get stats timeout\n"));
>> +	}
>> +
>> +	up(&ar->arSem);
>
> I believe we can release the semaphore early on. I don't see any reason..

What do you mean? I'm not the author of the patch, but I assume that
the idea is to protect the access to ar->statsUpdatePending.

Thanks for the review, I'll submit v2.

-- 
Kalle Valo
