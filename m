Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:54042 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYKGR6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:38 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Thoughts about mac80211 client PS implementation
References: <87k5bhkjf1.fsf@nokia.com>
	<1225917235.3619.180.camel@johannes.berg> <87fxm5ki6s.fsf@nokia.com>
	<1225919146.3619.190.camel@johannes.berg> <877i7hkgpn.fsf@nokia.com>
	<1225969259.3619.202.camel@johannes.berg>
	<1226073984.11203.3.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 07 Nov 2008 19:58:22 +0200
In-Reply-To: <1226073984.11203.3.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 07 Nov 2008 17\:06\:24 +0100")
Message-ID: <87fxm3ju4h.fsf@nokia.com> (sfid-20081107_190903_134944_694893E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Good point. So set my M to 1 and N to 0 ;) Well, in that case you don't
>> need a timer at all but can just schedule the work right away.
>
> Another thought I just had: you could catch the frame in
> subif_start_xmit, stop the master interface queues, xmit the frame to
> the master interface, schedule the PS off work, and after that turns PS
> on you wake the master queues.

Thanks for the tip, it looks good. I have my first version almost
ready now, I just need to proper testing first. It's just that
stlc45xx is crashing with wireless-testing, I need to fix that first :) 

I'll try this subif_start_xmit method in the second round.

-- 
Kalle Valo
