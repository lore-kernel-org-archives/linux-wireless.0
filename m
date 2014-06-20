Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:12748 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbaFTQlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 12:41:03 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] mac80211: fix dtim period propagation to the driver
Date: Fri, 20 Jun 2014 09:40:19 -0700
Message-Id: <1403282419-8468-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140620_184107_443859_E1C21770)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that set IEEE80211_HW_TIMING_BEACON_ONLY need to
know when the DTIM will be sent. For that purpose, mac80211
sends to the low level driver all the data needed by the
low level driver to determine the TBTT of the DTIM:
The TSF, the DTIM count and the device clock of one beacon.
If the low level driver knows the dtim period, it will be
able to know the TBTT of the next DTIM.

When we associate to an access point, we usually scan first
and get probe responses. Based on the probe responses, we
start to associate. If the device needs to configure the
TBTT of the next DTIM (IEEE80211_HW_TIMING_BEACON_ONLY is
set), then, mac80211 will wait until it hears a beacon and
then give the aforementioned data to the low level driver.
This case works fine.

A less common case is a case in which we hear a beacon
before we even start to associate. In this case, mac80211
already has all the data needed by the low level driveramd
all the data is sent straight away in the first
bss_info_changed call. In that specific flow, the setting
of the dtim_period was missing.

iwlmvm needs this data and will fail the connection unless
it is given the dtim_period within 300ms after the
association. The following print would appear:

iwlwifi: No association and the time event is over already...

This led to disconnections. This patch fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=78101

Cc: <stable@vger.kernel.org> [3.10+]
Fixes: ef429dadf33f ("mac80211: introduce beacon-only timing data")
Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e37b97d..661dc8b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4438,6 +4438,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			sdata->vif.bss_conf.sync_device_ts =
 				bss->device_ts_beacon;
 			sdata->vif.bss_conf.sync_dtim_count = dtim_count;
+			sdata->vif.bss_conf.dtim_period =
+				ifmgd->dtim_period ? : 1;
 		}
 	} else {
 		assoc_data->timeout = jiffies;
-- 
1.8.1.msysgit.1

