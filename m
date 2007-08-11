Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36495 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbXHKPFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 11:05:35 -0400
Message-ID: <46BDD038.4040207@lwfinger.net>
Date: Sat, 11 Aug 2007 10:05:28 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: How to use software encryption with WEP and mac80211
References: <46BD2C17.4000702@lwfinger.net> <200708111142.15991.mb@bu3sch.de>
In-Reply-To: <200708111142.15991.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 11 August 2007 05:25:11 Larry Finger wrote:
>> What do I need to do to get mac80211 to do software encryption for WEP? My port of the PHY code from 
>> bcm43xx and the mac80211 front end works with WPA encryption. With WEP, it authenticates and 
>> associates, but never gets an IP number from DHCP. That indicates to me that the encryption is not 
>> set up correctly. I looked through the various definitions in include/net/mac80211.h, but nothing 
>> seems to apply.
> 
> Which hw enc code do you use in that tree? The old softmac crap
> or my new code from bcm43xx-mac80211?

I had stripped out all the key stuff, but before that it was from bcm43xx-mac80211.

> Anyway, if you want to disable hw enc, always set the force sw enc bit
> in the set_key function and return early:
> 
> 	key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
> 	return 0;

This doesn't seem to work. I had tried it before. I guess I put your code back in again.

Thanks,

Larry



