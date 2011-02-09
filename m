Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41779 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab1BIMCB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:02:01 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 1D908664006
	for <linux-wireless@vger.kernel.org>; Wed,  9 Feb 2011 13:01:59 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC] DFS userspace handler
Date: Wed,  9 Feb 2011 13:01:40 +0100
Message-Id: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello DFS folks,

this is a patch series to prove the concept of DFS handling done in userspace.

It moves the radar pattern detector introduced in [1] and documented in [2] 
from mac80211 up to hostapd.

The basic concept is:
1) pattern detection
 * pulse events detected by HW are passed to hostapd
 * hostapd performs per-wiphy DFS pattern matching
2) channel handling: on radar detection hostapd
 * updates channel state (NOL handling)
 * switches to new operating channel with TX disabled (on all wiphys)
 * after CAC period enables TX on that channel

The proposed patches provide part 1) of the concept. The nl80211 interface is
extended with functions to pass DFS pulse events to hostapd.

Testing as described in [2] results in identical output, indicating that both
approaches (mac80211 and hostapd based) are equivalent from functional point
of view.

The testing was done with
 * OpenWRT r25417
 * Atheros AR9280 Rev:2
 * DFS radars generated with R&S vector signal generator

We at our company would prefer this approach over the mac80211 based one as
soon as we see that part 2) can be implemented as proposed. 



Cheers
Zefir



[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/61868
[2] http://linuxwireless.org/en/developers/DFS/DetectorDesignNt
---
-- 
1.7.1

