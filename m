Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1667 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161999Ab3DEI6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/16] brcmfmac: add role attribute to struct
 brcmf_if_event definition
Date: Fri, 5 Apr 2013 10:57:45 +0200
Message-ID: <1365152274-4252-8-git-send-email-arend@broadcom.com> (sfid-20130405_105825_237576_575C0FC6)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According specification the IF event has an additional field indicating
the role or type of the interface for which this event is sent.

Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h  |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index ef5e3a9..5249c67 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -548,6 +548,7 @@ struct brcmf_if_event {
 	u8 action;
 	u8 flags;
 	u8 bssidx;
+	u8 role;
 };
 
 /* forward declarations */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 01d39a9..9672b99 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -181,9 +181,9 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 	struct brcmf_if *ifp;
 	int err = 0;
 
-	brcmf_dbg(EVENT, "action: %u idx: %u bsscfg: %u flags: %u\n",
-		  ifevent->action, ifevent->ifidx,
-		  ifevent->bssidx, ifevent->flags);
+	brcmf_dbg(EVENT, "action: %u idx: %u bsscfg: %u flags: %u role: %u\n",
+		  ifevent->action, ifevent->ifidx, ifevent->bssidx,
+		  ifevent->flags, ifevent->role);
 
 	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
 		brcmf_err("invalid interface index: %u\n",
-- 
1.7.10.4


