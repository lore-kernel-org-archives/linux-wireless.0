Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0BSJkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 04:40:16 -0500
Subject: FYI: needlessly exported symbols
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 10:40:13 +0100
Message-ID: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to a little analysis I did on wireless-testing, these symbols
need not be exported because they're not imported by any module:

ath9k_hw_keyisvalid
ath9k_hw_keysetmac

ieee80211_queue_stopped
ieee80211_start_tx_ba_cb
ieee80211_stop_tx_ba_cb
(I wouldn't mind removing these from mac80211, if nobody wants to use
them)

p54_parse_eeprom

iwl_apm_stop_master
iwl_internal_short_hw_scan
iwl_leds_background

johannes

