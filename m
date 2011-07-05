Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2952 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab1GEWDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/31] staging: brcm80211: made name lookup arrays more
 const
Date: Wed, 6 Jul 2011 00:02:44 +0200
Message-ID: <1309903378-29021-18-git-send-email-arend@broadcom.com> (sfid-20110706_000322_450719_3932B24F)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The checkpatch script gave a hint that some character string arrays
probably should have an additional const keyword. This patch changes
the static const char * arrays to static const char * const arrays as
suggested getting rid of two checkpatch warnings.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 8d061ad..b89b0ec 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -278,7 +278,7 @@ static bool in_send_q;
 #define wme_shmemacindex(ac)	wme_ac2fifo[ac]
 
 #ifdef BCMDBG
-static const char *fifo_names[] = {
+static const char * const fifo_names[] = {
 	"AC_BK", "AC_BE", "AC_VI", "AC_VO", "BCMC", "ATIM" };
 #else
 static const char fifo_names[6][0];
@@ -2831,7 +2831,7 @@ static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 }
 
 #ifdef BCMDBG
-static const char *supr_reason[] = {
+static const char * const supr_reason[] = {
 	"None", "PMQ Entry", "Flush request",
 	"Previous frag failure", "Channel mismatch",
 	"Lifetime Expiry", "Underflow"
-- 
1.7.4.1


