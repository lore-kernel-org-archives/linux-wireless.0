Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E6A376475
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 20:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789244980; cv=pass; b=b6ejjt4SY4wcXzv6d5JHIbhkv/zrdNrKasLgt2V9TCSpVVISbIVaOlX+1bZHvyoZxYczCdb+tiq2jGj1lP+k+jO5ZS3OHQmlAuRCDpAR5ac80fOQvPTI15OliSWjJfU1EPj0AVBOe65g8mIzU4KXDFv8Io0q7bHXhIgH94vaRrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789244980; c=relaxed/simple;
	bh=3Z+rnR6y8+XrskA3hVov6v6LoLFko/3oEz6RpE1l2sc=;
	h=MIME-Version:From:In-Reply-To:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YNoBkpVusWUrtB3lP28iuNEl9dC14p4f9UjqvXr2lLzwACOItEGYTZOFl1y+WRzbxicohVPllbhR6g6BwlO9dhoJTqtiZl+P2R+ABb6Q57rQCC86EI1FaApIxpSMPMIVzeVhQ3+eG0YezAebDDDnnZ/6o51X/kNUXXQsA3erBf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=HCKv/l/h; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="HCKv/l/h"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff16dd47so5252571fa.3
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 13:29:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789244976; cv=none;
        d=google.com; s=arc-20260327;
        b=K9NI/0iBSMoxRRywezg3bZldZnw6yRG253Xhh0QzQx/ivVe3r8oNZkclgerq7WQcxp
         Sofvsy+G7Lwe/4/URAuZQ/3ePd9qGftRPoVWafeHzhhHLzTApvW2J0nmsbVBp7tzDuw9
         6G1k10YAdPH/7uCEkb5GQaZQryfQt6jd+JM8IQvbjAOzrF8BaRbfjqjdt5ggPRNXTQ2I
         YR+NnU9mFgoc5Swrmzng/C0zcnjBGBN4DBRd9DjbjZrOCTf3mNDMpfbO9f2OkTJgh5yL
         5UHIclmwlbkly8AiJAPwVsICrs+Y844x6PI8w21wZjoLkToYFH07FiqEpZ/2N7Hc3eKA
         1nEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=RLAp5n84PhWI7Xy3vjJ/UrGvAVQA5MGrxcUoi3gqi6M=;
        fh=TFULXDBgHlLqMQdfUyAurUJgwNjfZoZpfLyj5gKGrno=;
        b=pO+ira97toaaw6MREjRqGiGTxm/I09anXcUwR519durPX0PdZlZRMibsDdYB8BQOuz
         IrYduflUwi0rPJvr9fcFb1VkzzzBIjsIROamhRzFmkKtSTei/KrtcLQeUC/7yOc8uRmh
         qvEXc39br/MH5/4Gv/hqH+Rz94sK57OLinmYlKvOe75GpOiIQWAN3RAo/oyVJ5oG/c8e
         SuTpGUST+3IHeBzlumTWCgUxPDHCQzHm1MkZTXrs2N1K5pjZEON6lFx82aAH61SqRC+w
         eeNjKWT6xmyiB7WI3T/zV7JvHc5nodnc4O5jgDd7DyEGEqQg83N2cYsse0H4iFtF86ol
         nZFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789244976; x=1789849776; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RLAp5n84PhWI7Xy3vjJ/UrGvAVQA5MGrxcUoi3gqi6M=;
        b=HCKv/l/hkCjQzfrjvoD+DjKKduw/oClZ0SeZ7+jb4B5bSTkRxrwsKg+sFyHZjbduWE
         GO0GEVroFAtBmLJZemKgMUqd/5uyxZhWv3s+qR0BCNTzeFoyd9qoRx6FoWmGiaIJhCy2
         /VDY4K0M0rtmhW6ME/BZ+EC7tbetD+sFj7DPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789244976; x=1789849776;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RLAp5n84PhWI7Xy3vjJ/UrGvAVQA5MGrxcUoi3gqi6M=;
        b=cmZkjsq8Evi4+qd+0czoiICML079kL4zUzP0TNpdhPQCc91iQc0ua2OUvfxjlIhKei
         pPfZJRZva8pfk16BqqqVoRj4L3w4qVHRk4FkjYUsL/o4IpruEd0Neo8fqc7pQ1/1vC/r
         vJZGqiPnm5P3sVwxCaox1Mv30Dp0y0F2iFli9/E3jTu67w36JPi+pbIzLf6Ci8eKT/Cu
         4PEXMBvKThxqhOdVGqaPJzNi5tIAGZOU9wD6j5OhbaDf8N9Gk/62jA+6jo5EOhCKj2qK
         H3i6jLV4UV8jA5UkEHlvAyb+UxSYtNDJWOIXPB3iCQTqRMQzPvfAFp3zSoz6o69db7/X
         wnaA==
