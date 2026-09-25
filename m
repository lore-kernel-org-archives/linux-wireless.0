Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22833F4105;
	Fri, 25 Sep 2026 13:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790341676; cv=none; b=O3D+wpiD3iMbPu1k+3VfAPQo4xwoYPNDrIczQSrcnR7x1MwxW5sDWqb5gTXHux7Ux45xk9Oda3BoESiBFeYhgNi5CleLFMFYPPWvcj880tumDPGmT8tIK3/8M18lD+Gki0iEh+BFTPXERA+jr6Ky52encMFsCrgzKiM6JpHEqPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790341676; c=relaxed/simple;
	bh=y8dVLIDW0FBjOm8Ac/nAlZ+eUAH00DbqGnFIzr7xA7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PRdQRkx3VoJCFJP7Ow71VFrowaL9u4VhcoLrqheDAegRr+mqr0jbDusg4Iv0sh81rGJ2AMOoNqtOMLNm7krrgaGov78Ck3f+CRK5CrdL8gnJja+7gQGu3nh4+Wjiv5uli6MyYT0ezqqHKrfdxIDxJsi7tH4k6v/UwJznNhj+luI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IO8Gg6ut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IO8Gg6ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D231F000FF;
	Fri, 25 Sep 2026 13:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790341674;
	bh=y6HeMqcgnpiyhqJXKT+dnKLk1cRC+3OCnQckuwNGxjs=;
	h=From:To:Cc:Subject:Date;
	b=IO8Gg6utasdzPe12meDEN/aTWLHsNO2hsV5UYcZwj4kvCNqZvQvNDNiuvb7yBizdv
	 MGuLNs/DLgVdZHJ11NffT5OUIyKuZbhEob1qdkrwtBf7U5I9KfaCAWG4dWwHmrG2a/
	 7UEfbDYK5QVXF1tGqgq4cBmKF2lEFrx4f9ky8fty+o1GyJWACwpCLffD3lVp6hIPa1
	 S8anPhWE17L1Oe8IWiYReNxBHZFMskxPQIcMuASJgmShtCRaK6S6ci8YYom92LnSKu
	 FabXkqjHxjgxpe/9BP4qDlPQAKr5jz/Fo2tZofZNSkV3JhN+1SW8u5Ioq8KHBwfNYa
	 /+EQgHNsxf33A==
From: Arnd Bergmann <arnd@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] b43legacy: work around stack frame size warning
Date: Fri, 25 Sep 2026 15:07:36 +0200
Message-ID: <20260925130749.4191347-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

I came across a rare warning in the b43legacy driver while building
randconfig kernels using clang-21.1.8, with KASAN enabled:

drivers/net/wireless/broadcom/b43legacy/main.c:3250:12: error: stack frame size (1392) exceeds limit (1280) in 'b43legacy_wireless_core_init' [-Werror,-Wframe-larger-than]
 3250 | static int b43legacy_wireless_core_init(struct b43legacy_wldev *dev)
      |            ^

There are no actual large variables on the stack here, just excessive
spills, and the code looks fine otherwise, so this is really an
optimization quirk in the compiler. Marking the prepare_phy_data_for_init()
function as noinline completely avoids the issue, with no function in
this file using more than 200 bytes of stack space, same as without KASAN.

Link: https://pastebin.com/raw/KpV124Ep # .config
Link: https://pastebin.com/CxWfsBN0 # assembler output, truncated
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/b43legacy/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 6b3e0b2bbca7..dfff3710dea3 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -3207,7 +3207,8 @@ static void b43legacy_wireless_core_exit(struct b43legacy_wldev *dev)
 	ssb_bus_may_powerdown(dev->dev->bus);
 }
 
-static void prepare_phy_data_for_init(struct b43legacy_wldev *dev)
+static noinline_for_stack void
+prepare_phy_data_for_init(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_phy *phy = &dev->phy;
 	int i;
-- 
2.53.0

