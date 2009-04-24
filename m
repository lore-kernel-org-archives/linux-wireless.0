Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:59673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZDXGZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 02:25:00 -0400
Received: by fg-out-1718.google.com with SMTP id 16so121470fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 23:24:58 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: on radio_enabled
References: <1240439975.30082.66.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 24 Apr 2009 09:24:56 +0300
In-Reply-To: <1240439975.30082.66.camel@johannes.local> (Johannes Berg's message of "Thu\, 23 Apr 2009 00\:39\:35 +0200")
Message-ID: <87tz4ed0w7.fsf@litku.valot.fi> (sfid-20090424_082507_068366_AD5B0CE0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Now, if we're going to use radio_enabled more, I wonder whether we
> should completely deconfigure the hardware when we want to turn off
> radio_enabled, and then completely reconfigure it once we enable the
> radio again.

I assume that you mean op_stop() and op_start() here.

> Pros:
>  * configures all hardware correctly without the driver needing to do
>    everything by itself
>  * works with all hardware for sure
>
> Cons:
>  * higher latency

>From stlc45xx and wl12xx perspective I would like to have low latency as
possible for the radio on/off case. This is what I had in mind:

interface down:

o chip is powered off while down
o ifup uploads firmware and initialises it
o ifup might take hundreds of milliseconds, at least with 1271

radio off:

o chip is powered on
o firmware possibly sleeping/hibernating
o radios turned off
o very low latency (<5 ms) to wakeup
o small power consuption during radio off

This way it would be possible to have a bit faster scans when not
associated (with radio off), but still have a possibility to completely
turn of chip from user space for a longer periods of time (with
interface down).

-- 
Kalle Valo
