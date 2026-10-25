Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792931553;
	b=TauNwiiYSXcGvRK5Grw9+uL8wM4Z8HBoYL3WqJx6p0LetufRVxDI2LlLaFUUxqRiZOTM
	 8Rws+AZ+rN/viX+0uIZYmisUlgwGxbMQOSv/z6QjOLfJGS0UYS4hfYV4urQWDkiPM4KgO
	 qIFb82RmtV1QfJuGPHmwOLBZbrVD/JUuk2fnR2Va9hyjVTzV2EAVs3ZLPjUok7GCbCdXh
	 x6MeH6LavTedjiOzYFjfky6vqQTcaR2qC5kBZiNhvrUGDTmbJxhmKnyfoDg55dsBTGwBD
	 Wxe/+N2lxC1hC1cmnWzu5bFrrkbDEsZJBUTlD3tyIIuGZ+vG1aUO2UkLZBBo+fhWWRA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792931553;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=YZh6wF+ahaeexDUlwTwMTQHdHZzbG4bKgZfT4iMBDLw=;
	b=ZrddkI4mtEqEnd72o9oelCABt0YbhwzT+F6tl84bd/qlBOqD3SKUxLl+PJk47zOpxAqU
	 w/+ON/+ahis6hZxXG/RVfeNpL3lt1nBmIsJCLlgt5APyoietnFR6lYFXUrQD6sE8PvzTE
	 xj7D+jMxRIk8ppwIYShHh7doszFATTBODMwQg4NchZFSZ2l0zRSHClgufh6z0hQkcqR5a
	 oIqJIeCfXfzIqTKwFZzlG0bNbE/8poHIZuh77XlzImzfFSOYjN1fri3ubLb0SXWX7JyrH
	 DcKsX/Fd3aVUfFaFEVNQBoh6f+ZTv8jULNLmehV7rmitAVRieROwMSpkbdIzpvl8qfA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nvcc9dKg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A492606A320
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 12:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nvcc9dKg
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792931552;
	b=cYhf9oZPV+8dWi9bUvxTqHLTVOFWyd08F7G7mogR1XLto/q8hCspd/6q7+yxCyLIdzDi
	 fSt+gbqFSzH2lkURVYd9sBz7XhJO3Uil1ceqi3oJy1WkQFlsTaalGXURmAoUZCo2nuPsl
	 /gMsC43LGXUazdSYjIk7O+byedPy3U3FR/fHj67TYwA09jyDf664CE9N2/i4MlNi9yfz8
	 eI+ESIkITkBJeXnvnsPZQrCVXz5yRmBBsuWb80AnlCMcxMH3Kxqde/IGwDBRbQD79MvIe
	 l5vKTTiN/970/gDNQ157quPJcgBEvDuPvXRejDTS7j6JgrQGdMfUzij5wHxZTy/u6/Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792931552;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=YZh6wF+ahaeexDUlwTwMTQHdHZzbG4bKgZfT4iMBDLw=;
	b=tGdrhoGx5CU1MsOSWTzLdEgTpyKrs8kU52jbUGMqNuyRHqLe+uaQ79borExHQ9LbPJbI
	 7Y1fA9E5qiZZe8dvo+bmip1a6FSrvU8CKAcZZOabtGtFT0+Hdpora9eciKFY9Y0OVoyl/
	 CVETtMuWPD1veccWV/8h/iQFnlX82LZ9Kyk4jBeDAzTZZkolEHSvGA4E8Qqxbt6yXYZqY
	 gfsKzEeW+/ttOCfE3ZST2FxOtjJ1ZgxKcAAxDl9Nyz2ajkQEUBS3BXmi6ircRVFrlRRCM
	 LnBbBqhArQqSnn//CumcI10qgJC2C76o8IgKkBWEg9TvxlsaZR5d3xSvyU5YYRIPbAA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B38B71F01825;
	Sun, 25 Oct 2026 12:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792931552;
	bh=YZh6wF+ahaeexDUlwTwMTQHdHZzbG4bKgZfT4iMBDLw=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Nvcc9dKgLXiqPcAn1L/LjXAhGfVHW8qMqvrCecznnRhKrrus0UO9O29uJV48WvIZu
	 WIfN4g4vlNVtvbw66l3YCLCQYwFQGf7Zk/+TI/sZq/NF4o3Zs4CCfdkwhqPfvxxVk/
	 oBddgWtBLvUbS6mqMPO8b6Uiep5ZQTKULelBQVHqc4YOopmEyHiZFDWVL5od/aKY2u
	 imZIYhxbai3XkyewSXhV9ubXmFMGkhFfHg7+NlI/6D/oFjctIFMxqhcyY18Dqa+V9o
	 Uz+m44720cv0nohCy7t6Y6WAubp/lCSzV7KSX/L1sp0/BOZwVB1KsG95ZqnK52JRSI
	 YtjpRavugKWzw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 13B0244A02;
	Sun, 25 Oct 2026 12:32:31 +0000 (UTC)
