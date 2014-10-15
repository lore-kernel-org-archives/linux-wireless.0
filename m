Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:35453 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbaJOTBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 15:01:25 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] NFC: digital: use sizeof(*target) instead of nfc_target
Date: Wed, 15 Oct 2014 21:01:20 +0200
Message-Id: <1413399680-8338-1-git-send-email-fabf@skynet.be> (sfid-20141015_210145_028992_3BC2B37A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

See Documentation/CodingStyle Chapter 14

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/nfc/digital_technology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/digital_technology.c b/net/nfc/digital_technology.c
index fb58ed2d..5e94b6f 100644
--- a/net/nfc/digital_technology.c
+++ b/net/nfc/digital_technology.c
@@ -494,7 +494,7 @@ static void digital_in_recv_sens_res(struct nfc_digital_dev *ddev, void *arg,
 		goto exit;
 	}
 
-	target = kzalloc(sizeof(struct nfc_target), GFP_KERNEL);
+	target = kzalloc(sizeof(*target), GFP_KERNEL);
 	if (!target) {
 		rc = -ENOMEM;
 		goto exit;
@@ -693,7 +693,7 @@ static void digital_in_recv_sensb_res(struct nfc_digital_dev *ddev, void *arg,
 	else
 		ddev->target_fsc = digital_ats_fsc[fsci];
 
-	target = kzalloc(sizeof(struct nfc_target), GFP_KERNEL);
+	target = kzalloc(sizeof(*target), GFP_KERNEL);
 	if (!target) {
 		rc = -ENOMEM;
 		goto exit;
-- 
1.9.3

