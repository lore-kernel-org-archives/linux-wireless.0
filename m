Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:39313 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbXDIDx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 23:53:58 -0400
Message-ID: <4619B90E.1030403@lwfinger.net>
Date: Sun, 08 Apr 2007 22:54:54 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704081941.18921.flamingice@sourmilk.net> <461982A7.30901@lwfinger.net> <200704082031.59934.flamingice@sourmilk.net>
In-Reply-To: <200704082031.59934.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Sunday 08 April 2007 20:02, Larry Finger wrote:
>> Link Quality=219/60  Signal level=-200 dBm  Noise level=-69 dBm
>>
> Try the attached patch without your "bcm43xx-mac80211: Fix error in 
> initiallizing max RSSI and max signal" patch.
> 
> -Michael Wu

Why would I want to do this? If the community agrees on anything, it is that the signal is given in 
dBm (i.e. a negative number) and that the rssi is a positive number. The firmware in the bcm43xx 
chips return a quantity that looks like an rssi with a received packet, and bcm43xx_rssi_postprocess 
turns that into a quantity that looks like dBm. Your patch reverses those designations and mixes up 
the two quantities. Again I ask "Why"?

Larry

