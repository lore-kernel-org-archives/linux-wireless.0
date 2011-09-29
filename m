Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1885 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab1I2Wet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:49 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 09/25] staging: brcm80211: use fragment number
 provided in transmit frame
Date: Thu, 29 Sep 2011 15:34:20 -0700
Message-ID: <1317335676-3424-10-git-send-email-frankyl@broadcom.com> (sfid-20110930_003550_475643_AD2E11C9)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In the transmit path the field seq_ctrl is filled in, but the fragment
number was not properly determined.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 074e16f..dfd67de 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -7100,7 +7100,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				scb->seqnum[p->priority]++;
 
 			/* extract fragment number from frame first */
-			seq = le16_to_cpu(seq) & FRAGNUM_MASK;
+			seq = le16_to_cpu(h->seq_ctrl) & FRAGNUM_MASK;
 			seq |= (scb->seqnum[p->priority] << SEQNUM_SHIFT);
 			h->seq_ctrl = cpu_to_le16(seq);
 
-- 
1.7.1


