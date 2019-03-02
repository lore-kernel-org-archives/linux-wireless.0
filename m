Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D250C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 20:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02201206B6
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 20:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfCBUaK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 15:30:10 -0500
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:49156 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726497AbfCBUaK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 15:30:10 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 7C7D218224B84;
        Sat,  2 Mar 2019 20:30:08 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: sound41_58672b60c155a
X-Filterd-Recvd-Size: 3040
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Sat,  2 Mar 2019 20:30:07 +0000 (UTC)
Message-ID: <c422bd435e6172424ac2c27f673a64316576e819.camel@perches.com>
Subject: Re: [PATCH] mt76: usb: reduce code indentation in mt76u_alloc_tx
From:   Joe Perches <joe@perches.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Date:   Sat, 02 Mar 2019 12:30:06 -0800
In-Reply-To: <2ead6e0fc3222faa772a37d55736c03041c90a1f.1551534029.git.lorenzo@kernel.org>
References: <cover.1551534029.git.lorenzo@kernel.org>
         <2ead6e0fc3222faa772a37d55736c03041c90a1f.1551534029.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-03-02 at 14:50 +0100, Lorenzo Bianconi wrote:
> Improve code readability reducing code indentation in
> mt76u_alloc_tx

Trivial note below:

> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
[]
> @@ -787,6 +787,7 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
>  {
>  	struct mt76u_buf *buf;
>  	struct mt76_queue *q;
> +	size_t size;
>  	int i, j;
>  
>  	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
> @@ -810,15 +811,15 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
>  			if (!buf->urb)
>  				return -ENOMEM;
>  
> -			if (dev->usb.sg_en) {
> -				size_t size = MT_SG_MAX_SIZE *
> -					      sizeof(struct scatterlist);
> +			if (!dev->usb.sg_en)
> +				continue;
>  
> -				buf->urb->sg = devm_kzalloc(dev->dev, size,
> -							    GFP_KERNEL);
> -				if (!buf->urb->sg)
> -					return -ENOMEM;
> -			}
> +			size = MT_SG_MAX_SIZE * sizeof(struct scatterlist);
> +
> +			buf->urb->sg = devm_kzalloc(dev->dev, size,
> +						    GFP_KERNEL);

Perhaps eliminate size and use devm_kcalloc instead like
the allocation immediately above this.
---
 drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index ae6ada370597..fc87ae223f8d 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -806,15 +806,15 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 			if (!buf->urb)
 				return -ENOMEM;
 
-			if (dev->usb.sg_en) {
-				size_t size = MT_SG_MAX_SIZE *
-					      sizeof(struct scatterlist);
-
-				buf->urb->sg = devm_kzalloc(dev->dev, size,
-							    GFP_KERNEL);
-				if (!buf->urb->sg)
-					return -ENOMEM;
-			}
+			if (!dev->usb.sg_en)
+				continue;
+
+			buf->urb->sg = devm_kcalloc(dev->dev,
+						    MT_SG_MAX_SIZE,
+						    sizeof(*buf->urb->sg),
+						    GFP_KERNEL);
+			if (!buf->urb->sg)
+				return -ENOMEM;
 		}
 	}
 	return 0;


