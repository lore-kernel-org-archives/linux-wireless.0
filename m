Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:27166
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1948805AbdEZWtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 18:49:47 -0400
From: Norik Dzhandzhapanyan <norikd@ethertronics.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] Per chain RSSI reporting
Date: Fri, 26 May 2017 22:49:45 +0000
Message-ID: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com> (sfid-20170527_034507_975851_E91C90C7)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for per chain RSSI reporting w/smoothing.

Signed-off-by: Norik Dzhandzhapanyan norikd@ethertronics.com


--- htt_rx.c.orig  2017-05-26 15:26:37.918504255 -0700
+++ htt_rx.c        2017-05-26 12:10:33.139809025 -0700
@@ -825,14 +825,71 @@ static bool ath10k_htt_rx_h_channel(stru
              return true;
}

+/*
+ * Signal data is somewhat glitchy. We smooth it out here with
+ * a 16 point moving average by storing samples in a buffer.
+ * As new samples come in, remove the oldest and add the newest
+ * to the running sum.  Avoids changes/impact to other generic averaging.
+ */
+
+/* Moving average buffer */
+#define MA_SAMPLES (16)
+
+struct ma_buffer
+{
+             int count;
+             int head;
+             int tail;
+             int sum;
+             int samps[MA_SAMPLES];
+};
+
+struct ma_buffer ma_buffers[IEEE80211_MAX_CHAINS] =3D {{ 0 }};
+
+static int ath_cb_moving_average(struct ma_buffer *mb, int8_t samp)
+{
+             if (mb->count < MA_SAMPLES) {
+                            mb->count++;
+                            mb->sum +=3D samp;
+                            mb->tail =3D 0;
+             } else {
+                            int oldest =3D mb->samps[mb->tail];
+                            mb->tail =3D (mb->head =3D=3D MA_SAMPLES - 1) =
? 0 : mb->head + 1;
+                            mb->sum =3D mb->sum - oldest + samp;
+             }
+
+             mb->samps[mb->head] =3D samp;
+             mb->head =3D (mb->head =3D=3D MA_SAMPLES - 1) ? 0 : mb->head =
+ 1;
+
+             return (mb->sum / mb->count);
+}
+
static void ath10k_htt_rx_h_signal(struct ath10k *ar,
                                                              struct ieee80=
211_rx_status *status,
                                                              struct htt_rx=
_desc *rxd)
{
-              /* FIXME: Get real NF */
-              status->signal =3D ATH10K_DEFAULT_NOISE_FLOOR +
-                                            rxd->ppdu_start.rssi_comb;
-              status->flag &=3D ~RX_FLAG_NO_SIGNAL_VAL;
+    int i;
+
+    for(i=3D0;i<IEEE80211_MAX_CHAINS;i++)
+    {
+        status->chains &=3D ~BIT(i);
+
+        if (rxd->ppdu_start.rssi_chains[i].pri20_mhz !=3D 0x80)
+        {
+            int8_t rssi =3D ATH10K_DEFAULT_NOISE_FLOOR +
+                rxd->ppdu_start.rssi_chains[i].pri20_mhz;
+
+            status->chains |=3D BIT(i);
+
+            /* Compute the moving average of rssi */
+                                status->chain_signal[i] =3D ath_cb_moving_=
average(&ma_buffers[i], rssi);
+        }
+    }
+
+    /* FIXME: Get real NF */
+    status->signal =3D ATH10K_DEFAULT_NOISE_FLOOR +
+        rxd->ppdu_start.rssi_comb;
+    status->flag &=3D ~RX_FLAG_NO_SIGNAL_VAL;
}

 static void ath10k_htt_rx_h_mactime(struct ath10k *ar,
The contents of this transmission are Ethertronics Inc. Confidential and ma=
y contain proprietary or legally privileged information which may not be di=
sclosed, copied or distributed without the express written consent of Ether=
tronics Inc. The information is intended to be for the use of the individua=
l or entity named on this transmission. If you are not the intended recipie=
nt, be aware that any disclosure, copying, distribution or use of the conte=
nts of this information is prohibited. If you have received this transmissi=
on in error, please notify us by telephone immediately so that we can arran=
ge for the retrieval of the original documents at no cost to you. Alternati=
vely, notify the sender by replying to this transmission and delete the mes=
sage without disclosing it. Thank you
