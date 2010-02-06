Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58419 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab0BFNUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 08:20:30 -0500
Received: by vws20 with SMTP id 20so1584009vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2010 05:20:29 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: holgerschurig@gmail.com, sameo@linux.intel.com, dcbw@redhat.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 0/2] cfg80211: Retrieve missing BSS info after connect
Date: Sat,  6 Feb 2010 13:20:14 +0000
Message-Id: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset attempts to address the issue where a driver that uses
the cfg80211 connect operation connects to an AP before the scan result
for the AP is available. This triggers a WARN_ON in sme.c, and the
connection fails.

This is only an issue for drivers that do not pass beacons/probes to
cfg80211, except in response to an explicit scan. With typical
userspace the issue will only manifest if using iwconfig to connect, or
if using wpa_supplicant with ap_scan=2 (which you might do with a
hidden SSID).

The patches were originally written for the orinoco cfg80211 conversion
(currently stalled due to lack of time). It sounds like the libertas
cfg80211 drivers have the same problem, so I'm posting them in case
they're useful. There's a bit of cleanup to do, and there may be issues
with the setting of the channels to scan (orinoco can't scan by
channel) so if someone wants to pick these up, please do.

Testing
 - a version of this has been running with my orinoco changes for the
   last 3 or 4 months (in more or less daily use).
 - Untested against drivers that don't use ->connect

Signed-off-by: David Kilroy <kilroyd@googlemail.com>

---
David Kilroy (2):
  cfg80211: generic trigger scan and callback on completion
  cfg80211: scan for missing BSS on connect completion

 include/net/cfg80211.h |    3 +
 net/wireless/core.h    |    6 ++
 net/wireless/scan.c    |   41 ++++++++++++-
 net/wireless/sme.c     |  163 ++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 178 insertions(+), 35 deletions(-)

