Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.pawisda.de ([213.157.4.156]:38909 "EHLO mail.pawisda.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933800AbaDIVM0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 17:12:26 -0400
Message-ID: <5345B7B8.1010903@sp.consulting.lsexperts.de> (sfid-20140409_231234_684234_C913E811)
Date: Wed, 09 Apr 2014 23:12:24 +0200
From: Stefan Pietsch <stefan.pietsch@lsexperts.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, chaitanya.mgit@gmail.com
Subject: Re: iwlwifi: Invalid RXON when trying to join IBSS network
References: <534464F9.1080805@sp.consulting.lsexperts.de>		 (sfid-20140408_233636_176148_44D5A66B) <1397029645.4964.1.camel@jlt4.sipsolutions.net>	 <5345A814.8090301@sp.consulting.lsexperts.de> <1397075249.4964.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1397075249.4964.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09.04.2014 22:27, Johannes Berg wrote:
> On Wed, 2014-04-09 at 22:05 +0200, Stefan Pietsch wrote:
> 
>> [  489.184233] wlan0: Trigger new scan to find an IBSS to join
>> [  489.320584] wlan0: Selected IBSS BSSID 55:44:33:22:11:00 based on
>> configured SSID
> 
> Well, 55:... still has the multicast bit set.
> 
> Clearly this is a bug and we should just refuse this in mac80211, but by
> setting the BSSID by hand to an invalid value you're really just
> shooting yourself in the foot. :)
> 
> johannes


My bad. I was not aware of that.

I set the first byte to 00 and it worked.

Thanks!
