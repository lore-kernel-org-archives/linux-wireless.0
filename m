Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58615 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3FNX62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 19:58:28 -0400
Received: by mail-pb0-f44.google.com with SMTP id uo1so1024555pbc.31
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 16:58:28 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Jun 2013 19:58:28 -0400
Message-ID: <CA+7oygcTxgPiVbup6BT-+sJWFNy=nMTc8C7OeCew9Xc6WgQinw@mail.gmail.com> (sfid-20130615_015844_150670_65E8AF4A)
Subject: unable to force transmission rate on injection
From: George Nychis <gnychis@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an ath9k_htc card that I am trying to force a transmission rate
on injection.  I did some digging around and found this patch from
Pavel:

http://article.gmane.org/gmane.linux.kernel.wireless.general/47441

I updated and implemented that patch in to my kernel, and I see my
injected packets coming down through the code.  I see that the rates I
am trying to transmit pass the test to make sure that the rate is
available:

[ 1244.647325] *** gnychis: OK on rate 540 -- idx: 11
[ 1244.682061] *** gnychis: OK on rate 480 -- idx: 10
[ 1244.741305] *** gnychis: OK on rate 360 -- idx: 9
...

And then I double checked to make sure that, given the flag,
ieee80211_tx_h_rate_ctrl() is *not* being called.  So, to the best of
my knowledge the patch supplied seems to keeping the supplied rate and
disabling rate control.

But, for some reason it still keeps getting transmitted at a rate of
1Mbps.  I have verified this with an independent receiver.  If I do a
pcapdump on the transmitting interface, I see two packets for every
transmission.  One at the rate I am trying to transmit at, and another
at 1Mbps:
http://users.ece.cmu.edu/~gnychis/bad_tx.pcap

Am I missing something else in mac80211 to inject at a specific rate?

Thanks!
George
