Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2143 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYKWEmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 23:42:03 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [RFC PATCH 0/2] mac80211 suspend/resume
Date: Sat, 22 Nov 2008 23:41:24 -0500
Message-Id: <1227415286-30179-1-git-send-email-me@bobcopeland.com> (sfid-20081123_054213_121895_38E03104)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are suspend/resume callbacks for mac80211.

This is not for applying since it is known to be broken.  Particularly,
it is missing a few things in resume(), it currently triggers warnings, 
and resume() may want to defer some stuff in case the driver callbacks 
want an active userspace.  

However, here is the code where I left it last, rebased back into
compiling state, in case anyone wants to hack on it or poke holes.
This is one representative driver conversion but a series with some 
more drivers is here:

    http://bobcopeland.com/kernel/wl/

These mostly just give a rough idea -- especially in the larger driver 
conversions, I may have excised more than needed.

