Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36745 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbcASPoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 10:44:05 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: johannes@sipsolutions.net
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, jprvita@endlessm.com,
	linux@endlessm.com
Subject: [PATCH 0/8] General RFKill improvements
Date: Tue, 19 Jan 2016 10:42:35 -0500
Message-Id: <1453218163-31998-1-git-send-email-jprvita@endlessm.com> (sfid-20160119_164528_086101_42B376B6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a few general improvements to the RFKill code, found while
I was writing the rfkill-all / airplane mode LED trigger. All were points where
I had to read twice or do some other kind of extra effort to fully understand
it, so I think merging these changes will benefit someone trying to understand
the RFKill subsystem in the future.

It also removes sysfs interfaces that were marked as obsolete for 4+ years.

João Paulo Rechi Vita (8):
  rfkill: Documentation and style fixes
  rfkill: Improve code readability
  rfkill: Improve code readability
  rfkill: Remove obsolete "claim" sysfs interface
  rfkill: Remove obsolete "state" sysfs interface
  rfkill: Move user_state_from_blocked() close to its user
  rfkill: Update userspace API documentation
  rfkill: Factor common code

 Documentation/ABI/obsolete/sysfs-class-rfkill |  29 -----
 Documentation/ABI/removed/sysfs-class-rfkill  |  30 +++++
 include/linux/rfkill.h                        |   7 +-
 include/uapi/linux/rfkill.h                   |   1 +
 net/rfkill/core.c                             | 154 ++++++++------------------
 5 files changed, 82 insertions(+), 139 deletions(-)
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-rfkill
 create mode 100644 Documentation/ABI/removed/sysfs-class-rfkill

-- 
2.5.0

