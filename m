Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYHEQXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 12:23:17 -0400
Date: Tue, 05 Aug 2008 11:23:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
Message-ID: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> (sfid-20080805_182322_268022_1C278CB0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following commit 741b4fbc441dba885cc8f97a10e87f2acd04c5f2, if a packet
has the IEEE80211_TX_CTL_ASSIGN_SEQ assigned, a sequence number must be
supplied, either by hardware or software. AFAIK, no such hardware exists
for the p54, thus it must be done in software. With this patch, a connection
qith p54usb is stable, whereas the interface went off-line in 2-3 hours
without this change. Note that this code will have to be reworked for proper
sequence numbers on beacons. In addition, the sequence number has been placed
in the hardware state, not the vif state.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is a bug fix for 2.6.27.

Larry
---

 p54.h       |    1 +
 p54common.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

Index: wireless-testing/drivers/net/wireless/p54/p54.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54.h
+++ wireless-testing/drivers/net/wireless/p54/p54.h
@@ -52,6 +52,7 @@ struct p54_common {
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
+	u16 seqno;
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -553,6 +553,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct p54_tx_control_allocdata *txhdr;
 	size_t padding, len;
 	u8 rate;
@@ -605,6 +606,19 @@ static int p54_tx(struct ieee80211_hw *d
 	if (padding)
 		txhdr->align[0] = padding;
 
+	/* FIXME: The sequence that follows is needed for this driver to
+	 * work with mac80211 since "mac80211: fix TX sequence numbers".
+	 * As with the temporary code in rt2x00, changes will be needed
+	 * to get proper sequence numbers on beacons. In addition, this
+	 * patch places the sequence number in the hardware state, which
+	 * limits us to a single virtual state.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			priv->seqno += 0x10;
+		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
+	}
 	/* modifies skb->cb and with it info, so must be last! */
 	p54_assign_address(dev, skb, hdr, skb->len);
 
