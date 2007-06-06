Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbXFFDvj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 23:51:39 -0400
Subject: Please pull libertas-2.6
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 05 Jun 2007 23:55:22 -0400
Message-Id: <1181102122.18061.8.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Changes since you last pulled are mainly Christoph-inspired cleanups, a
few bug fixes, mesh scanning, and a few more mesh-specific knobs (though
most likely general to 802.11s implementations, not just the CozyBit
one).

Per the email thread with jgarzik from the last pull, everything from
libertas-2.6 'master' branch is currently targeted at _2.6.22_.

Thanks,
Dan

---

The following changes since commit fce1142de24730373ab0f922896f81e225e132d7:
  John W. Linville (1):
        Merge branch 'libertas'

are found in the git repository at:

  git://git.infradead.org/libertas-2.6

Dan Williams (24):
      libertas: actually remove version.h
      libertas: kill wlan_scan_process_results
      libertas: kill ieeetypes_capinfo bitfield, use ieee80211.h types
      libertas: rename WLAN_802_11_KEY to enc_key and clean up usage
      libertas: clean up indentation in libertas_association_worker
      libertas: clean up 802.11 IE post-scan handling
      libertas: rename private ioctl constants and clean up ioctl handling
      libertas: remove if_bootcmd.c
      libertas: fix mixed-case abuse in cmd_ds_802_11_scan
      libertas: fix mixed-case abuse in cmd_ds_802_11_ad_hoc_result
      libertas: fix mixed-case abuse in cmd_ds_802_11_ad_hoc_start
      libertas: re-uppercase command defines and other constants
      libertas: fix debug build breakage due to field rename
      libertas: remove thread.h and make kthread usage clearer
      libertas: new mesh control knobs
      libertas: bump version to 322.p1
      libertas: wlan_ -> libertas_ rename in ioctl.c
      libertas: fix more mixed-case abuse
      libertas: move generic firmware reset command to common code
      libertas: wlan_ -> libertas_ function prefix renames for main.c
      libertas: simplify and clean up data rate handling
      libertas: fix MESH_[GET/SET]_BCASTR ioctl, clean up ioctl subcmd handling
      libertas: actually send mesh frames to mesh netdev

Luis Carlos Cobo (1):
      libertas: specific mesh scan for mshX interface

Luis Carlos Cobo Rus (2):
      libertas: pull current channel from firmware on mesh autostart
      libertas: deauthenticate from AP in channel switch

 drivers/net/wireless/libertas/11d.c        |   22 +-
 drivers/net/wireless/libertas/Makefile     |    1 -
 drivers/net/wireless/libertas/README       |   65 ++++
 drivers/net/wireless/libertas/assoc.c      |   98 ++++---
 drivers/net/wireless/libertas/assoc.h      |    2 +
 drivers/net/wireless/libertas/cmd.c        |  338 ++++++++++----------
 drivers/net/wireless/libertas/cmdresp.c    |  173 +++++-----
 drivers/net/wireless/libertas/debugfs.c    |  130 ++++----
 drivers/net/wireless/libertas/decl.h       |    6 +-
 drivers/net/wireless/libertas/defs.h       |   66 ++---
 drivers/net/wireless/libertas/dev.h        |   35 +--
 drivers/net/wireless/libertas/ethtool.c    |    8 +-
 drivers/net/wireless/libertas/fw.c         |   43 ++--
 drivers/net/wireless/libertas/host.h       |  438 +++++++++++++-------------
 drivers/net/wireless/libertas/hostcmd.h    |   69 ++---
 drivers/net/wireless/libertas/if_bootcmd.c |   40 ---
 drivers/net/wireless/libertas/if_usb.c     |   58 ++--
 drivers/net/wireless/libertas/if_usb.h     |    1 -
 drivers/net/wireless/libertas/ioctl.c      |  478 +++++++++++++++-------------
 drivers/net/wireless/libertas/join.c       |  374 +++++++++++-----------
 drivers/net/wireless/libertas/join.h       |    2 +
 drivers/net/wireless/libertas/main.c       |  232 ++++++++------
 drivers/net/wireless/libertas/rx.c         |   14 +-
 drivers/net/wireless/libertas/scan.c       |  355 ++++++++-------------
 drivers/net/wireless/libertas/scan.h       |   10 +-
 drivers/net/wireless/libertas/thread.h     |   52 ---
 drivers/net/wireless/libertas/tx.c         |    2 +-
 drivers/net/wireless/libertas/types.h      |   65 +----
 drivers/net/wireless/libertas/version.h    |    1 -
 drivers/net/wireless/libertas/wext.c       |  428 ++++++++------------------
 drivers/net/wireless/libertas/wext.h       |   68 +++--
 33 files changed, 1731 insertions(+), 1975 deletions(-)
 delete mode 100644 drivers/net/wireless/libertas/if_bootcmd.c
 delete mode 100644 drivers/net/wireless/libertas/thread.h
 delete mode 100644 drivers/net/wireless/libertas/version.h


