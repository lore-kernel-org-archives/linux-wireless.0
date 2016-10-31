Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20580 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756626AbcJaQGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 12:06:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc v4.9] mei: bus: fix received data size check in NFC fixup
Date: Mon, 31 Oct 2016 19:02:39 +0200
Message-Id: <1477933359-18984-1-git-send-email-tomas.winkler@intel.com> (sfid-20161031_170654_875803_B647924E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Usyskin <alexander.usyskin@intel.com>

NFC version reply size checked against only header size, not against
full message size. That may lead potentially to uninitialized memory access
in version data.

That leads to warnings when version data is accessed:
drivers/misc/mei/bus-fixup.c: warning: '*((void *)&ver+11)' may be used uninitialized in this function [-Wuninitialized]:  => 212:2

Reported in
Build regressions/improvements in v4.9-rc3
https://lkml.org/lkml/2016/10/30/57

Fixes: 59fcd7c63abf (mei: nfc: Initial nfc implementation)
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus-fixup.c | 2 +-
 drivers/nfc/mei_phy.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
index e9e6ea3ab73c..75b9d4ac8b1e 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -178,7 +178,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 
 	ret = 0;
 	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, if_version_length);
-	if (bytes_recv < 0 || bytes_recv < sizeof(struct mei_nfc_reply)) {
+	if (bytes_recv < if_version_length) {
 		dev_err(bus->dev, "Could not read IF version\n");
 		ret = -EIO;
 		goto err;
diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 07b4239585fa..03139c5a05e4 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -133,7 +133,7 @@ static int mei_nfc_if_version(struct nfc_mei_phy *phy)
 		return -ENOMEM;
 
 	bytes_recv = mei_cldev_recv(phy->cldev, (u8 *)reply, if_version_length);
-	if (bytes_recv < 0 || bytes_recv < sizeof(struct mei_nfc_reply)) {
+	if (bytes_recv < 0 || bytes_recv < if_version_length) {
 		pr_err("Could not read IF version\n");
 		r = -EIO;
 		goto err;
-- 
2.7.4
