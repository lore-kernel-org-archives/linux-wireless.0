Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757177AbXHETuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 15:50:20 -0400
Subject: suspend/resume support in mac80211
From: Mattias Nissler <mattias.nissler@gmx.de>
To: linux-wireless@vger.kernel.org
Cc: rt2400-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Sun, 05 Aug 2007 21:50:17 +0200
Message-Id: <1186343417.8459.23.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we have recently been struggling with getting suspend/resume working in
rt2x00. A few questions:

1. What is the recommended scheme for implementing suspend/resume with
mac80211? Some drivers (p54, iwlwifi) call ieee80211_stop_queues().
rt2x00 is currently doing so, but it doesn't seem to be enough: mac80211
calls back into rt2x00 while the device is suspended, resulting in
chaos.

2. Are there any mac80211 drivers that suspend/resume properly? Also
when associated?

3. Shouldn't mac80211 be made suspend/resume-aware (AFAIK it is not), so
we can do things like disassociating during suspend and reassociating
when resuming? I'd like something in the spirit of
netif_device_detach()/netif_device_attach(). Comments?

Cheers,

Mattias

