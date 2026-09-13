Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9501F3955FF;
	Sun, 13 Sep 2026 07:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789284812; cv=none; b=J5okoGDcbgp7a4pDMMJv08I0lm5zL4WxmVXPhro5e/7Nq/P3LbsSc3Mm8N08yOsXOxZjNBhsIBljzlT2OBes32BK+kt9bkTkiYZRrvgRtMaDhfjNMF+6nxdduUAsnfozMsd1L84ywyrS62XRyvZOudHPtilIHdjGasqRRS3vV5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789284812; c=relaxed/simple;
	bh=KZjnPZfSPxxQqYle0vt9ysc31pC8OUpHmTU8dUYagTc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=H8PmHSTojc4TejxDQBpCqTK1eNYMEx8OPbnFhldXLBH//5ryNGVekDZDzlI67zIJtoiqynAjCcY4MUjvqT/i9AK5ZEhm9ZHO7dBqfsdvN7OJ5Yaq6yzHlr9Rn6vcnk6i/FJjJGW+iNgOtvhf8S3wfKl+/YdaqylvWlMvzKazVVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HO4DOkBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HO4DOkBK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30EE5C2BCFB;
	Sun, 13 Sep 2026 07:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789284812;
	bh=KZjnPZfSPxxQqYle0vt9ysc31pC8OUpHmTU8dUYagTc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HO4DOkBKQcY3c09JsvIbq7z0uWGPHdGp3LFe2S8lMx3TxmQnuZRkOIszJMfMhMXL8
	 sprZRXhrl0b48qnMerYBae86B2Byg8HLGTsb9rZP7xbEKraK7uNZyAYSAcCUwgu7cu
	 sMiJdQghiFNi3GvpBsfKWnE7DPETm3hvnIYHtqCGiyRiF+Vfyty9JYyrT21q8k8cd2
	 ycVAfMhnfzFpc/tWoCjhHp0z9DIHyGORjUd0CXJJ/k3cSFH1clJrzOBzyOFXn7l+lk
	 eHJ5jd4/4hMr3j8RNaRZjipeETfhROgAhPKO/IHS8HQtu90L9dqMU9jLoeOwwwkOfr
	 41oM1Znf893uA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8C2C88E40;
	Sun, 13 Sep 2026 07:33:32 +0000 (UTC)
From: kimwooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Date: Sun, 13 Sep 2026 16:33:19 +0900
Subject: [PATCH rtw-next v2 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-codex-rtw-rx-v2-v2-1-f09c964e0b96@khu.ac.kr>
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
In-Reply-To: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, linux-kernel@vger.kernel.org, 
 kimwooseok <5mghybrid@khu.ac.kr>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789284810; l=3091;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=att+fRGHRDjKAGrEwD6lJWxhFqTMBbHhK5UA95dqBLI=;
 b=l4wXlY9AF1apx7M9CnnrUPfyJENk6cDjKw+elyDFUgY/do+ILtOb+wu1k2a9tqziQjleZ3w/u
 S3C6J9TXs6EC5+li2VEYkwPk0rlfEiltvL9gFTd2tE4ikpsv+r1sn/l
X-Developer-Key: i=5mghybrid@khu.ac.kr; a=ed25519;
 pk=1az/6lC8Tmd6BcvyarPc8FWoSxsV/WRr5NLs1v+kjlE=
X-Endpoint-Received: by B4 Relay for 5mghybrid@khu.ac.kr/kernel-20260913
 with auth_id=1028
X-Original-From: kimwooseok <5mghybrid@khu.ac.kr>
Reply-To: 5mghybrid@khu.ac.kr

From: kimwooseok <5mghybrid@khu.ac.kr>

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

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
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
@@ -6596,8 +6593,11 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
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


