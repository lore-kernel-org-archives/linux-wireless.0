Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:36246 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcBVQg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 11:36:59 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCHv2 00/10] RFKill airplane-mode indicator
Date: Mon, 22 Feb 2016 11:36:31 -0500
Message-Id: <1456159001-20307-1-git-send-email-jprvita@endlessm.com> (sfid-20160222_174336_435319_51095A8D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series implements an airplane-mode indicator LED trigger, which can be
used by platform drivers. The default policy have have airplane-mode set when
all the radios known by RFKill are OFF, and unset otherwise. This policy can be
overwritten by one single userspace application at a time using the operations
_AIRPLANE_MODE_INDICATOR_ACQUIRE and _AIRPLANE_MODE_INDICATOR_CHANGE. When the
airplane-mode indicator state changes, userspace gets notifications through the
RFKill control misc device (/dev/rfkill).

The series also contains a few general fixes and improvements to the subsystem.

Additionally, I have a couple of patches to have this feature supported by the
userspace tool 'rfkill' [1]. Should I use a different subject prefix to help
separate those from kernel patches in linux-wireless?

[1] https://wireless.wiki.kernel.org/en/users/documentation/rfkill

João Paulo Rechi Vita (10):
  rfkill: Improve documentation language
  rfkill: Remove extra blank line
  rfkill: Point to the correct deprecated doc location
  rfkill: Move "state" sysfs file back to stable
  rfkill: Factor rfkill_global_states[].cur assignments
  rfkill: Add documentation about LED triggers
  rfkill: Create "rfkill-airplane-mode" LED trigger
  rfkill: Use switch to demux userspace operations
  rfkill: Userspace control for airplane mode
  rfkill: Notify userspace of airplane-mode state changes

 Documentation/ABI/obsolete/sysfs-class-rfkill |  20 ----
 Documentation/ABI/stable/sysfs-class-rfkill   |  27 ++++-
 Documentation/rfkill.txt                      |  17 +++
 include/uapi/linux/rfkill.h                   |   6 +
 net/rfkill/core.c                             | 162 ++++++++++++++++++++------
 5 files changed, 173 insertions(+), 59 deletions(-)
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-rfkill

-- 
2.5.0

