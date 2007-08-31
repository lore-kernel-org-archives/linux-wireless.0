Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:54072 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965674AbXHaV1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 17:27:31 -0400
From: Chr <chunkeey@web.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/2] p54: various fixes
Date: Fri, 31 Aug 2007 23:27:14 +0200
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <46BFF10B.1090307@hhs.nl> <200708282132.59474.chunkeey@web.de> <200708300152.27736.flamingice@sourmilk.net>
In-Reply-To: <200708300152.27736.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yeI2GgxfscFgQY5"
Message-Id: <200708312327.14559.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_yeI2GgxfscFgQY5
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

From: Christian Lamparter <chunkeey@web.de>

This patch should finally fix the mysterious "stuck at 1 mbps" and numerous of
"lost" ACKs (very important for the not yet released p54 AP addon).

The patch also includes a bunch of useful one liners that did not make it in the tree yet.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---

--Boundary-00=_yeI2GgxfscFgQY5
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="p54-forgotten-patch4.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="p54-forgotten-patch4.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54com=
mon.c
=2D-- a/drivers/net/wireless/p54common.c	2007-08-31 21:56:42.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-08-31 21:57:29.000000000 +0200
@@ -283,12 +283,13 @@ static void p54_rx_data(struct ieee80211
 	struct ieee80211_rx_status rx_status =3D {0};
 	u16 freq =3D le16_to_cpu(hdr->freq);
=20
=2D	rx_status.ssi =3D hdr->rssi;	/* TODO: check this */
+	rx_status.ssi =3D hdr->rssi;
 	rx_status.rate =3D hdr->rate & 0x1f; /* report short preambles & CCK too =
*/
 	rx_status.channel =3D freq =3D=3D 2484 ? 14 : (freq - 2407)/5;
 	rx_status.freq =3D freq;
 	rx_status.phymode =3D MODE_IEEE80211G;
 	rx_status.antenna =3D hdr->antenna;
+	rx_status.mactime =3D le64_to_cpu(hdr->timestamp);
=20
 	skb_pull(skb, sizeof(*hdr));
 	skb_trim(skb, le16_to_cpu(hdr->len));
@@ -324,6 +325,9 @@ static void p54_rx_frame_sent(struct iee
 		range =3D (struct memrecord *)&entry->cb;
 		if (range->start_addr =3D=3D addr) {
 			struct ieee80211_tx_status status =3D {{0}};
+			struct p54_control_hdr *entry_hdr;
+			struct p54_tx_control_allocdata *entry_data;
+			int pad =3D 0;
=20
 			if (entry->next !=3D (struct sk_buff *)&priv->tx_queue)
 				freed =3D ((struct memrecord *)&entry->next->cb)->start_addr - last_ad=
dr;
@@ -339,14 +343,22 @@ static void p54_rx_frame_sent(struct iee
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);
=2D			if (!payload->status)
=2D				status.flags |=3D IEEE80211_TX_STATUS_ACK;
=2D			else
=2D				status.excessive_retries =3D 1;
+			priv->tx_stats.data[status.control.queue].len--;
+
+			entry_hdr =3D (struct p54_control_hdr *) entry->data;
+			entry_data =3D (struct p54_tx_control_allocdata *) entry_hdr->data;
+			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) !=3D 0)
+				pad =3D entry_data->align[0];
+
+			if (!status.control.flags & IEEE80211_TXCTL_NO_ACK) {
+				if (!(payload->status & 0x01))
+					status.flags |=3D IEEE80211_TX_STATUS_ACK;
+				else
+					status.excessive_retries =3D 1;
+			}
 			status.retry_count =3D payload->retries - 1;
 			status.ack_signal =3D le16_to_cpu(payload->ack_rssi);
=2D			skb_pull(entry, sizeof(*hdr) + sizeof(struct p54_tx_control_allocdata=
));
=2D			priv->tx_stats.data[status.control.queue].len--;
+			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 			ieee80211_tx_status_irqsafe(dev, entry, &status);
 			break;
 		} else
@@ -895,7 +907,7 @@ struct ieee80211_hw *p54_init_common(siz
 		    IEEE80211_HW_RX_INCLUDES_FCS |
 		    IEEE80211_HW_WEP_INCLUDE_IV;
 	dev->channel_change_time =3D 1000;	/* TODO: find actual value */
=2D	dev->max_rssi =3D 100;
+	dev->max_rssi =3D 127;
=20
 	/* (hard) queue limits */
 	priv->tx_stats.data[0].limit =3D 3;
diff -Nurp a/drivers/net/wireless/p54common.h b/drivers/net/wireless/p54com=
mon.h
=2D-- a/drivers/net/wireless/p54common.h	2007-08-18 20:44:04.000000000 +0200
+++ b/drivers/net/wireless/p54common.h	2007-08-28 19:53:13.000000000 +0200
@@ -168,7 +168,7 @@ struct p54_rx_hdr {
 	u8 antenna;
 	u8 rate;
 	u8 rssi;
=2D	u8 padding;
+	u8 quality;
 	u16 unknown2;
 	__le64 timestamp;
 	u8 data[0];

--Boundary-00=_yeI2GgxfscFgQY5--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
