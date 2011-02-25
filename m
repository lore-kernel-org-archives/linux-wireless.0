Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1BYL0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 06:26:53 -0500
Message-Id: <20110225112409.977212647@sipsolutions.net>
Date: Fri, 25 Feb 2011 12:24:09 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Swati Rallapalli <swati@cs.utexas.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] fix iwlwifi needed RX chains
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally, I got around to looking into this
problem, I apologise for the delay!

The issue turns out to be that mostly we
were working with asymmetric devices (2x3)
and there this worked ... otherwise not.

The original mac80211 patch is still needed
to fix it, but it's not sufficient, iwlagn
also needs to be fixed.

Tested against an ath9k AP (3x3) and also
against the same ath9k AP with hostapd
hacked to pretend it is 1x1.

johannes

