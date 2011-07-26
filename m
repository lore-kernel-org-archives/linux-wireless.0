Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60052 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1GZWwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 18:52:43 -0400
Subject: [PATCH 2/3] hostap_cs: support cards with "Version 01.02" as third
 product ID
To: linux-pcmcia@lists.infradead.org, linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 26 Jul 2011 18:52:41 -0400
Message-ID: <20110726225241.29951.86739.stgit@mj.roinet.com> (sfid-20110727_005249_416964_DBF4BA63)
In-Reply-To: <20110726225235.29951.70265.stgit@mj.roinet.com>
References: <20110726225235.29951.70265.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cards with numeric ID 0x0156:0x0002 and third ID "Version 01.02" can be
assumed to have Intersil firmware.  Cards with Agere firmware use
"Version 01.01".

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/hostap/hostap_cs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index c052a0d..5441ad1 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -648,6 +648,8 @@ static const struct pcmcia_device_id hostap_cs_ids[] = {
 					 0x74c5e40d),
 	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "Intersil",
 					 0x4b801a17),
+	PCMCIA_DEVICE_MANF_CARD_PROD_ID3(0x0156, 0x0002, "Version 01.02",
+					 0x4b74baa0),
 	PCMCIA_MFC_DEVICE_PROD_ID12(0, "SanDisk", "ConnectPlus",
 				    0x7a954bd9, 0x74be00c6),
 	PCMCIA_DEVICE_PROD_ID123(
