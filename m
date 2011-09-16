Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3490 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/19] staging: brcm80211: removed set_fs/get_fs/get_ds
 calls from brcmf_dev_ioctl()
Date: Fri, 16 Sep 2011 12:27:57 -0700
Message-ID: <1316201288-29635-9-git-send-email-frankyl@broadcom.com> (sfid-20110916_212848_937246_E6378645)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

brcmf_dev_ioctl() does not provide a user space buffer to
brcmf_netdev_ioctl_priv. Hence these calls are not necessary.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 1f736ea..c4a8117 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -251,7 +251,6 @@ static s32
 brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 {
 	struct brcmf_ioctl ioc;
-	mm_segment_t fs;
 	s32 err = 0;
 
 	memset(&ioc, 0, sizeof(ioc));
@@ -259,10 +258,7 @@ brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 	ioc.buf = arg;
 	ioc.len = len;
 
-	fs = get_fs();
-	set_fs(get_ds());
 	err = brcmf_netdev_ioctl_priv(dev, &ioc);
-	set_fs(fs);
 
 	return err;
 }
-- 
1.7.1


