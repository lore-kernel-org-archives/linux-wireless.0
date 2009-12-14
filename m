Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58878 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786AbZLNWMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:19 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>, stable@kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: fix EEPROM/OTP reading endian annotations and a bug
Date: Mon, 14 Dec 2009 14:12:08 -0800
Message-Id: <1260828733-22726-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
References: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

The construct "le16_to_cpu((__force __le16)(r >> 16))" has
always bothered me when looking through the iwlwifi code,
it shouldn't be necessary to __force anything, and before
this code, "r" was obtained with an ioread32, which swaps
each of the two u16 values in it properly when swapping the
entire u32 value. I've had arguments about this code with
people before, but always conceded they were right because
removing it only made things not work at all on big endian
platforms.

However, analysing a failure of the OTP reading code, I now
finally figured out what is going on, and why my intuition
about that code being wrong was right all along.

It turns out that the 'priv->eeprom' u8 array really wants
to have the data in it in little endian. So the force code
above and all really converts *to* little endian, not from
it. Cf., for instance, the function iwl_eeprom_query16() --
it reads two u8 values and combines them into a u16, in a
little-endian way. And considering it more, it makes sense
to have the eeprom array as on the device, after all not
all values really are 16-bit values, the MAC address for
instance is not.

Now, what this really means is that all the annotations are
completely wrong. The eeprom reading code should fill the
priv->eeprom array as a __le16 array, with __le16 values.

This also means that iwl_read_otp_word() should really have
a __le16 pointer as the data argument, since it should be
filling that in a format suitable for priv->eeprom.

Propagating these changes throughout, iwl_find_otp_image()
is found to be, now obviously visible, defective -- it uses
the data returned by iwl_read_otp_word() directly as if it
was CPU endianness. Fixing that, which is this hunk of the
patch:

-               next_link_addr = link_value * sizeof(u16);
+               next_link_addr = le16_to_cpu(link_value) * sizeof(u16);

is the only real change of this patch. Everything else is
just fixing the sparse annotations.

Also, the bug only shows up on big endian platforms with a
1000 series card. 5000 and previous series do not use OTP,
and 6000 series has shadow RAM support which means we don't
ever use the defective code on any cards but 1000.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This fix is needed in 2.6.32 but does not apply in this form (one hunk
applies with some fuzz). A rebased version will be provided after this
patch has been merged into 2.6.33.


 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   20 +++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e1032f2..165d1f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1168,7 +1168,7 @@ struct iwl_priv {
 	u32 last_beacon_time;
 	u64 last_tsf;
 
-	/* eeprom */
+	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
 	int    nvm_device_type;
 	struct iwl_eeprom_calib_info *calib_info;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 72f0d77..08ad6e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -370,7 +370,7 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 	return ret;
 }
 
-static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, u16 *eeprom_data)
+static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, __le16 *eeprom_data)
 {
 	int ret = 0;
 	u32 r;
@@ -404,7 +404,7 @@ static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, u16 *eeprom_data)
 				CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
 		IWL_ERR(priv, "Correctable OTP ECC error, continue read\n");
 	}
-	*eeprom_data = le16_to_cpu((__force __le16)(r >> 16));
+	*eeprom_data = cpu_to_le16(r >> 16);
 	return 0;
 }
 
@@ -413,7 +413,8 @@ static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, u16 *eeprom_data)
  */
 static bool iwl_is_otp_empty(struct iwl_priv *priv)
 {
-	u16 next_link_addr = 0, link_value;
+	u16 next_link_addr = 0;
+	__le16 link_value;
 	bool is_empty = false;
 
 	/* locate the beginning of OTP link list */
@@ -443,7 +444,8 @@ static bool iwl_is_otp_empty(struct iwl_priv *priv)
 static int iwl_find_otp_image(struct iwl_priv *priv,
 					u16 *validblockaddr)
 {
-	u16 next_link_addr = 0, link_value = 0, valid_addr;
+	u16 next_link_addr = 0, valid_addr;
+	__le16 link_value = 0;
 	int usedblocks = 0;
 
 	/* set addressing mode to absolute to traverse the link list */
@@ -463,7 +465,7 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 		 * check for more block on the link list
 		 */
 		valid_addr = next_link_addr;
-		next_link_addr = link_value * sizeof(u16);
+		next_link_addr = le16_to_cpu(link_value) * sizeof(u16);
 		IWL_DEBUG_INFO(priv, "OTP blocks %d addr 0x%x\n",
 			       usedblocks, next_link_addr);
 		if (iwl_read_otp_word(priv, next_link_addr, &link_value))
@@ -497,7 +499,7 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
  */
 int iwl_eeprom_init(struct iwl_priv *priv)
 {
-	u16 *e;
+	__le16 *e;
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
 	int sz;
 	int ret;
@@ -516,7 +518,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		ret = -ENOMEM;
 		goto alloc_err;
 	}
-	e = (u16 *)priv->eeprom;
+	e = (__le16 *)priv->eeprom;
 
 	priv->cfg->ops->lib->apm_ops.init(priv);
 
@@ -559,7 +561,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		}
 		for (addr = validblockaddr; addr < validblockaddr + sz;
 		     addr += sizeof(u16)) {
-			u16 eeprom_data;
+			__le16 eeprom_data;
 
 			ret = iwl_read_otp_word(priv, addr, &eeprom_data);
 			if (ret)
@@ -584,7 +586,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 				goto done;
 			}
 			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
-			e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
+			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
 	ret = 0;
-- 
1.5.6.3

