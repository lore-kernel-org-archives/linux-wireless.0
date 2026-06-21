Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A88C2AD37;
	Sun, 21 Jun 2026 02:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782009918; cv=none; b=Ep4omAboJ6a0PbWgmUXJSjJjKVMYa7GGCfT3SgZnpIaNHvrc0iYsF7YWwugeKzii7TSHrdCYww3GBQXHyVl4m87lgRnLpqzh6nnWTxuJPkQ/Ofyb+DpD/tr7hCbiCUAxS0mQslj/5kRwUeoH1CBlefkXqG/lz7w+qIctOIKQn50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782009918; c=relaxed/simple;
	bh=QGnNWdt+FgO58x0+Z3wMXsNd+qo+B8EMVj0UW+DWAu8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=nsAOh9L4d9NoWSHquHL6gJxUcZlIlCP/R0i4vDUKvzaH/fqJkvrHvyJIBKaHTPWVCWpIyzmXCdg1OuhnaSPNmaX91QiaBGjaUn49qjz5u1Ic1lIC6qDeFY5aPSXMDEW/XVbOVQPYCyGn46+e6NIurcTP5y0M9tBPCES45NFngnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzZYW3S/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzZYW3S/"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38068C2BCB0;
	Sun, 21 Jun 2026 02:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782009918;
	bh=QGnNWdt+FgO58x0+Z3wMXsNd+qo+B8EMVj0UW+DWAu8=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=fzZYW3S/qnIAFjwudux7BSadqP8QmQ33y+K94naAV9mHWMNsz/EHXGP+rTmNec5mf
	 L/fa6I4OIuDEOmMx/yKgO5zqvRL+e4uDm+hbTsiuloxJT8I5RFpfRc4flyprDuFPwm
	 6vzp27qlAqdv3t/nO5n/JyACR1WrNFSA0zGynQS4jlgIqvuKziIy7XO0XW67i2GzgA
	 0nvsmRhGJ+A9m5flP6XL3C5oOk3Tftmh1snjqRS2gSkCeW8R7wdGivvnsbDCu4hm62
	 uDh+FMK/0//67n5DAGoZhS6SXfbtdlO+ArasMVo2XUWgAOqkWO/LJFFqVe79ugjFBS
	 ypOqdVifEdjAw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E419CD4F26;
	Sun, 21 Jun 2026 02:45:18 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 20 Jun 2026 21:45:18 -0500
Subject: [PATCH] wifi: mac80211_hwsim: clamp virtio RX length before
 skb_put
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260620-b4-disp-474bee37-v1-1-1a4d37f3e2d4@proton.me>
X-B4-Tracking: v=1; b=H4sIAD1QN2oC/x2MMQqAMAwAvyKZDdRYWvQr4mDbqFlUWhCh+HeDt
 91wV6FwFi4wNhUy31LkPFS6toG4L8fGKEkdyJAzjgwGi0nKhdbbwNx7DBwHhVyKBJpdmVd5/uU
 0v+8H6+K7ZGIAAAA=
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782009917; l=1634;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=HtfyUWDREuoINdT8NTkjOwRIxvQAbmpdni8YZu5OyaE=;
 b=l9uiKusTE+/qmCSun1xP8GV+9egR3wX99KQL2QurOzdFlurwTTL7BHRsCR0HgIJNaymx3dy3b
 rPxe23SiYBeAxa/cz5yjc6DjofDDvUX/FvjSBv39cJlZf4JRLl+ak5Q
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

hwsim_virtio_rx_work() passes the virtqueue used-ring length reported by
the device straight to skb_put() on a fixed-size receive skb. A backend
reporting a length larger than the skb tailroom drives skb_put() past the
buffer end and hits skb_over_panic() -- a host-triggerable guest panic
(denial of service).

Clamp the length to the skb's available room before skb_put(). A
conforming device never reports more than the posted buffer size, so valid
frames are unaffected; a truncated over-report then fails the
length/header checks in hwsim_virtio_handle_cmd() and is dropped, so
truncating rather than dropping here cannot be turned into a parsing
problem.

Fixes: 5d44fe7c9808 ("mac80211_hwsim: add frame transmission support over virtio")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 0dd8a6c85953..5c1718277599 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -7289,6 +7289,7 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 
 	skb->data = skb->head;
 	skb_reset_tail_pointer(skb);
+	len = min(len, skb_end_offset(skb));
 	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 

---
base-commit: 1a3746ccbb0a97bed3c06ccde6b880013b1dddc1
change-id: 20260620-b4-disp-474bee37-bec999926dc2

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


