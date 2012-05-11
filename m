Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2EKIiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 04:38:18 -0400
Message-Id: <20120511083413.778117363@sipsolutions.net> (sfid-20120511_103828_936680_9C636653)
Date: Fri, 11 May 2012 10:34:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] AP mode channel setting simplification
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ath6kl stores the channel, while mac80211 tries to
immediately apply it. The latter isn't great for
multi-channel.

Change cfg80211 to store the channel, and give it
to the driver (mac80211, ath6kl, etc.) only in the
start_ap() function.

This simplifies ath6kl a lot, and while it doesn't
make a difference to mac80211 today I think it'll
make it simpler to implement multi-channel.

johannes
