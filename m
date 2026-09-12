Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F69E377ABE
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 20:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789244994; cv=pass; b=TZ/6nKsyBAMSqABPWnUgpHCkJYslREAOdgDISp7Y9j74xqA83OVXtfei77qhapnj1Qlh74YIsKpNgTF6IsJcmGOlpTcDv95vNmztPOgqy28kc7XokEPSH0G3w8QnBoOKx9Ju+A3fkRb3Up1Rv4mu4joFMaF5pU+2so5WqjwbVhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789244994; c=relaxed/simple;
	bh=/ikQ1kfuLVYm8B4nlxAmsk7qhp2ROAhGxUVQKgrQezg=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H+QxwdawpZ0c+F9lQSWn+vAefSO6AfwQIdjdS5UXDYt3yY4k7jYZ307L7DidfL7Uo3T88ij9d2bot/CHxhRaQW66oyyEP4h5Zk1VelYHSuihdBmxpfryl2bI5In7OCAmvbZjLBQJ3+gnCETcoDxPt/O5Knbu1MkPPYMU6Uds/Q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=KGgTrb2x; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="KGgTrb2x"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b4a9994c20so2418508e87.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 13:29:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789244990; cv=none;
        d=google.com; s=arc-20260327;
        b=PCw1YXKEBN3mnuceE9KG+cxEycVXU/C31UoxQsXzrl51nHacZYmP61HLIJtYqCY5nV
         h25H57S0X+NKLtGzjwyOthNl4T2IFRd/yKaH6z4TZMaxAs92zezoydj44h7LvtzVdLkv
         asq5/E+0AzrBu5ZOVS2ljfVHw1m026saR1MtaPkgHlokEnjGhf/98kYdP+9QjmGl7xVC
         GKI1o8WLDamMtqboXAG7fSmI/7yWQ4jdSViZ+d6qbRSyG9ZqDyvDixlluc6/z3E4QpuV
         pl4xCAqfv5uaJFtYmVmqCXKdZmdQZmZUDFa3FNm2+NflRZgHpEtumqi9aKfcHSIDR+E5
         BTPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=mpGBWL5dTfQk5mc1h0ZVvwGMGlDDwNb+lFBx2tyur78=;
        fh=TFULXDBgHlLqMQdfUyAurUJgwNjfZoZpfLyj5gKGrno=;
        b=T03X9SDsibH1O0E97stc7MtZtlR3Bfk7CAL8sWA63iwQingJ0koPIkt97gBvlI2EUe
         WHJjZyq4A3xgtE8RSylKp9iI+iunsljG+Cg++J/lIU4cDWnFY9ZFqU4TiDnCU1EWQstL
         MhyDczpcIY5o/u1tCFcH4zUfK1WGJ8CWSST5S/1sScnq6ErxUsp9RcK8e+5Hx19DiZDt
         8SaBBj9+ps0MQPCnNgzfR7GmzqTk++YOUg4rltxhnqhjcalqAR1CvK+5eFIuzsWnEP+r
         qoDJxxvgKDJG79xAOYYJS4b5hy87XlbOFfWxdkECpNS045Pa6WRkQJoM0t3sX5LU0/0N
         ILVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789244990; x=1789849790; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mpGBWL5dTfQk5mc1h0ZVvwGMGlDDwNb+lFBx2tyur78=;
        b=KGgTrb2x/73gOqhKweRBk73/sNMjaMiBA9capmyv14/lEvXdE1Ec5CcLTuY26ukVdm
         xrwsu/rnfekNPmd0XPr0ZJ3lkhmZwO7A6JNJag2AiHYZs3ZnsnZyqjcvzKdWfmgzAQ87
         1ax5XkKLhCGDCs8QvA5Kb8UKQgVj/hKZdHEFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789244990; x=1789849790;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mpGBWL5dTfQk5mc1h0ZVvwGMGlDDwNb+lFBx2tyur78=;
        b=sc8qf/orQIpCwBJuVCP7ipM7QuxsO8KCEFgrYyjhoXRK/9AtmrZOMVB5VjSc/RldL7
         DCQDMbG/7nUZod0FklYrhkf1qTgqAjK9pdWME0P7le7CMLlPgOv4tYP9RQDiK/ifXTKc
         lAervSWAiGyoJbIKsvJB6v8EVaIhwJ0EEkaPfJHvMD/Uer7aPd2yNSINSqRTJZ359OVK
         jxfKGwTrpit89EUYrJhYCuUDtS1IUx0jyPnPMHzi4Lt9HBR3MQjuKp2dJN8OHIF6ciBC
         2Izasemh2lyUzdCK1G4CMS4vdnMb5mL1Abdt30g8wRV0U9P8yxiwTwjOQ8M12b5rl7ws
         RYLg==
