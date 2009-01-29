Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:42817 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZA2UT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 15:19:57 -0500
Received: by mu-out-0910.google.com with SMTP id g7so71269muf.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2009 12:19:55 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "vivek.natraj\@gmail.com" <vivek.natraj@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power	save mode is disabled
References: <20090122114240.31443.18218.stgit@tikku>
	<20090122114546.31443.79387.stgit@tikku>
	<1232643729.5819.3.camel@johannes.local> <87hc3jgyu9.fsf@nokia.com>
	<1233168737.4811.18.camel@johannes.local> <4981F232.5000801@nokia.com>
	<1233253941.4067.2.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 29 Jan 2009 22:19:52 +0200
In-Reply-To: <1233253941.4067.2.camel@johannes.local> (Johannes Berg's message of "Thu\, 29 Jan 2009 19\:32\:21 +0100")
Message-ID: <87y6wtlv9z.fsf@litku.valot.fi> (sfid-20090129_212002_154710_C9A35412)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-01-29 at 20:15 +0200, Kalle Valo wrote:
>
>> > No, I mean in the timeout > 0 case, what vivek mentioned too. We never
>> > go back to sleep unless we send a packet.
>> 
>> First of all, this patchset doesn't change the logic for timeout > 0 
>> case. But that case was working already earlier, here's my analysis:
>> 
>> 1. tim bit is set
>> 2. if timeout > 0 disable power save and send null frame
>> 3. null frame enables dynamic_ps_timer in ieee80211_master_start_xmit()
>> 4. after dynamic_ps_timer triggers, power save is enabled again
>> 
>> I understood that this was the reason why Vivek moved the running of 
>> dynamic_ps_timer from subif to the master interface. Or did I miss 
>> something?
>
> Hah, no, you're right, sorry, I got confused.

It confused me also. I would prefer to have the dynamic_ps_timer stuff
in subif and have an explicit timer for the null frames, just to avoid
confusion. I'll try to see if I can come up with a patch later on.

-- 
Kalle Valo
