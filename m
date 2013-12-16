Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:45612 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3LPNvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 08:51:16 -0500
Received: by mail-ig0-f174.google.com with SMTP id hk11so3803937igb.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 05:51:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387201528.2057.1.camel@jlt4.sipsolutions.net>
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
	<1387197416.4665.15.camel@jlt4.sipsolutions.net>
	<CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com>
	<1387201528.2057.1.camel@jlt4.sipsolutions.net>
Date: Mon, 16 Dec 2013 14:51:15 +0100
Message-ID: <CANq1E4TJWCgM4yCFC25b3ssQEvFv+hEhW6jP3_mQKxQCw-QtUQ@mail.gmail.com> (sfid-20131216_145130_239119_499B1A67)
Subject: Re: [BUG] P2P setup timeout
From: David Herrmann <dh.herrmann@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Dec 16, 2013 at 2:45 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-12-16 at 14:39 +0100, David Herrmann wrote:
>
>> > Can you check in a sniffer what the frame bitrates are that go out? This
>> > seems suspicious:
>> >
>> > nl80211: Set TX rates failed: ret=-100 (Network is down)
>>
>> I looked at the sniffer data and all I see is a huge amount of p2p
>> probe requests from my local device, the successful p2p-invitation and
>> invitation response and then lots of go-negotiation requests that
>> never get any response.
>
> Right, and I suspect they don't get a response because (as the sniffer
> trace tells me) they're sent with 1 Mbps (a CCK rate), which is invalid
> in the P2P spec (must use OFDM).
>
> Thus something is wrong with the TX bitrates stuff, but I can't tell you
> where that would be ...

Ok, I will try hooking into the ath9k driver then and see why setting
TX rates fails. Thanks a lot! Maybe Oleksij has some more ideas on
that.

Thanks
David
