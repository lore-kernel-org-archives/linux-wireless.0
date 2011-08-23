Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4698 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1HWMOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/8] staging: brcm80211: fix checkpatch warning in
 fullmac
Date: Tue, 23 Aug 2011 14:13:56 +0200
Message-ID: <1314101640-4229-5-git-send-email-arend@broadcom.com> (sfid-20110823_141426_875521_98DA3BA4)
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Fix the __aligned checkpatch warning in wl_cfg80211.h

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 049138b..0542bac 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -317,7 +317,7 @@ struct brcmf_cfg80211_priv {
 	u8 *ioctl_buf;	/* ioctl buffer */
 	u8 *extra_buf;	/* maily to grab assoc information */
 	struct dentry *debugfsdir;
-	u8 ci[0] __attribute__ ((__aligned__(NETDEV_ALIGN)));
+	u8 ci[0] __aligned(NETDEV_ALIGN);
 };
 
 #define cfg_to_wiphy(w) (w->wdev->wiphy)
-- 
1.7.4.1


