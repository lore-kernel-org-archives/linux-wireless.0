Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:54050 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaE0K4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:35 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/16] brcmfmac: reduce log level for invalid scheduled scan request
Date: Tue, 27 May 2014 12:56:13 +0200
Message-ID: <1401188188-16492-2-git-send-email-arend@broadcom.com> (sfid-20140527_125647_821449_F9CD5BE6)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a regular scan does not return any networks user-space does
request a scheduled scan without any matchset or ssid. This can
not be handled by the firmware so we return -EINVAL. However, as
this request is done let us not add an error message to the log.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 92cb29a..10aacc9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3178,7 +3178,7 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 	}
 
 	if (!request->n_ssids || !request->n_match_sets) {
-		brcmf_err("Invalid sched scan req!! n_ssids:%d\n",
+		brcmf_dbg(SCAN, "Invalid sched scan req!! n_ssids:%d\n",
 			  request->n_ssids);
 		return -EINVAL;
 	}
-- 
1.7.9.5

