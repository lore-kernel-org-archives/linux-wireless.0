Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33103 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbbHYVFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 17:05:42 -0400
Received: by lbbsx3 with SMTP id sx3so108027590lbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2015 14:05:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55DAD0FD.3070807@broadcom.com>
References: <CANfLQrbXn2pLjVY8DVC=xs9oWZC2nX3VcEZQMLh1zQa7i4EHCg@mail.gmail.com>
	<55DAD0FD.3070807@broadcom.com>
Date: Wed, 26 Aug 2015 00:05:40 +0300
Message-ID: <CANfLQrYQnk6bUjPEKxucxBhLvsRsqpfydvAkvsvKdg0nnte3iA@mail.gmail.com> (sfid-20150825_230547_374861_9230EEF0)
Subject: Re: bcmdhd: Concurrent use of wlan0 and virtual interface in managed mode
From: Gucea Doru <gucea.doru@gmail.com>
To: Arend van Spriel <arend@broadcom.com>, gautams@broadcom.com
Cc: Ecco Park <eccopark@broadcom.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Arend

On Mon, Aug 24, 2015 at 11:08 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 08/23/2015 05:15 PM, Gucea Doru wrote:
>>
>> Hello, community
>
>
> As you are using bcmdhd I don't think this particular community cares a lot
> about it. But I will take the bait ;-)
>

Thanks for taking the bait :). Should we move this discussion to a
bcmdhd specific mail-list?

>> I started with the simplest use-case where I have only two APs (AP1
>> and AP2) and an Android client  - a Nexus 5 device running the Kernel
>> from [1]. For the connection with AP1 I used the already present
>> interface wlan0. For the connection with AP2 I tried to use a newly
>> created virtual interface but the wpa_supplicant connection is not
>> successful. I'm not sure if this is a driver limitation or a driver
>> bug.
>
>
> I am not sure either. For the upstream brcmfmac we don't allow it at the
> moment. I am kinda surprised you were able to create the additional
> interface.

As you can see at [1], the .max_interface inside
sta_p2p_iface_combinations is set to 3 so I assume that's the reason
for being able to create a new virtual interface in the managed mode.
However, the driver  needs a new virtual interface only for the case
when during P2P-GO removal, P2P-GO is first changed to STA and later
only removed [2]. I don't think it's there for concurrent use with the
wlan0 interface or with the p2p interface. So, the concurrent usage of
wlan0 and a new vif seems to be a driver limitation, at least.

> There are a couple of things that I can think of here which may
> cause issues:
>
> - APs operating on different channels.
Actually I use the same AP both for the connection using the wla0
interface and the newly created virtual interface.
So, both interfaces are connecting using the same channel.

> - Both STA interfaces have powersave enabled.
How could I disable powesave mode?

> - Firmware/driver do not support multi STA.
>
Considering what I said above, it seems to be at least a driver
limitation.  How could I discover if it's also a firmware limitation?
(I CC-ed Ecco Park who has a lot of patches in the driver but he
didn't respond :)
>From my research, it seems that the firmware for BCM4330 (wireless
chip from Nexus 5) is closed-source. In this case, how does the driver
know how to communicate with the firmware? I assume there is an API
exposed by the firmware and the API is open-source. I would be really
grateful if you could give me more details about the communication
with the firmware.


> If APs are operating on the same channel it may work, but you probably won't
> have advantage of MP-TCP because of medium use.

Wow, I'm pleasantly surprised that you know about MP-TCP. That's
exactly what I will use. Connection to multiple APs was already
implemented on Linux and MP-TCP proved to have multiple advantages/
If we disregard WiFi interference between APs, the theoretically
optimal mobility solution is to always connect to every visible AP,
and let MPTCP handle load balancing at the transport layer: if an AP
has poor signal strength, its loss rate will be higher (because of
lower bandwidth and similar RTTs) and the MPTCP congestion controller
will simply migrate most of the traffic to the APs with better
connectivity to the client. This way, handover delays are eliminated
and the mobile enjoys continuous connectivity. But, yout're right,
medium use interferences can be a major issue, and you can read more
about at [3].

On Mon, Aug 24, 2015 at 2:08 PM, Gautam (Gautam Kumar) Shukla
<gautams@broadcom.com> wrote:
> I guess you can achieve the same by starting p2p client or gc and connect it
> with p2p go device. So you have 2 interface , one your wlan interface and
> another one is gc interface.
>

Yep, I already did this using a setup composed of two Nexus 5, a
laptop and an AP:
--------
wlan0: Nexus5_1 ----- AP ------ Laptop (on 5 Ghz)
First Nexus 5 is connected to the AP on 5Ghz. Also, the laptop is
connected with the AP on 5Ghz.

----
p2p: Nexus5_1 ---- (WiFi Direct on 2.4 Ghz) --- Nexus5_2 ---- AP (on 5
Ghz) --- Laptop:
First Nexus 5 is connected with the second Nexus 5 using WIFi Direct
on the 2.4 Ghz. Both the laptop and the second Nexus 5 are connected
to the AP on 5Ghz.
When I use just the wlan0 interface for an iperf test I get a high
throughput (~60Mbits/s). When I just connect the phones with WiFi
Direct (no iperf data transmitted on p2p) I get an iperf throughput
three times lower.
What are the possible explanations?

Do you have any numbers for the time needed for a switch between a the
2.4 Ghz and 5Ghz for bcmdhd?


Best regards,
Doru

[1] https://github.com/gdetal/mptcp_nexus5/blob/eb8eded8a6986e1ac94976ae206c74351abd0d1b/drivers/net/wireless/bcmdhd/wl_cfg80211.c#L195-L202
[2] https://github.com/gdetal/mptcp_nexus5/blob/eb8eded8a6986e1ac94976ae206c74351abd0d1b/drivers/net/wireless/bcmdhd/wl_cfg80211.c#L161-L163
[3] http://nets.cs.pub.ro/~costin/files/multi-wifi.pdf
