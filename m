Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805B2439F6F;
	Thu,  6 Aug 2026 10:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010817; cv=none; b=Hxg+B3jgMUYA03VfN3DiBy7qiffOuMgJ5D2KJrZXJNnCyb2aAxWu6YKnCOlGFWHW+2w+m3M312KE0IDyPXAC4sxQUYCF3tx5u/hXwam2Dp9aOsAA2uAGQDRq5GzTOO02O7hDcB/G13enYIWqsZPt1l+jyprUhbauhCUw3JGE3fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010817; c=relaxed/simple;
	bh=6dgZVSJZE+wcGYtUqJSTmXHZwMEHecB8Xfh0U5SuM4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fz4bx9wXPr9zEtZXotyYvcOjz2Z2Fk3BEgMPehf860TRbEbwh3dWpoGPskFnWRJrSfkN4R3G8oJBM8+etopheJ9i8ECiD+2DGHxt3521nbRoIX138lxykmUKB3wOhdBH2toTu9RCk5zUGT/7h8x3Gc+RDTYc+CONjs9e6EYoIFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509C91F000E9;
	Thu,  6 Aug 2026 10:06:46 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] wifi: nxp: NXPWIFI should be invisible and selected by its users
Date: Thu,  6 Aug 2026 12:06:43 +0200
Message-ID: <aefb37d8398175cb2fb520cb5f725a85bcd3049d.1786010763.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All supported NXP WiFi wireless adapters have an SDIO interface.
Hence there is no point in asking the user about these adapters when
configuring a kernel without MMC support.

Fix this by making the core driver symbol invisible, and selecting it by
its user when needed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Alternatively, NXPWIFI could depend on MMC, at the expense of asking the
user one more question.
---
 drivers/net/wireless/nxp/nxpwifi/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/Kconfig b/drivers/net/wireless/nxp/nxpwifi/Kconfig
index 3637068574b8a286..38a8820084dd84b7 100644
--- a/drivers/net/wireless/nxp/nxpwifi/Kconfig
+++ b/drivers/net/wireless/nxp/nxpwifi/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NXPWIFI
-	tristate "NXP WiFi Driver"
+	tristate "NXP WiFi Driver" if COMPILE_TEST
 	depends on CFG80211
 	help
 	  This adds support for wireless adapters based on NXP
@@ -11,7 +11,8 @@ config NXPWIFI
 
 config NXPWIFI_SDIO
 	tristate "NXP WiFi Driver for IW61x"
-	depends on NXPWIFI && MMC
+	depends on CFG80211 && MMC
+	select NXPWIFI
 	select FW_LOADER
 	select WANT_DEV_COREDUMP
 	help
-- 
2.43.0