From: Francesco Palmarini via B4 Relay <devnull+palmarini.unive.it@kernel.org>
Subject: [PATCH 0/2] wifi: mt76: mt7615: fix mt7622 wmac init
Date: Sun, 25 Oct 2026 12:32:30 +0000
Message-Id: <20261025-mt7622-patch-sem-v1-0-e16e31c1face@unive.it>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN723WoC/yXMQQqDMBBA0avIrB3Q0UTwKsVFjJM6Ba1kYimId
 ze2y7f4/wDlKKzQFwdE/ojKe82oywL87NYno0zZQBXZuiKDS+osEW4u+RmVF2ym1pjgg21NgJx
 tkYN8f8vH8Lfu44t9uj9wnhe9z7ZtdAAAAA==
X-Change-ID: 20261025-mt7622-patch-sem-3d455fcf645f
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, linux-wireless@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, 
 Francesco Palmarini <palmarini@unive.it>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792931550; l=1313;
 i=palmarini@unive.it; s=20261025; h=from:subject:message-id;
 bh=TAUeTqoHydFZudstTa347nDclKp24/ne5JhcQ0rYjV4=;
 b=1MCrRsC72ux1oKScKeczk0gvTY//W9FiRMbaJ2xoYyTZ5HEHHkGZ2cClP9U2L4sS4yuGtJd12
 3YdpZXsTYg8Dh/6sGMDhNs2ana+dmoSHpzrSHf4sJSClnGVUYTywOI7
X-Developer-Key: i=palmarini@unive.it; a=ed25519;
 pk=3OQ6zyqkl8a98pNobVtrSRWmLpTk0XEeKGtpd+/yK70=
X-Endpoint-Received: by B4 Relay for palmarini@unive.it/20261025 with
 auth_id=1317
X-Original-From: Francesco Palmarini <palmarini@unive.it>
Reply-To: palmarini@unive.it

On MT7622 the 2.4 GHz wmac fails to come up on most boots with
"Failed to get patch semaphore". The rom does grant the semaphore, but
its reply to the first PATCH_SEM_CONTROL lands on the data ring with an
extra dword in front and gets dropped as tx status, so every retry
finds the semaphore already taken.

Patch 1 handles the shifted event, patch 2 releases the semaphore after
a timeout so a lost reply can't block the init anymore.

Tested on a Xiaomi AX3200 (same hw as Redmi AX6S) running OpenWrt
25.12.6: 0 of 5 boots ok before, 15 of 15 with both patches. Build
tested on wireless-next.

OpenWrt reports of the same failure:
https://github.com/openwrt/openwrt/issues/14874
https://github.com/openwrt/openwrt/issues/17565

Signed-off-by: Francesco Palmarini <palmarini@unive.it>
---
Francesco Palmarini (2):
      wifi: mt76: mt7615: fix lost first mcu event on mt7622
      wifi: mt76: mt7615: release patch semaphore on timeout

 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 23 +++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c |  4 ++++
 2 files changed, 27 insertions(+)
---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261025-mt7622-patch-sem-3d455fcf645f

Best regards,
--  
Francesco Palmarini <palmarini@unive.it>


