Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2044 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab1FIOpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:15 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/21] staging: brcm80211: Remove flags from
 wl_is_nonetwork
Date: Thu, 9 Jun 2011 16:44:44 +0200
Message-ID: <1307630701-9170-5-git-send-email-rvossen@broadcom.com> (sfid-20110609_164523_776452_C52684CD)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove this debug only variable in fullmace driver to avoid compile
warning when BCMDBG is off

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 0a7a9b2..457f5b1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2588,11 +2588,11 @@ static bool wl_is_nonetwork(struct wl_priv *wl, const wl_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
-	u16 flags = be16_to_cpu(e->flags);
 
 	if (event == WLC_E_LINK && status == WLC_E_STATUS_NO_NETWORKS) {
 		WL_CONN("Processing Link %s & no network found\n",
-				flags & WLC_EVENT_MSG_LINK ? "up" : "down");
+				be16_to_cpu(e->flags) & WLC_EVENT_MSG_LINK ?
+				"up" : "down");
 		return true;
 	}
 
-- 
1.7.4.1


