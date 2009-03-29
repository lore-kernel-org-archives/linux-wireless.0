Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:7321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbZC2XgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 19:36:24 -0400
Received: by fg-out-1718.google.com with SMTP id 16so233211fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 16:36:21 -0700 (PDT)
Subject: AR2425 - test report
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	Nick Kossifidis <mick@madwifi-project.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 02:36:17 +0300
Message-Id: <1238369777.5165.32.camel@maxim-laptop> (sfid-20090330_013642_803228_1EB64999)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I today did some testing with my aspire one and its wireless, and this
is what I found:


Environment: B/G AP configured for WPA2, about -50 to -60 dBm signal
about (-101 noise - according to ath5k - in short the access point in
next room)

A wired desktop connected to the access point.
I also have a laptop, but I didn't use in in tests.

Win XP (on aspire of course):
Upload/download speeds 2.4 Mbytes/s - solid speeds, just one horizontal
line, tested against samba on wired desktop, thus have just copied large
files, thus might be better.


Madwifi-free - I tried it to compare it, as it seems to have ANI
support, and many more features. 
Download 2.3/2.4 Mbytes/s - solid, and this thing lies so it shows you
that you have 4.7 Mbytes/s, but looking at desktop reveals the truth.
or using iperf.

Uploads - very very badly, almost always, stall, sometimes peak at 2.1
Mbytes/s, in other words almost don't work at all - I wonder how
downloads still work, as there is still some upload stream for tcp acks
(about 30 Kbytes/s I think or even more).

Everything else broken, for example adhoc doesn't work, with or without
wlanconfig. I am not complaining about it, it is dead anyway, just what
worries me is that since madwifi and its free hal don't work, then you
could make the device work without the docs?



and now ath5k:

Uploads/downloads also peak at 2.4 Mbytes/s, but often data transfer
stalls.

This is what I found:


Uploads alone (udp) seems to work always, although, somehow udp gives me
maximum 1.5 Mbytes/s, but TCP gives 2.4 Mbytes/s

Downloads stall often, and this happen randomally, and seems phy
related. If I restart the device by triggering scanning (sudo iwlst
scan...) it starts to work again for a while.

It doesn't seem to be related to reset, actually, the resets that often
happen, just cause an inverted spike on throughput graph. This seems to
happen without a reset, and like I said reset helps.


TCP uploads stall too, but I feel that it is related to download too.


It could be that I mixed up directions above, I retest this again.


Then I turned off WPA2, switched to open mode.
Suddenly download speeds increased to 2.9/3.0 Mbytes/s, and uploads
speed increased too, don't remember how much. I use hardware crypto, but
does it support AES? (Maybe this is due to the fact that atom is slow?)

Speaking of which, by doing some simple benchmarks (loops in bash) this
atom seems to be 3 times slower that core 2 duo 1.5 Ghz T5450 - on my
notebook - of course - atom is single core, and this is dual core - thus
for compilations atom is effectively 6 times slower....)

My laptop's iwl3945 does 3.0 Mbytes/s in one direction (don't remeber
which, with or without WPA2 and 2.4 in other direction - didn't try
without WPA2 - will do someday)



Best regards,
	Maxim Levitsky


