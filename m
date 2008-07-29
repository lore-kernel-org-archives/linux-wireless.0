Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53832 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162AbYG2DI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 23:08:27 -0400
Message-ID: <488E89A2.9010308@lwfinger.net> (sfid-20080729_050830_953571_C3642409)
Date: Mon, 28 Jul 2008 22:08:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: [PATCH] rtl8187: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 741b4fbc441dba885cc8f97a10e87f2acd04c5f2 broke rtl8187. This
patch makes the same kind of fix that was done for rt2x00. Note that
this code will have to be reworked for proper sequence numbers on beacons.
In addition, the sequence number has been placed in the hardware state,
not the vif state.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John and Johnannes,

This is a bug fix for 2.6.27.

Larry
---

  rtl8187.h     |    1 +
  rtl8187_dev.c |   13 +++++++++++++
  2 files changed, 14 insertions(+)

Index: wireless-testing/drivers/net/wireless/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl8187.h
@@ -100,6 +100,7 @@ struct rtl8187_priv {
  	struct usb_device *udev;
  	u32 rx_conf;
  	u16 txpwr_base;
+	u16 seqno;
  	u8 asic_rev;
  	u8 is_rtl8187b;
  	enum {
Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -169,6 +169,7 @@ static int rtl8187_tx(struct ieee80211_h
  {
  	struct rtl8187_priv *priv = dev->priv;
  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
  	unsigned int ep;
  	void *buf;
  	struct urb *urb;
@@ -234,6 +235,20 @@ static int rtl8187_tx(struct ieee80211_h
  			ep = epmap[skb_get_queue_mapping(skb)];
  	}

+	/* XXX: The sequence that follows is needed for this driver to work
+	 * with mac80211 since commit 741b4fbc44 (mac80211: fix TX sequence
+	 * numbers). As with the temporary code in rt2x00, changes will be
+	 * needed to get proper sequence numbers on beacons. In addition,
+	 * this patch places the sequence number in the hardware state, which
+	 * limits us to a single virtual state.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			priv->seqno += 0x10;
+		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
+	}
+
  	info->driver_data[0] = dev;
  	info->driver_data[1] = urb;


