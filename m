Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1HNKRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:04 -0400
Received: by wyg24 with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:02 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 00/40] wl12xx: move to wl12xx-fw-3
Date: Sun, 14 Aug 2011 13:16:59 +0300
Message-Id: <1313317059-16567-1-git-send-email-eliad@wizery.com> (sfid-20110814_121711_910291_A71D78FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new wl12xx fw (ver 7.3.0.0.75) had some major api changes.
The main change was the addition of multi-role concept, which
will later allow using multiple vifs concurrently.

Consequently, this design change caused api changes for most
of the api commands, as a new role_id had to be added.

This patchset migrates the fw to use the new fw api (a new
fw filename is used, as there is no backward compatability
with older firmwares).

Additional patchsets will follow, with further bugfixes
and new features (e.g. p2p support).

v2: apply Luca's comments, rebase.

Arik Nemtsov (17):
  wl12xx: Revert "wl12xx: schedule TX packets according to FW
    occupancy"
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

 drivers/net/wireless/wl12xx/acx.c          |  322 ++++------
 drivers/net/wireless/wl12xx/acx.h          |  394 ++++--------
 drivers/net/wireless/wl12xx/boot.c         |   30 +-
 drivers/net/wireless/wl12xx/cmd.c          |  793 +++++++++++++++++------
 drivers/net/wireless/wl12xx/cmd.h          |  329 ++++++-----
 drivers/net/wireless/wl12xx/conf.h         |  352 ++++------
 drivers/net/wireless/wl12xx/debugfs.c      |   17 +-
 drivers/net/wireless/wl12xx/event.c        |    6 +-
 drivers/net/wireless/wl12xx/event.h        |   80 +--
 drivers/net/wireless/wl12xx/init.c         |   91 +--
 drivers/net/wireless/wl12xx/io.h           |    1 -
 drivers/net/wireless/wl12xx/main.c         |  951 +++++++++++++++++-----------
 drivers/net/wireless/wl12xx/ps.c           |    4 +-
 drivers/net/wireless/wl12xx/reg.h          |   75 ---
 drivers/net/wireless/wl12xx/rx.c           |   23 +-
 drivers/net/wireless/wl12xx/rx.h           |   10 +-
 drivers/net/wireless/wl12xx/scan.c         |   38 +-
 drivers/net/wireless/wl12xx/scan.h         |   25 +-
 drivers/net/wireless/wl12xx/sdio.c         |    4 +-
 drivers/net/wireless/wl12xx/spi.c          |    2 -
 drivers/net/wireless/wl12xx/tx.c           |  136 +++--
 drivers/net/wireless/wl12xx/tx.h           |   16 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |  153 +++---
 drivers/net/wireless/wl12xx/wl12xx_80211.h |   25 -
 24 files changed, 2034 insertions(+), 1843 deletions(-)

-- 
1.7.6.401.g6a319

