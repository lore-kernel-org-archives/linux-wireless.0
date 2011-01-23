Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65238 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1AWVDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 16:03:07 -0500
Received: by fxm20 with SMTP id 20so3406578fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 13:03:05 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 0/6] Probe-resp offloading support
Date: Sun, 23 Jan 2011 23:02:53 +0200
Message-Id: <1295816579-28925-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support passing SSID and probe-response template to drivers.
This data can be used to offload the beacon -> probe-req -> probe-resp
process to HW.

v1->v2: Add probe response template configuration

Arik Nemtsov (6):
  nl80211: allow passing SSID in nl80211_set_bss
  nl80211: Pass probe response data to drivers
  mac80211: add SSID for AP mode with change notification
  mac80211: Save probe response data for BSS
  wl12xx: AP mode - support hidden SSID
  wl12xx: configure probe-resp template according to notification

 drivers/net/wireless/wl12xx/cmd.c  |   23 +++++++++-----------
 drivers/net/wireless/wl12xx/main.c |   32 +++++++++++++++++++++++++++-
 include/linux/nl80211.h            |    9 ++++++++
 include/net/cfg80211.h             |    8 +++++++
 include/net/mac80211.h             |   21 ++++++++++++++++++
 net/mac80211/cfg.c                 |   40 ++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h         |    1 +
 net/mac80211/iface.c               |    5 +++-
 net/mac80211/tx.c                  |   31 +++++++++++++++++++++++++++
 net/mac80211/util.c                |    8 ++++++-
 net/wireless/nl80211.c             |   40 ++++++++++++++++++++++++++++++++++++
 11 files changed, 202 insertions(+), 16 deletions(-)

