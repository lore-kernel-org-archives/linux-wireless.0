Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:42056 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYKJJue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 04:50:34 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211: implement dynamic power save
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	<1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
	<1226309808.4004.16.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 10 Nov 2008 11:49:58 +0200
In-Reply-To: <1226309808.4004.16.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 10 Nov 2008 10\:36\:48 +0100")
Message-ID: <87myg7zz95.fsf@nokia.com> (sfid-20081110_105043_105025_72BD7A2F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sun, 2008-11-09 at 17:43 +0200, Kalle Valo wrote:
>
>>  	bool powersave;
>> +	int dynamic_ps_timeout;
>> +	struct work_struct ps_enable_work;
>> +	struct work_struct ps_disable_work;
>> +	struct timer_list dynamic_ps_timer;
>
> I think you could use a delayed work for the enable-work+timer, that
> combines them already.

I was planning to but I didn't find mod_timer() equivalent for
delayed_work. I need it because I need to cancel the timer all the
time. Is there similar functionality with delayed_work?

> Looks good to me.

Thanks a lot for looking at these.

-- 
Kalle Valo
