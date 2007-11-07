Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:47688 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755874AbXKGJWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 04:22:36 -0500
Date: Wed, 7 Nov 2007 10:21:58 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Wu <flamingice.sourmilk.net@polimi.it>,
	Johannes Berg <johannes.sipsolutions.net@polimi.it>,
	Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: mac80211 doesn't reassociate after failed ProbeResp
Message-ID: <20071107102158.61b4ca3d@morte> (sfid-20071107_092252_538647_2789CD0F)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got a quite reproducible bug with mac80211. Sometimes, this happens
(phy0 is a b43 PHY):

Nov  7 02:06:23 morte [123784.591945] wlan0: No ProbeResp from current AP 00:14:c1:35:8d:eb - assume out of range
Nov  7 02:06:23 morte [123784.591968] phy0: Removed STA 00:14:c1:35:8d:eb

then, instead of trying to reassociate, mac80211 acts like this:
Nov  7 02:06:25 morte [123785.138041] wlan0: dropped data frame to not associated station 00:14:c1:35:8d:eb
Nov  7 02:06:25 morte [123785.138243] wlan0: dropped data frame to not associated station 00:14:c1:35:8d:eb
Nov  7 02:06:55 morte [123798.704732] wlan0: No STA entry for own AP 00:14:c1:35:8d:eb

I guess that's a mac80211 bug. I'll be happy to provide you with more
testing.


-- 
Ciao
Stefano
