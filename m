Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11633 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbZEZLCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 07:02:21 -0400
Date: Tue, 26 May 2009 13:04:11 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
Message-ID: <20090526110403.GA14626@sortiz.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com> <1243307448-17441-2-git-send-email-yi.zhu@intel.com> <1243312991.21383.3.camel@localhost.localdomain> <1243317777.3623.19.camel@debian> <1243319583.30938.2.camel@localhost.localdomain> <1243320454.3623.35.camel@debian> <1243327894.30938.9.camel@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <1243327894.30938.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Tue, May 26, 2009 at 01:51:34AM -0700, Marcel Holtmann wrote:
> > > > FIRMWARE_NAME_MAX is defined 30 at this time.
> > > 
> > > I think we need to fix this. Especially since all the other name
> > > length limits in the driver model are gone.
> > 
> > I agree. Should we fix this by simply increasing FIRMWARE_NAME_MAX to
> > some acceptable length (what should it be? btw) or there are other
> > better ideas?
> 
> I think just increasing the length of the static array is bad. Can we
> just not allocated the needed length for the firmware filename?
I think we can, assuming all firmware name strings passed through
request_firmware() are \0 terminated. Based on that assumption, this is what I
propose:

--
 drivers/base/firmware_class.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d3a59c6..e1e69de 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -40,7 +40,7 @@ static int loading_timeout = 60;	/* In seconds */
 static DEFINE_MUTEX(fw_lock);
 
 struct firmware_priv {
-	char fw_id[FIRMWARE_NAME_MAX];
+	char *fw_id;
 	struct completion completion;
 	struct bin_attribute attr_data;
 	struct firmware *fw;
@@ -278,6 +278,7 @@ static void fw_dev_release(struct device *dev)
 {
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 
+	kfree(fw_priv->fw_id);
 	kfree(fw_priv);
 	kfree(dev);
 
@@ -309,7 +310,14 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 
 	init_completion(&fw_priv->completion);
 	fw_priv->attr_data = firmware_attr_data_tmpl;
-	strlcpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
+	fw_priv->fw_id = kzalloc(strlen(fw_name) + 1, GFP_KERNEL);
+	if (!fw_priv->fw_id) {
+		dev_err(device, "%s: Firmware name allocation failed\n",
+			__func__);
+		retval = -ENOMEM;
+		goto error_kfree;
+	}
+	strcpy(fw_priv->fw_id, fw_name);
 
 	fw_priv->timeout.function = firmware_class_timeout;
 	fw_priv->timeout.data = (u_long) fw_priv;
@@ -323,11 +331,14 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	retval = device_register(f_dev);
 	if (retval) {
 		dev_err(device, "%s: device_register failed\n", __func__);
-		goto error_kfree;
+		goto error_kfree_fw_id;
 	}
 	*dev_p = f_dev;
 	return 0;
 
+error_kfree_fw_id:
+	kfree(fw_priv->fw_id);
+
 error_kfree:
 	kfree(fw_priv);
 	kfree(f_dev);

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

