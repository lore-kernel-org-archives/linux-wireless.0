Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:28505 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXEQDbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 23:31:36 -0400
Date: Wed, 16 May 2007 20:35:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Message-Id: <20070516203505.556df4f9.randy.dunlap@oracle.com>
In-Reply-To: <464B7B7C.5080800@linux.intel.com>
References: <464B7B7C.5080800@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 16 May 2007 14:45:32 -0700 James Ketrenos wrote:

> This patch adds the iwlwifi project directory and sources needed to 
> build the mac80211 based wireless drivers for the Intel PRO/Wireless 
> 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.
> 
> Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
> 
> NOTE:  The patch is 597k and can be found at:
> 
> 	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch
> 
> Patch is against wireless-dev commit-id be8662897~


1.  Can't this:

+	if (sizeof(priv->eeprom) != 1024) {
+		IWL_ERROR("EEPROM structure size incorrect!\n");
+		return -EINVAL;
+	}

use this instead of 1024 ?
+#define IWL4965_EEPROM_IMAGE_SIZE  (0x200 * sizeof(u16))

2.  Use of bitfields:  bitfields are not (guaranteed to be) portable
across a wire interface to some other CPU architecture.
Are all bitfield uses always local to the running driver?
They should be.

3.  What are all of those "volatile" C keywords doing in struct
iwl_shared?
See http://lwn.net/Articles/232961/ : "The trouble with volatile"

4.  Don't list the parameters like this:

+static const struct iwl_channel_info *iwl4965_get_current_txpower_info(struct
+								       iwl_priv
+								       *priv,
+								       u8 *
+								       band,
+								       u8 *
+								       channel,
+								       u8 *
+								       is_fat,
+								       u8 *
+								       ctrl_chan_high)
+{

Just do more like this:

+static const struct iwl_channel_info *iwl4965_get_current_txpower_info(
+						struct iwl_priv *priv,
+						u8 *band,
+						u8 *channel,
+						u8 *is_fat,
+						u8 *ctrl_chan_high)
+{

5.  This function:

+static inline u8 iwl4965_get_dma_hi_address(dma_addr_t addr)
+{
+#ifdef _X86_64_TYPES_H
+	return addr >> 32;
+#else
+#ifdef _I386_TYPES_H
+	return 0;
+#else
+#error "unsupported architecture"
+#endif
+#endif
+}

a.  For i386, dma_addr_t can still be 64 bits.  See asm-i386/types.h:

#ifdef CONFIG_HIGHMEM64G
typedef u64 dma_addr_t;
#else
typedef u32 dma_addr_t;
#endif

b.  Should use CONFIG_64BIT instead of checking _X64_64_TYPES_H or
_I386_TYPES_H.

c.  can just shift addr 32 bits right (in 2 shifts) in all cases:

	return (addr >> 16) >> 16;

6.  No need to init rc:

+int iwl_hw_setup_bootstrap(struct iwl_priv *priv)
+{
+	int rc = 0;
+
+	/* Load bootstrap instructions into bootstrap state machine, for
+	 *   restoring after suspend/resume and rfkill power-downs */
+	rc = iwl4965_load_bsm(priv, priv->ucode_boot.v_addr,
+			      priv->ucode_boot.len);

7.  No need to init hwVersion:

+void iwl_hw_card_show_info(struct iwl_priv *priv)
+{
+	u16 hwVersion = 0;
+
+	hwVersion = priv->eeprom.board_revision_4965;

8.  Too many BUG_ON()s.  Try to recover or return -ERRORs instead.

9.  printk() calls should use KERN_* levels.

10. Don't use C99-style // comments.



and as Andrew's -mm announcements and my sig say, use
Documentation/SubmitChecklist to see what else needs to be done.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
