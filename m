Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2396 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 36/61] staging: brcm80211: remove use of si_* functions
 from wlc_phy_lcn.c
Date: Tue, 3 May 2011 11:35:36 +0200
Message-ID: <1304415361-7813-37-git-send-email-arend@broadcom.com> (sfid-20110503_113637_988037_8C189E52)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The source file used si_alp_clock to determine crystal frequency.
It now uses the si_pmu_alp_clock call instead to remove dependency from
siutils functionality.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    2 +-
 drivers/staging/brcm80211/util/hndpmu.c            |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index 9f5ee40..4e7a20a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -5053,7 +5053,7 @@ bool wlc_phy_attach_lcnphy(phy_info_t *pi)
 		pi->hwpwrctrl_capable = true;
 	}
 
-	pi->xtalfreq = si_alp_clock(pi->sh->sih);
+	pi->xtalfreq = si_pmu_alp_clock(pi->sh->sih);
 	pi_lcn->lcnphy_papd_rxGnCtrl_init = 0;
 
 	pi->pi_fptr.init = wlc_phy_init_lcnphy;
diff --git a/drivers/staging/brcm80211/util/hndpmu.c b/drivers/staging/brcm80211/util/hndpmu.c
index ffa2e2d..566e030 100644
--- a/drivers/staging/brcm80211/util/hndpmu.c
+++ b/drivers/staging/brcm80211/util/hndpmu.c
@@ -1425,6 +1425,9 @@ u32 si_pmu_alp_clock(si_t *sih)
 #ifdef BCMDBG
 	char chn[8];
 #endif
+	/* bail out with default */
+	if (!PMUCTL_ENAB(sih))
+		return clock;
 
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
-- 
1.7.4.1