X-Gm-Message-State: AFuF++nEvxCHnKubypdB5k1F0Jo88VFiEy/9+z7/6jQ1uXXETXqxbjKT
	TQ3Pmm9f56Dwim9vLNFvAwvqIOafOTEO3jSEitaCOk0yaf41vKcoSO4w+tOm0d7SkQRShregMkJ
	Ni6R1Z/dhUNgN/WUoDDrxtIqEJqpI4AIT4TGKnHGELg==
X-Gm-Gg: AYBFou0EbV97M+Wx5Ntsp/cqyM+Ewj0IEjBEcS1W0ACQBrpX+X0HTQVr4WmnJWQcKXx
	Y0YIFwH/juo73Eaac+Q2S+grTPzKHIFhzK3x4acfRpzRdhI+VtYOSGrQ0RT3hR8ZYrkHjdgeFoK
	NGxNj4YViRfhYreSjoEd2+RNRwz7i/lmCg+F5qKZIkX2W3MATJ9iT9XZKSUVqHO9ZcZnCAamwfu
	Z3BtK1zbzdld6BV5Cno2oKdQvLhvuLyXwZ89XyKbNAteKblmuaSZbR+5daYJUQGPJVEEbtpqXDL
	Jssg10bqk1VtzKJX/yGudtDAp0bvfozQ2Tux2c4gvPAWmBPCttA=
X-Received: by 2002:a05:6512:224e:b0:5b6:183d:2a72 with SMTP id
 2adb3069b0e04-5b8a029db1emr2087880e87.18.1789244990207; Sat, 12 Sep 2026
 13:29:50 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 16:29:49 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 15:28:18 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 16:20:12 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 12 Sep 2026 16:09:51 -0400
From: kimwooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
References: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
Date: Sat, 12 Sep 2026 16:29:49 -0400
X-Gm-Features: AcwNN1Ww8RECxvFUbnTVydmcsxe2gffbw6SmVBK6pP8Gb3uL_2aWnXSQENYPC-k
Message-ID: <CAH1Bc_wnBERR3YpFMon5+dcci846d9k42wb3bC7=LuN9ZV-FgQ@mail.gmail.com>
Subject: [PATCH wireless 2/4] wifi: rtl8xxxu: unwind incomplete receive startup
To: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

rtl8xxxu_start() allocates and submits RX URBs one at a time. If a later
allocation fails, earlier requests may already be active. After a
successful submission, that allocation failure can also leave ret set
to zero. The error path then frees TX resources and disables RX filters
without draining the earlier RX requests, yet reports startup success.

Separate pool allocation from submission so an allocation failure can be
handled before any RX request is active. Introduce rtl8xxxu_alloc_rx_urbs()
to allocate all 32 wrappers, then rtl8xxxu_start_rx() to submit the
completed pool. Return ENOMEM for every RX or TX URB pool allocation
failure so a partial allocation is reported as an error.

Once submission begins, keep ENOMEM/EAGAIN failures queued for retry.
For other submission errors, rtl8xxxu_start_rx() frees the unsubmitted
requests and returns the error. Since earlier submissions may already be
active at that point, route the outer start failure through the existing
rtl8xxxu_stop() path. This drains queued work and active requests and
cleans up RF state and TX resources together. Interrupt URB submission
failure uses the same cleanup path.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: kimwooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 99 ++++++++++++++------
 1 file changed, 71 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c
b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 795a5ec2f8cd4..1932a9ec1970c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -58,6 +58,7 @@ MODULE_PARM_DESC(dma_agg_pages, "Set DMA aggregation
pages (range 1-127, 0 to di
 #define RTL8XXXU_TX_URB_LOW_WATER	25
 #define RTL8XXXU_TX_URB_HIGH_WATER	32

+static void rtl8xxxu_stop(struct ieee80211_hw *hw, bool suspend);
 static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 				  struct rtl8xxxu_rx_urb *rx_urb);

@@ -5832,6 +5833,27 @@ static void rtl8xxxu_free_rx_resources(struct
rtl8xxxu_priv *priv)
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 }

