Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56118 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab3FSNix (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 09:38:53 -0400
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0ME0gb-1V61qO2yDv-00HNnV for
 <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2013 15:38:51 +0200
Message-ID: <51C1B467.1030509@rempel-privat.de> (sfid-20130619_153909_304190_A8504515)
Date: Wed, 19 Jun 2013 15:38:47 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "Berg, Johannes" <johannes.berg@intel.com>
CC: Ignacy Gawedzki <i@lri.fr>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
References: <20130619115809.GA26717@zenon.in.qult.net> <51C1ACEC.2020703@rempel-privat.de> <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
In-Reply-To: <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 19.06.2013 15:08, schrieb Berg, Johannes:
>
>>       mac80211: fix idle handling sequence
>>
>>       Corey Richardson reported that my idle handling cleanup
>>       (commit fd0f979a1b, "mac80211: simplify idle handling")
>>       broke ath9k_htc. The reason appears to be that it wants
>>       to go out of idle before switching channels. To fix it,
>>       reimplement that sequence.
>>
>>       Reported-by: Corey Richardson <corey@octayn.net>
>>       Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>
>> Johannes, can you please take a look on it.
>
> Not very well, I don't know anything about ath9k. I'm willing to help out, but I can't really say what broke it.

hm.. looks like this code depends on power_save. is it correct?

Ignacy,

can you please take a look if power_save mode is enabled by you.

iw dev wlan0 get power_save

if yes. Try to disable it.

I think last week power_save was set to disabled by default. There are 
too many bugs right now.
-- 
Regards,
Oleksij
