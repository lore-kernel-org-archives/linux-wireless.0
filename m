Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751813AbdB0KZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 05:25:28 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH 2/4] brcmfmac: p2p and normal ap access are not always possible at the same time
Date: Mon, 27 Feb 2017 11:01:38 +0100
Message-Id: <20170227100140.5190-3-hdegoede@redhat.com> (sfid-20170227_112552_027801_315005D8)
In-Reply-To: <20170227100140.5190-1-hdegoede@redhat.com>
References: <20170227100140.5190-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware responding with -EBUSY when trying to add an extra virtual-if
is a normal thing, do not print an error for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14 ++++++++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c     |  5 ++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7ffc4ab..c54e8b4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -688,11 +688,17 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (IS_ERR(wdev))
-		brcmf_err("add iface %s type %d failed: err=%d\n",
-			  name, type, (int)PTR_ERR(wdev));
-	else
+	if (IS_ERR(wdev)) {
+		err = PTR_ERR(wdev);
+		if (err != -EBUSY)
+			brcmf_err("add iface %s type %d failed: err=%d\n",
+				  name, type, err);
+		else
+			brcmf_dbg(INFO, "add iface %s type %d failed: err=%d\n",
+				  name, type, err);
+	} else {
 		brcmf_cfg80211_update_proto_addr_mode(wdev);
+	}
 
 	return wdev;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index de19c7c..b5df0a0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2090,7 +2090,10 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* Initialize P2P Discovery in the firmware */
 	err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
 	if (err < 0) {
-		brcmf_err("set p2p_disc error\n");
+		if (err != -EBUSY)
+			brcmf_err("set p2p_disc error\n");
+		else
+			brcmf_dbg(INFO, "set p2p_disc error\n");
 		brcmf_fweh_p2pdev_setup(pri_ifp, false);
 		brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
 		goto fail;
-- 
2.9.3
