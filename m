Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3109 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1ALVVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 16:21:23 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 3/3] staging: brcm80211: Remove unnecessary memset(,0,)
Date: Wed, 12 Jan 2011 13:21:19 -0800
Message-Id: <2edac359392f7f549ab508070f0c357e1cf39d65.1294867098.git.joe@perches.com>
In-Reply-To: <6f6d4a7a705949a3464471f364f77215f1e796f3.1294867098.git.joe@perches.com>
References: <6f6d4a7a705949a3464471f364f77215f1e796f3.1294867098.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kzalloc'd memory doesn't need a memset to 0.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 991463f..2af0d6a 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -703,7 +703,6 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid, u16 action)
 	params = kzalloc(params_size, GFP_KERNEL);
 	if (unlikely(!params))
 		return -ENOMEM;
-	memset(params, 0, params_size);
 	BUG_ON(unlikely(params_size >= WLC_IOCTL_SMLEN));
 
 	wl_iscan_prep(&params->params, ssid);
-- 
1.7.3.3.398.g0b0cd.dirty

