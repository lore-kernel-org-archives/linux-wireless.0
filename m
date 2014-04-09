Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964922AbaDIU1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 16:27:49 -0400
Message-ID: <1397075249.4964.19.camel@jlt4.sipsolutions.net> (sfid-20140409_222753_634947_5A3B1F6C)
Subject: Re: iwlwifi: Invalid RXON when trying to join IBSS network
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Pietsch <stefan.pietsch@lsexperts.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Apr 2014 22:27:29 +0200
In-Reply-To: <5345A814.8090301@sp.consulting.lsexperts.de>
References: <534464F9.1080805@sp.consulting.lsexperts.de>
		 (sfid-20140408_233636_176148_44D5A66B) <1397029645.4964.1.camel@jlt4.sipsolutions.net>
	 <5345A814.8090301@sp.consulting.lsexperts.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 22:05 +0200, Stefan Pietsch wrote:

> [  489.184233] wlan0: Trigger new scan to find an IBSS to join
> [  489.320584] wlan0: Selected IBSS BSSID 55:44:33:22:11:00 based on
> configured SSID

Well, 55:... still has the multicast bit set.

Clearly this is a bug and we should just refuse this in mac80211, but by
setting the BSSID by hand to an invalid value you're really just
shooting yourself in the foot. :)

johannes

