Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2520 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab1FIOpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 20/21] staging: brcm80211: fix checkpatch errors in
 brcmsmac driver
Date: Thu, 9 Jun 2011 16:45:00 +0200
Message-ID: <1307630701-9170-21-git-send-email-rvossen@broadcom.com> (sfid-20110609_164604_223092_5474DC7B)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several source files in brcmsmac driver have checkpatch errors that
have been removed (see below).

ERROR: spaces required around that ':' (ctx:VxV)
+           (u8)NPHY_RSSI_SEL_TSSI_5G:(u8)NPHY_RSSI_SEL_TSSI_2G;
--
ERROR: code indent should use tabs where possible
+ ^Ierr = initvars_table(base, vp, vars, count);$
--

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/srom.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index bc5da60..696825f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -23456,7 +23456,7 @@ wlc_phy_est_tonepwr_nphy(phy_info_t *pi, s32 *qdBm_pwrbuf, u8 num_samps)
 
 	tssi_type =
 	    CHSPEC_IS5G(pi->radio_chanspec) ?
-	    (u8)NPHY_RSSI_SEL_TSSI_5G:(u8)NPHY_RSSI_SEL_TSSI_2G;
+	    (u8)NPHY_RSSI_SEL_TSSI_5G : (u8)NPHY_RSSI_SEL_TSSI_2G;
 
 	wlc_phy_poll_rssi_nphy(pi, tssi_type, rssi_buf, num_samps);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 8aa6d01..1117f91 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -1318,9 +1318,9 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 	vp = b.buf;
 	*vp++ = '\0';
 
- 	err = initvars_table(base, vp, vars, count);
+	err = initvars_table(base, vp, vars, count);
 
- errout:
+errout:
 	if (base)
 		kfree(base);
 
-- 
1.7.4.1


