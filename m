Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2B3C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 13:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D2B821904
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 13:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732816AbfBRNwv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 08:52:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731591AbfBRNwu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 08:52:50 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 643411219AB;
        Mon, 18 Feb 2019 13:52:49 +0000 (UTC)
Received: from localhost (unknown [10.40.205.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B42C86012C;
        Mon, 18 Feb 2019 13:52:48 +0000 (UTC)
Date:   Mon, 18 Feb 2019 14:52:47 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190218135247.GA9602@redhat.com>
References: <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <2009016263.528260.1550344627996@email.ionos.de>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 18 Feb 2019 13:52:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2019 at 08:17:07PM +0100, Stefan Wahren wrote:
> this is a misunderstanding. The warning is about memory alignment to 32 bit addresses, not about page alignment. This is a typical ARM restriction. Maybe we need to make sure in mt76 that the DMA buffer needs to be aligned. But it's also possible that the warning isn't the root cause of our problem.
> 

I see, it needs 4 bytes alignment . There is already dwc2 code checks
that and allocate new buffer if the alignment is not right:
dwc2_alloc_dma_aligned_buffer(), but it does nothing if urb->sg
is not NULL. I thought mt76usb already provide aligned buffers, but
looks it does not for one TX special case, which are PROBE REQUEST
frames. Other frames are aligned by inserting L2 header pad. One
solution for this would be just submit urb with  NULL sg (same as
Lorenzo's patches do, but still allocating buffers via buf->sg),
but I think, you have right, we should provide 4 bytes aligned buffers
by default as other DMA hardware may require that. I'm attaching yet
another patch to test, which fix up alignment for PROBE REQUEST frames.

> > Attached patch should fix this, plese test, thanks in advance.
> 
> Anyway i tested the following patch combinations against next with the same results as 1,2,3 (no wifi, alignment warning):
> 1,3
> 1,2,3,4

I noticed on my setup that patch 4 can cause troubles, but still
device is workable here on my PC machines.

> > > Btw i can confirm a regression was introduced after 4.19, because in 4.19 there was no firmware timeout but even no working wifi:
> > 
> > You ment 'no working wifi' or 'working wifi'?
> 
> Wifi is broken in 4.19, 4.20, 5.0 and next. It only worked with Lorenzo's SG avoid patches so far. Btw the regression (firmware timeout) started in 4.20. I also tested it today.

That somewhat strange because 4.19 mt76x0u does not use SG.
On 4.19 there is phy calibration bug fixed in 4.19.5:

commit 0d9813319b40399a0d8fd761d2fcfedee5701487
Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri Sep 7 23:13:12 2018 +0200

    mt76x0: run vco calibration for each channel configuration

It's possible that without this vco calibration fix, MT7610U device
does not see AP if it's signal is weak.

Stanislaw


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0005-mt76x02-make-sure-probe-request-skb-s-are-4-bytes-al.patch"

From d420961afd1ae2ca8590ee2c79defc0a48fa8e73 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Mon, 18 Feb 2019 14:39:38 +0100
Subject: [PATCH] mt76x02: make sure probe request skb's are 4 bytes aligned

We add 2 bytes header pad if header length is not multiple of 4 bytes,
this assure most tx skb buffers are 4 bytes aligned. But this is not
true for probe request frames which have n*4 bytes header length and
are not aligned.

I think is ok to assume that frames have to be 4 bytes aligned
for DMA purpose, so mt76 driver should take care of that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |  5 +---
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 32 +++++++++++++++-------
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 6d96766a6ed3..ad329db7de4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -155,7 +155,7 @@ void mt76x02_set_tx_ackto(struct mt76x02_dev *dev);
 void mt76x02_set_coverage_class(struct ieee80211_hw *hw,
 				s16 coverage_class);
 int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val);
-int mt76x02_insert_hdr_pad(struct sk_buff *skb);
+void mt76x02_align_skb(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update);
 void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index a5413a309a0a..63c5520a65ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -163,7 +163,6 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct mt76x02_txwi *txwi = txwi_ptr;
 	int qsel = MT_QSEL_EDCA;
 	int pid;
-	int ret;
 
 	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
 		mt76x02_mac_wcid_set_drop(dev, wcid->idx, false);
@@ -173,9 +172,7 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
 
-	ret = mt76x02_insert_hdr_pad(skb);
-	if (ret < 0)
-		return ret;
+	mt76x02_align_skb(skb);
 
 	if (pid >= MT_PACKET_ID_FIRST)
 		qsel = MT_QSEL_MGMT;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 098d05e109e7..bd5838c26f43 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -79,7 +79,7 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	u32 flags;
 	int pid;
 
-	mt76x02_insert_hdr_pad(skb);
+	mt76x02_align_skb(skb);
 
 	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
 	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 062614ad0d51..08425b1d2c30 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -550,21 +550,33 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
 
-int mt76x02_insert_hdr_pad(struct sk_buff *skb)
+void mt76x02_align_skb(struct sk_buff *skb)
 {
-	int len = ieee80211_get_hdrlen_from_skb(skb);
+	int align = ((unsigned long) skb->data) & 3;
+	int hdrlen, skblen;
 
-	if (len % 4 == 0)
-		return 0;
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	WARN_ON_ONCE(align == 0 && (hdrlen & 3));
+
+	if (align == 0)
+		return;
 
-	skb_push(skb, 2);
-	memmove(skb->data, skb->data + 2, len);
+	if (hdrlen & 3) {
+		/* Align frame and add 2 bytes pad after header. */
+		skb_push(skb, 2);
+		memmove(skb->data, skb->data + 2, hdrlen);
 
-	skb->data[len] = 0;
-	skb->data[len + 1] = 0;
-	return 2;
+		skb->data[hdrlen] = 0;
+		skb->data[hdrlen + 1] = 0;
+	} else {
+		/* Only for probe request frames. */
+		skblen = skb->len;
+		skb_push(skb, 2);
+		memmove(skb->data, skb->data + 2, skblen);
+		skb_trim(skb, skblen);
+	}
 }
-EXPORT_SYMBOL_GPL(mt76x02_insert_hdr_pad);
+EXPORT_SYMBOL_GPL(mt76x02_align_skb);
 
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len)
 {
-- 
2.7.5


--zYM0uCDKw75PZbzx--
