Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759477Ab0E0SlW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 14:41:22 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4RIfLtU029539
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 14:41:21 -0400
Date: Thu, 27 May 2010 14:41:20 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100527183717.24368.49914.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: libertas: fix uninitialized variable warning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes:

drivers/net/wireless/libertas/rx.c: In function ‘process_rxed_802_11_packet’:
drivers/net/wireless/libertas/rx.c:354: error: ‘radiotap_hdr.flags’ may be used uninitialized in this function

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index e2b8d88..2319bde 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -330,9 +330,8 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	/* create the exported radio header */
 
 	/* radiotap header */
-	radiotap_hdr.hdr.it_version = 0;
-	/* XXX must check this value for pad */
-	radiotap_hdr.hdr.it_pad = 0;
+	memset(&radiotap_hdr, 0, sizeof(radiotap_hdr));
+	/* XXX must check radiotap_hdr.hdr.it_pad for pad */
 	radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
 	radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
 	radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
