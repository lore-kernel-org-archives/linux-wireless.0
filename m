Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAC53C4B8D;
	Sat,  6 Jun 2026 20:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780777645; cv=none; b=THOjreRSjUAEK0nDz+CDizWuJl2TZr0Eyu0G2MN/49yhCtQu3Ewcu2L+x+kVCwe+7cgS/3KRw/Y0yo1C3e6O6Ypy100eGQyzCRkVRFay2D8v/UaIyHZX0OlAur7MHuIyxndVYtCi5H2cxrFDnskGzVbhw2RTGkYtc51x1wkmFZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780777645; c=relaxed/simple;
	bh=uSHaNvTOe+QCtHj00I9igqcwTFrdh/QdZfN2j94IGqM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VhmXhRzbNfAI0Gya6VZS3cbcq1tPUrTcm5cM+bHVFExZHsESRpz9kL4PQiqzXyH6QVBoTP17E9GpA1IzW8PirQHdthYF2Z3elS+nMfuBlUq0fQaOubbpQf4wPzzu43XffZ9scNnzCEcG18pSNaBtvPb4V0RgSHVPKXhxV9rrna4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=h8orFUGF; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="h8orFUGF"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbx-007cIv-VH; Sat, 06 Jun 2026 22:27:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=EsiSusHmKbsuS9wX85eZ852sXDJ3CmjPutJp5AFLAoQ=; b=h8orFU
	GFra3nES6Bqiw5WC9V0047HZ8NM1obIUOHvKN2y2cBwy33fKk0K/iuLfAb5cEKR5lcwZ+AtL6qCVi
	n6UUj2NX6b0t5LjXAgJXy1yQ3wHP5c6ZlSqyLWqkB7a/pqClX43R5xLGXtvCQyfgy0DNCaiQ00I82
	9PN8S6TzgYYTHEZKlOBWpVejFGGpuiEeQMYMBPQkRo2FSTxe68rPzi6w1+Aaj3Drcu05FtvsuUH/X
	nDHyKqRs+fVRSSFN02VsAXF9332LFtLmvlEs7F6iR5ywYdYLleyO1G3H7oOc3S+mAKJtUp/UGMIXo
	FGdypqwbtVBkC691XarUQF094knA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbx-0005Dl-Dg; Sat, 06 Jun 2026 22:27:17 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wVxbh-006V18-RL;
	Sat, 06 Jun 2026 22:27:01 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH net-next] drivers/net/wireless/microchip/wilc1000: Use strscpy() to copy device name
Date: Sat,  6 Jun 2026 21:26:15 +0100
Message-Id: <20260606202633.5018-21-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/net/wireless/microchip/wilc1000/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 956cb578bf37..66580233646d 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -960,7 +960,7 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 
 	vif = netdev_priv(ndev);
 	ndev->ieee80211_ptr = &vif->priv.wdev;
-	strcpy(ndev->name, name);
+	strscpy(ndev->name, name);
 	vif->wilc = wl;
 	vif->ndev = ndev;
 	ndev->ml_priv = vif;
-- 
2.39.5

