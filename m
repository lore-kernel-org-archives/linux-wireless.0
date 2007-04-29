Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34248 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031334AbXD2UBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 16:01:14 -0400
Date: Sun, 29 Apr 2007 22:01:12 +0200
From: Jiri Benc <jbenc@suse.cz>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: mac80211: pull request
Message-ID: <20070429220112.5703e15c@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git up
to obtain following patches:

James Ketrenos (1):
      mac80211: Fix ieee80211_sta_config_auth to select networks if rssi < 0

Jiri Benc (5):
      mac80211: remove unused code
      mac80211: remove test_mode
      mac80211: document requirement for atomicity of callbacks
      mac80211: add copyrights
      mac80211: remove hostapd scanning

Johannes Berg (1):
      mac80211: optimise ieee80211_get_hdrlen

Larry Finger (1):
      mac80211: Add channel to scan results

Michael Wu (18):
      mac80211: Add radiotap support
      mac80211: fix virtual interface related locking
      mac80211: disable tasklets on close
      mac80211: remove statistics callback for master device
      mac80211: avoid flush_scheduled_work
      mac80211: fix configuration concurrency issues in ieee80211_sta.c
      mac80211: misc cleanups in ieee80211_sta.c
      mac80211: set bssid to broadcast before scan
      mac80211: fix issues in ieee80211 qdisc
      mac80211: prevent master device from going up without ieee80211 qdisc
      mac80211: stop all virtual interfaces when master device goes down
      mac80211: kill ieee80211_set_mac_address
      mac80211: kill ceiling_div
      mac80211: eliminate forward declarations in ieee80211.c
      mac80211: set event_capa in iw_range
      mac80211: suppress warnings
      mac80211: Allow drivers to configure default regulatory domain
      mac80211: remove ieee80211_netif_oper

 include/net/mac80211.h         |  111 ++++--------
 net/mac80211/Makefile          |    1 -
 net/mac80211/debugfs.c         |    3 -
 net/mac80211/hostapd_ioctl.h   |    3 -
 net/mac80211/ieee80211.c       |  403 ++++++++++++++++++++--------------------
 net/mac80211/ieee80211_cfg.c   |   15 +-
 net/mac80211/ieee80211_i.h     |   50 +-----
 net/mac80211/ieee80211_iface.c |   79 ++++-----
 net/mac80211/ieee80211_ioctl.c |  178 ++++--------------
 net/mac80211/ieee80211_scan.c  |  344 ----------------------------------
 net/mac80211/ieee80211_sta.c   |   75 +++++---
 net/mac80211/sta_info.c        |    5 +-
 net/mac80211/wme.c             |   24 ++--
 net/mac80211/wme.h             |    1 +
 14 files changed, 370 insertions(+), 922 deletions(-)

-- 
Jiri Benc
SUSE Labs
