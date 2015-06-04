Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36579 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbbFDRWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 13:22:04 -0400
Received: by pdjm12 with SMTP id m12so34985839pdj.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 10:22:04 -0700 (PDT)
MIME-Version: 1.0
From: Allan Matthew <amatthew@3drobotics.com>
Date: Thu, 4 Jun 2015 10:21:43 -0700
Message-ID: <CAPHXWevfEUid5W=w6wtPorjxvXo9+pAmBQBU3VTJN8rV0a94Aw@mail.gmail.com> (sfid-20150604_192209_661810_3048943E)
Subject: RTS flood when client unexpectedly disconnects
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running into an issue where my AP blasts a ton of ready-to-send
packets out when a client goes out of range or unexpectedly
disconnects with no disassociation.  This flood of packets slows its
own network down as well as any other networks on the same channel or
adjacent channels.  The flood lasts for about 20s, but I can reduce
that to about 1s when using disassoc_low_ack=1 in hostapd.conf.

I'm running:
linux 3.10.17
ath9k/mac80211/cfg80211 from backports 12/21/2014
hostapd-2.4

I've tried turning off RTS with iw (iw phy0 set rts off) as well as
changing the threshold values with no effect.  It appears the RTS
setting is being overridden by minstrel_ht
(http://www.spinics.net/lists/linux-wireless/msg126563.html) but I'm
not sure if thats really the source of my problem.

Is this expected behavior?

Its having a pretty major impact on other clients on my network and
other networks around me... is there anyway can I work around it?  I'd
prefer not to use the disassoc_low_ack as it tends to decrease the
maximum range clients can connect and it only reduces the flood to
about 1s.

Thanks!
