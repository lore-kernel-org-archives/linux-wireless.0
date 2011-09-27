Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4823 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab1I0Rpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:52 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 11/26] staging: brcm80211: make device initializer
 table for wme constant
Date: Tue, 27 Sep 2011 10:45:15 -0700
Message-ID: <1317145530-18839-12-git-send-email-frankyl@broadcom.com> (sfid-20110927_194630_928798_7A7357D3)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
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
index dfd67de..a3c0157 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4297,7 +4297,7 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 	int i_ac;
 	struct ieee80211_tx_queue_params txq_pars;
 	struct ieee80211_tx_queue_params *params = &txq_pars;
-	static struct edcf_acparam default_edcf_acparams[] = {
+	static const struct edcf_acparam default_edcf_acparams[] = {
 		 {EDCF_AC_BE_ACI_STA, EDCF_AC_BE_ECW_STA,
 		  cpu_to_le16(EDCF_AC_BE_TXOP_STA)},
 		 {EDCF_AC_BK_ACI_STA, EDCF_AC_BK_ECW_STA,
@@ -4307,7 +4307,7 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 		 {EDCF_AC_VO_ACI_STA, EDCF_AC_VO_ECW_STA,
 		  cpu_to_le16(EDCF_AC_VO_TXOP_STA)}
 	}; /* ucode needs these parameters during its initialization */
-	struct edcf_acparam *edcf_acp = &default_edcf_acparams[0];
+	const struct edcf_acparam *edcf_acp = &default_edcf_acparams[0];
 
 	for (i_ac = 0; i_ac < AC_COUNT; i_ac++, edcf_acp++) {
 		/* find out which ac this set of params applies to */
-- 
1.7.1


