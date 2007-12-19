Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40769 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbXLSQKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:16 -0500
Subject: [PATCH 118/48] libertas: don't clear priv->dnld_sent after sending sleep confirm
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50tu-000208-0K@pmac.infradead.org> (sfid-20071219_161020_189646_340053D1)
Date: Wed, 19 Dec 2007 15:32:02 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 17 Dec 2007 12:35:28 -0500

DNLD_RES_RECEIVED is a bit of a misnomer -- we never wait for the result
to be received; it's purely representing the state of the TX path, and
in this case the TX path is definitely busy.

Of course, that means that we don't actually care about DATA_SENT vs.
CMD_SENT either, but that's a can of worms for another day...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 2765b9c..10c60ba 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -2000,7 +2000,6 @@ static int sendconfirmsleep(struct lbs_private *priv, u8 *cmdptr, u16 size)
 	lbs_deb_hex(LBS_DEB_HOST, "sleep confirm command", cmdptr, size);
 
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, cmdptr, size);
-	priv->dnld_sent = DNLD_RES_RECEIVED;
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	if (priv->intcounter || priv->currenttxskb)
-- 
1.5.3.4

