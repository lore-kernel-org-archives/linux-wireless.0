Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1675 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1HHN71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:27 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 05/82] staging: brcm80211: removed function
 declaration typedefs from phy_int.h
Date: Mon, 8 Aug 2011 15:57:49 +0200
Message-ID: <1312811946-16713-6-git-send-email-arend@broadcom.com> (sfid-20110808_160156_722137_98A404B0)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac related code cleanup. Typedefs are undesirable according to the
CodingStyle document.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    9 ++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |   35 +++++++--------------
 2 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 17012fb..f4224ef 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -865,7 +865,7 @@ void wlc_phy_hw_state_upd(struct brcms_phy_pub *pih, bool newstate)
 void wlc_phy_init(struct brcms_phy_pub *pih, chanspec_t chanspec)
 {
 	u32 mc;
-	initfn_t phy_init = NULL;
+	void (*phy_init) (struct brcms_phy *) = NULL;
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (pi->init_in_progress)
@@ -921,7 +921,7 @@ void wlc_phy_init(struct brcms_phy_pub *pih, chanspec_t chanspec)
 void wlc_phy_cal_init(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
-	initfn_t cal_init = NULL;
+	void (*cal_init)(struct brcms_phy *) = NULL;
 
 	if (WARN((R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) != 0,
 		 "HW error: MAC enabled during phy cal\n"))
@@ -1329,8 +1329,7 @@ void wlc_phy_chanspec_set(struct brcms_phy_pub *ppi, chanspec_t chanspec)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 m_cur_channel;
-	chansetfn_t chanspec_set = NULL;
-
+	void (*chanspec_set) (struct brcms_phy *, chanspec_t) = NULL;
 	m_cur_channel = CHSPEC_CHANNEL(chanspec);
 	if (CHSPEC_IS5G(chanspec))
 		m_cur_channel |= D11_CURCHANNEL_5G;
@@ -1671,7 +1670,7 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 	u8 start_rate = 0;
 	chanspec_t chspec;
 	u32 band = CHSPEC2BAND(pi->radio_chanspec);
-	initfn_t txpwr_recalc_fn = NULL;
+	void (*txpwr_recalc_fn)(struct brcms_phy *) = NULL;
 
 	chspec = pi->radio_chanspec;
 	if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_NONE)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index a01b01c..7dae802 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -49,17 +49,6 @@ struct brcms_phy_srom_fem {
 	u8 antswctrllut;	/* antswctrl lookup table configuration: 32 possible choices */
 };
 
-typedef void (*initfn_t) (struct brcms_phy *);
-typedef void (*chansetfn_t) (struct brcms_phy *, chanspec_t);
-typedef int (*longtrnfn_t) (struct brcms_phy *, int);
-typedef void (*txiqccgetfn_t) (struct brcms_phy *, u16 *, u16 *);
-typedef void (*txiqccsetfn_t) (struct brcms_phy *, u16, u16);
-typedef u16(*txloccgetfn_t) (struct brcms_phy *);
-typedef void (*radioloftgetfn_t) (struct brcms_phy *, u8 *, u8 *, u8 *,
-				  u8 *);
-typedef s32(*rxsigpwrfn_t) (struct brcms_phy *, s32);
-typedef void (*detachfn_t) (struct brcms_phy *);
-
 #undef ISNPHY
 #undef ISLCNPHY
 #define ISNPHY(pi)	PHYTYPE_IS((pi)->pubpi.phy_type, PHY_TYPE_N)
@@ -579,18 +568,18 @@ struct brcms_phy_pub {
 };
 
 struct phy_func_ptr {
-	initfn_t init;
-	initfn_t calinit;
-	chansetfn_t chanset;
-	initfn_t txpwrrecalc;
-	longtrnfn_t longtrn;
-	txiqccgetfn_t txiqccget;
-	txiqccsetfn_t txiqccset;
-	txloccgetfn_t txloccget;
-	radioloftgetfn_t radioloftget;
-	initfn_t carrsuppr;
-	rxsigpwrfn_t rxsigpwr;
-	detachfn_t detach;
+	void (*init) (struct brcms_phy *);
+	void (*calinit) (struct brcms_phy *);
+	void (*chanset) (struct brcms_phy *, chanspec_t);
+	void (*txpwrrecalc) (struct brcms_phy *);
+	int (*longtrn) (struct brcms_phy *, int);
+	void (*txiqccget) (struct brcms_phy *, u16 *, u16 *);
+	void (*txiqccset) (struct brcms_phy *, u16, u16);
+	u16(*txloccget) (struct brcms_phy *);
+	void (*radioloftget) (struct brcms_phy *, u8 *, u8 *, u8 *, u8 *);
+	void (*carrsuppr) (struct brcms_phy *);
+	s32(*rxsigpwr) (struct brcms_phy *, s32);
+	void (*detach) (struct brcms_phy *);
 };
 
 struct brcms_phy {
-- 
1.7.4.1


