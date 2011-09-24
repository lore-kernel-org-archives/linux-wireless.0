Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4579 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab1IXCJU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 22:09:20 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/20] staging: brcm80211: use fragment number provided
 in transmit frame
Date: Fri, 23 Sep 2011 19:08:59 -0700
Message-ID: <1316830148-28661-12-git-send-email-frankyl@broadcom.com> (sfid-20110924_040948_259726_EC41542E)
In-Reply-To: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
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
index 35fc8b0..c023b8b 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -7101,7 +7101,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				scb->seqnum[p->priority]++;
 
 			/* extract fragment number from frame first */
-			seq = le16_to_cpu(seq) & FRAGNUM_MASK;
+			seq = le16_to_cpu(h->seq_ctrl) & FRAGNUM_MASK;
 			seq |= (scb->seqnum[p->priority] << SEQNUM_SHIFT);
 			h->seq_ctrl = cpu_to_le16(seq);
 
-- 
1.7.1


