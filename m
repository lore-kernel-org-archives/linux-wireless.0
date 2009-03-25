Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:31652 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZCYUWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 16:22:45 -0400
Received: by fk-out-0910.google.com with SMTP id 18so99118fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 13:22:42 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: wireless powersaving (in NM?)
References: <1237891149.4320.73.camel@johannes.local>
	<87ab7bqa21.fsf@litku.valot.fi>
	<1237978630.4320.150.camel@johannes.local>
	<87ab791isj.fsf@litku.valot.fi>
	<1238011579.4320.169.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 25 Mar 2009 22:22:39 +0200
In-Reply-To: <1238011579.4320.169.camel@johannes.local> (Johannes Berg's message of "Wed\, 25 Mar 2009 21\:06\:19 +0100")
Message-ID: <87wsadz71s.fsf@litku.valot.fi> (sfid-20090325_212303_321083_C150A645)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-03-25 at 21:53 +0200, Kalle Valo wrote:
>
>> > I'm just worried that we'll require a whole bunch of different
>> > interfaces. Yes, in theory there isn't much to control, but iwlwifi
>> > firmware for example can, as far as I interpret the code, dynamically
>> > vary the listen interval.
>> 
>> You mean the wakeup interval? For me, listen interval means the
>> maximum time AP is willing to buffer frames for a STA.
>
> No, I mean the listen interval in the assoc request frame.

It only tells the AP maximum time it should buffer the frames for use.
We can set it 10 but still wake every second beacon. So listen
interval has merely informative value.

>> I assume you mean sleep_interval here:
>> 
>> #define IWL_POWER_VEC_SIZE 5
>> 
>> struct iwl_powertable_cmd {
>> 	__le16 flags;
>> 	u8 keep_alive_seconds;		/* 3945 reserved */
>> 	u8 debug_flags;			/* 3945 reserved */
>> 	__le32 rx_data_timeout;
>> 	__le32 tx_data_timeout;
>> 	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
>> 	__le32 keep_alive_beacons;
>> } __attribute__ ((packed));
>> 
>> So there's an array sleep/wakeup interval, which firmware most
>> probably rotates periodically. 
>
> I don't actually know what the sleep interval here is...

I think it determines how often the firmware will wakeup for beacons.
At least stlc45xx had something similar.

>> I think stlc45xx/p54 even had something
>> similar. But honestly, I don't know if this kind of trickery is
>> useful. Why not directly go to the longest wakeup interval
>> immediately?
>
> But listen interval * beacon interval determines latency.

Yeah. I just wouldn't use the listen interval, because it's
a bit misleading. I have used the term wakeup interval here.

>> My view is that the decision to change wakeup interval should be done
>> in host, preferably userspace. Userspace has the best knowledge, it
>> should make the decision as well.
>
> What's the wakeup interval?

That's my own invention, again :) It's the interval how often firmware
wakes up for beacons, and unit is beacon interval. For example, if
wakeup interval is three and beacon interval 100 msec, the firmware
would wakeup for beacons every 300 ms.

>> > Some of the decisions might also depend on the hardware, I could
>> > imagine, the point where turning off power saving is required might be
>> > different depending on hardware due to wakeup time maybe?
>> 
>> Yes, there might be some differences.
>
> How would we capture these?

I was thinking that it's the responsibility of the driver's author to
map these to the hardware.

-- 
Kalle Valo