X-Gm-Message-State: AFuF++mD3TqBHD3ZTHWnsdkWRfn23V0S0EcQFkEknq6T0Jn/xd9PHtJm
	+e1q/N36V86Uf+xVP5mwsiNKS0jNt/CRQCcoWc5xCxAX7ZACsKxzIx4E9dEenipxHaBhRlh0Fhh
	gOzCHsfsLpuab97pQehw0wVIXNBivBxORG5LqBPm1qQ==
X-Gm-Gg: AYBFou2ElzzRn4lugFhd1rVdDum8fj1DlU+yAWTcO9fEV7n9yAYncS3Hua6fUXapm4X
	Pqfd0il1Z/IXJBuvl7m/uFPXi6WibJXOmdqrDgbRCE2s0LFUY/B9ALBGa9yxittXSJ95wVNKr6b
	/rCsXRe9rqQMV1iI5buOIpHodGt86Dohvq4aBduyCLRwYprLDn6J7kGBhGnhnetb3BE3TRZlbEf
	FSym4P8Qq29QFtmFtsedq3JLvS9HRrD5iUktUs91qCH9XCoT95SCvO+EYYYKl04L51EqK1aqR+y
	MMD7KbLqi9DqalRbwxHlJWt9+msQ4vBw9gZL5IBKDOI6Y37nZ1A=
X-Received: by 2002:a05:6512:31c7:b0:5b6:186e:b79d with SMTP id
 2adb3069b0e04-5b8a8efb04amr723267e87.57.1789244976231; Sat, 12 Sep 2026
 13:29:36 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 16:29:35 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 16:28:14 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 12 Sep 2026 16:20:09 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 12 Sep 2026 16:09:50 -0400
From: kimwooseok <5mghybrid@khu.ac.kr>
In-Reply-To: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
References: <CAH1Bc_wBUmmNyzF3c2H1aFBRBbAPSw0hR=1MnPOAcCXypVL_Dg@mail.gmail.com>
Date: Sat, 12 Sep 2026 16:29:35 -0400
X-Gm-Features: AcwNN1XLCOa6gaClJgemEvFiJiVPSixm8S5rZ4-E3hZh2AQgrnsujY7tPXvHltk
Message-ID: <CAH1Bc_xSxOrEUjx11NtTE9Y6WVitF8K0mVws8s3623C8O=Lpkw@mail.gmail.com>
Subject: [PATCH wireless 1/4] wifi: rtl8xxxu: free RX skb when URB submission fails
To: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A failed RX URB submission can leak the skb allocated for that attempt.
rtl8xxxu_submit_rx_urb() allocates the buffer and stores it in urb.context,
but if usb_submit_urb() fails, it only unanchors the URB. The RX worker
queues ENOMEM/EAGAIN failures for retry with that buffer still attached.

On the next attempt, rtl8xxxu_submit_rx_urb() allocates another skb and
overwrites urb.context, losing the reference to the previous buffer.
Stopping before the retry also leaks the buffer because pending-request
cleanup frees only the URB.

Fix the leak at the submission failure by making rtl8xxxu_submit_rx_urb()
responsible for both allocating the skb and releasing it when submission
fails. Free the newly allocated skb and clear urb.context before returning
the error, so neither retry nor stop receives a pending URB that still
owns a buffer. Remove the caller-side skb cleanup from start and the RX
worker; those callers now handle only whether to retry or release the URB.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: kimwooseok <5mghybrid@khu.ac.kr>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c
b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index bddbd0990de72..795a5ec2f8cd4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -5864,7 +5864,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
 	struct list_head local;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret;

@@ -5896,8 +5895,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 		default:
 			dev_warn(&priv->udev->dev,
 				 "failed to requeue urb with error %i\n", ret);
-			skb = (struct sk_buff *)rx_urb->urb.context;
-			dev_kfree_skb(skb);
 			usb_free_urb(&rx_urb->urb);
 		}
 	}
@@ -6596,8 +6593,11 @@ static int rtl8xxxu_submit_rx_urb(struct
rtl8xxxu_priv *priv,
 			  skb_size, rtl8xxxu_rx_complete, skb);
 	usb_anchor_urb(&rx_urb->urb, &priv->rx_anchor);
 	ret = usb_submit_urb(&rx_urb->urb, GFP_ATOMIC);
-	if (ret)
+	if (ret) {
 		usb_unanchor_urb(&rx_urb->urb);
+		dev_kfree_skb(skb);
+		rx_urb->urb.context = NULL;
+	}
 	return ret;
 }

@@ -7410,7 +7410,6 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;

@@ -7461,13 +7460,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		rx_urb->hw = hw;

 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		if (ret) {
-			if (ret != -ENOMEM) {
-				skb = (struct sk_buff *)rx_urb->urb.context;
-				dev_kfree_skb(skb);
-			}
+		if (ret)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
-		}
 	}

 	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
-- 
2.48.1
