Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44613 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbeA0NRr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 08:17:47 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k will not tx packets sometimes.
In-Reply-To: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com>
Date: Sat, 27 Jan 2018 14:11:28 +0100
Message-ID: <87a7wzv43j.fsf@toke.dk> (sfid-20180127_141751_755960_5C6077D3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> I'm doing a test with 200 virtual stations on each of 6 ath9k radios.
>
> When I configure stations for DHCP, I see cases where stations on a particular
> radio will not transmit anything sometimes.  I see no 'XMIT' logs that show indication of
> frames being received in the driver from the upper stack, but if I use 'tshark' on
> a station interface, it shows frames being 'transmitted'.
>
> I do, however, see this, which looks like it might show
> an issue.  It looks like whatever 'aqm' is, it has an ever expanding number
> of backlog packets:

The aqm is the intermediate queues in mac80211. So this indicates that
the driver is not pulling packets for transmission.

With that many stations, I wonder whether it is due to the airtime
fairness scheduler throttling the station? What is the contents of
debug/ieee80211/wiphy2/netdev\:sta30194/stations/00\:0e\:8e\:69\:b8\:f7/airtime
while the station is not transmitting? And is it all stations on that
particular radio, or only some of them?

-Toke
