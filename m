Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1771 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab2JKMFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 08:05:23 -0400
Message-ID: <5076B5FB.10608@broadcom.com> (sfid-20121011_140526_881927_CB0B1B41)
Date: Thu, 11 Oct 2012 14:05:15 +0200
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
cc: "Stanislaw Gruszka" <sgruszka@redhat.com>,
	"=?UTF-8?B?UmFmYcWCIE1pxYJlY2s=?= =?UTF-8?B?aQ==?="
	<zajec5@gmail.com>
Subject: [PATCH] bcma: fix unregistration of cores
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cores are unregistered, entries
need to be removed from cores list in a safe manner.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Cc: stable@vger.kernel.org
---
 drivers/bcma/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 758af9c..0059e26 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -141,9 +141,10 @@ static int bcma_register_cores(struct bcma_bus *bus)

 static void bcma_unregister_cores(struct bcma_bus *bus)
 {
-	struct bcma_device *core;
+	struct bcma_device *core, *tmp;

-	list_for_each_entry(core, &bus->cores, list) {
+	list_for_each_entry_safe(core, tmp, &bus->cores, list) {
+		list_del(&core->list);
 		if (core->dev_registered)
 			device_unregister(&core->dev);
 	}
-- 
1.7.10.4

