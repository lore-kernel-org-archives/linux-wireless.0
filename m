Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48147 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3IIVZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 17:25:46 -0400
Received: by mail-ob0-f174.google.com with SMTP id wd6so6439919obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 14:25:46 -0700 (PDT)
Date: Mon, 9 Sep 2013 16:25:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Performance problems with Netgear WNDAP350
Message-ID: <20130909212544.GA27771@thinkpad-t410> (sfid-20130909_232550_013099_9793BFC7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the previous fix to deal with invalid ECSA IEs in probe response
frames, I've received more reports of trouble with this AP. I've been
experimenting with one and have uncovered some odd behavior that I'm not
sure how to deal with.

I've found in testing TCP throughput with iperf that the performance
ranges from somewhat inconsistent to downright terrible with Linux STAs.
I've tried iwlwifi, ath9k, and brcmsmac, and all are similar. I also
tested with OSX, and while performance is pretty inconsistent it never
gets to the point of being absolutely terrible. My test setup has the
iperf server behind the APs ethernet interface with the client on the
STA.

What I'm seeing under wireshark is that everything seems to go fine for
a while, but sometimes the AP is failing to transmit the TCP ACKs from
the iperf server to the STA in a timely fashion. This delay can be
seconds in length, and I see it with iwlwifi, ath9k, and brcmsmac. I've
run wireshark on my iperf server, and the delays do not show up between
the same ACKs there.

I see the delays when running the iperf client on OSX too, but they're
never quite as bad. The difference seems to be that once the TCP window
is exhaused, OSX enables power save for a couple hundred msecs before
retransmitting. This somehow seems to get the AP to transmit the frames
(though the TIM never indicates that there are any buffered frames). I
don't see the problem if I prevent the AP from transmitting A-MPDUs,
even if the STAs continue using aggregation.

So it seems apparent that this AP has issues. I'm hoping to solicit some
suggestions on how we might be able to deal with it. I could try to
emulate the behavior I see from OSX, but that won't help for drivers
that don't support power save.

I posted some wireshark traces in case someone else can find something
else informative that I've missed. They're at
http://people.canonical.com/~sforshee/wndap350/:

 * iperf-iwlwifi.pcapng.gz: Trace from iperf client on Linux STA with
   iwlwifi
 * iperf-server.pcapng.gz: Trace from the iperf server for the same test
   as iperf-iwlwifi
 * iperf-osx.pcapng.gz: Trace from iperf client on OSX, using Broadcom
   wireless

I'm happy to collect more data if there's anything else that would be
useful.

Thanks,
Seth
