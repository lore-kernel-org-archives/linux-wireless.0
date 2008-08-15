Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38065 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbYHOSbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 14:31:53 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Fri, 15 Aug 2008 20:34:45 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808082038.48840.chunkeey@web.de> <489EF8DE.5030801@lwfinger.net>
In-Reply-To: <489EF8DE.5030801@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808152034.46346.chunkeey@web.de> (sfid-20080815_203157_290780_F48C6699)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 August 2008 16:19:10 Larry Finger wrote:
> Chr wrote:
> > the next one is at line 27188... and so down to end of packages at line
> > 329241. there isn't one single package where the sequence number is not
> > zero!
> >
> > So the problem must be somewhere else! what happens when:
> > if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> > 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> > 		priv->seqno += 0x10;
> >
> > 	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> > 	ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
> > 	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> > }
> > (yeah a new definition for idiotic! but it's about the same amount of of
> > clock cycles).
>
> There must be some situation where the firmware fails to assign a
> proper sequence number to some packets. With this patch in place, the
> device failed after 2 hours. Restoring my original patch, it has been
> up for 15 hours and still going.
Hmm, or there's something else can't count?!??

Anyway, the firmware will always assign (as in overwrite) the
sequence number for every transmitted frame... unfortunatly
there isn't a uniform way to disable this behaviour. 

So, rather than doing the sequence number (ac-)couting in the
driver, we can stick to the one the firmware has already generated...

Larry, does this patch fixes the "every two hour disconnect" problem as well, or not at all?
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-08-13 20:50:03.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-15 20:06:12.000000000 +0200
@@ -428,6 +428,12 @@ static void p54_rx_frame_sent(struct iee
 			info->status.retry_count = payload->retries - 1;
 			info->status.ack_signal = le16_to_cpu(payload->ack_rssi);
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
+			if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+				struct ieee80211_hdr *ieee80211hdr =
+					(struct ieee80211_hdr *) entry->data;
+
+				ieee80211hdr->seq_ctrl |= payload->seq;
+			}
 			ieee80211_tx_status_irqsafe(dev, entry);
 			break;
 		} else
@@ -553,7 +559,6 @@ static int p54_tx(struct ieee80211_hw *d
 	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct p54_tx_control_allocdata *txhdr;
 	size_t padding, len;
 	u8 rate, cts_rate = 0x20;
@@ -604,19 +609,6 @@ static int p54_tx(struct ieee80211_hw *d
 	if (padding)
 		txhdr->align[0] = padding;
 
-	/* FIXME: The sequence that follows is needed for this driver to
-	 * work with mac80211 since "mac80211: fix TX sequence numbers".
-	 * As with the temporary code in rt2x00, changes will be needed
-	 * to get proper sequence numbers on beacons. In addition, this
-	 * patch places the sequence number in the hardware state, which
-	 * limits us to a single virtual state.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			priv->seqno += 0x10;
-		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
-	}
 	/* modifies skb->cb and with it info, so must be last! */
 	p54_assign_address(dev, skb, hdr, skb->len);
 
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-08-13 20:50:30.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-08-15 19:38:10.000000000 +0200
@@ -52,7 +52,6 @@ struct p54_common {
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
-	u16 seqno;
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];

