Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2288 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/15] brcm80211: smac: some local function made static
 in main.c
Date: Tue, 18 Oct 2011 14:03:07 +0200
Message-ID: <1318939391-19495-12-git-send-email-arend@broadcom.com> (sfid-20111018_140353_818772_A918003C)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In main.c a couple of functions were not static although they
were only locally used. Sparse gave warnings on them and these
functions have been made static.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 2e1a20b..abb49fc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -618,9 +618,8 @@ static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
  * calculate frame duration of a given rate and length, return
  * time in usec unit
  */
-uint
-brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
-			u8 preamble_type, uint mac_len)
+static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
+				    u8 preamble_type, uint mac_len)
 {
 	uint nsyms, dur = 0, Ndps, kNdps;
 	uint rate = rspec2rate(ratespec);
@@ -4184,7 +4183,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 	}
 }
 
-void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
+static void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 {
 	u16 aci;
 	int i_ac;
@@ -6100,9 +6099,9 @@ void brcms_c_print_txdesc(struct d11txh *txh)
 #endif				/* defined(BCMDBG) */
 
 #if defined(BCMDBG)
-int
+static int
 brcms_c_format_flags(const struct brcms_c_bit_desc *bd, u32 flags, char *buf,
-		   int len)
+		     int len)
 {
 	int i;
 	char *p = buf;
-- 
1.7.4.1


