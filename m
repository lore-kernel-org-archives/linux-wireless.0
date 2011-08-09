Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1HIJNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:31 -0400
Received: by wwf5 with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:30 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/40] wl12xx: move to wl12xx-fw-3
Date: Tue,  9 Aug 2011 12:13:13 +0300
Message-Id: <1312881233-9366-1-git-send-email-eliad@wizery.com> (sfid-20110809_111335_437223_C230AA37)
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
  wl12xx: temporarily disable 11n and advanced ap functions
  wl12xx: remove rx filtering stuff
  wl12xx: wl12xx-fw-3 - Update fw status struct
  wl12xx: wl12xx-fw-3 - update acx commands
  wl12xx: wl12xx-fw-3 - update commands & events
  wl12xx: enable/disable role on interface add/remove
  wl12xx: add device role commands
  wl12xx: wl12xx-fw-3 - update scan cmd api
  wl12xx: wl12xx-fw-3 - rx/tx changes
  wl12xx: wl12xx-fw-3 - change max/default template size
  wl12xx: use wl1271_acx_beacon_filter_opt for both sta and ap
  wl12xx: add set_rate_mgmt_params acx
  wl12xx: add system_hlid
  wl12xx: add ROC/CROC commands
  wl12xx: replace dummy_join with ROC/CROC commands
  wl12xx: update BT coex configuration params
  wl12xx: call wl1271_cmd_set_peer_state() in AP mode
  wl12xx: don't remove key if hlid was already deleted
  wl12xx: add wl1271_cmd_role_start_ibss()
  wl12xx: support IBSS vif type
  wl12xx: use ap_bcast_hlid for recorded keys
  wl12xx: don't remove key if hlid was already deleted
  wl12xx: don't wait for disconnection event

 drivers/net/wireless/wl12xx/acx.c          |  325 ++++------
 drivers/net/wireless/wl12xx/acx.h          |  395 +++++--------
 drivers/net/wireless/wl12xx/boot.c         |   16 +-
 drivers/net/wireless/wl12xx/cmd.c          |  802 ++++++++++++++++++-------
 drivers/net/wireless/wl12xx/cmd.h          |  337 ++++++-----
 drivers/net/wireless/wl12xx/conf.h         |  345 ++++-------
 drivers/net/wireless/wl12xx/debugfs.c      |   17 +-
 drivers/net/wireless/wl12xx/event.c        |    6 +-
 drivers/net/wireless/wl12xx/event.h        |   83 +--
 drivers/net/wireless/wl12xx/init.c         |   96 +--
 drivers/net/wireless/wl12xx/io.h           |    1 -
 drivers/net/wireless/wl12xx/main.c         |  915 ++++++++++++++++-----------
 drivers/net/wireless/wl12xx/ps.c           |    4 +-
 drivers/net/wireless/wl12xx/reg.h          |   75 ---
 drivers/net/wireless/wl12xx/rx.c           |   17 +-
 drivers/net/wireless/wl12xx/rx.h           |   10 +-
 drivers/net/wireless/wl12xx/scan.c         |   38 +-
 drivers/net/wireless/wl12xx/scan.h         |   25 +-
 drivers/net/wireless/wl12xx/sdio.c         |    2 -
 drivers/net/wireless/wl12xx/spi.c          |    2 -
 drivers/net/wireless/wl12xx/tx.c           |  107 ++--
 drivers/net/wireless/wl12xx/tx.h           |   16 +-
 drivers/net/wireless/wl12xx/wl12xx.h       |  148 +++---
 drivers/net/wireless/wl12xx/wl12xx_80211.h |   25 -
 24 files changed, 2002 insertions(+), 1805 deletions(-)

-- 
1.7.6.401.g6a319

