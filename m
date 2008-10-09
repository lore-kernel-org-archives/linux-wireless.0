Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:49655 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211AbYJIPUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 11:20:32 -0400
Message-ID: <48EE2139.102@lwfinger.net> (sfid-20081009_172037_633241_14867235)
Date: Thu, 09 Oct 2008 08:20:25 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>,
	Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH 1/5] p54: broken out vdcf code
References: <200810050238.28100.chunkeey@web.de>
In-Reply-To: <200810050238.28100.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> Broken out the vdcf's code into another patch, as it caused problems in the last RFC.

This patch has the following insertion as a replacement:

+struct p54_tx_vdcf_queues {
+	u8 aifs;
+	u8 padding;
+	__le16 cwmin;
+	__le16 cwmax;
+	__le16 txop;
+} __attribute__ ((packed));

Previously, aifs was of type __le16. With this change, the macro
P54_SET_QUEUE must be changed as follows:

 #define P54_SET_QUEUE(queue, ai_fs, cw_min, cw_max, _txop)     \
 do {                                                           \
-       queue.aifs = cpu_to_le16(ai_fs);                        \
+       queue.aifs = ai_fs;                                     \
        queue.cwmin = cpu_to_le16(cw_min);                      \
        queue.cwmax = cpu_to_le16(cw_max);                      \
        queue.txop = cpu_to_le16(_txop);                        \

To further emphasize that the second parameter is u8, I also suggest
the following changes in the macro invocation:

-       P54_SET_QUEUE(priv->qos_params[0], 0x0002, 0x0003, 0x0007, 47);
-       P54_SET_QUEUE(priv->qos_params[1], 0x0002, 0x0007, 0x000f, 94);
-       P54_SET_QUEUE(priv->qos_params[2], 0x0003, 0x000f, 0x03ff, 0);
-       P54_SET_QUEUE(priv->qos_params[3], 0x0007, 0x000f, 0x03ff, 0);
+       P54_SET_QUEUE(priv->qos_params[0], 0x02, 0x0003, 0x0007, 47);
+       P54_SET_QUEUE(priv->qos_params[1], 0x02, 0x0007, 0x000f, 94);
+       P54_SET_QUEUE(priv->qos_params[2], 0x03, 0x000f, 0x03ff, 0);
+       P54_SET_QUEUE(priv->qos_params[3], 0x07, 0x000f, 0x03ff, 0);

Larry

