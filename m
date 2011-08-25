Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:37223 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab1HYHDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 03:03:18 -0400
Received: by mail-bw0-f44.google.com with SMTP id r4so2436388bka.17
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 00:03:17 -0700 (PDT)
Subject: pull request: wl12xx 2011-07-05
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 10:03:12 +0300
Message-ID: <1314255792.2296.244.camel@cumari> (sfid-20110825_090325_007565_BFC280F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first batch of wl12xx patches intended for 3.2.  It contains
mostly some changes needed to support our new firmware version that has
just been published in linux-firmware. 

Please pull or let me know if there's any problem. This tree is based
on wireless-next/master.

Thanks!

The following changes since commit 25232490af96f899f7e17de2c136e03d2c9ded62:

  libertas: update readme file (2011-08-24 14:57:21 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Arik Nemtsov (17):
      wl12xx: Revert "wl12xx: schedule TX packets according to FW occupancy"
      wl12xx: Use a single fw for both STA and AP roles
      wl12xx: use 1 spare block in all cases
      wl12xx: handle dummy packet event also in ap mode
      wl12xx: fix session counter
      wl12xx: use dynamic hlids for AP-mode
      wl12xx: re-enable block ack session support
      wl12xx: AP-mode - set STA HT capabilities when adding a STA
      wl12xx: AP-mode - configure STA HT rates on join
      wl12xx: AP-mode - configure HT rate support to the FW
      wl12xx: track freed packets in FW by AC
      wl12xx: schedule TX packets according to FW packet occupancy
      wl12xx: handle wrap-around overflow in released Tx blocks FW counter
      wl12xx: enable AP advanced functionality
      wl12xx: set the AP-started flag only after setting keys
      wl12xx: AP-mode - prevent Tx to stale/invalid stations
      wl12xx: fix tx_queue_count spurious increment

Eliad Peller (23):
      wl12xx: temporarily disable advanced ap functions
      wl12xx: remove rx filtering stuff
      wl12xx: update fw status struct
      wl12xx: update acx commands
      wl12xx: update commands & events
      wl12xx: enable/disable role on interface add/remove
      wl12xx: add device role commands
      wl12xx: update scan cmd api
      wl12xx: update rx/tx
      wl12xx: change max/default template size
      wl12xx: use wl1271_acx_beacon_filter_opt for both sta and ap
      wl12xx: add set_rate_mgmt_params acx
      wl12xx: add system_hlid
      wl12xx: add ROC/CROC commands
      wl12xx: replace dummy_join with ROC/CROC commands
      wl12xx: update BT coex configuration params
      wl12xx: call wl12xx_cmd_set_peer_state() in AP mode
      wl12xx: don't remove key if hlid was already deleted
      wl12xx: add wl12xx_cmd_role_start_ibss()
      wl12xx: support IBSS vif type
      wl12xx: use ap_bcast_hlid for recorded keys
      wl12xx: don't remove key if hlid was already deleted
      wl12xx: don't wait for disconnection event

Gery Kahn (1):
      wl12xx: fixes for hw_pg_ver and chip id reporting

Shahar Levi (1):
      wl12xx: Add support to RX packets payload alignment

 drivers/net/wireless/wl12xx/acx.c          |  322 ++++------
 drivers/net/wireless/wl12xx/acx.h          |  394 ++++--------
 drivers/net/wireless/wl12xx/boot.c         |   43 +-
 drivers/net/wireless/wl12xx/boot.h         |    3 +-
 drivers/net/wireless/wl12xx/cmd.c          |  793 +++++++++++++++++------
 drivers/net/wireless/wl12xx/cmd.h          |  329 ++++++-----
 drivers/net/wireless/wl12xx/conf.h         |  352 ++++------
 drivers/net/wireless/wl12xx/debugfs.c      |   17 +-
 drivers/net/wireless/wl12xx/event.c        |    6 +-
 drivers/net/wireless/wl12xx/event.h        |   80 +--
 drivers/net/wireless/wl12xx/init.c         |   91 +--
 drivers/net/wireless/wl12xx/io.h           |    1 -
 drivers/net/wireless/wl12xx/main.c         |  961 +++++++++++++++++-----------
 drivers/net/wireless/wl12xx/ps.c           |    4 +-
 drivers/net/wireless/wl12xx/reg.h          |   75 ---
 drivers/net/wireless/wl12xx/rx.c           |   60 +-
 drivers/net/wireless/wl12xx/rx.h           |   18 +-
 drivers/net/wireless/wl12xx/scan.c         |   38 +-
 drivers/net/wireless/wl12xx/scan.h         |   25 +-
 drivers/net/wireless/wl12xx/sdio.c         |    4 +-
 drivers/net/wireless/wl12xx/spi.c          |    4 +-
 drivers/net/wireless/wl12xx/tx.c           |  136 +++--
 drivers/net/wireless/wl12xx/tx.h           |   16 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |  153 +++---
 drivers/net/wireless/wl12xx/wl12xx_80211.h |   25 -
 25 files changed, 2090 insertions(+), 1860 deletions(-)

-- 
Cheers,
Luca.