+static int rtl8xxxu_alloc_rx_urbs(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_rx_urb *rx_urb;
+	int i;
+
+	/* No RX work is active until the complete pool has been allocated. */
+	for (i = 0; i < RTL8XXXU_RX_URBS; i++) {
+		rx_urb = kmalloc_obj(struct rtl8xxxu_rx_urb);
+		if (!rx_urb)
+			return -ENOMEM;
+
+		usb_init_urb(&rx_urb->urb);
+		INIT_LIST_HEAD(&rx_urb->list);
+		rx_urb->hw = priv->hw;
+		list_add_tail(&rx_urb->list, &priv->rx_urb_pending_list);
+		priv->rx_urb_pending_count++;
+	}
+
+	return 0;
+}
+
 static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 				  struct rtl8xxxu_rx_urb *rx_urb)
 {
@@ -5900,6 +5922,44 @@ static void rtl8xxxu_rx_urb_work(struct
work_struct *work)
 	}
 }

+static int rtl8xxxu_start_rx(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
+	unsigned long flags;
+	LIST_HEAD(local);
+	int ret;
+
+	spin_lock_irqsave(&priv->rx_urb_lock, flags);
+	list_splice_init(&priv->rx_urb_pending_list, &local);
+	priv->rx_urb_pending_count = 0;
+	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
+
+	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
+		list_del_init(&rx_urb->list);
+		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
+		switch (ret) {
+		case 0:
+			break;
+		case -ENOMEM:
+		case -EAGAIN:
+			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+			break;
+		default:
+			usb_free_urb(&rx_urb->urb);
+			goto free_remaining;
+		}
+	}
+
+	return 0;
+
+free_remaining:
+	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
+		list_del(&rx_urb->list);
+		usb_free_urb(&rx_urb->urb);
+	}
+	return ret;
+}
+
 /*
  * The RTL8723BU/RTL8192EU vendor driver use coexistence table type
  * 0-7 to represent writing different combinations of register values
@@ -7408,7 +7468,6 @@ static void rtl8xxxu_watchdog_callback(struct
work_struct *work)
 static int rtl8xxxu_start(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
-	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
 	unsigned long flags;
 	int ret, i;
@@ -7423,14 +7482,13 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	if (priv->usb_interrupts) {
 		ret = rtl8xxxu_submit_int_urb(hw);
 		if (ret)
-			goto exit;
+			goto error_out;
 	}

 	for (i = 0; i < RTL8XXXU_TX_URBS; i++) {
 		tx_urb = kmalloc_obj(struct rtl8xxxu_tx_urb);
 		if (!tx_urb) {
-			if (!i)
-				ret = -ENOMEM;
+			ret = -ENOMEM;

 			goto error_out;
 		}
@@ -7441,31 +7499,21 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		priv->tx_urb_free_count++;
 	}

+	ret = rtl8xxxu_alloc_rx_urbs(priv);
+	if (ret)
+		goto error_out;
+
 	priv->tx_stopped = false;

 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
 	priv->shutdown = false;
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);

-	for (i = 0; i < RTL8XXXU_RX_URBS; i++) {
-		rx_urb = kmalloc_obj(struct rtl8xxxu_rx_urb);
-		if (!rx_urb) {
-			if (!i)
-				ret = -ENOMEM;
-
-			goto error_out;
-		}
-		usb_init_urb(&rx_urb->urb);
-		INIT_LIST_HEAD(&rx_urb->list);
-		rx_urb->hw = hw;
-
-		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		if (ret)
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
-	}
+	ret = rtl8xxxu_start_rx(priv);
+	if (ret)
+		goto error_out;

 	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
-exit:
 	/*
 	 * Accept all data and mgmt frames
 	 */
@@ -7478,13 +7526,7 @@ exit:
 	return ret;

 error_out:
-	rtl8xxxu_free_tx_resources(priv);
-	/*
-	 * Disable all data and mgmt frames
-	 */
-	rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x0000);
-	rtl8xxxu_write16(priv, REG_RXFLTMAP0, 0x0000);
-
+	rtl8xxxu_stop(hw, false);
 	return ret;
 }

@@ -7820,6 +7862,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	spin_lock_init(&priv->tx_urb_lock);
 	INIT_LIST_HEAD(&priv->rx_urb_pending_list);
 	spin_lock_init(&priv->rx_urb_lock);
+	priv->shutdown = true;
 	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
 	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
 	INIT_DELAYED_WORK(&priv->update_beacon_work,
rtl8xxxu_update_beacon_work_callback);
-- 
2.48.1
