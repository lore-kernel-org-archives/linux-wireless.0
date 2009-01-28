Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:56023 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZA1Ij1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 03:39:27 -0500
Received: by fg-out-1718.google.com with SMTP id 13so463352fge.17
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 00:39:25 -0800 (PST)
To: Tomas Winkler <tomasw@gmail.com>
Cc: johannes@sipsolutions.net, vivek.natraj@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power save  mode is disabled
References: <20090122114240.31443.18218.stgit@tikku>
	<20090122114546.31443.79387.stgit@tikku>
	<1ba2fa240901231528m21f13c1m43721f1d673e7cc7@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 28 Jan 2009 10:39:21 +0200
In-Reply-To: <1ba2fa240901231528m21f13c1m43721f1d673e7cc7@mail.gmail.com> (Tomas Winkler's message of "Sat\, 24 Jan 2009 01\:28\:43 +0200")
Message-ID: <874ozj964m.fsf@litku.valot.fi> (sfid-20090128_093932_550255_3410F712)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

> On Thu, Jan 22, 2009 at 1:45 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
>> When a directed tim bit is set, mac80211 currently disables power save
>> ands sends a null frame to the AP. But if dynamic power save is
>> disabled, mac80211 will not enable power save ever gain.
>
> Why not?

Because of a bug.

>> Fix this by
>> adding ps-poll functionality to mac80211. When a directed tim bit is
>> set, mac80211 sends a ps-poll frame to the AP and checks for the more
>> data bit in the returned data frames.
>
> Still have to see the implementation but this sounds strange.

Please be more specific, I don't understand what part you think is
strange. This is specified in the spec, see chapter 11.2.

>> Using ps-poll is slower than waking up with null frame, but it's saves more
>> power in cases where the traffic is low. Userspace can control if either
>> ps-poll or null wakeup method is used by enabling and disabling dynamic
>> power save.
>
> Do you have numbers how much power you save?

Unfortunately not yet.

> With PS-Poll you must stay awak longer not saying that issueing TX
> (PS-poll) also consume power.Ususally TXing has higher power
> consumption then RX. Instead of tx(null PM=0) rx tx(ack)...rx
> tx(ack) tx(null PM=1) you have now tx(ps-poll) rx tx (ack)
> tx(ps-poll) rx tx(ack). So if the AP holds more then 3 packetes PS
> poll will consume more power in this very simplified computation.

Let's take the null frame approach:

1. notice tim bit set
2. send null frame (pm=0)
3. receive data frames
4. wait for all buffered data frames
5. send null frame (pm=1)

How do you know when the station has received all buffered data frames
from the AP (item 4 above)? By waiting a certain period after the last
received data frame? If that timeout is too short, we will get packet
loss, which is not good. If the timeout is too long, we waste too much
power.

With ps-poll we don't have to set any timeouts, the station can go to
sleep immeadiately after receiving a data frame with moredata bit not
set. So I see a clear advantage in certain cases where the data
troughput is very low and maximum power savings is desired. For
example when the device is idle on the table, display turned off and
only irc/jabber session is running in the background.

And remember that userspace can control this with the power timeout
setting. My recommendation would be to use this only when the device
is idle and display is turned off.

> Do you measure power consumption on of the NIC or the whole system?

Usually I measure just the whole system. I can measure the nic, but
that's very time consuming.

-- 
Kalle Valo
