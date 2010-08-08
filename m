Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:48351 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab0HHTZK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Aug 2010 15:25:10 -0400
Received: from pippo.localnet (p5B174554.dip.t-dialin.net [91.23.69.84])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hyde.gogi.tv (Postfix) with ESMTPSA id B27784800B
	for <linux-wireless@vger.kernel.org>; Sun,  8 Aug 2010 19:25:07 +0000 (UTC)
To: linux-wireless@vger.kernel.org
Subject: Setting MCS rate on injected packets does not work properly (with patches)
From: Daniel Haid <d.haid@gogi.tv>
Date: Sun, 8 Aug 2010 21:24:32 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008082124.33033.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have applied some old patches that were posted here,
that allow to set the rate via the radiotap header for
injected packets.

Additionally I had to comment out the call
to ieee80211_tx_h_rate_ctrl in net/mac80211/tx.c
for anything to work.

I have patched two stations. My problem is as follows:

When I use hostapd on one station and enable HT I get
rates of about 60MBit/s.

But when I inject packets manually and I set the MCS index
the MCS index gets reported properly at the other station.
However no matter what index I choose, I never get rates
higher than 10MBit/s  (I wrote a program that reads monitor
mode packets with libpcap and sends them to a tun device
and everything that comes from the tun device is injected
with libpcap - then I measured the rate for UDP packets sent
trough this connection).

Is there anything that has to be set up first for MCS mode to
work properly? What else can I do?

Thank you.
