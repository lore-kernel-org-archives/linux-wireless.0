Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1563 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab2BIUJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:24 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/15] brcm80211: smac: remove smatch warnings from
 brcmsmac code
Date: Thu, 9 Feb 2012 21:08:59 +0100
Message-ID: <1328818149-4826-6-git-send-email-arend@broadcom.com> (sfid-20120209_210928_513664_67648229)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes following smatch warnings:

main.c +2902 brcms_b_read_objmem(11) info: ignoring unreachable code.
mac80211_if.c +1146 brcms_suspend(8) error: we previously assumed 'wl'
could be null (see line 1145)
srom.c +641 _initvars_srom_pci(16) error: potential null dereference
'entry'.  (kzalloc returns null)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |   14 ++++++++++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index c842797..fec0f10 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1136,8 +1136,8 @@ static int brcms_suspend(struct bcma_device *pdev)
 	hw = bcma_get_drvdata(pdev);
 	wl = hw->priv;
 	if (!wl) {
-		wiphy_err(wl->wiphy,
-			  "brcms_suspend: bcma_get_drvdata failed\n");
+		pr_err("%s: %s: no driver private struct!\n", KBUILD_MODNAME,
+		       __func__);
 		return -ENODEV;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index fb712ca..86186fa 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2901,7 +2901,6 @@ brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset, u32 sel)
 		objoff += 2;
 
 	return bcma_read16(core, objoff);
-;
 }
 
 static void
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index 5637436..b96f4b9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -621,7 +621,7 @@ static inline void cpu_to_le16_buf(u16 *buf, uint nwords)
 /*
  * convert binary srom data into linked list of srom variable items.
  */
-static void
+static int
 _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 {
 	struct brcms_srom_list_head *entry;
@@ -638,6 +638,9 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 
 	/* first store the srom revision */
 	entry = kzalloc(sizeof(struct brcms_srom_list_head), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
 	entry->varid = BRCMS_SROM_REV;
 	entry->var_type = BRCMS_SROM_UNUMBER;
 	entry->uval = sromrev;
@@ -715,6 +718,8 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 
 		entry = kzalloc(sizeof(struct brcms_srom_list_head) +
 				extra_space, GFP_KERNEL);
+		if (!entry)
+			return -ENOMEM;
 		entry->varid = id;
 		entry->var_type = type;
 		if (flags & SRFL_ETHADDR) {
@@ -754,6 +759,8 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 			entry =
 			    kzalloc(sizeof(struct brcms_srom_list_head),
 				    GFP_KERNEL);
+			if (!entry)
+				return -ENOMEM;
 			entry->varid = srv->varid+p;
 			entry->var_type = BRCMS_SROM_UNUMBER;
 			entry->uval = val;
@@ -761,6 +768,7 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
 		}
 		pb += psz;
 	}
+	return 0;
 }
 
 /*
@@ -906,7 +914,9 @@ int srom_var_init(struct si_pub *sih)
 		INIT_LIST_HEAD(&sii->var_list);
 
 		/* parse SROM into name=value pairs. */
-		_initvars_srom_pci(sromrev, srom, &sii->var_list);
+		err = _initvars_srom_pci(sromrev, srom, &sii->var_list);
+		if (err)
+			srom_free_vars(sih);
 	}
 
 errout:
-- 
1.7.5.4


