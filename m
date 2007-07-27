Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:43694 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759633AbXG0R0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 13:26:19 -0400
Date: Fri, 27 Jul 2007 19:26:17 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: mac80211: pull request
Message-ID: <20070727192617.5ae82584@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git up-2.6
to obtain patches below.

This is intended for wireless-2.6. Because of the number of patches and
the fact they are not much tested, it's maybe a good idea not to push
them upstream immediately - but that's up to you.

Andy Green (2):
      mac80211: Add get_unaligned to ieee80211_get_radiotap_len
      mac80211: Improve sanity checks on injected packets

Daniel Drake (5):
      mac80211: missing dev_put in ieee80211_master_start_xmit
      mac80211: STA reassociation improvements
      mac80211: don't allow scanning in monitor mode
      mac80211: improved short preamble handling
      mac80211: implement ERP info change notifications

Ivo van Doorn (1):
      mac80211: Add LONG_RETRY flag to ieee80211_tx_control

Johannes Berg (14):
      mac80211: split RX handlers into own file
      mac80211: move QoS rx handlers into rx.c
      mac80211: rx cleanups (1)
      mac80211: split ieee80211_rx_h_check handler
      mac80211: split up __ieee80211_rx
      mac80211: fix bug for per-sta stats
      mac80211: rx cleanups (2)
      mac80211: split TX path into own file
      mac80211: remove some unnecessary includes
      mac80211: split out some key functions from ieee80211.c
      mac80211: move some rate control functions out of ieee80211.c
      mac80211: reorder interface related functions
      mac80211: introduce util.c
      mac80211: fix add_interface monitor mode behaviour

Michael Wu (2):
      mac80211: improve locking of sta_info related structures
      mac80211: use more GFP_KERNEL instead of GFP_ATOMIC

Zhu Yi (2):
      mac80211: use do { } while (0) for multi-line macros
      mac80211: Fix sparse error for sta_last_seq_ctrl_read

 include/net/ieee80211_radiotap.h |   10 +
 include/net/mac80211.h           |   34 +-
 net/mac80211/Makefile            |    6 +-
 net/mac80211/debugfs_netdev.c    |    8 +-
 net/mac80211/debugfs_sta.c       |    2 +-
 net/mac80211/ieee80211.c         | 4491 ++++----------------------------------
 net/mac80211/ieee80211_i.h       |   74 +-
 net/mac80211/ieee80211_iface.c   |    2 +-
 net/mac80211/ieee80211_ioctl.c   |   36 +-
 net/mac80211/ieee80211_rate.c    |   42 +
 net/mac80211/ieee80211_rate.h    |    6 +
 net/mac80211/ieee80211_sta.c     |   60 +-
 net/mac80211/key.c               |   69 +
 net/mac80211/rx.c                | 1453 ++++++++++++
 net/mac80211/sta_info.c          |  184 +-
 net/mac80211/sta_info.h          |   11 +-
 net/mac80211/tx.c                | 1883 ++++++++++++++++
 net/mac80211/util.c              |  488 +++++
 net/mac80211/wme.c               |   65 -
 net/mac80211/wme.h               |    9 +-
 20 files changed, 4589 insertions(+), 4344 deletions(-)


-- 
Jiri Benc
SUSE Labs
