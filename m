Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3LPNpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 08:45:32 -0500
Message-ID: <1387201528.2057.1.camel@jlt4.sipsolutions.net> (sfid-20131216_144543_869010_B48EFC05)
Subject: Re: [BUG] P2P setup timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 16 Dec 2013 14:45:28 +0100
In-Reply-To: <CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com> (sfid-20131216_143914_205158_56AAC54B)
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
	 <1387197416.4665.15.camel@jlt4.sipsolutions.net>
	 <CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com>
	 (sfid-20131216_143914_205158_56AAC54B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 14:39 +0100, David Herrmann wrote:

> > Can you check in a sniffer what the frame bitrates are that go out? This
> > seems suspicious:
> >
> > nl80211: Set TX rates failed: ret=-100 (Network is down)
> 
> I looked at the sniffer data and all I see is a huge amount of p2p
> probe requests from my local device, the successful p2p-invitation and
> invitation response and then lots of go-negotiation requests that
> never get any response.

Right, and I suspect they don't get a response because (as the sniffer
trace tells me) they're sent with 1 Mbps (a CCK rate), which is invalid
in the P2P spec (must use OFDM).

Thus something is wrong with the TX bitrates stuff, but I can't tell you
where that would be ...

johannes

