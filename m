Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50390 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0CCQiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 11:38:54 -0500
Received: by fxm19 with SMTP id 19so1727528fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 08:38:52 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: Export rt2x00soc_probe from rt2x00soc
Date: Wed, 3 Mar 2010 17:38:49 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003031738.49706.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export rt2x00soc_probe from rt2x00soc as it is used in rt2800pci.

Otherwise loading rt2800pci gives "rt2800pci: Unknown symbol
rt2x00soc_probe".

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

This time without whitespace damage John ... hopefully ;)

 drivers/net/wireless/rt2x00/rt2x00soc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
index 4efdc96..111c0ff 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
@@ -112,6 +112,7 @@ exit_free_device:
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(rt2x00soc_probe);
 
 int rt2x00soc_remove(struct platform_device *pdev)
 {
-- 
1.6.0.2

