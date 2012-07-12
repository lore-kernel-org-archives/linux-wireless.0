Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2GLUfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 16:35:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: michal.kazior@tieto.com, mohammed@qca.qualcomm.com
Subject: [PATCH 0/3] cfg80211/mac80211: revert/fix monitor interfaces
Date: Thu, 12 Jul 2012 22:35:37 +0200
Message-Id: <1342125340-6468-1-git-send-email-johannes@sipsolutions.net> (sfid-20120712_223555_060171_FA85FA00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So short of introducing a NETDEV_UP_FAIL hook that closes
NETDEV_PRE_UP, which I don't want to do right now, I don't
see a way to fix the monitor issue.

This mostly reverts back to the old code, but keeps the
monitor interface accounting so we can reject setting the
monitor channel.

johannes

