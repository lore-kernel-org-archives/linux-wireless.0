Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46507 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1ITIuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 04:50:00 -0400
Message-ID: <4E7853B3.1080100@qca.qualcomm.com> (sfid-20110920_105006_757856_F71AB43C)
Date: Tue, 20 Sep 2011 11:49:55 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Dave Taht <dave.taht@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: pass only unicast frames for aggregation
References: <20110919183844.25296.65533.stgit@localhost6.localdomain6> <CAA93jw7LnsJ-2+Js33M5JVu+Eo1920YyOiejizB9XBA04_qG_g@mail.gmail.com>
In-Reply-To: <CAA93jw7LnsJ-2+Js33M5JVu+Eo1920YyOiejizB9XBA04_qG_g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2011 10:40 PM, Dave Taht wrote:
> On Mon, Sep 19, 2011 at 11:38 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> When pinging form ar6003 to the AP RTT was high even when power save was
>> disabled:
>>
>> 100 packets transmitted, 97 received, 3% packet loss, time 99125ms
>> rtt min/avg/max/mdev = 1.875/46.733/795.506/139.181 ms
>>
>> After some investigation one reason for this was that received
>> multicast traffic confused the aggrecation logic and caused 400 ms
>> timeouts when receiving multicast frames from AP.
>>
>> A simple way to fix is to pass only unicast frames for aggregation. This
>> improves RTT:
>>
>> 100 packets transmitted, 99 received, 1% packet loss, time 99144ms
>> rtt min/avg/max/mdev = 2.083/13.084/403.390/56.794 ms
> 
> I note that while the improvement above is enormous, a 403ms RTT for
> a packet is the rough equivalent of a detour around all of planet Earth...
> between your couch and the AP.

That's because firmware doesn't disable 802.11 power save when I ping
with one second interval. Apparently it needs two frames within ~200 ms
to disable power save.

> Can outliers of this sort be improved?

Definitely. I just want to fix serious bugs first, like the one above.

> At what point are packets dropped?

I'm guessing that the power save has issues and drops packets
occasionally. I haven't investigated it yet.

Kalle
