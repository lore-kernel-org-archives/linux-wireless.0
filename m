Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58123 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752555AbaKGN3J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 08:29:09 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri,  7 Nov 2014 15:28:34 +0200
Message-Id: <1415366914-10997-3-git-send-email-luca@coelho.fi> (sfid-20141107_142913_309340_5BE8B989)
In-Reply-To: <1415366914-10997-1-git-send-email-luca@coelho.fi>
References: <1415366914-10997-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 2/2] mac80211: add device_timestamp to the drv_pre_channel_switch trace
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The device_timestamp value was left out of the event trace for
drv_pre_channel_switch by mistake.  Add it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/trace.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 809a498..96847e7 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2140,6 +2140,7 @@ TRACE_EVENT(drv_pre_channel_switch,
 		VIF_ENTRY
 		CHANDEF_ENTRY
 		__field(u64, timestamp)
+		__field(u32, device_timestamp)
 		__field(bool, block_tx)
 		__field(u8, count)
 	),
@@ -2149,6 +2150,7 @@ TRACE_EVENT(drv_pre_channel_switch,
 		VIF_ASSIGN;
 		CHANDEF_ASSIGN(&ch_switch->chandef)
 		__entry->timestamp = ch_switch->timestamp;
+		__entry->device_timestamp = ch_switch->device_timestamp;
 		__entry->block_tx = ch_switch->block_tx;
 		__entry->count = ch_switch->count;
 	),
-- 
2.1.1

