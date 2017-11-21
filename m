Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.uni-rostock.de ([139.30.22.72]:57395 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751684AbdKUMXT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 07:23:19 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v2 0/5] improvements for wmediumd-like simulations and config enhancements
Date: Tue, 21 Nov 2017 13:17:39 +0100
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <e8f4e937-7ba1-4067-9995-69d183763e53@MAIL2.uni-rostock.de> (sfid-20171121_132323_947098_6FD0EA7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes our efforts for more sophisticated simulations
for wifi-networks.
 
Especially Patch 2 and 4 add missing functionality. 

Patch 1 addresses deferred deletion in situations with many hwsim_radios.

The patch 2 adds an obvious performance improvement for many radios, since
for every received frame a linear search through all radios was done, and
now we use a dynamic rhashtable. This will not improve nor should it worse
the performance on non-wmediumd senarios, because there is no lookup of 
MAC-addresses.

Patch 3 refines the netlink radio dump callback for the specified behavior
of interrupted dumps.

Patch 4 helps to create conveniently new radios with their permanent
MAC-addresses since it is crucial in a setup with many mobile nodes, to
create the nodes when they are in the focus of the simulation and remove
them, if they leave and maybe recreate them if they re-arrive. But this
requires predictable permanent MAC-addresses.

Patch 5 adds the rate flags, as already discussed some time ago, to be
able to interpret the right Rate from the tx rates array (e.g. whether
it is MCS, NSS, and so on).


Changes since v1:
This version of the patchset tries to address all comments of Johannes:
* all syntactical/formal issues
* the hashtable is now formed by rhashtable
* instead of the radio id, the radio mac-address can be configured by new
	radio command
* parallel ops patch is removed
* removed the reverse synchronization of the tx-flags from driver to
mac80211, since I believe the tx-rate flags are not used after the
transmission is done

Moreover the patchset includes new aspects:
Patch 1: The deferred deletion of radios is now synchronized at module
unload. Without this, there could be execution of code of the module,
after unloading, although I was not able to provoke such corner cases.

Patch 2: The lookup of rhashtable do not use the radio lock, because of
the rcu lock of the rhastable. Maybe I need to insert an rcu_sychronize
in the deletion function to address all possible scenarios, but I am
unsure.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>

Benjamin Beichler (5):
  mac80211_hwsim: wait for deferred radio deletion on mod unload
  mac80211_hwsim: add hashtable with mac address keys for faster lookup
  mac80211_hwsim: add generation count for netlink dump operation
  mac80211_hwsim: add permanent mac address option for new radios
  mac80211_hwsim: add hwsim_tx_rate_flags to netlink attributes

 drivers/net/wireless/mac80211_hwsim.c | 210 ++++++++++++++++++++++++++++------
 drivers/net/wireless/mac80211_hwsim.h |  77 ++++++++++++-
 2 files changed, 248 insertions(+), 39 deletions(-)

-- 
2.15.0
