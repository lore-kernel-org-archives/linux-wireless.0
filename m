Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44899 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2IZHWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 03:22:13 -0400
Date: Wed, 26 Sep 2012 10:21:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] brcmfmac: use kcalloc() to prevent integer overflow
Message-ID: <20120926072148.GA3956@elgon.mountain> (sfid-20120926_092302_281773_2DD63955)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The multiplication here looks like it could overflow.  I've changed it
to use kcalloc() to prevent that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.  This was added in e58060723c "brcmfmac:
introduce scheduled scan support".

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index af396e4..7983be1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3299,8 +3299,8 @@ brcmf_notify_sched_scan_results(struct brcmf_cfg80211_priv *cfg_priv,
 		int i;
 
 		request = kzalloc(sizeof(*request), GFP_KERNEL);
-		ssid = kzalloc(sizeof(*ssid) * result_count, GFP_KERNEL);
-		channel = kzalloc(sizeof(*channel) * result_count, GFP_KERNEL);
+		ssid = kcalloc(result_count, sizeof(*ssid), GFP_KERNEL);
+		channel = kcalloc(result_count, sizeof(*channel), GFP_KERNEL);
 		if (!request || !ssid || !channel) {
 			err = -ENOMEM;
 			goto out_err;
