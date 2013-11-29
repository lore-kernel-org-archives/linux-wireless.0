Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2260 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab3K2LZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/19] brcmfmac: expose chip information through debugfs
Date: Fri, 29 Nov 2013 12:25:24 +0100
Message-ID: <1385724324-6361-20-git-send-email-arend@broadcom.com> (sfid-20131129_123808_191848_3DFB94E6)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding the debugfs file <debugfs_mnt>/brcmfmac/<devid>/chipinfo
which contains the chip number and revision.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c |   36 ++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 0f9e9057..03fe8ac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -22,7 +22,6 @@
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
-#include "tracepoint.h"
 
 static struct dentry *root_folder;
 
@@ -42,6 +41,40 @@ void brcmf_debugfs_exit(void)
 	root_folder = NULL;
 }
 
+static
+ssize_t brcmf_debugfs_chipinfo_read(struct file *f, char __user *data,
+				   size_t count, loff_t *ppos)
+{
+	struct brcmf_pub *drvr = f->private_data;
+	struct brcmf_bus *bus = drvr->bus_if;
+	char buf[40];
+	int res;
+
+	/* only allow read from start */
+	if (*ppos > 0)
+		return 0;
+
+	res = scnprintf(buf, sizeof(buf), "chip: %x(%u) rev %u\n",
+			bus->chip, bus->chip, bus->chiprev);
+	return simple_read_from_buffer(data, count, ppos, buf, res);
+}
+
+static const struct file_operations brcmf_debugfs_chipinfo_ops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = brcmf_debugfs_chipinfo_read
+};
+
+static int brcmf_debugfs_create_chipinfo(struct brcmf_pub *drvr)
+{
+	struct dentry *dentry =  drvr->dbgfs_dir;
+
+	if (!IS_ERR_OR_NULL(dentry))
+		debugfs_create_file("chipinfo", S_IRUGO, dentry, drvr,
+				    &brcmf_debugfs_chipinfo_ops);
+	return 0;
+}
+
 int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 {
 	struct device *dev = drvr->bus_if->dev;
@@ -50,6 +83,7 @@ int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 		return -ENODEV;
 
 	drvr->dbgfs_dir = debugfs_create_dir(dev_name(dev), root_folder);
+	brcmf_debugfs_create_chipinfo(drvr);
 	return PTR_ERR_OR_ZERO(drvr->dbgfs_dir);
 }
 
-- 
1.7.10.4


