Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:55082 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZCNRiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:38:01 -0400
Message-ID: <49BBEB69.6090301@nokia.com> (sfid-20090314_183805_089935_CAFE7739)
Date: Sat, 14 Mar 2009 19:37:45 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC PATCH v2 3/4] mac80211: disable power save when scanning
References: <20090314171234.11126.21125.stgit@tikku>	 <20090314171445.11126.97668.stgit@tikku> <1237051502.5235.102.camel@johannes.local>
In-Reply-To: <1237051502.5235.102.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:
> 
>> +	if (!ps || (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
>> +		/*
>> +		 * with IEEE80211_HW_PS_NULLFUNC_STACK and power save
>> +		 * enabled the firmware sent a null frame when power save
>> +		 * was disabled, so we need to send a new null frame
>> +		 */
>> +		ieee80211_send_nullfunc(local, sdata, 1);
>> +}
> 
> Now I'm confused a little. I thought with PS_NULLFUNC_STACK the firmware
> _didn't_ send such frames.

That's a bug, good catch! It should be:

!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)

I'll fix that in v3.

Kalle
