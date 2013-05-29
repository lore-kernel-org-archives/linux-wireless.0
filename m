Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1478 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759384Ab3E2QjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 13/16] brcmfmac: Accept only first creditmap
 event.
Date: Wed, 29 May 2013 18:39:03 +0200
Message-ID: <1369845546-31950-14-git-send-email-arend@broadcom.com> (sfid-20130529_184006_796132_F7527C15)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

During P2P testing it turned out that the firmware sents multiple
multiple creditmap event messages. Only the first message from the
firmware should be processed. Otherwise the firmware-signalled flow
control can run haywire when it has packets outstanding in firmware.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index b11a51b..dd47796 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -438,6 +438,7 @@ struct brcmf_fws_info {
 	u32 fifo_delay_map;
 	unsigned long borrow_defer_timestamp;
 	bool bus_flow_blocked;
+	bool creditmap_received;
 };
 
 /*
@@ -1432,6 +1433,10 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 		brcmf_err("event payload too small (%d)\n", e->datalen);
 		return -EINVAL;
 	}
+	if (fws->creditmap_received)
+		return 0;
+
+	fws->creditmap_received = true;
 
 	brcmf_dbg(TRACE, "enter: credits %pM\n", credits);
 	brcmf_fws_lock(ifp->drvr, flags);
-- 
1.7.10.4


