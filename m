Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab1ASWfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:35:32 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so1417828fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:35:32 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 0/8] Clean proto/ethernet.h and remove it.
Date: Wed, 19 Jan 2011 23:35:24 +0100
Message-Id: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the short discussion I started cleaning up the code, and this is the
first small patch series. I thought I'll start with rather simple 
replacements.

This series replaces everything from proto/ethernet.h with their 
equivalents in the kernel and then removes it.

It does not fix previously existing style violations, so checkpatch still
complains about too long lines; I will address these in further patches.

Since I do not have a supported device at hand, I'd be happy if anyone
could test that I didn't break anything while replacing things. Especially
in patch 7 (Replace ether_addr with fixed size array) I might have broken
something.

-- 

Jonas

Jonas Gorski (8):
  staging: brcm80211: Remove unused ETHER_<foo> macros.
  staging: brcm80211: Use linux ethhdr struct.
  staging: brcm80211: Remove unused ETHER_<foo> defines.
  staging: brcm80211: Remove ETHER_MAX_LEN definition.
  staging: brcm80211: Remove ETHER_TYPE_BRCM.
  staging: brcm80211: Remove static ether_bcast.
  staging: brcm80211: Replace ether_addr with fixed size array.
  staging: brcm80211: Remove proto/ethernet.h.

 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   19 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    5 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    5 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |    1 -
 drivers/staging/brcm80211/include/bcmcdc.h         |    3 +-
 drivers/staging/brcm80211/include/bcmutils.h       |    2 +-
 drivers/staging/brcm80211/include/proto/802.11.h   |   20 +++---
 drivers/staging/brcm80211/include/proto/bcmevent.h |    8 ++-
 drivers/staging/brcm80211/include/proto/ethernet.h |   72 --------------------
 drivers/staging/brcm80211/include/proto/wpa.h      |    2 -
 drivers/staging/brcm80211/include/wlioctl.h        |   23 +++---
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    3 +-
 drivers/staging/brcm80211/sys/wlc_alloc.c          |    4 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |   34 ++++-----
 drivers/staging/brcm80211/sys/wlc_bmac.h           |   14 ++--
 drivers/staging/brcm80211/sys/wlc_bsscfg.h         |    6 +-
 drivers/staging/brcm80211/sys/wlc_key.h            |    2 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   55 +++++++--------
 drivers/staging/brcm80211/sys/wlc_mac80211.h       |   12 ++--
 drivers/staging/brcm80211/sys/wlc_pub.h            |   10 ++--
 drivers/staging/brcm80211/sys/wlc_scb.h            |    2 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   18 ++---
 drivers/staging/brcm80211/util/bcmutils.c          |    5 +-
 26 files changed, 117 insertions(+), 212 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/include/proto/ethernet.h

