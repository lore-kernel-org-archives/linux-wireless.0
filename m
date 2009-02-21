Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48998 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZBUApU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 19:45:20 -0500
Date: Fri, 20 Feb 2009 19:31:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL in
	iwl_adjust_beacon_interval
Message-ID: <20090221003133.GB3890@tuxdriver.com> (sfid-20090221_014525_958814_725D4288)
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com> <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk> <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090221003013.GA3890@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

Default to MAX_UCODE_BEACON_INTERVAL if the output of
iwl_adjust_beacon_interval would otherwise be zero.  This prevents a
division by zero on my iwl5300-equipped Lenovo T400 with kernels that
include "mac80211: use cfg80211s BSS infrastructure".

This patch is a bit of a hack -- I'm not sure why iwl_setup_rxon_timing
is giving iwl_adjust_beacon_interval a zero input (which is the only way
it would output zero).  I would be happy to have a better fix.  But for
now, this makes my box boot...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 50f8c7f..ad31005 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -644,6 +644,9 @@ static u16 iwl_adjust_beacon_interval(u16 beacon_val)
 					/ MAX_UCODE_BEACON_INTERVAL;
 	new_val = beacon_val / beacon_factor;
 
+	if (!new_val)
+		new_val = MAX_UCODE_BEACON_INTERVAL;
+
 	return new_val;
 }
 
-- 
1.6.0.6

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
