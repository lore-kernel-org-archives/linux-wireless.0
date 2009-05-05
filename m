Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:65071 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZEEFpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 01:45:54 -0400
Received: by bwz22 with SMTP id 22so962400bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 22:45:53 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: report operating frequency rather than current
References: <1241452330.8683.49.camel@johannes.local>
	<49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local>
	<49FF2FE8.8010004@gmail.com> <20090504181357.GA19022@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 May 2009 08:45:51 +0300
In-Reply-To: <20090504181357.GA19022@tuxdriver.com> (John W. Linville's message of "Mon\, 4 May 2009 14\:13\:57 -0400")
Message-ID: <87eiv49k6o.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

>> Yes, and at what point does it seem like a good idea to hide the channel  
>> the wifi card is on?  If I set channel 11 and it is scanning instead of  
>> locked on channel 11 then I should see the current channel the hardware  
>> is on.  This seems like an aweful idea to me, granted, it may help a few  
>> people that don't understand how scanning works, but hiding the truth is  
>> never a good idea. NACK.
>
> I can see what you mean, but I think showing seemingly random
> fluctuations in channel assignments is at best distracting.  Don't you
> agree that most people are more interested in seeing the configuration
> state than the transient state of the hardware?

I agree, it's very distracting. And while doing mac80211 software scan
the device is on a channel approximately 30 ms with queues stopped, so
no data is transfered at that time. I don't see any benefit from
reporting this value to user space: "Hey, I'm on channel 5 now but by
the time to you read this I will be on channel 6 already."

If people want to follow how mac80211 changes the frequency during scan,
the proper way is to add debug messages for op_config() calls. I saw
that Johannes was already working on that.

-- 
Kalle Valo
