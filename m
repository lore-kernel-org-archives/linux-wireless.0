Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbYBWOVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:21:30 -0500
Message-Id: <20080223141703.194775000@sipsolutions.net> (sfid-20080223_142138_743612_1D842388)
Date: Sat, 23 Feb 2008 15:17:03 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 00/18] mac80211 802.11s networking code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cleaned up version of Luis's 11s code which doesn't break
git bisect, compiles cleanly and ultimately has a lot less #ifdefs.

Let's merge this code and fix the remaining problems later.

Notably, this marks 11s as BROKEN because of endianness problems in it.

John, this applies after the following patches:
 * mac80211: fix IBSS code
 * mac80211: rework TX filtered frame code
 * mac80211: atomically check whether STA exists already
 * mac80211: fix debugfs_sta print_mac() warning
 * mac80211: Disallow concurrent IBSS/STA mode interfaces

Please apply those first and then this set, I will respin my sta_info
rework on top of these patches (it needs bugfixes anyway.)

johannes

