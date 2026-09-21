Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A13044F551;
	Mon, 21 Sep 2026 07:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977592; cv=none; b=cOnUsoWufLthYEGLFHkB4zh5uJw6ofjQ8SFMJfV4LCrK2VVVdkT8lDv4z1ezP6OpzcMTHY2LVtkq/e+j3Jb0E10CJ1sOzcITlE5QhWGi7Auy4rd4awkqJP+iDT9GGVnOfkWJiPNtVlE4U5i40Ka7Dx/eqfRkn5X9IpVpZRmrLs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977592; c=relaxed/simple;
	bh=O4jHspC2Q+PMYWXP+lpP2UpLmRNt60AedDGYqXHhhl4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GLV/96Vls6eveL8peJDHlx1/9ggjN6aCzuSgKVA03jLUlI5gE8bG+8D5uNrZ+pAMrulaIwpL3ACcaLO/WIDCU2tDp4X0vVVk6K2v8KpAZs5AZG5ASraTw0wJ+J/K2crEUsKcR/YJN9Fl9btBYBdgQ9jLqzUihVFIfAwBCSkwwF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBgnuMQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBgnuMQs"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF210C2BCB3;
	Mon, 21 Sep 2026 07:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789977592;
	bh=O4jHspC2Q+PMYWXP+lpP2UpLmRNt60AedDGYqXHhhl4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LBgnuMQsAzLLB/Fa5zvJODl+9O631ItyZ1sxQx+vhSRT5clmjiq3tyh6keinfqZOA
	 8gHg71YOR/q59TUVOLEUuFG95U5LaZYqqFF8uJYorESH+A8dJhfRcxc+R1OUaNm0uZ
	 srf0emKgpGJAx0ejyzyOBNcNgeZK0vOMQJNTZZ4YxoCkU82iz3eNANDjmyMWJybEDF
	 D9Xmxl67YVQWPHaT7JH2jhA3HioIzlbj8JBMtNfl5O7Iko90VjNVZaoefBxlMVgQVh
	 8xNoVG4PwCN52DcdKO4vslos/7u8zyH0IaokkpX7teBR7Oh8DWrqvD0MuyfWHo+cKO
	 vigGEdlC5qn3A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9DDC982ED;
	Mon, 21 Sep 2026 07:59:51 +0000 (UTC)
From: Kim Wooseok via B4 Relay <devnull+5mghybrid.khu.ac.kr@kernel.org>
Date: Mon, 21 Sep 2026 16:59:49 +0900
Subject: [PATCH rtw-next v4 1/3] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-codex-rtl-rx-v3-submit-v4-1-eeb09fe8f791@khu.ac.kr>
References: <20260921-codex-rtl-rx-v3-submit-v4-0-eeb09fe8f791@khu.ac.kr>
In-Reply-To: <20260921-codex-rtl-rx-v3-submit-v4-0-eeb09fe8f791@khu.ac.kr>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>, 
 Jes Sorensen <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
 linux-kernel@vger.kernel.org, Kim Wooseok <5mghybrid@khu.ac.kr>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789977589; l=2896;
 i=5mghybrid@khu.ac.kr; s=kernel-20260913; h=from:subject:message-id;
 bh=v2NnvT75DMsgHtN+8TES4Q5i+B5ih9gWoiLYF9i+R38=;
 b=8VMd7dtyT9w2+wCwgxaWS7lmbTf3Jcojdxl9HFw1fB9/z0tlJHw+a1Gp9GFWtfFNhEeMK/24t
 jHa6yTvjSOlCFmP+edgBVICKA41LCt173JmUnYh0I14cmb17awTb/Li
X-Developer-Key: i=5mghybrid@khu.ac.kr; a=ed25519;
 pk=1az/6lC8Tmd6BcvyarPc8FWoSxsV/WRr5NLs1v+kjlE=
X-Endpoint-Received: by B4 Relay for 5mghybrid@khu.ac.kr/kernel-20260913
 with auth_id=1028
X-Original-From: Kim Wooseok <5mghybrid@khu.ac.kr>
Reply-To: 5mghybrid@khu.ac.kr

From: Kim Wooseok <5mghybrid@khu.ac.kr>

When usb_submit_urb() fails, rtl8xxxu_submit_rx_urb() unanchors the URB
but leaves the newly allocated skb in urb.context. For ENOMEM/EAGAIN,
the RX worker puts the request back on the pending list. The next
submission allocates another skb and overwrites that pointer, leaking
the previous buffer. Stopping before the retry also leaks it, because
pending-list cleanup frees only the URB.

Free the skb and clear urb.context in rtl8xxxu_submit_rx_urb() when
submission fails. This keeps buffer allocation and failure cleanup in
the same function, so a request returned for retry or teardown no longer
owns an skb. Remove the corresponding cleanup from start and the RX
worker; they only need to decide whether to retry or free the URB.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Assisted-by: GPT-6 Astra
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
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
2.53.0


