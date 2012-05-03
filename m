Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62039 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2ECNJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 09:09:24 -0400
From: "Lee, Youngsin" <youngsin@qualcomm.com>
To: "Natarajan, Vivekanandan" <nataraja@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"Kwak, Steven" <sskwak@qualcomm.com>,
	"Kim, Kyle" <kkim@qualcomm.com>,
	"Byun, Matt" <mattbyun@qualcomm.com>,
	"Lee, Ryan (QCA KR)" <ryanlee@qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"Kim, Sunny" <sunnykim@qualcomm.com>,
	"Huang, Karen (Karen Huang_QCA TW)" <yahuan@qca.qualcomm.com>,
	"Lee, HG" <honglee@qualcomm.com>, "Kim, Cj" <cjkim@qualcomm.com>,
	"Kim, Taek-Soo (Henry)" <henrykim@qualcomm.com>
Subject: RE: [PATCH] ath6kl_sdio: Fix the EAPOL out of order issue
Date: Thu, 3 May 2012 13:09:21 +0000
Message-ID: <CD6CCE71FC934142A137CF091F64707B2854C3ED@nasanexd02c.na.qualcomm.com> (sfid-20120503_150928_702771_03072F11)
References: <1335950725-15597-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1335950725-15597-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ More folks.

Steven, Please also check this patch for CR346620.

Thanks a lot,
Youngsin.

-----Original Message-----
From: Natarajan, Vivekanandan 
Sent: Wednesday, May 02, 2012 6:25 PM
To: Valo, Kalle
Cc: linux-wireless@vger.kernel.org; ath6kl-devel
Subject: [PATCH] ath6kl_sdio: Fix the EAPOL out of order issue

Send the EAPOL and management frames in the same AC_VO queue. The issue happens when the AP supports QOS, the management frames are sent to AC_VO queue and EAP frame goes to AC_BE queue. Even though the EAP frame is queued before the DEAUTH management frame, as they are queued on different h/w queues, order of delivery between these frames cannot be controlled.

This fixes the connection failure seen in P2P case.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    7 +++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |    2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 102477d..ee8ec23 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -290,6 +290,13 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, u8 if_idx,
 					layer2_priority);
 		} else
 			usr_pri = layer2_priority & 0x7;
+
+		/*
+		 * Queue the EAPOL frames in the same WMM_AC_VO queue
+		 * as that of management frames.
+		 */
+		if (skb->protocol == cpu_to_be16(ETH_P_PAE))
+			usr_pri = WMI_VOICE_USER_PRIORITY;
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9966140..9076bec 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -106,6 +106,8 @@ struct wmi_data_sync_bufs {
 #define WMM_AC_VI   2		/* video */
 #define WMM_AC_VO   3		/* voice */
 
+#define WMI_VOICE_USER_PRIORITY		0x7
+
 struct wmi {
 	u16 stream_exist_for_ac[WMM_NUM_AC];
 	u8 fat_pipe_exist;
--
1.7.10

