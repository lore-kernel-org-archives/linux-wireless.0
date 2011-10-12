Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4335 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab1JLSvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/22] brcm80211: moved function brcmu_chspec_malformed
Date: Wed, 12 Oct 2011 20:51:29 +0200
Message-ID: <1318445492-24207-20-git-send-email-arend@broadcom.com> (sfid-20111012_205155_517652_32339A1D)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Moved brcmu_chspec_malformed into the only file using it. The
function name was adjusted accordingly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |   28 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmutil/wifi.c     |   27 -------------------
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |    8 -----
 3 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index a1b415d..89ad1b7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -1485,6 +1485,32 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 }
 
 /*
+ * Verify the chanspec is using a legal set of parameters, i.e. that the
+ * chanspec specified a band, bw, ctl_sb and channel and that the
+ * combination could be legal given any set of circumstances.
+ * RETURNS: true is the chanspec is malformed, false if it looks good.
+ */
+static bool brcms_c_chspec_malformed(u16 chanspec)
+{
+	/* must be 2G or 5G band */
+	if (!CHSPEC_IS5G(chanspec) && !CHSPEC_IS2G(chanspec))
+		return true;
+	/* must be 20 or 40 bandwidth */
+	if (!CHSPEC_IS40(chanspec) && !CHSPEC_IS20(chanspec))
+		return true;
+
+	/* 20MHZ b/w must have no ctl sb, 40 must have a ctl sb */
+	if (CHSPEC_IS20(chanspec)) {
+		if (!CHSPEC_SB_NONE(chanspec))
+			return true;
+	} else if (!CHSPEC_SB_UPPER(chanspec) && !CHSPEC_SB_LOWER(chanspec)) {
+		return true;
+	}
+
+	return false;
+}
+
+/*
  * Validate the chanspec for this locale, for 40MHZ we need to also
  * check that the sidebands are valid 20MZH channels in this locale
  * and they are also a legal HT combination
@@ -1497,7 +1523,7 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 	u8 channel = CHSPEC_CHANNEL(chspec);
 
 	/* check the chanspec */
-	if (brcmu_chspec_malformed(chspec)) {
+	if (brcms_c_chspec_malformed(chspec)) {
 		wiphy_err(wlc->wiphy, "wl%d: malformed chanspec 0x%x\n",
 			wlc->pub->unit, chspec);
 		return false;
diff --git a/drivers/net/wireless/brcm80211/brcmutil/wifi.c b/drivers/net/wireless/brcm80211/brcmutil/wifi.c
index e8d3bf2..8483f24 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/wifi.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/wifi.c
@@ -14,30 +14,3 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 #include <brcmu_wifi.h>
-
-/*
- * Verify the chanspec is using a legal set of parameters, i.e. that the
- * chanspec specified a band, bw, ctl_sb and channel and that the
- * combination could be legal given any set of circumstances.
- * RETURNS: true is the chanspec is malformed, false if it looks good.
- */
-bool brcmu_chspec_malformed(u16 chanspec)
-{
-	/* must be 2G or 5G band */
-	if (!CHSPEC_IS5G(chanspec) && !CHSPEC_IS2G(chanspec))
-		return true;
-	/* must be 20 or 40 bandwidth */
-	if (!CHSPEC_IS40(chanspec) && !CHSPEC_IS20(chanspec))
-		return true;
-
-	/* 20MHZ b/w must have no ctl sb, 40 must have a ctl sb */
-	if (CHSPEC_IS20(chanspec)) {
-		if (!CHSPEC_SB_NONE(chanspec))
-			return true;
-	} else if (!CHSPEC_SB_UPPER(chanspec) && !CHSPEC_SB_LOWER(chanspec)) {
-		return true;
-	}
-
-	return false;
-}
-EXPORT_SYMBOL(brcmu_chspec_malformed);
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
index 5b1aca7..f10d302 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
@@ -168,14 +168,6 @@ static inline bool ac_bitmap_tst(u8 bitmap, int prec)
 	return (bitmap & (1 << (prec))) != 0;
 }
 
-/*
- * Verify the chanspec is using a legal set of parameters, i.e. that the
- * chanspec specified a band, bw, ctl_sb and channel and that the
- * combination could be legal given any set of circumstances.
- * RETURNS: true is the chanspec is malformed, false if it looks good.
- */
-extern bool brcmu_chspec_malformed(u16 chanspec);
-
 /* Enumerate crypto algorithms */
 #define	CRYPTO_ALGO_OFF			0
 #define	CRYPTO_ALGO_WEP1		1
-- 
1.7.4.1


