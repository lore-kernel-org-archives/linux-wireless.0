Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52993 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbZJ3LoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 07:44:21 -0400
Message-ID: <4AEAD177.40701@nokia.com>
Date: Fri, 30 Oct 2009 13:43:51 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2.6.32] mac80211: split hardware scan by band
References: <1256673595.4237.24.camel@johannes.local> <1256675077.4237.26.camel@johannes.local>
In-Reply-To: <1256675077.4237.26.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Tue, 2009-10-27 at 20:59 +0100, Johannes Berg wrote:
> 
>> Fix this by splitting up cfg80211 scan requests by
>> band -- recalculating the IEs every time -- and
>> requesting only per-band scans from the driver.
> 
> Incidentally, this means that dual-band drivers now absolutely need to
> take a look at the scan channel list that is provided since if they
> ignore it they will end up doing two full scans instead of one. Since
> wl1271 is the only driver this affects right now, and its 5ghz support
> is disabled, this seems ok to me.

Sorry for the late response.

This is fine with me.  We added one item to handle this on our 5GHz TODO list. 
We're unfortunately not working with 5GHz at the moment, but we'll hopefully do 
so in the near future (prioritization and stuff).

I said to you that I would add a FIXME in the code, but I think this is not 
really necessary, because 5GHz is not fully working anyway, there is definitely 
still some work to be done (and that's why it is disabled).

-- 
Cheers,
Luca.
