Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:57505 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2AQNF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 08:05:57 -0500
Subject: [PATCH 3/3] ath6kl: fix uninitialized warning in
	ath6kl_process_uapsdq()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 15:05:46 +0200
Message-ID: <20120117130546.22832.4319.stgit@localhost6.localdomain6> (sfid-20120117_140559_440772_E7923EB0)
In-Reply-To: <20120117130519.22832.29908.stgit@localhost6.localdomain6>
References: <20120117130519.22832.29908.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before I commited patch c1762a3fe ("ath6kl: Add support for uAPSD") I
did a minor change how up variable is initialised in
ath6kl_process_uapsdq(). But I was sloppy and caused this compiler
warning:

txrx.c:88:5: warning: 'up' may be used uninitialized in this function

Revert my change to fix the warning.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 91bbc1f..dd63371 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -85,7 +85,7 @@ static bool ath6kl_process_uapsdq(struct ath6kl_sta *conn,
 	struct ath6kl *ar = vif->ar;
 	bool is_apsdq_empty = false;
 	struct ethhdr *datap = (struct ethhdr *) skb->data;
-	u8 up, traffic_class, *ip_hdr;
+	u8 up = 0, traffic_class, *ip_hdr;
 	u16 ether_type;
 	struct ath6kl_llc_snap_hdr *llc_hdr;
 
@@ -122,8 +122,6 @@ static bool ath6kl_process_uapsdq(struct ath6kl_sta *conn,
 		if (ether_type == IP_ETHERTYPE)
 			up = ath6kl_wmi_determine_user_priority(
 							ip_hdr, 0);
-	} else {
-		up = 0;
 	}
 
 	traffic_class = ath6kl_wmi_get_traffic_class(up);

