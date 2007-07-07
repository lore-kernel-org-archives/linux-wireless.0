Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:20986 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXGGUJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 16:09:26 -0400
Received: by wa-out-1112.google.com with SMTP id v27so772035wah
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2007 13:09:26 -0700 (PDT)
Message-ID: <9e4733910707071309u101a890fl3e1013c10226961d@mail.gmail.com>
Date: Sat, 7 Jul 2007 16:09:26 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Problems with promiscuous mode fixed - wireshark
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've fixed the promiscuous problem but I don't know what the cause
was. I noticed that when I captured a lot of packets with libpcap, it
and the adapter were reporting the same number of packets seen. That
implied that nothing was missing which made me suspect wireshark.
Deleting the .wireshark directory made all of the missing packets
appear. So I must have done something to wireshark to make it filter
out packets that weren't directed to me in a way that it remembered
the filter across restarts, but I don't know what I did to get it in
that mode. tcpdump was getting the packets, but I was writing them to
a file and using wireshark to look at them.

Something is still wrong with the radio tap headers. Using the bcm4318
all of my packets say they were captured on channel 3, when they were
captured from channel 1. This may be a problem with wireshark. The
beacons show channel 1 in tcpdump, and channel 3 in wireshark.

Have the structures for radio tap been changed? That could explain
things if wireshark is compiled with the old version. I'm using
0.99.4-6 from ubuntu.

So now I can get back to my original goal of get zd1211/rt2x00 to run
on an ARM with mac80211 and OLSR. I can say that the zd1211 and rt2x00
mac80211 drivers appear to be working much better now than they were
six months ago.

-- 
Jon Smirl
jonsmirl@gmail.com
