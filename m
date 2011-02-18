Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4877 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab1BRF3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 00:29:18 -0500
Date: Thu, 17 Feb 2011 21:29:01 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
To: linville@tuxdriver.com
cc: "John W. Linville" <linville@tuxdriver.com>,
	"kernel@fomichev.me" <kernel@fomichev.me>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>, gregkh@suse.de,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Subject: [PATCH v3] wireless-next-2.6: brcm80211: fix compile
 issue
Message-ID: <20110218052900.GA4711@broadcom.com>
References: <1297721111-20606-1-git-send-email-kernel@fomichev.me>
 <7A94256FD72B884D9E7C55586C3CBCEE13CDA25D88@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110215221200.GA2087@sdf-MacBook> <4D5B0034.3090303@broadcom.com>
 <20110216015040.GA2349@tuxdriver.com> <4D5DDD7A.4080801@broadcom.com>
 <20110218030539.GE17143@suse.de>
MIME-Version: 1.0
In-Reply-To: <20110218030539.GE17143@suse.de>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For wireless-next-2.6:

Commit 59eb21a65047 "cfg80211: Extend channel to frequency mapping for 802.11j"
changed the definition of the ieee80211_channel_to_frequency; so fix its
usage in brcmfmac.

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 991463f..9b7b71c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2313,7 +2313,9 @@ static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 	notif_bss_info->frame_len =
 	    offsetof(struct ieee80211_mgmt,
 		     u.beacon.variable) + wl_get_ielen(wl);
-	freq = ieee80211_channel_to_frequency(notif_bss_info->channel);
+	freq = ieee80211_channel_to_frequency(notif_bss_info->channel,
+					      band->band);
+
 	channel = ieee80211_get_channel(wiphy, freq);
 
 	WL_DBG("SSID : \"%s\", rssi %d, channel %d, capability : 0x04%x, bssid %pM\n",
-- 
1.7.1


