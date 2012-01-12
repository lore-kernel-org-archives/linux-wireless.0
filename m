Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44432 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2ALGgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 01:36:16 -0500
Date: Thu, 12 Jan 2012 09:34:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ipw2x00: signedness bug handling frame length
Message-ID: <20120112063449.GA2408@elgon.mountain> (sfid-20120112_073620_870375_7E8284B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is basically just a cleanup.  Large positive numbers get counted as
negative but then get implicitly cast to positive again for the checks
that matter.

This does make a small difference in ipw_handle_promiscuous_rx() when we
test "if (unlikely((len + IPW_RX_FRAME_SIZE) > skb_tailroom(rxb->skb)))"
It should return there, but we don't return until a couple lines later
when we test "if (len > IPW_RX_BUF_SIZE - sizeof(struct ipw_rt_hdr)) {".
The difference is that in the second test the sizeof() means that there
is an implied cast to unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 018a8de..4fcdac6 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -7848,7 +7848,7 @@ static void ipw_handle_data_packet_monitor(struct ipw_priv *priv,
 	 * more efficiently than we can parse it. ORDER MATTERS HERE */
 	struct ipw_rt_hdr *ipw_rt;
 
-	short len = le16_to_cpu(pkt->u.frame.length);
+	unsigned short len = le16_to_cpu(pkt->u.frame.length);
 
 	/* We received data from the HW, so stop the watchdog */
 	dev->trans_start = jiffies;
@@ -8023,7 +8023,7 @@ static void ipw_handle_promiscuous_rx(struct ipw_priv *priv,
 	s8 signal = frame->rssi_dbm - IPW_RSSI_TO_DBM;
 	s8 noise = (s8) le16_to_cpu(frame->noise);
 	u8 rate = frame->rate;
-	short len = le16_to_cpu(pkt->u.frame.length);
+	unsigned short len = le16_to_cpu(pkt->u.frame.length);
 	struct sk_buff *skb;
 	int hdr_only = 0;
 	u16 filter = priv->prom_priv->filter;
