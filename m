Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36177 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab1ITIhq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 04:37:46 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>, Luciano Coelho <coelho@ti.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
	<CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	<1316450319.5995.33.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 20 Sep 2011 11:37:45 +0300
In-Reply-To: <1316450319.5995.33.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Mon\, 19 Sep 2011 18\:38\:39 +0200")
Message-ID: <87hb47ip7q.fsf@purkki.adurom.net> (sfid-20110920_103749_152415_89A72D1D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> bottom line - i'm not sure about all the details, but according to
>> their tests - it does improve the throughput.
>> (i can try getting better details if you have additional questions)
>
> It'd be interesting to see if we can just treat this as a "minimum awake
> time", kinda like going back to the range I thought about earlier.

Yeah. Or maybe have a separate event to postpone dynps timer or
something like that (if firmware informs host whenever there's coex
traffic).

One extreme is that wl12xx would set IEEE80211_HW_SUPPORTS_DYNAMIC_PS
and reimplement the dynps timer in the driver. That way the driver
would have full control how it works and not complicate the mac80211
implementation.

-- 
Kalle Valo
