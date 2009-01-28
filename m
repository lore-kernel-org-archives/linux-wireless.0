Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:34379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZA1LqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 06:46:18 -0500
Received: by fg-out-1718.google.com with SMTP id 13so524598fge.17
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 03:46:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <874ozj964m.fsf@litku.valot.fi>
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114546.31443.79387.stgit@tikku>
	 <1ba2fa240901231528m21f13c1m43721f1d673e7cc7@mail.gmail.com>
	 <874ozj964m.fsf@litku.valot.fi>
Date: Wed, 28 Jan 2009 13:46:16 +0200
Message-ID: <1ba2fa240901280346v6b4000b9m74eef26aabf86419@mail.gmail.com> (sfid-20090128_124623_447477_27D41587)
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power save
	mode is disabled
From: Tomas Winkler <tomasw@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: johannes@sipsolutions.net, vivek.natraj@gmail.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 10:39 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Tomas Winkler <tomasw@gmail.com> writes:
>
>> On Thu, Jan 22, 2009 at 1:45 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
>>> When a directed tim bit is set, mac80211 currently disables power save
>>> ands sends a null frame to the AP. But if dynamic power save is
>>> disabled, mac80211 will not enable power save ever gain.
>>
>> Why not?
>
> Because of a bug.

So wouldn't be better to fix the bug.

>
>>> Fix this by
>>> adding ps-poll functionality to mac80211. When a directed tim bit is
>>> set, mac80211 sends a ps-poll frame to the AP and checks for the more
>>> data bit in the returned data frames.
>>
>> Still have to see the implementation but this sounds strange.
>
> Please be more specific, I don't understand what part you think is
> strange. This is specified in the spec, see chapter 11.2.
>
Strange you've decided implementing another feature instead of fixing
a bug. Not that I'm against existence of PS-poll implementation in
mac80211 it just should not be in order to fix a bug.


>>> Using ps-poll is slower than waking up with null frame, but it's saves more
>>> power in cases where the traffic is low. Userspace can control if either
>>> ps-poll or null wakeup method is used by enabling and disabling dynamic
>>> power save.
>>
>> Do you have numbers how much power you save?
>
> Unfortunately not yet.
>
>> With PS-Poll you must stay awak longer not saying that issueing TX
>> (PS-poll) also consume power.Ususally TXing has higher power
>> consumption then RX. Instead of tx(null PM=0) rx tx(ack)...rx
>> tx(ack) tx(null PM=1) you have now tx(ps-poll) rx tx (ack)
>> tx(ps-poll) rx tx(ack). So if the AP holds more then 3 packetes PS
>> poll will consume more power in this very simplified computation.
>
> Let's take the null frame approach:
>
> 1. notice tim bit set
> 2. send null frame (pm=0)
> 3. receive data frames
> 4. wait for all buffered data frames
> 5. send null frame (pm=1)
>
> How do you know when the station has received all buffered data frames
> from the AP (item 4 above)? By waiting a certain period after the last
> received data frame? If that timeout is too short, we will get packet
> loss, which is not good. If the timeout is too long, we waste too much
> power.

You can manage the idle timeout according the power save
aggressiveness you want to achieve. There is no free lunch
as result of power save you get some packet loss and jitter. Packet
loss and jitter are natural to wifi also in normal operation. Last
packet loss is not really an issue it's guarded by 802.11
retransmission mechanism and by higher protocol.


> With ps-poll we don't have to set any timeouts, the station can go to
> sleep immeadiately after receiving a data frame with moredata bit not
> set. So I see a clear advantage in certain cases where the data
> troughput is very low and maximum power savings is desired. For
> example when the device is idle on the table, display turned off and
> only irc/jabber session is running in the background.

You certainly cannot predict the RX activity especially when you have
irc running in background.

>
> And remember that userspace can control this with the power timeout
> setting. My recommendation would be to use this only when the device
> is idle and display is turned off.

I guess that environment is more dynamic then user space can react
upon and I thing that null packet method is more
flexible then PS-poll but I also doesn't  have numbers to support my view

Now maybe I'm a bit biased towards null frame approach because what we
are doing in iwlwifi with and I know there was a lot of data collected
in different environments to tune the numbers deep in HW and firmware
but still this is was only on laptops usage in corporate or
coffee/airport environments.
There might be a case that for handhelds and different HW PS-poll
might be preferable.  My point is that you cannot find universally
said what is correct and there shell be configuration possibility from
HW, user space, environment perspective.

Frankly I don't like much mapping power save aggressiveness to timeout
number because there so much more parameters that governs it that is
says nothing.

I would suggest to expose to user space non-unit index of power save
aggressiveness which can be mapped to different methods such as
PS-Poll, dynamic power save or iwlwifi firmware implementation by
other more reach configurable interface


>
>> Do you measure power consumption on of the NIC or the whole system?
>
> Usually I measure just the whole system. I can measure the nic, but
> that's very time consuming.

This can be important in tuning since you cannot distinguish between
wasting of power by some wakening up timer or thread in the driver or
by the fact that NIC itself doesn't enter power save state.

Thanks
Tomas
