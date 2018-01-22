Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:51899 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbeAVREz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 12:04:55 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v4 0/3] improvements for wmediumd-like simulations and config enhancements
Date: Mon, 22 Jan 2018 18:04:34 +0100
Message-ID: <20180122170437.14213-1-benjamin.beichler@uni-rostock.de> (sfid-20180122_180459_520082_F3B9A0FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series (based on mac80211next branch) includes the rest of our proposed
changes:
- add argument to set permanent MAC address of a hwsim interface while creation
- fixing bad behavior of radio dump and module unload with many radios

Changes since v3:
* applied all comments of jberg
* only included non-merged commits to avoid conflicts

Changes since v2:
* added a separate workqueue for the deferred deletion tasks (and therefore
	reduce the introduced code massively)
* fixed missing signaling of interrupted nl-dump operation
* fixed small formatting errors

Changes since v1:
* syntactical/formal issues
* the hashtable is now formed by rhashtable
* instead of the radio id, the radio mac-address can be configured by new
	radio command
* parallel ops patch is removed
* removed the reverse synchronization of the tx-flags from driver to mac80211,
	since I believe the tx-rate flags are not used after the transmission
	is done

Benjamin Beichler (3):
  mac80211_hwsim: add permanent mac address option for new radios
  mac80211_hwsim: add nl_err_msg in hwsim_new_radio in netlink case
  mac80211_hwsim: add generation count for netlink dump operation

 drivers/net/wireless/mac80211_hwsim.c | 83 +++++++++++++++++++++++++++--------
 drivers/net/wireless/mac80211_hwsim.h |  9 +++-
 2 files changed, 73 insertions(+), 19 deletions(-)

-- 
2.15.1
