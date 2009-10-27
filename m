Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:46036 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbZJ0QSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:18:07 -0400
Received: by ey-out-2122.google.com with SMTP id 9so75711eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 09:18:10 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mac80211: fix dynamic power save for devices with nullfunc support in hw
References: <20091027153608.27827.70629.stgit@tikku>
	<20091027153616.27827.46490.stgit@tikku>
	<1256659688.4237.21.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 27 Oct 2009 18:18:08 +0200
In-Reply-To: <1256659688.4237.21.camel@johannes.local> (Johannes Berg's message of "Tue\, 27 Oct 2009 17\:08\:08 +0100")
Message-ID: <87zl7cg69r.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2009-10-27 at 17:36 +0200, Kalle Valo wrote:
>> From: Kalle Valo <kalle.valo@nokia.com>
>> 
>> In TX path it was assumed that dynamic power save works only if
>> IEEE80211_HW_PS_NULLFUNC_STACK is set. But is not the case, there are
>> devices which have nullfunc support in hardware but need mac80211
>> to handle dynamic power save timers, TI's wl1251 is one of them.
>> 
>> The fix is to not check for IEEE80211_HW_PS_NULLFUNC_STACK in
>> is_dynamic_ps_enabled(), instead check IEEE80211_HW_SUPPORTS_PS and
>> IEEE80211_HW_SUPPORTS_DYNAMIC_PS flags and act accordingly.
>> 
>> Tested with wl1251.
>> 
>> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

For the record, I sent v1 back in August:

http://www.spinics.net/lists/linux-wireless/msg37717.html

Better late than ever :)

-- 
Kalle Valo
