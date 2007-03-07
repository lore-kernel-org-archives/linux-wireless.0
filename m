Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965563AbXCGQvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 11:51:47 -0500
Message-Id: <20070307164531.910923000@sipsolutions.net>
Date: Wed, 07 Mar 2007 17:45:31 +0100
From: johannes@sipsolutions.net
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH (v3) 0/4] move everything in mac80211 from sysfs to debugfs
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to not export internal details via sysfs (which is a
userspace ABI) this patch series moves everything from sysfs
into debugfs.

There's still the problem with following renames in debugfs,
but the code is almost there so we only need to change two
lines of code once we get debugfs_rename().

Over the previously posted series this fixes a small bug with
a key's station symlink, introduces a new configuration symbol
for the debugfs interface and fixes a few other bugs for the
compiling-without-debugfs case.

I've now tested this in station mode with and without encryption
and in hostap mode.

johannes
