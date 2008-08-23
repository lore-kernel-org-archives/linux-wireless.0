Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:59548 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYHWUM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2008 16:12:26 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: fix rssi auto calibration
Date: Sat, 23 Aug 2008 22:15:25 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808232215.26360.chunkeey@web.de> (sfid-20080823_221246_368582_483004D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ever wondered why the signal was so bad with p54 compared to madwifi, or intel?

Well, if you have revision 1 rssi calibration curve points in your EEPROM, then wonder no more.
The firmware wants a extra 1 byte padding for every curve point. But someone forgot to put 
them into the EEPROM's data structure...

So now, big question: what happens when we blindly "memcpy" these data points?

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

I think you should put this into -next... since the bug sounds more terrifying than it really is.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-08-23 21:11:07.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-23 21:13:37.000000000 +0200
@@ -155,14 +155,14 @@ void p54_parse_firmware(struct ieee80211
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
 
-static int p54_convert_rev0_to_rev1(struct ieee80211_hw *dev,
-				    struct pda_pa_curve_data *curve_data)
+static int p54_convert_rev0(struct ieee80211_hw *dev,
+			    struct pda_pa_curve_data *curve_data)
 {
 	struct p54_common *priv = dev->priv;
-	struct pda_pa_curve_data_sample_rev1 *rev1;
-	struct pda_pa_curve_data_sample_rev0 *rev0;
+	struct p54_pa_curve_data_sample *dst;
+	struct pda_pa_curve_data_sample_rev0 *src;
 	size_t cd_len = sizeof(*curve_data) +
-		(curve_data->points_per_channel*sizeof(*rev1) + 2) *
+		(curve_data->points_per_channel*sizeof(*dst) + 2) *
 		 curve_data->channels;
 	unsigned int i, j;
 	void *source, *target;
@@ -180,27 +180,63 @@ static int p54_convert_rev0_to_rev1(stru
 		*((__le16 *)target) = *freq;
 		target += sizeof(__le16);
 		for (j = 0; j < curve_data->points_per_channel; j++) {
-			rev1 = target;
-			rev0 = source;
+			dst = target;
+			src = source;
 
-			rev1->rf_power = rev0->rf_power;
-			rev1->pa_detector = rev0->pa_detector;
-			rev1->data_64qam = rev0->pcv;
+			dst->rf_power = src->rf_power;
+			dst->pa_detector = src->pa_detector;
+			dst->data_64qam = src->pcv;
 			/* "invent" the points for the other modulations */
 #define SUB(x,y) (u8)((x) - (y)) > (x) ? 0 : (x) - (y)
-			rev1->data_16qam = SUB(rev0->pcv, 12);
-			rev1->data_qpsk  = SUB(rev1->data_16qam, 12);
-			rev1->data_bpsk  = SUB(rev1->data_qpsk, 12);
-			rev1->data_barker= SUB(rev1->data_bpsk, 14);
+			dst->data_16qam = SUB(src->pcv, 12);
+			dst->data_qpsk = SUB(dst->data_16qam, 12);
+			dst->data_bpsk = SUB(dst->data_qpsk, 12);
+			dst->data_barker = SUB(dst->data_bpsk, 14);
 #undef SUB
-			target += sizeof(*rev1);
-			source += sizeof(*rev0);
+			target += sizeof(*dst);
+			source += sizeof(*src);
 		}
 	}
 
 	return 0;
 }
 
+static int p54_convert_rev1(struct ieee80211_hw *dev,
+			    struct pda_pa_curve_data *curve_data)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_pa_curve_data_sample *dst;
+	struct pda_pa_curve_data_sample_rev1 *src;
+	size_t cd_len = sizeof(*curve_data) +
+		(curve_data->points_per_channel*sizeof(*dst) + 2) *
+		 curve_data->channels;
+	unsigned int i, j;
+	void *source, *target;
+
+	priv->curve_data = kmalloc(cd_len, GFP_KERNEL);
+	if (!priv->curve_data)
+		return -ENOMEM;
+
+	memcpy(priv->curve_data, curve_data, sizeof(*curve_data));
+	source = curve_data->data;
+	target = priv->curve_data->data;
+	for (i = 0; i < curve_data->channels; i++) {
+		__le16 *freq = source;
+		source += sizeof(__le16);
+		*((__le16 *)target) = *freq;
+		target += sizeof(__le16);
+		for (j = 0; j < curve_data->points_per_channel; j++) {
+			memcpy(target, source, sizeof(*src));
+
+			target += sizeof(*dst);
+			source += sizeof(*src);
+		}
+		source++;
+	}
+
+	return 0;
+}
+
 int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
@@ -250,27 +286,32 @@ int p54_parse_eeprom(struct ieee80211_hw
 			       entry->data[1]*sizeof(*priv->output_limit));
 			priv->output_limit_len = entry->data[1];
 			break;
-		case PDR_PRISM_PA_CAL_CURVE_DATA:
-			if (data_len < sizeof(struct pda_pa_curve_data)) {
+		case PDR_PRISM_PA_CAL_CURVE_DATA: {
+			struct pda_pa_curve_data *curve_data =
+				(struct pda_pa_curve_data *)entry->data;
+			if (data_len < sizeof(*curve_data)) {
 				err = -EINVAL;
 				goto err;
 			}
 
-			if (((struct pda_pa_curve_data *)entry->data)->cal_method_rev) {
-				priv->curve_data = kmalloc(data_len, GFP_KERNEL);
-				if (!priv->curve_data) {
-					err = -ENOMEM;
-					goto err;
-				}
-
-				memcpy(priv->curve_data, entry->data, data_len);
-			} else {
-				err = p54_convert_rev0_to_rev1(dev, (struct pda_pa_curve_data *)entry->data);
-				if (err)
-					goto err;
+			switch (curve_data->cal_method_rev) {
+			case 0:
+				err = p54_convert_rev0(dev, curve_data);
+				break;
+			case 1:
+				err = p54_convert_rev1(dev, curve_data);
+				break;
+			default:
+				printk(KERN_ERR "p54: unknown curve data "
+						"revision %d\n",
+						curve_data->cal_method_rev);
+				err = -ENODEV;
+				break;
 			}
+			if (err)
+				goto err;
 
-			break;
+		}
 		case PDR_PRISM_ZIF_TX_IQ_CALIBRATION:
 			priv->iq_autocal = kmalloc(data_len, GFP_KERNEL);
 			if (!priv->iq_autocal) {
@@ -672,12 +713,9 @@ static int p54_set_freq(struct ieee80211
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_channel *chan;
 	unsigned int i;
-	size_t payload_len = sizeof(*chan) + sizeof(u32)*2 +
-			     sizeof(*chan->curve_data) *
-			     priv->curve_data->points_per_channel;
 	void *entry;
 
-	hdr = kzalloc(sizeof(*hdr) + payload_len +
+	hdr = kzalloc(sizeof(*hdr) + sizeof(*chan) +
 		      priv->tx_hdr_len, GFP_KERNEL);
 	if (!hdr)
 		return -ENOMEM;
@@ -689,10 +727,10 @@ static int p54_set_freq(struct ieee80211
 	hdr->magic1 = cpu_to_le16(0x8001);
 	hdr->len = cpu_to_le16(sizeof(*chan));
 	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_CHANNEL_CHANGE);
-	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + payload_len);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*chan));
 
-	chan->magic1 = cpu_to_le16(0x1);
-	chan->magic2 = cpu_to_le16(0x0);
+	chan->flags = cpu_to_le16(0x1);
+	chan->dwell = cpu_to_le16(0x0);
 
 	for (i = 0; i < priv->iq_autocal_len; i++) {
 		if (priv->iq_autocal[i].freq != freq)
@@ -710,35 +748,41 @@ static int p54_set_freq(struct ieee80211
 			continue;
 
 		chan->val_barker = 0x38;
-		chan->val_bpsk = priv->output_limit[i].val_bpsk;
-		chan->val_qpsk = priv->output_limit[i].val_qpsk;
-		chan->val_16qam = priv->output_limit[i].val_16qam;
-		chan->val_64qam = priv->output_limit[i].val_64qam;
+		chan->val_bpsk = chan->dup_bpsk =
+			priv->output_limit[i].val_bpsk;
+		chan->val_qpsk = chan->dup_qpsk =
+			priv->output_limit[i].val_qpsk;
+		chan->val_16qam = chan->dup_16qam =
+			priv->output_limit[i].val_16qam;
+		chan->val_64qam = chan->dup_64qam =
+			priv->output_limit[i].val_64qam;
 		break;
 	}
 	if (i == priv->output_limit_len)
 		goto err;
 
-	chan->pa_points_per_curve = priv->curve_data->points_per_channel;
-
 	entry = priv->curve_data->data;
 	for (i = 0; i < priv->curve_data->channels; i++) {
 		if (*((__le16 *)entry) != freq) {
 			entry += sizeof(__le16);
-			entry += sizeof(struct pda_pa_curve_data_sample_rev1) *
-				 chan->pa_points_per_curve;
+			entry += sizeof(struct p54_pa_curve_data_sample) *
+				 priv->curve_data->points_per_channel;
 			continue;
 		}
 
 		entry += sizeof(__le16);
+		chan->pa_points_per_curve =
+			min(priv->curve_data->points_per_channel, (u8) 8);
+
 		memcpy(chan->curve_data, entry, sizeof(*chan->curve_data) *
 		       chan->pa_points_per_curve);
 		break;
 	}
 
-	memcpy(hdr->data + payload_len - 4, &chan->val_bpsk, 4);
+	chan->rssical_mul = cpu_to_le16(130);
+	chan->rssical_add = cpu_to_le16(0xfe70);	/* -400 */
 
-	priv->tx(dev, hdr, sizeof(*hdr) + payload_len, 1);
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*chan), 1);
 	return 0;
 
  err:
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-08-23 21:11:26.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-08-23 21:10:49.000000000 +0200
@@ -89,6 +89,16 @@ struct pda_pa_curve_data_sample_rev1 {
 	u8 data_qpsk;
 	u8 data_16qam;
 	u8 data_64qam;
+} __attribute__ ((packed));
+
+struct p54_pa_curve_data_sample {
+	u8 rf_power;
+	u8 pa_detector;
+	u8 data_barker;
+	u8 data_bpsk;
+	u8 data_qpsk;
+	u8 data_16qam;
+	u8 data_64qam;
 	u8 padding;
 } __attribute__ ((packed));
 
@@ -212,8 +222,8 @@ struct p54_tx_control_filter {
 } __attribute__ ((packed));
 
 struct p54_tx_control_channel {
-	__le16 magic1;
-	__le16 magic2;
+	__le16 flags;
+	__le16 dwell;
 	u8 padding1[20];
 	struct pda_iq_autocal_entry iq_autocal;
 	u8 pa_points_per_curve;
@@ -222,8 +232,13 @@ struct p54_tx_control_channel {
 	u8 val_qpsk;
 	u8 val_16qam;
 	u8 val_64qam;
-	struct pda_pa_curve_data_sample_rev1 curve_data[0];
-	/* additional padding/data after curve_data */
+	struct pda_pa_curve_data_sample_rev1 curve_data[8];
+	u8 dup_bpsk;
+	u8 dup_qpsk;
+	u8 dup_16qam;
+	u8 dup_64qam;
+	__le16 rssical_mul;
+	__le16 rssical_add;
 } __attribute__ ((packed));
 
 struct p54_tx_control_led {

