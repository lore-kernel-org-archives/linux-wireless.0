Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4600 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab1IXCJU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 22:09:20 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/20] staging: brcm80211: make device initializer table
 for wme constant
Date: Fri, 23 Sep 2011 19:09:01 -0700
Message-ID: <1316830148-28661-14-git-send-email-frankyl@broadcom.com> (sfid-20110924_040940_816982_6C36E77A)
In-Reply-To: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

For chip initialisation of the wme parameters a table is used, but
it was not marked as constant.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index c023b8b..407e99e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4302,13 +4302,13 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 	u16 aci;
 	int i_ac;
 	struct ieee80211_tx_queue_params txq_pars;
-	static struct edcf_acparam default_edcf_acparams[] = {
+	static const struct edcf_acparam default_edcf_acparams[] = {
 		 {EDCF_AC_BE_ACI_STA, EDCF_AC_BE_ECW_STA, EDCF_AC_BE_TXOP_STA},
 		 {EDCF_AC_BK_ACI_STA, EDCF_AC_BK_ECW_STA, EDCF_AC_BK_TXOP_STA},
 		 {EDCF_AC_VI_ACI_STA, EDCF_AC_VI_ECW_STA, EDCF_AC_VI_TXOP_STA},
 		 {EDCF_AC_VO_ACI_STA, EDCF_AC_VO_ECW_STA, EDCF_AC_VO_TXOP_STA}
 	}; /* ucode needs these parameters during its initialization */
-	struct edcf_acparam *edcf_acp = &default_edcf_acparams[0];
+	const struct edcf_acparam *edcf_acp = &default_edcf_acparams[0];
 
 	for (i_ac = 0; i_ac < AC_COUNT; i_ac++, edcf_acp++) {
 		/* find out which ac this set of params applies to */
-- 
1.7.1


