Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2334 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 43/61] staging: brcm80211: fix checkpatch warning in
 si_pmu_otp_power
Date: Tue, 3 May 2011 11:35:43 +0200
Message-ID: <1304415361-7813-44-git-send-email-arend@broadcom.com> (sfid-20110503_113816_580127_8F854E5A)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "remove dependency between aiutils and siutils sources" introduced
several checkpatch warnings. This patch remove those in si_pmu_otp_power().

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index e98ace6..4b2095f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -1886,9 +1886,8 @@ void si_pmu_otp_power(si_t *sih, bool on)
 	u32 rsrcs = 0;	/* rsrcs to turn on/off OTP power */
 
 	/* Don't do anything if OTP is disabled */
-	if (si_is_otp_disabled(sih)) {
+	if (si_is_otp_disabled(sih))
 		return;
-	}
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-- 
1.7.4.1


