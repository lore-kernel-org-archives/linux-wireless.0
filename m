Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:64757 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965075AbeAJQnl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 11:43:41 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v3 0/5] improvements for wmediumd-like simulations and config enhancements
Date: Wed, 10 Jan 2018 17:42:50 +0100
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <d468225c-52bd-4f8a-8831-299ed1581bc7@MAIL2.uni-rostock.de> (sfid-20180110_174345_864326_1372CF49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series (based on mac80211next branch) includes our efforts for more sophisticated simulations for
wifi-networks:
- improving MAC-Address lookups with rhashtable
- add tx-flags for every frame for more detailed transmission simulation
- add argument to set permanent MAC address of a hwsim interface while creation
- fixing bad behavior of radio dump and module unload with many radios

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

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>

Benjamin Beichler (5):
  mac80211_hwsim: add workqueue to wait for deferred radio deletion on
    mod unload
  mac80211_hwsim: add hashtable with mac address keys for faster lookup
  mac80211_hwsim: add generation count for netlink dump operation
  mac80211_hwsim: add permanent mac address option for new radios
  mac80211_hwsim: add hwsim_tx_rate_flags to netlink attributes

 drivers/net/wireless/mac80211_hwsim.c | 206 +++++++++++++++++++++++++++-------
 drivers/net/wireless/mac80211_hwsim.h |  77 ++++++++++++-
 2 files changed, 240 insertions(+), 43 deletions(-)

-- 
2.15.1
