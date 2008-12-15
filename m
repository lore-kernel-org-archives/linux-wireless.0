Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2020 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYLODuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2008 22:50:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mabbaswireless@gmail.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v2 0/3] mac80211 suspend/resume
Date: Sun, 14 Dec 2008 22:50:36 -0500
Message-Id: <1229313039-5544-1-git-send-email-me@bobcopeland.com> (sfid-20081215_045052_004012_72F7C56D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's version 2 of the suspend/resume for mac80211, including
Johannes Berg's patch for the cfg80211 hooks.  

Changes since last time:

 - fixed broken conditional for monitor & ap vlan checking
 - removed pm.h
 - removed frag threshold setting since that's gone now
 - the call to ieee80211_sta_tear_down_BA_sessions was locking up so 
   I just dropped it for now in the interest of getting a stable base

I also tracked down the disappearing interface problem.. turns out this 
was just gnome-power-manager or HAL.  (I do not have 'network_sleep' set 
in gconf, but I didn't bother pinning it down otherwise...)  Using 
'echo mem > /sys/power/state' to suspend keeps the interface up across
suspend.

This seems to work ok for me but can use a lot of testing.


