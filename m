Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946784Ab3BHRZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:25:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U3rhr-0000pC-BZ
	for linux-wireless@vger.kernel.org; Fri, 08 Feb 2013 18:25:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/14] mac80211: HT/VHT improvements
Date: Fri,  8 Feb 2013 18:25:30 +0100
Message-Id: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net> (sfid-20130208_182553_968211_D74B3094)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While continuing my VHT work I found a number of HT issues,
which I'm addressing to get consistent code and behaviour.
Some of the issues are minor, others like the change to not
muck with the station's HT capabilities require changes in
all drivers.

Overall the change with most potential impact would be the
change to track the HT/VHT channel width changes, but that
is a requirement. I myself removed it last year in commit
24398e39c8ee4a9d9123eed322b859ece4d16cac ("mac80211: set HT
channel before association") but that was a mistake, and in
my analysis there I missed that the AP could switch from 20
to 40 during operation -- if we had associated as a 40 MHz
capable station (which we would if the driver supports it)
then that'd still lead to deaf-ness problems.

Note that I'm making it disconnect if the AP switches to
something that we can't support or is incompatible with our
current channel contexts. We don't have much choice, but it
should be unlikely since it's just regulatory changes or
channel contexts -- the latter shouldn't happen due to the
802.11 channelization.

Note that the last patch is completely untested so far :-)

johannes

