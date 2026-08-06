Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A35D3F4139;
	Thu,  6 Aug 2026 10:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010749; cv=none; b=cLzDyPEGapFUuPBYpmr9KhdM5HiTIP3Y7bOEkG08edA5J4JS/GFgTyi4wOdremVUoeUNWfy1Ksoo5Bm8X53/1cZJeueipQoHSqw8qW4e1GmT6eJ3ZuBLLkVn79bHJgbAw58SGjOvisO7h8ivgCmIN4a8ObaDRoKZo7G001tRlgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010749; c=relaxed/simple;
	bh=rqeaXTcqzi9PI56eH9TcdzmtpduJXQ9ej3GCu3rgv4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kg+zLx3Nv/WVA8DnDBCxXShMTXRPOSgOan2khVNybRficzKwMcaYAYldkOpX3QRp/oQr+MxkwniLyePJAEQtp4Fi5DX1FYY1nPIG2EvySEx5/zQycsqzVTmCWfODhWuQMnUKxRJ2RkEe4lmV4VJs0R6wXLXFNoMDcef/iFjmSlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93481F000E9;
	Thu,  6 Aug 2026 10:05:46 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] wifi: morsemicro: MM81X should be invisible and selected by its users
Date: Thu,  6 Aug 2026 12:05:42 +0200
Message-ID: <3415bda97c2faf7c56eff7fe79a91b218d0d6731.1786010705.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Morse Micro MM81x wireless devices can have either SDIO or USB
interfaces.  Hence there is no point in asking the user about these
devices when configuring a kernel without MMC or USB support.

Fix this by making the core driver symbol invisible, and selecting it by
its users when needed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Alternatively, MM81X could depend on "MMC || USB", at the expense of
asking the user one more question.
---
 drivers/net/wireless/morsemicro/mm81x/Kconfig | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/Kconfig b/drivers/net/wireless/morsemicro/mm81x/Kconfig
index 33cdcc0df4de2e00..4c4fae77ff67be48 100644
--- a/drivers/net/wireless/morsemicro/mm81x/Kconfig
+++ b/drivers/net/wireless/morsemicro/mm81x/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 config MM81X
-	tristate "Morse Micro MM81x wireless devices"
+	tristate "Morse Micro MM81x wireless devices" if COMPILE_TEST
 	depends on MAC80211
 	select FW_LOADER
 	select CRC7
@@ -11,14 +11,16 @@ config MM81X
 
 config MM81X_USB
 	tristate "Morse Micro MM81x USB support"
-	depends on MM81X && USB
+	depends on MAC80211 && USB
+	select MM81X
 	help
 	  This module adds support for the USB interface of
 	  devices using the Morse Micro MM81x chipset.
 
 config MM81X_SDIO
 	tristate "Morse Micro MM81x SDIO support"
-	depends on MM81X && MMC
+	depends on MAC80211 && MMC
+	select MM81X
 	help
 	  This module adds support for the SDIO interface of
 	  devices using the Morse Micro MM81x chipset.
-- 
2.43.0

