Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:17812 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZCQBo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 21:44:27 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2835544qwi.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 18:44:23 -0700 (PDT)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk> <1236312734.19328.37.camel@rainbow>
	 <1236317982.12430.9.camel@rc-desk> <1236649234.6685.9.camel@rainbow>
	 <1236661466.15923.53.camel@rc-desk> <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-PgPRGYlUqEMLMbcJne3X"
Date: Mon, 16 Mar 2009 21:44:03 -0400
Message-Id: <1237254243.13077.33.camel@rainbow> (sfid-20090317_024437_951400_FD5D2609)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PgPRGYlUqEMLMbcJne3X
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-03-16 at 08:10 -0400, Jason Andryuk wrote:
> On Thu, Mar 12, 2009 at 11:31 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> > On Tue, Mar 10, 2009 at 11:40 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> >>> You log below has a new error (similar to what you note in your next
> >>> email). "Unsupported interface type 515". This is very strange and
> >>> really looks like some corruption as this value is initialized with a
> >>> macro during probe. Could you enable mac and info debugging also (add
> >>> 0x3 to your current debug flags)? This code has also changed a bit since
> >>> commit bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d.
> 
> > Looking at ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f, I found the call
> > to iwl_reset_qos corrupts priv->iw_mode.  It is 2 before the call and
> > 515 after.
> 
> Turns out that iwlcore.ko was stale with respect to iwl3945.ko.  The
> older iwl_reset_qos in iwlcore.ko used an incorrect offset to access
> priv->qos_data.
> 
> Unfortunately this did not solve the Microcode SW error, and I spent a
> lot of time chasing the wrong issue.
> 
> Jason

I noticed that Bugzilla now has a similar (the same?) bug as I have been
seeing.  http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1936

I believe there may be some incorrect use of the DMA API.

My tree is as follows:
git checkout -f ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f
git cherry-pick -x fadd267e5f9c2319ad62edad30f7af07b6b368ef
patch -p1 < iwl3945-rb_stts_and_BUG_to_WARN.patch (attached)
plus patch from below.

The patch below reorganizes the code so that pci_map_single is called
after out_cmd is finished being modified.  My understanding is after the
call to pci_map_single, the device owns the memory.  Additionally, in
the case of x86_64, the SWIOTLB may copy the contents to another
location.  At that point, writes to out_cmd may not be reflected in what
the devices sees.  Note, my machine has 4GB of RAM, so and there are
physical addresses over 4GB.  Hence, mapping can be an issue.

ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f introduced this error when it
converted from pci_alloc_consistent to pci_map_single with parameter
PCI_DMA_TODEVICE.

I still cannot authenticate to my AP.  However, with the patch below,
Microcode SW errors are less frequent.  Originally, I thought it
prevented them, but I noticed one when I went to copy the log file.

Below are two loadings of the driver.  The first has the Microcode SW
error.  The second does not prior to unloading.  debug is unknown
(possibly 0xc0040003) for the first run and was 0xc0840003 for the
second.

For other code issues, it seems pci_unmap_single is never called for the
cmds.

In "iwl3945: add apm ops 3fdd4102abceb4c99c5091674047b5c61fd3ebba", the
call following call, "iwl_set_bit(priv, CSR_ANA_PLL_CFG,
CSR39_ANA_PLL_CFG_VAL);",  was dropped and never replaced.  Was it
intentional?

Hopefully this helps shed some light on what is going wrong.

Jason

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3b39aef..ec93796 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -513,14 +513,6 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	len = (idx == TFD_CMD_SLOTS) ?
 			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
 
-	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
-					len, PCI_DMA_TODEVICE);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
-	pci_unmap_len_set(&out_cmd->meta, len, len);
-	phys_addr += offsetof(struct iwl_cmd, hdr);
-
-	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
-
 	pad = U32_PAD(cmd->len);
 	tfd->control_flags |= cpu_to_le32(TFD_CTL_PAD_SET(pad));
 
@@ -532,6 +524,13 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	txq->need_update = 1;
 
+	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
+					len, PCI_DMA_TODEVICE);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
+	pci_unmap_len_set(&out_cmd->meta, len, len);
+	phys_addr += offsetof(struct iwl_cmd, hdr);
+
+	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	ret = iwl3945_tx_queue_update_write_ptr(priv, txq);
@@ -2263,7 +2262,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	int txq_id = skb_get_queue_mapping(skb);
-	u16 len, idx, len_org, hdr_len;
+	u16 len, idx, len_org, hdr_len, attach_len;
 	u8 id;
 	u8 unicast;
 	u8 sta_id;
@@ -2381,6 +2380,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	 */
 	len = sizeof(struct iwl3945_tx_cmd) +
 			sizeof(struct iwl_cmd_header) + hdr_len;
+	attach_len = len;
 
 	len_org = len;
 	len = (len + 3) & ~3;
@@ -2390,42 +2390,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	else
 		len_org = 0;
 
-	/* Physical address of this Tx command's header (not MAC header!),
-	 * within command buffer array. */
-	txcmd_phys = pci_map_single(priv->pci_dev,
-				    out_cmd, sizeof(struct iwl_cmd),
-				    PCI_DMA_TODEVICE);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
-	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	txcmd_phys += offsetof(struct iwl_cmd, hdr);
-
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
-
 	if (info->control.hw_key)
 		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, 0);
 
-	/* Set up TFD's 2nd entry to point directly to remainder of skb,
-	 * if any (802.11 null frames have no payload). */
-	len = skb->len - hdr_len;
-	if (len) {
-		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
-					   len, PCI_DMA_TODEVICE);
-		iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
-	}
-
-	if (!len)
-		/* If there is no payload, then we use only one Tx buffer */
-		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(1));
-	else
-		/* Else use 2 buffers.
-		 * Tell 3945 about any padding after MAC header */
-		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(2) |
-			TFD_CTL_PAD_SET(U32_PAD(len)));
-
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
 	tx->len = cpu_to_le16(len);
@@ -2453,6 +2420,39 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
 			   ieee80211_hdrlen(fc));
 
+	/* Physical address of this Tx command's header (not MAC header!),
+	 * within command buffer array. */
+	txcmd_phys = pci_map_single(priv->pci_dev,
+				    out_cmd, sizeof(struct iwl_cmd),
+				    PCI_DMA_TODEVICE);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
+	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	txcmd_phys += offsetof(struct iwl_cmd, hdr);
+
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, attach_len);
+
+	/* Set up TFD's 2nd entry to point directly to remainder of skb,
+	 * if any (802.11 null frames have no payload). */
+	len = skb->len - hdr_len;
+	if (!len)
+		/* If there is no payload, then we use only one Tx buffer */
+		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(1));
+	else
+		/* Else use 2 buffers.
+		 * Tell 3945 about any padding after MAC header */
+		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(2) |
+			TFD_CTL_PAD_SET(U32_PAD(len)));
+
+	if (len) {
+		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
+					   len, PCI_DMA_TODEVICE);
+		iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
+	}
+
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl3945_tx_queue_update_write_ptr(priv, txq);



-------------
Logs

Mar 16 20:55:03 rainbow kernel: [ 2845.094660] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
Mar 16 20:55:03 rainbow kernel: [ 2845.094666] iwl3945: Copyright(c) 2003-2008 Intel Corporation
Mar 16 20:55:03 rainbow kernel: [ 2845.094824] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar 16 20:55:03 rainbow kernel: [ 2845.094843] iwl3945 0000:03:00.0: setting latency timer to 64
Mar 16 20:55:03 rainbow kernel: [ 2845.095034] ieee80211 phy5: U iwl3945_pci_probe pci_resource_len = 0x00001000
Mar 16 20:55:03 rainbow kernel: [ 2845.095042] ieee80211 phy5: U iwl3945_pci_probe pci_resource_base = ffffc200052b8000
Mar 16 20:55:03 rainbow kernel: [ 2845.139871] ieee80211 phy5: U iwl3945_pci_probe MAC address: 00:1f:3c:20:a1:6e
Mar 16 20:55:03 rainbow kernel: [ 2845.139886] ieee80211 phy5: U iwl_reset_qos set QoS to default 
Mar 16 20:55:03 rainbow kernel: [ 2845.139891] ieee80211 phy5: U iwl3945_init_channel_map Initializing regulatory info from EEPROM
Mar 16 20:55:03 rainbow kernel: [ 2845.139897] ieee80211 phy5: U iwl3945_init_channel_map Parsing data for 56 channels.
Mar 16 20:55:03 rainbow kernel: [ 2845.139931] ieee80211 phy5: U iwl3945_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.139940] ieee80211 phy5: U iwl3945_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.139947] ieee80211 phy5: U iwl3945_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.139955] ieee80211 phy5: U iwl3945_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.139962] ieee80211 phy5: U iwl3945_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.139970] ieee80211 phy5: U iwl3945_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.139978] ieee80211 phy5: U iwl3945_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.139985] ieee80211 phy5: U iwl3945_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.139993] ieee80211 phy5: U iwl3945_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140023] ieee80211 phy5: U iwl3945_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140030] ieee80211 phy5: U iwl3945_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140037] ieee80211 phy5: U iwl3945_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140043] ieee80211 phy5: U iwl3945_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140048] ieee80211 phy5: U iwl3945_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140055] ieee80211 phy5: U iwl3945_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140060] ieee80211 phy5: U iwl3945_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140066] ieee80211 phy5: U iwl3945_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140072] ieee80211 phy5: U iwl3945_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140078] ieee80211 phy5: U iwl3945_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140084] ieee80211 phy5: U iwl3945_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140090] ieee80211 phy5: U iwl3945_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140096] ieee80211 phy5: U iwl3945_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140102] ieee80211 phy5: U iwl3945_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140108] ieee80211 phy5: U iwl3945_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140114] ieee80211 phy5: U iwl3945_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140119] ieee80211 phy5: U iwl3945_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140125] ieee80211 phy5: U iwl3945_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140131] ieee80211 phy5: U iwl3945_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140139] ieee80211 phy5: U iwl3945_init_channel_map Ch. 36 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140146] ieee80211 phy5: U iwl3945_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140153] ieee80211 phy5: U iwl3945_init_channel_map Ch. 40 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140160] ieee80211 phy5: U iwl3945_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140167] ieee80211 phy5: U iwl3945_init_channel_map Ch. 44 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140174] ieee80211 phy5: U iwl3945_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140181] ieee80211 phy5: U iwl3945_init_channel_map Ch. 48 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140189] ieee80211 phy5: U iwl3945_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140197] ieee80211 phy5: U iwl3945_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140205] ieee80211 phy5: U iwl3945_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140214] ieee80211 phy5: U iwl3945_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140221] ieee80211 phy5: U iwl3945_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140227] ieee80211 phy5: U iwl3945_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140233] ieee80211 phy5: U iwl3945_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140238] ieee80211 phy5: U iwl3945_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140244] ieee80211 phy5: U iwl3945_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140250] ieee80211 phy5: U iwl3945_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140256] ieee80211 phy5: U iwl3945_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140262] ieee80211 phy5: U iwl3945_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140268] ieee80211 phy5: U iwl3945_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140273] ieee80211 phy5: U iwl3945_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140279] ieee80211 phy5: U iwl3945_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140286] ieee80211 phy5: U iwl3945_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:03 rainbow kernel: [ 2845.140293] ieee80211 phy5: U iwl3945_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140301] ieee80211 phy5: U iwl3945_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140309] ieee80211 phy5: U iwl3945_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140316] ieee80211 phy5: U iwl3945_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140324] ieee80211 phy5: U iwl3945_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:03 rainbow kernel: [ 2845.140337] ieee80211 phy5: U iwl3945_hw_reg_txpower_get_temperature Temperature: 260
Mar 16 20:55:03 rainbow kernel: [ 2845.140369] ieee80211 phy5: U iwl3945_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140376] ieee80211 phy5: U iwl3945_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140383] ieee80211 phy5: U iwl3945_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140389] ieee80211 phy5: U iwl3945_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140395] ieee80211 phy5: U iwl3945_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140401] ieee80211 phy5: U iwl3945_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140407] ieee80211 phy5: U iwl3945_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140414] ieee80211 phy5: U iwl3945_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140420] ieee80211 phy5: U iwl3945_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140426] ieee80211 phy5: U iwl3945_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140433] ieee80211 phy5: U iwl3945_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=00
Mar 16 20:55:03 rainbow kernel: [ 2845.140439] ieee80211 phy5: U iwl3945_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140446] ieee80211 phy5: U iwl3945_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140452] ieee80211 phy5: U iwl3945_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140458] ieee80211 phy5: U iwl3945_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140465] ieee80211 phy5: U iwl3945_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0E
Mar 16 20:55:03 rainbow kernel: [ 2845.140471] ieee80211 phy5: U iwl3945_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0E
Mar 16 20:55:03 rainbow kernel: [ 2845.140477] ieee80211 phy5: U iwl3945_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0E
Mar 16 20:55:03 rainbow kernel: [ 2845.140484] ieee80211 phy5: U iwl3945_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0E
Mar 16 20:55:03 rainbow kernel: [ 2845.140490] ieee80211 phy5: U iwl3945_init_geos Channel 149 Freq=5745[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140497] ieee80211 phy5: U iwl3945_init_geos Channel 153 Freq=5765[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140503] ieee80211 phy5: U iwl3945_init_geos Channel 157 Freq=5785[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140509] ieee80211 phy5: U iwl3945_init_geos Channel 161 Freq=5805[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140516] ieee80211 phy5: U iwl3945_init_geos Channel 165 Freq=5825[5.2GHz] valid flag=06
Mar 16 20:55:03 rainbow kernel: [ 2845.140522] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
Mar 16 20:55:03 rainbow kernel: [ 2845.140528] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
Mar 16 20:55:03 rainbow kernel: [ 2845.140577] ieee80211 phy5: U iwl3945_set_rxon_channel Staging channel set to 6 [0]
Mar 16 20:55:03 rainbow kernel: [ 2845.142445] phy5: Selected rate control algorithm 'iwl-3945-rs'
Mar 16 20:55:07 rainbow kernel: [ 2849.219833] ieee80211 phy5: U iwl3945_mac_start enter
Mar 16 20:55:07 rainbow kernel: [ 2849.219861] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar 16 20:55:07 rainbow kernel: [ 2849.220218] iwl3945 0000:03:00.0: irq 2295 for MSI/MSI-X
Mar 16 20:55:07 rainbow kernel: [ 2849.220330] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
Mar 16 20:55:07 rainbow kernel: [ 2849.226756] ieee80211 phy5: U iwl3945_read_ucode Got firmware 'iwlwifi-3945-2.ucode' file (149816 bytes) from disk
Mar 16 20:55:07 rainbow kernel: [ 2849.226766] iwl3945 0000:03:00.0: loaded firmware version 15.28.2.8
Mar 16 20:55:07 rainbow kernel: [ 2849.226772] ieee80211 phy5: U iwl3945_read_ucode f/w package hdr ucode version raw = 0xf1c0208
Mar 16 20:55:07 rainbow kernel: [ 2849.226777] ieee80211 phy5: U iwl3945_read_ucode f/w package hdr runtime inst size = 80684
Mar 16 20:55:07 rainbow kernel: [ 2849.226783] ieee80211 phy5: U iwl3945_read_ucode f/w package hdr runtime data size = 32768
Mar 16 20:55:07 rainbow kernel: [ 2849.226788] ieee80211 phy5: U iwl3945_read_ucode f/w package hdr init inst size = 2672
Mar 16 20:55:07 rainbow kernel: [ 2849.226793] ieee80211 phy5: U iwl3945_read_ucode f/w package hdr init data size = 32768
Mar 16 20:55:07 rainbow kernel: [ 2849.226798] ieee80211 phy5: U iwl3945_read_ucode f/w package hdr boot inst size = 900
Mar 16 20:55:07 rainbow kernel: [ 2849.226939] ieee80211 phy5: U iwl3945_read_ucode Copying (but not loading) uCode instr len 80684
Mar 16 20:55:07 rainbow kernel: [ 2849.226977] ieee80211 phy5: U iwl3945_read_ucode uCode instr buf vaddr = 0xffff88008f080000, paddr = 0x8f080000
Mar 16 20:55:07 rainbow kernel: [ 2849.226983] ieee80211 phy5: U iwl3945_read_ucode Copying (but not loading) uCode data len 32768
Mar 16 20:55:07 rainbow kernel: [ 2849.227030] ieee80211 phy5: U iwl3945_read_ucode Copying (but not loading) init instr len 2672
Mar 16 20:55:07 rainbow kernel: [ 2849.227038] ieee80211 phy5: U iwl3945_read_ucode Copying (but not loading) init data len 32768
Mar 16 20:55:07 rainbow kernel: [ 2849.227066] ieee80211 phy5: U iwl3945_read_ucode Copying (but not loading) boot instr len 900
Mar 16 20:55:07 rainbow kernel: [ 2849.227205] ieee80211 phy5: U iwl3945_hw_nic_init HW Revision ID = 0x2
Mar 16 20:55:07 rainbow kernel: [ 2849.227255] ieee80211 phy5: U iwl3945_nic_config 3945 RADIO-MM type
Mar 16 20:55:07 rainbow kernel: [ 2849.227265] ieee80211 phy5: U iwl3945_nic_config SKU OP mode is basic
Mar 16 20:55:07 rainbow kernel: [ 2849.227270] ieee80211 phy5: U iwl3945_nic_config 3945ABG revision is 0xF1
Mar 16 20:55:07 rainbow kernel: [ 2849.227281] ieee80211 phy5: U iwl3945_nic_config Card M type B version is 0x3
Mar 16 20:55:07 rainbow kernel: [ 2849.228401] ieee80211 phy5: U iwl3945_load_bsm Begin load bsm
Mar 16 20:55:07 rainbow kernel: [ 2849.229666] ieee80211 phy5: U iwl3945_verify_bsm Begin verify bsm
Mar 16 20:55:07 rainbow kernel: [ 2849.231884] ieee80211 phy5: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Mar 16 20:55:07 rainbow kernel: [ 2849.231941] ieee80211 phy5: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Mar 16 20:55:07 rainbow kernel: [ 2849.231958] ieee80211 phy5: U __iwl3945_up iwl3945 is coming up
Mar 16 20:55:07 rainbow kernel: [ 2849.231962] ieee80211 phy5: U iwl3945_mac_start Start UP work.
Mar 16 20:55:07 rainbow kernel: [ 2849.243420] ieee80211 phy5: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Mar 16 20:55:07 rainbow kernel: [ 2849.243428] ieee80211 phy5: I iwl3945_rx_reply_alive Initialization Alive received.
Mar 16 20:55:07 rainbow kernel: [ 2849.252102] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 16 20:55:07 rainbow kernel: [ 2849.252196] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 16 20:55:07 rainbow kernel: [ 2849.252477] ieee80211 phy5: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Mar 16 20:55:07 rainbow kernel: [ 2849.252482] ieee80211 phy5: U iwl3945_init_alive_start Initialization Alive received.
Mar 16 20:55:07 rainbow kernel: [ 2849.252530] ieee80211 phy5: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Mar 16 20:55:07 rainbow kernel: [ 2849.256856] ieee80211 phy5: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Mar 16 20:55:07 rainbow kernel: [ 2849.256862] ieee80211 phy5: I iwl3945_rx_reply_alive Runtime Alive received.
Mar 16 20:55:07 rainbow kernel: [ 2849.256908] ieee80211 phy5: I iwl3945_disable_events Selected uCode log events may be disabled
Mar 16 20:55:07 rainbow kernel: [ 2849.256913] ieee80211 phy5: I iwl3945_disable_events   by writing "1"s into disable bitmap
Mar 16 20:55:07 rainbow kernel: [ 2849.256919] ieee80211 phy5: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Mar 16 20:55:07 rainbow kernel: [ 2849.264099] ieee80211 phy5: U iwl3945_alive_start Runtime Alive received.
Mar 16 20:55:07 rainbow kernel: [ 2849.264105] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 16 20:55:07 rainbow kernel: [ 2849.264189] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 16 20:55:07 rainbow kernel: [ 2849.264272] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Mar 16 20:55:07 rainbow kernel: [ 2849.271994] ieee80211 phy5: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Mar 16 20:55:07 rainbow kernel: [ 2849.272042] ieee80211 phy5: U iwl3945_alive_start RFKILL status: 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.273188] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.274035] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:07 rainbow kernel: [ 2849.274037] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:07 rainbow kernel: [ 2849.274039] * channel = 1
Mar 16 20:55:07 rainbow kernel: [ 2849.274041] * bssid = 00:00:00:00:00:00
Mar 16 20:55:07 rainbow kernel: [ 2849.274053] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.277164] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.280457] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:07 rainbow kernel: [ 2849.280471] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.283751] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:07 rainbow kernel: [ 2849.283766] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.286578] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.289857] ieee80211 phy5: U iwl3945_hw_reg_txpower_get_temperature Temperature: 72
Mar 16 20:55:07 rainbow kernel: [ 2849.289882] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.294316] Registered led device: iwl-phy5:radio
Mar 16 20:55:07 rainbow kernel: [ 2849.294329] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.294373] Registered led device: iwl-phy5:assoc
Mar 16 20:55:07 rainbow kernel: [ 2849.294415] Registered led device: iwl-phy5:RX
Mar 16 20:55:07 rainbow kernel: [ 2849.294448] Registered led device: iwl-phy5:TX
Mar 16 20:55:07 rainbow kernel: [ 2849.294452] ieee80211 phy5: U iwl3945_alive_start ALIVE processing complete.
Mar 16 20:55:07 rainbow kernel: [ 2849.294501] ieee80211 phy5: U iwl3945_mac_start leave
Mar 16 20:55:07 rainbow kernel: [ 2849.294517] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.294532] ieee80211 phy5: U iwl3945_mac_add_interface enter: type 2
Mar 16 20:55:07 rainbow kernel: [ 2849.294539] ieee80211 phy5: U iwl3945_mac_add_interface Set: 00:1f:3c:20:a1:6e
Mar 16 20:55:07 rainbow kernel: [ 2849.294551] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:07 rainbow kernel: [ 2849.294553] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:07 rainbow kernel: [ 2849.294555] * channel = 1
Mar 16 20:55:07 rainbow kernel: [ 2849.294556] * bssid = 00:00:00:00:00:00
Mar 16 20:55:07 rainbow kernel: [ 2849.294568] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.296107] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.299354] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:07 rainbow kernel: [ 2849.299369] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.301738] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:07 rainbow kernel: [ 2849.308241] ieee80211 phy5: U iwl3945_mac_add_interface leave
Mar 16 20:55:07 rainbow kernel: [ 2849.308249] ieee80211 phy5: U iwl3945_bss_info_changed changes = 0xE
Mar 16 20:55:07 rainbow kernel: [ 2849.308255] ieee80211 phy5: U iwl3945_bss_info_changed ERP_PREAMBLE 0
Mar 16 20:55:07 rainbow kernel: [ 2849.308260] ieee80211 phy5: U iwl3945_bss_info_changed ERP_CTS 0
Mar 16 20:55:07 rainbow kernel: [ 2849.320081] ieee80211 phy5: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:07 rainbow kernel: [ 2849.321985] ieee80211 phy5: U iwl3945_mac_config enter to channel 1
Mar 16 20:55:07 rainbow kernel: [ 2849.321998] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:07 rainbow kernel: [ 2849.322001] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:07 rainbow kernel: [ 2849.322003] * channel = 1
Mar 16 20:55:07 rainbow kernel: [ 2849.322004] * bssid = 00:00:00:00:00:00
Mar 16 20:55:07 rainbow kernel: [ 2849.322061] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.332791] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.335587] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:07 rainbow kernel: [ 2849.335602] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.338413] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:07 rainbow kernel: [ 2849.338429] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.341697] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:07 rainbow kernel: [ 2849.344927] ieee80211 phy5: U iwl3945_mac_config leave
Mar 16 20:55:07 rainbow kernel: [ 2849.344934] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:07 rainbow kernel: [ 2849.344939] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:07 rainbow kernel: [ 2849.344943] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:07 rainbow kernel: [ 2849.344947] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:07 rainbow kernel: [ 2849.344951] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:07 rainbow kernel: [ 2849.344955] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:07 rainbow kernel: [ 2849.344959] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:07 rainbow kernel: [ 2849.344963] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:07 rainbow kernel: [ 2849.344977] ieee80211 phy5: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:07 rainbow kernel: [ 2849.345008] ieee80211 phy5: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:07 rainbow kernel: [ 2849.346848] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar 16 20:55:07 rainbow kernel: [ 2849.346855] ieee80211 phy5: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:07 rainbow kernel: [ 2849.351612] ieee80211 phy5: U iwl3945_mac_hw_scan enter
Mar 16 20:55:07 rainbow kernel: [ 2849.351621] ieee80211 phy5: U iwl3945_scan_initiate Starting scan...
Mar 16 20:55:07 rainbow kernel: [ 2849.351632] ieee80211 phy5: U iwl3945_mac_hw_scan leave
Mar 16 20:55:07 rainbow kernel: [ 2849.351699] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:08 rainbow kernel: [ 2849.759334] ieee80211 phy5: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 408ms
Mar 16 20:55:09 rainbow kernel: [ 2851.238123] ieee80211 phy5: I iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1480ms
Mar 16 20:55:09 rainbow kernel: [ 2851.238133] ieee80211 phy5: I iwl3945_rx_scan_complete_notif Setting scan to off
Mar 16 20:55:09 rainbow kernel: [ 2851.238138] ieee80211 phy5: I iwl3945_rx_scan_complete_notif Scan took 1888ms
Mar 16 20:55:09 rainbow kernel: [ 2851.238160] ieee80211 phy5: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:55:09 rainbow kernel: [ 2851.238191] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.244528] ieee80211 phy5: U iwl3945_mac_config enter to channel 11
Mar 16 20:55:09 rainbow kernel: [ 2851.244537] ieee80211 phy5: U iwl3945_set_rxon_channel Staging channel set to 11 [0]
Mar 16 20:55:09 rainbow kernel: [ 2851.244551] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:09 rainbow kernel: [ 2851.244554] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:09 rainbow kernel: [ 2851.244555] * channel = 11
Mar 16 20:55:09 rainbow kernel: [ 2851.244557] * bssid = 00:00:00:00:00:00
Mar 16 20:55:09 rainbow kernel: [ 2851.244611] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.256397] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.259071] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:09 rainbow kernel: [ 2851.259086] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.262009] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:09 rainbow kernel: [ 2851.262027] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.264651] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.267876] ieee80211 phy5: U iwl3945_mac_config leave
Mar 16 20:55:09 rainbow kernel: [ 2851.267889] ieee80211 phy5: U iwl3945_mac_config_interface bssid: 00:30:bd:c0:90:24
Mar 16 20:55:09 rainbow kernel: [ 2851.267899] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:09 rainbow kernel: [ 2851.267901] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:09 rainbow kernel: [ 2851.267903] * channel = 11
Mar 16 20:55:09 rainbow kernel: [ 2851.267904] * bssid = 00:30:bd:c0:90:24
Mar 16 20:55:09 rainbow kernel: [ 2851.267917] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.270805] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.273590] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:09 rainbow kernel: [ 2851.273605] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.276389] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:09 rainbow kernel: [ 2851.276404] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.279592] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:09 rainbow kernel: [ 2851.282750] ieee80211 phy5: U iwl3945_mac_config_interface leave
Mar 16 20:55:09 rainbow kernel: [ 2851.282758] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:09 rainbow kernel: [ 2851.282763] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:09 rainbow kernel: [ 2851.282766] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:09 rainbow kernel: [ 2851.282770] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:09 rainbow kernel: [ 2851.282774] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:09 rainbow kernel: [ 2851.282778] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:09 rainbow kernel: [ 2851.282782] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:09 rainbow kernel: [ 2851.282786] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:09 rainbow kernel: [ 2851.282792] ieee80211 phy5: U iwl3945_mac_reset_tsf enter
Mar 16 20:55:09 rainbow kernel: [ 2851.282797] ieee80211 phy5: U iwl_reset_qos set QoS to default 
Mar 16 20:55:09 rainbow kernel: [ 2851.282806] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:09 rainbow kernel: [ 2851.282808] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:09 rainbow kernel: [ 2851.282810] * channel = 11
Mar 16 20:55:09 rainbow kernel: [ 2851.282811] * bssid = 00:30:bd:c0:90:24
Mar 16 20:55:09 rainbow kernel: [ 2851.282824] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:10 rainbow kernel: [ 2851.788102] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 20:55:10 rainbow kernel: [ 2851.788111] iwl3945 0000:03:00.0: Error setting Tx power (-110).
Mar 16 20:55:10 rainbow kernel: [ 2851.788118] ieee80211 phy5: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 20:55:10 rainbow kernel: [ 2851.788128] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar 16 20:55:10 rainbow kernel: [ 2851.788149] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:10 rainbow kernel: [ 2851.788207] ieee80211 phy5: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:10 rainbow kernel: [ 2851.788219] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:10 rainbow kernel: [ 2851.798663] ieee80211 phy5: I iwl3945_rx_reply_tx Tx queue reclaim 0
Mar 16 20:55:10 rainbow kernel: [ 2851.988072] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar 16 20:55:10 rainbow kernel: [ 2851.988098] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:10 rainbow kernel: [ 2851.988142] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:10 rainbow kernel: [ 2851.988239] ieee80211 phy5: I iwl3945_rx_reply_tx Tx queue reclaim 1
Mar 16 20:55:10 rainbow kernel: [ 2852.188104] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar 16 20:55:10 rainbow kernel: [ 2852.188123] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:10 rainbow kernel: [ 2852.188188] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:10 rainbow kernel: [ 2852.188210] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
Mar 16 20:55:10 rainbow kernel: [ 2852.188241] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
Mar 16 20:55:10 rainbow kernel: [ 2852.188245] iwl3945 0000:03:00.0: Status: 0x000302E4, count: 1
Mar 16 20:55:10 rainbow kernel: [ 2852.188250] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Mar 16 20:55:10 rainbow kernel: [ 2852.188324] iwl3945 0000:03:00.0: SYSASSERT     (#5) 0000392116 0x0089A 0x0025E 0x00300 0x04BC6 78
Mar 16 20:55:10 rainbow kernel: [ 2852.188327] 
Mar 16 20:55:10 rainbow kernel: [ 2852.188391] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 15
Mar 16 20:55:10 rainbow kernel: [ 2852.188426] iwl3945 0000:03:00.0: 0000004129^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188459] iwl3945 0000:03:00.0: 0000004133^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188493] iwl3945 0000:03:00.0: 0000004138^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188526] iwl3945 0000:03:00.0: 0000004142^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188559] iwl3945 0000:03:00.0: 0000004146^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188592] iwl3945 0000:03:00.0: 0000004151^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188625] iwl3945 0000:03:00.0: 0000004155^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188658] iwl3945 0000:03:00.0: 0000004159^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188691] iwl3945 0000:03:00.0: 0000004163^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188725] iwl3945 0000:03:00.0: 0000004168^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188757] iwl3945 0000:03:00.0: 0000004172^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188791] iwl3945 0000:03:00.0: 0000004176^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188824] iwl3945 0000:03:00.0: 0000004180^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188857] iwl3945 0000:03:00.0: 0000004185^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188890] iwl3945 0000:03:00.0: 0000004189^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188923] iwl3945 0000:03:00.0: 0000004193^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188957] iwl3945 0000:03:00.0: 0000004198^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.188990] iwl3945 0000:03:00.0: 0000004202^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189023] iwl3945 0000:03:00.0: 0000004206^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189056] iwl3945 0000:03:00.0: 0000004210^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189089] iwl3945 0000:03:00.0: 0000004215^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189122] iwl3945 0000:03:00.0: 0000004219^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189156] iwl3945 0000:03:00.0: 0000004223^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189189] iwl3945 0000:03:00.0: 0000004227^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189222] iwl3945 0000:03:00.0: 0000004232^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189255] iwl3945 0000:03:00.0: 0000004236^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189287] iwl3945 0000:03:00.0: 0000004240^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189321] iwl3945 0000:03:00.0: 0000004245^I0x00000001^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189354] iwl3945 0000:03:00.0: 0000004245^I0x0000000f^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.189387] iwl3945 0000:03:00.0: 0000004247^I0x000003ac^I1105
Mar 16 20:55:10 rainbow kernel: [ 2852.189420] iwl3945 0000:03:00.0: 0000004250^I0x000004e8^I1115
Mar 16 20:55:10 rainbow kernel: [ 2852.189453] iwl3945 0000:03:00.0: 0000004254^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.189486] iwl3945 0000:03:00.0: 0000004255^I0x0000000b^I0462
Mar 16 20:55:10 rainbow kernel: [ 2852.189520] iwl3945 0000:03:00.0: 0000004267^I0x0000010c^I0601
Mar 16 20:55:10 rainbow kernel: [ 2852.189553] iwl3945 0000:03:00.0: 0000004277^I0x04200047^I0401
Mar 16 20:55:10 rainbow kernel: [ 2852.189586] iwl3945 0000:03:00.0: 0000004287^I0x0000010f^I0603
Mar 16 20:55:10 rainbow kernel: [ 2852.189619] iwl3945 0000:03:00.0: 0000004359^I0x00000180^I0604
Mar 16 20:55:10 rainbow kernel: [ 2852.189652] iwl3945 0000:03:00.0: 0000004361^I0x0000019c^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.189685] iwl3945 0000:03:00.0: 0000004362^I0x00017ef7^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.189718] iwl3945 0000:03:00.0: 0000004363^I0x00000000^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.189751] iwl3945 0000:03:00.0: 0000004411^I0x00000500^I0600
Mar 16 20:55:10 rainbow kernel: [ 2852.189785] iwl3945 0000:03:00.0: 0000005913^I0x000001ed^I0616
Mar 16 20:55:10 rainbow kernel: [ 2852.189818] iwl3945 0000:03:00.0: 0000004405^I0x00017ecb^I0638
Mar 16 20:55:10 rainbow kernel: [ 2852.189851] iwl3945 0000:03:00.0: 0000004828^I0x0000001c^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.189884] iwl3945 0000:03:00.0: 0000004861^I0x0000001a^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.189917] iwl3945 0000:03:00.0: 0000004888^I0x000000ff^I1103
Mar 16 20:55:10 rainbow kernel: [ 2852.189950] iwl3945 0000:03:00.0: 0000004889^I0xffff9111^I1103
Mar 16 20:55:10 rainbow kernel: [ 2852.189983] iwl3945 0000:03:00.0: 0000004891^I0x00000010^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.190016] iwl3945 0000:03:00.0: 0000004909^I0x00000011^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.190049] iwl3945 0000:03:00.0: 0000004922^I0x00000000^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.190082] iwl3945 0000:03:00.0: 0000004923^I0x00000000^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.190115] iwl3945 0000:03:00.0: 0000004925^I0x000001d8^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.190148] iwl3945 0000:03:00.0: 0000004927^I0x00000065^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.190181] iwl3945 0000:03:00.0: 0000004929^I0x0000000e^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.190215] iwl3945 0000:03:00.0: 0000004930^I0x00680034^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190248] iwl3945 0000:03:00.0: 0000004931^I0x00670035^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190281] iwl3945 0000:03:00.0: 0000004933^I0x007e0036^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190314] iwl3945 0000:03:00.0: 0000004935^I0x007c0037^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190347] iwl3945 0000:03:00.0: 0000004936^I0x00000038^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190380] iwl3945 0000:03:00.0: 0000004938^I0x00840052^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190412] iwl3945 0000:03:00.0: 0000004939^I0x00840053^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190445] iwl3945 0000:03:00.0: 0000004941^I0x007e0054^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190478] iwl3945 0000:03:00.0: 0000004942^I0x007d0055^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190511] iwl3945 0000:03:00.0: 0000004944^I0x00000056^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190544] iwl3945 0000:03:00.0: 0000004945^I0x00007050^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190577] iwl3945 0000:03:00.0: 0000004947^I0x00017051^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190610] iwl3945 0000:03:00.0: 0000004949^I0x00008204^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190643] iwl3945 0000:03:00.0: 0000004951^I0x00018205^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190675] iwl3945 0000:03:00.0: 0000004954^I0x00000001^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.190708] iwl3945 0000:03:00.0: 0000004955^I0x008b0063^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190742] iwl3945 0000:03:00.0: 0000004957^I0x0000001d^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.190775] iwl3945 0000:03:00.0: 0000004959^I0x00000069^I1114
Mar 16 20:55:10 rainbow kernel: [ 2852.190808] iwl3945 0000:03:00.0: 0000004980^I0x0000020f^I0605
Mar 16 20:55:10 rainbow kernel: [ 2852.190841] iwl3945 0000:03:00.0: 0000004981^I0x0000026b^I0621
Mar 16 20:55:10 rainbow kernel: [ 2852.190874] iwl3945 0000:03:00.0: 0000004985^I0x0000010b^I1108
Mar 16 20:55:10 rainbow kernel: [ 2852.190907] iwl3945 0000:03:00.0: 0000004987^I0x0000000e^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.190940] iwl3945 0000:03:00.0: 0000004988^I0x00680034^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.190973] iwl3945 0000:03:00.0: 0000004989^I0x00670035^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191007] iwl3945 0000:03:00.0: 0000004991^I0x007e0036^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191039] iwl3945 0000:03:00.0: 0000004992^I0x007c0037^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191073] iwl3945 0000:03:00.0: 0000004994^I0x00000038^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191106] iwl3945 0000:03:00.0: 0000004995^I0x00840052^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191139] iwl3945 0000:03:00.0: 0000004997^I0x00840053^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191171] iwl3945 0000:03:00.0: 0000004998^I0x007e0054^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191204] iwl3945 0000:03:00.0: 0000005000^I0x007d0055^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191237] iwl3945 0000:03:00.0: 0000005001^I0x00000056^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191270] iwl3945 0000:03:00.0: 0000005003^I0x00007050^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191303] iwl3945 0000:03:00.0: 0000005005^I0x00017051^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191336] iwl3945 0000:03:00.0: 0000005007^I0x00008204^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191369] iwl3945 0000:03:00.0: 0000005009^I0x00018205^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191402] iwl3945 0000:03:00.0: 0000005012^I0x00000001^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.191434] iwl3945 0000:03:00.0: 0000005013^I0x008b0063^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191467] iwl3945 0000:03:00.0: 0000005015^I0x0000001c^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.191500] iwl3945 0000:03:00.0: 0000005016^I0x00000002^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.191533] iwl3945 0000:03:00.0: 0000005017^I0x0083903f^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191566] iwl3945 0000:03:00.0: 0000005019^I0x0001d213^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191598] iwl3945 0000:03:00.0: 0000005022^I0x00000002^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.191632] iwl3945 0000:03:00.0: 0000005023^I0x0003d206^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191665] iwl3945 0000:03:00.0: 0000005025^I0x0083903e^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.191698] iwl3945 0000:03:00.0: 0000005029^I0x00000059^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.191731] iwl3945 0000:03:00.0: 0000005129^I0x00000013^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.191764] iwl3945 0000:03:00.0: 0000005147^I0x00000005^I1107
Mar 16 20:55:10 rainbow kernel: [ 2852.191797] iwl3945 0000:03:00.0: 0000005715^I0x000179ae^I1110
Mar 16 20:55:10 rainbow kernel: [ 2852.191830] iwl3945 0000:03:00.0: 0000005726^I0xffffff4d^I0454
Mar 16 20:55:10 rainbow kernel: [ 2852.191863] iwl3945 0000:03:00.0: 0000005727^I0x00000000^I0472
Mar 16 20:55:10 rainbow kernel: [ 2852.191897] iwl3945 0000:03:00.0: 0000005737^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.191930] iwl3945 0000:03:00.0: 0000005740^I0xffffff4d^I1111
Mar 16 20:55:10 rainbow kernel: [ 2852.191963] iwl3945 0000:03:00.0: 0000005745^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.191996] iwl3945 0000:03:00.0: 0000005745^I0x0000000e^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192029] iwl3945 0000:03:00.0: 0000005750^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192062] iwl3945 0000:03:00.0: 0000005754^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005758^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005762^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005767^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005771^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005775^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005780^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005784^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005788^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005792^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005797^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005801^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005805^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005809^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005814^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005818^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005822^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005827^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005831^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005835^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005839^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005844^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005848^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005852^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005856^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005861^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005865^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005869^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005874^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005878^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005882^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005886^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005891^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005895^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005899^I0x00000001^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005900^I0x0000000f^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005902^I0x00000396^I1105
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005905^I0x000004e8^I1115
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005909^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005910^I0x0000000b^I0462
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005921^I0x0000010c^I0601
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005932^I0x04210047^I0401
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000005942^I0x0000010f^I0603
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006014^I0x00000180^I0604
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006016^I0x0000019c^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006017^I0x00017880^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006018^I0x00000000^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006066^I0x00000500^I0600
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007568^I0x000001ed^I0616
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006060^I0x00017854^I0638
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006083^I0x0000001c^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006116^I0x0000001a^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006143^I0x000000ff^I1103
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006144^I0xffff9111^I1103
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006146^I0x00000010^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006164^I0x00000011^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006177^I0x00000000^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006178^I0x00000000^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006180^I0x000001d8^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006182^I0x00000065^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006184^I0x0000000e^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006185^I0x00680034^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006187^I0x00670035^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006188^I0x007e0036^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006190^I0x007c0037^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006191^I0x00000038^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006193^I0x00840052^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006194^I0x00840053^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006196^I0x007e0054^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006197^I0x007d0055^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006199^I0x00000056^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006200^I0x00007050^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006202^I0x00017051^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006204^I0x00008204^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006206^I0x00018205^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006209^I0x00000001^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006210^I0x008b0063^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006212^I0x0000001d^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006214^I0x00000069^I1114
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006235^I0x0000020f^I0605
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006236^I0x0000026b^I0621
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006240^I0x0000010b^I1108
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006242^I0x0000000e^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006243^I0x00680034^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006244^I0x00670035^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006246^I0x007e0036^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006247^I0x007c0037^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006249^I0x00000038^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006250^I0x00840052^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006252^I0x00840053^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006253^I0x007e0054^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006255^I0x007d0055^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006256^I0x00000056^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006258^I0x00007050^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006260^I0x00017051^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006262^I0x00008204^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006264^I0x00018205^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006267^I0x00000001^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006268^I0x008b0063^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006270^I0x0000001c^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006271^I0x00000002^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006272^I0x0083903f^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006274^I0x0001d213^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006277^I0x00000002^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006278^I0x0003d206^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006280^I0x0083903e^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006284^I0x00000059^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006384^I0x00000013^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006402^I0x00000005^I1107
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006970^I0x000174c7^I1110
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006981^I0xffffff4d^I0454
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006982^I0x00000000^I0472
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006992^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000006995^I0xffffff4d^I1111
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007000^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007000^I0x0000000e^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007005^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007009^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007013^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007017^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007022^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007026^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007030^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007035^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007039^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007043^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007047^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007052^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007056^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007060^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007064^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007069^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007073^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007077^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007082^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007086^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007090^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007094^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007099^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007103^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007107^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007111^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007116^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007120^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007124^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007129^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007133^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007137^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007141^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007146^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007150^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007154^I0x00000001^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007155^I0x0000000f^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007157^I0x00000396^I1105
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007160^I0x000004e8^I1115
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007164^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007165^I0x0000000b^I0462
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007176^I0x0000010c^I0601
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007187^I0x04220010^I0401
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007244^I0x00000175^I1005
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007245^I0x00000000^I1001
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000007245^I0x00000000^I1002
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000012^I0x000001b8^I1005
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000040^I0x000000aa^I0103
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000048^I0x0000010f^I0603
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000072^I0x00000180^I0604
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000073^I0x0000019c^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000074^I0x00018fb6^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000075^I0x00000000^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000124^I0x00000500^I0600
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001626^I0x000001ed^I0616
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000118^I0x00018f8a^I0638
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000141^I0x0000001c^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000174^I0x0000001a^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000201^I0x000000ff^I1103
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000202^I0xffff9111^I1103
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000204^I0x00000010^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000222^I0x00000011^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000235^I0x00000000^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000236^I0x00000000^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000238^I0x000001d8^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000240^I0x00000065^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000242^I0x0000000e^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000243^I0x00680034^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000244^I0x00670035^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000246^I0x007e0036^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000248^I0x007c0037^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000249^I0x00000038^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000251^I0x00840052^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000252^I0x00840053^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000254^I0x007e0054^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000255^I0x007d0055^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000257^I0x00000056^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000258^I0x00007050^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000260^I0x00017051^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000262^I0x00008204^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000264^I0x00018205^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000267^I0x00000001^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000268^I0x008b0063^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000270^I0x0000001d^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000272^I0x00000069^I1114
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000293^I0x0000020f^I0605
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000294^I0x0000026b^I0621
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000298^I0x0000010b^I1108
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000300^I0x0000000e^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000301^I0x00680034^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000302^I0x00670035^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000304^I0x007e0036^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000305^I0x007c0037^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000307^I0x00000038^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000308^I0x00840052^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000310^I0x00840053^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000311^I0x007e0054^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000313^I0x007d0055^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000314^I0x00000056^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000316^I0x00007050^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000318^I0x00017051^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000320^I0x00008204^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000322^I0x00018205^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000325^I0x00000001^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000326^I0x008b0063^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000328^I0x0000001c^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000329^I0x00000002^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000330^I0x0083903f^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000332^I0x0001d213^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000335^I0x00000002^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000336^I0x0003d206^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000338^I0x0083903e^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000342^I0x00000059^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000442^I0x00000013^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000000460^I0x00000005^I1107
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001028^I0x00018bfd^I1110
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001039^I0xffffff4d^I0454
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001040^I0x00000000^I0472
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001050^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001053^I0xffffff4d^I1111
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001058^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001058^I0x0000000e^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001063^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001067^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001071^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001075^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001080^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001084^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001088^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001093^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001097^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001101^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001105^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001110^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001114^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001118^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001122^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001127^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001131^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001135^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001140^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001144^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001148^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001152^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001157^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001161^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001165^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001169^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001174^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001178^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001182^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001187^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001191^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001195^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001199^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001204^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001208^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001212^I0x00000001^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001213^I0x0000000f^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001215^I0x00000396^I1105
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001218^I0x000004e8^I1115
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001222^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001223^I0x0000000b^I0462
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001234^I0x0000010c^I0601
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001252^I0x0000010f^I0603
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001327^I0x00000180^I0604
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001329^I0x0000019c^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001330^I0x00018acf^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001331^I0x00000000^I0610
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001379^I0x00000500^I0600
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001373^I0x00018aa3^I0638
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001385^I0x0000001c^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001417^I0x0000001a^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001445^I0x000000ff^I1103
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001446^I0xffff9111^I1103
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001447^I0x00000010^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001466^I0x00000011^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001479^I0x00000000^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001480^I0x00000000^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001482^I0x000001d8^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001484^I0x00000064^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001486^I0x0000000e^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001487^I0x00680034^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001488^I0x00670035^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001490^I0x007e0036^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001491^I0x007c0037^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001493^I0x00000038^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001494^I0x00840052^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001496^I0x00840053^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001497^I0x007e0054^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001499^I0x007d0055^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001500^I0x00000056^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001502^I0x00007050^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001504^I0x00017051^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001506^I0x00008204^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001508^I0x00018205^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001511^I0x00000001^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001512^I0x008b0063^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001514^I0x0000001c^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001516^I0x00000069^I1114
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001554^I0x02000000^I0600
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001560^I0x00000000^I0651
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001561^I0x00000259^I0605
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001563^I0x0000026b^I0621
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001566^I0x0000010b^I1108
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001568^I0x0000000e^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001569^I0x00680034^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001571^I0x00670035^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001572^I0x007e0036^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001574^I0x007c0037^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001575^I0x00000038^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001577^I0x00840052^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001578^I0x00840053^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001580^I0x007e0054^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001581^I0x007d0055^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001583^I0x00000056^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001584^I0x00007050^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001586^I0x00017051^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001588^I0x00008204^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001590^I0x00018205^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001593^I0x00000001^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001594^I0x008b0063^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001596^I0x0000001d^I1104
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001598^I0x00000002^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001599^I0x0083903f^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001601^I0x0001d213^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001604^I0x00000002^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001605^I0x0003d206^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001607^I0x0083903e^I1102
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001611^I0x00000059^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001711^I0x00000013^I1101
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000001728^I0x00000005^I1107
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002296^I0x00018709^I1110
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002307^I0xffffff49^I0454
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002308^I0x00000000^I0472
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002318^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002321^I0xffffff49^I1111
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002326^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002326^I0x0000000e^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002331^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002335^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002339^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002343^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002348^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002352^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002356^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002361^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002365^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002369^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002373^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002378^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002382^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002386^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002390^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002395^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002399^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002403^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002408^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002412^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002416^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002420^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002425^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002429^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002433^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002437^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002442^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002446^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002450^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002455^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002459^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002463^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002467^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002472^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002476^I0x00000000^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002480^I0x00000001^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002481^I0x0000000f^I1106
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002483^I0x00000396^I1105
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002486^I0x000004e8^I1115
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002490^I0x0000000b^I0463
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002491^I0x0000000b^I0462
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002502^I0x0000010c^I0601
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002544^I0x0001008b^I0250
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000002550^I0x0000001c^I0218
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000192131^I0x0001008b^I0250
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000392114^I0x00000002^I0123
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: 0000392117^I0x00000100^I0125
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] ieee80211 phy5: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
Mar 16 20:55:10 rainbow kernel: [ 2852.192080] iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd REPLY_TX (0x1C) seq 0x0001 ser 0x004E0000
Mar 16 20:55:10 rainbow kernel: [ 2852.215261] ieee80211 phy5: U __iwl3945_down iwl3945 is going down
Mar 16 20:55:10 rainbow kernel: [ 2852.219362] iwl3945 0000:03:00.0: Can't stop Rx DMA.
Mar 16 20:55:10 rainbow kernel: [ 2852.219423] ieee80211 phy5: U iwl3945_apm_stop_master stop master
Mar 16 20:55:10 rainbow kernel: [ 2852.219646] ieee80211 phy5: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Mar 16 20:55:10 rainbow kernel: [ 2852.219768] ieee80211 phy5: U iwl3945_hw_nic_init HW Revision ID = 0x2
Mar 16 20:55:10 rainbow kernel: [ 2852.219818] ieee80211 phy5: U iwl3945_nic_config 3945 RADIO-MM type
Mar 16 20:55:10 rainbow kernel: [ 2852.219830] ieee80211 phy5: U iwl3945_nic_config SKU OP mode is basic
Mar 16 20:55:10 rainbow kernel: [ 2852.219835] ieee80211 phy5: U iwl3945_nic_config 3945ABG revision is 0xF1
Mar 16 20:55:10 rainbow kernel: [ 2852.219846] ieee80211 phy5: U iwl3945_nic_config Card M type B version is 0x3
Mar 16 20:55:10 rainbow kernel: [ 2852.221157] ieee80211 phy5: U iwl3945_load_bsm Begin load bsm
Mar 16 20:55:10 rainbow kernel: [ 2852.222418] ieee80211 phy5: U iwl3945_verify_bsm Begin verify bsm
Mar 16 20:55:10 rainbow kernel: [ 2852.224639] ieee80211 phy5: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Mar 16 20:55:10 rainbow kernel: [ 2852.224696] ieee80211 phy5: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Mar 16 20:55:10 rainbow kernel: [ 2852.224714] ieee80211 phy5: U __iwl3945_up iwl3945 is coming up
Mar 16 20:55:10 rainbow kernel: [ 2852.236125] ieee80211 phy5: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Mar 16 20:55:10 rainbow kernel: [ 2852.236134] ieee80211 phy5: I iwl3945_rx_reply_alive Initialization Alive received.
Mar 16 20:55:10 rainbow kernel: [ 2852.245071] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 16 20:55:10 rainbow kernel: [ 2852.245168] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 16 20:55:10 rainbow kernel: [ 2852.245451] ieee80211 phy5: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Mar 16 20:55:10 rainbow kernel: [ 2852.245457] ieee80211 phy5: U iwl3945_init_alive_start Initialization Alive received.
Mar 16 20:55:10 rainbow kernel: [ 2852.245505] ieee80211 phy5: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Mar 16 20:55:10 rainbow kernel: [ 2852.249824] ieee80211 phy5: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Mar 16 20:55:10 rainbow kernel: [ 2852.249831] ieee80211 phy5: I iwl3945_rx_reply_alive Runtime Alive received.
Mar 16 20:55:10 rainbow kernel: [ 2852.249877] ieee80211 phy5: I iwl3945_disable_events Selected uCode log events may be disabled
Mar 16 20:55:10 rainbow kernel: [ 2852.249882] ieee80211 phy5: I iwl3945_disable_events   by writing "1"s into disable bitmap
Mar 16 20:55:10 rainbow kernel: [ 2852.249888] ieee80211 phy5: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Mar 16 20:55:10 rainbow kernel: [ 2852.256028] ieee80211 phy5: U iwl3945_alive_start Runtime Alive received.
Mar 16 20:55:10 rainbow kernel: [ 2852.256034] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 16 20:55:10 rainbow kernel: [ 2852.256118] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 16 20:55:10 rainbow kernel: [ 2852.256200] ieee80211 phy5: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Mar 16 20:55:10 rainbow kernel: [ 2852.263957] ieee80211 phy5: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Mar 16 20:55:10 rainbow kernel: [ 2852.263991] ieee80211 phy5: U iwl3945_alive_start RFKILL status: 0x1
Mar 16 20:55:10 rainbow kernel: [ 2852.264149] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:10 rainbow kernel: [ 2852.265988] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:10 rainbow kernel: [ 2852.265990] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:10 rainbow kernel: [ 2852.265992] * channel = 11
Mar 16 20:55:10 rainbow kernel: [ 2852.265993] * bssid = 00:00:00:00:00:00
Mar 16 20:55:10 rainbow kernel: [ 2852.266006] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:10 rainbow kernel: [ 2852.272101] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:10 rainbow kernel: [ 2852.272116] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:10 rainbow kernel: [ 2852.274843] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:10 rainbow kernel: [ 2852.274858] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:10 rainbow kernel: [ 2852.281266] ieee80211 phy5: U iwl3945_hw_reg_txpower_get_temperature Temperature: 78
Mar 16 20:55:10 rainbow kernel: [ 2852.281291] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:10 rainbow kernel: [ 2852.284600] Registered led device: iwl-phy5:radio
Mar 16 20:55:10 rainbow kernel: [ 2852.284614] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:10 rainbow kernel: [ 2852.284659] Registered led device: iwl-phy5:assoc
Mar 16 20:55:10 rainbow kernel: [ 2852.284693] Registered led device: iwl-phy5:RX
Mar 16 20:55:10 rainbow kernel: [ 2852.284726] Registered led device: iwl-phy5:TX
Mar 16 20:55:10 rainbow kernel: [ 2852.284731] ieee80211 phy5: U iwl3945_alive_start ALIVE processing complete.
Mar 16 20:55:10 rainbow kernel: [ 2852.408066] wlan0: authentication with AP 00:30:bd:c0:90:24 timed out
Mar 16 20:55:27 rainbow kernel: [ 2869.389766] ieee80211 phy5: U iwl3945_mac_hw_scan enter
Mar 16 20:55:27 rainbow kernel: [ 2869.389779] ieee80211 phy5: U iwl3945_scan_initiate Starting scan...
Mar 16 20:55:27 rainbow kernel: [ 2869.389788] ieee80211 phy5: U iwl3945_mac_hw_scan leave
Mar 16 20:55:27 rainbow kernel: [ 2869.389860] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:28 rainbow kernel: [ 2869.824095] ieee80211 phy5: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 436ms
Mar 16 20:55:29 rainbow kernel: [ 2871.302785] ieee80211 phy5: I iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1476ms
Mar 16 20:55:29 rainbow kernel: [ 2871.302795] ieee80211 phy5: I iwl3945_rx_scan_complete_notif Setting scan to off
Mar 16 20:55:29 rainbow kernel: [ 2871.302801] ieee80211 phy5: I iwl3945_rx_scan_complete_notif Scan took 1912ms
Mar 16 20:55:29 rainbow kernel: [ 2871.302825] ieee80211 phy5: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:55:29 rainbow kernel: [ 2871.302857] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.305547] ieee80211 phy5: U iwl3945_mac_config enter to channel 11
Mar 16 20:55:29 rainbow kernel: [ 2871.305565] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:29 rainbow kernel: [ 2871.305567] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:29 rainbow kernel: [ 2871.305569] * channel = 11
Mar 16 20:55:29 rainbow kernel: [ 2871.305570] * bssid = 00:00:00:00:00:00
Mar 16 20:55:29 rainbow kernel: [ 2871.305584] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.308503] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.311219] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:29 rainbow kernel: [ 2871.311234] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.313984] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:29 rainbow kernel: [ 2871.314000] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.317479] ieee80211 phy5: U iwl3945_mac_config leave
Mar 16 20:55:29 rainbow kernel: [ 2871.317620] ieee80211 phy5: U iwl3945_mac_config enter to channel 11
Mar 16 20:55:29 rainbow kernel: [ 2871.317628] ieee80211 phy5: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 20:55:29 rainbow kernel: [ 2871.317633] ieee80211 phy5: U iwl3945_mac_config leave
Mar 16 20:55:29 rainbow kernel: [ 2871.317639] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.317643] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.317647] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.317651] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.317655] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.317659] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.317663] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.317667] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.317672] ieee80211 phy5: U iwl3945_mac_reset_tsf enter
Mar 16 20:55:29 rainbow kernel: [ 2871.317677] ieee80211 phy5: U iwl_reset_qos set QoS to default 
Mar 16 20:55:29 rainbow kernel: [ 2871.317686] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:29 rainbow kernel: [ 2871.317689] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:29 rainbow kernel: [ 2871.317691] * channel = 11
Mar 16 20:55:29 rainbow kernel: [ 2871.317692] * bssid = 00:00:00:00:00:00
Mar 16 20:55:29 rainbow kernel: [ 2871.317706] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.321086] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.323131] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:29 rainbow kernel: [ 2871.323146] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.326306] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:29 rainbow kernel: [ 2871.326320] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.329465] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.332644] ieee80211 phy5: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 20:55:29 rainbow kernel: [ 2871.332653] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar 16 20:55:29 rainbow kernel: [ 2871.332671] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.332687] ieee80211 phy5: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.332698] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.332709] ieee80211 phy5: U iwl3945_mac_config enter to channel 11
Mar 16 20:55:29 rainbow kernel: [ 2871.332715] ieee80211 phy5: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 20:55:29 rainbow kernel: [ 2871.332720] ieee80211 phy5: U iwl3945_mac_config leave
Mar 16 20:55:29 rainbow kernel: [ 2871.332724] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.332729] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.332733] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.332737] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.332741] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.332745] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.332748] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.332753] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.332757] ieee80211 phy5: U iwl3945_mac_reset_tsf enter
Mar 16 20:55:29 rainbow kernel: [ 2871.332761] ieee80211 phy5: U iwl_reset_qos set QoS to default 
Mar 16 20:55:29 rainbow kernel: [ 2871.332769] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:29 rainbow kernel: [ 2871.332772] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:29 rainbow kernel: [ 2871.332773] * channel = 11
Mar 16 20:55:29 rainbow kernel: [ 2871.332775] * bssid = 00:00:00:00:00:00
Mar 16 20:55:29 rainbow kernel: [ 2871.332786] ieee80211 phy5: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:29 rainbow kernel: [ 2871.335746] ieee80211 phy5: I iwl3945_rx_reply_tx Tx queue reclaim 0
Mar 16 20:55:29 rainbow kernel: [ 2871.337152] ieee80211 phy5: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:29 rainbow kernel: [ 2871.337289] ieee80211 phy5: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:29 rainbow kernel: [ 2871.337551] ieee80211 phy5: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 20:55:29 rainbow kernel: [ 2871.337558] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar 16 20:55:29 rainbow kernel: [ 2871.337570] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.337606] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:29 rainbow kernel: [ 2871.536091] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar 16 20:55:29 rainbow kernel: [ 2871.536107] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:29 rainbow kernel: [ 2871.536149] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:30 rainbow kernel: [ 2871.736085] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar 16 20:55:30 rainbow kernel: [ 2871.736108] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:30 rainbow kernel: [ 2871.736150] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:30 rainbow kernel: [ 2871.937084] wlan0: authentication with AP 00:30:bd:c0:90:24 timed out
Mar 16 20:55:39 rainbow kernel: [ 2881.323366] ieee80211 phy5: U iwl3945_mac_hw_scan enter
Mar 16 20:55:39 rainbow kernel: [ 2881.323378] ieee80211 phy5: U iwl3945_scan_initiate Starting scan...
Mar 16 20:55:39 rainbow kernel: [ 2881.323388] ieee80211 phy5: U iwl3945_mac_hw_scan leave
Mar 16 20:55:40 rainbow kernel: [ 2881.821071] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 20:55:40 rainbow kernel: [ 2881.821084] ieee80211 phy5: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:55:40 rainbow kernel: [ 2882.320245] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 20:55:40 rainbow kernel: [ 2882.320269] ieee80211 phy5: U iwl3945_mac_config enter to channel 11
Mar 16 20:55:40 rainbow kernel: [ 2882.320279] ieee80211 phy5: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 20:55:40 rainbow kernel: [ 2882.320284] ieee80211 phy5: U iwl3945_mac_config leave
Mar 16 20:55:40 rainbow kernel: [ 2882.320667] ieee80211 phy5: U iwl3945_mac_config enter to channel 11
Mar 16 20:55:40 rainbow kernel: [ 2882.320674] ieee80211 phy5: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 20:55:40 rainbow kernel: [ 2882.320679] ieee80211 phy5: U iwl3945_mac_config leave
Mar 16 20:55:40 rainbow kernel: [ 2882.320686] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:40 rainbow kernel: [ 2882.320690] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:40 rainbow kernel: [ 2882.320694] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:40 rainbow kernel: [ 2882.320698] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:40 rainbow kernel: [ 2882.320702] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:40 rainbow kernel: [ 2882.320706] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:40 rainbow kernel: [ 2882.320710] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:40 rainbow kernel: [ 2882.320714] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:40 rainbow kernel: [ 2882.320720] ieee80211 phy5: U iwl3945_mac_reset_tsf enter
Mar 16 20:55:40 rainbow kernel: [ 2882.320725] ieee80211 phy5: U iwl_reset_qos set QoS to default 
Mar 16 20:55:40 rainbow kernel: [ 2882.320737] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:40 rainbow kernel: [ 2882.320739] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:40 rainbow kernel: [ 2882.320741] * channel = 11
Mar 16 20:55:40 rainbow kernel: [ 2882.320742] * bssid = 00:00:00:00:00:00
Mar 16 20:55:41 rainbow kernel: [ 2882.820064] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Mar 16 20:55:41 rainbow kernel: [ 2882.820073] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Mar 16 20:55:41 rainbow kernel: [ 2882.820079] ieee80211 phy5: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 20:55:41 rainbow kernel: [ 2882.820092] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 20:55:41 rainbow kernel: [ 2882.820113] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:41 rainbow kernel: [ 2882.820153] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:41 rainbow kernel: [ 2882.820206] ieee80211 phy5: U iwl3945_mac_config enter to channel 11
Mar 16 20:55:41 rainbow kernel: [ 2882.820214] ieee80211 phy5: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 20:55:41 rainbow kernel: [ 2882.820219] ieee80211 phy5: U iwl3945_mac_config leave
Mar 16 20:55:41 rainbow kernel: [ 2882.820223] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:41 rainbow kernel: [ 2882.820228] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:41 rainbow kernel: [ 2882.820232] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:41 rainbow kernel: [ 2882.820236] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:41 rainbow kernel: [ 2882.820239] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:41 rainbow kernel: [ 2882.820243] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:41 rainbow kernel: [ 2882.820247] ieee80211 phy5: U iwl3945_mac_conf_tx enter
Mar 16 20:55:41 rainbow kernel: [ 2882.820251] ieee80211 phy5: U iwl3945_mac_conf_tx leave
Mar 16 20:55:41 rainbow kernel: [ 2882.820256] ieee80211 phy5: U iwl3945_mac_reset_tsf enter
Mar 16 20:55:41 rainbow kernel: [ 2882.820261] ieee80211 phy5: U iwl_reset_qos set QoS to default 
Mar 16 20:55:41 rainbow kernel: [ 2882.820270] ieee80211 phy5: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:41 rainbow kernel: [ 2882.820272] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:41 rainbow kernel: [ 2882.820274] * channel = 11
Mar 16 20:55:41 rainbow kernel: [ 2882.820275] * bssid = 00:00:00:00:00:00
Mar 16 20:55:41 rainbow kernel: [ 2883.320076] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Mar 16 20:55:41 rainbow kernel: [ 2883.320087] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Mar 16 20:55:41 rainbow kernel: [ 2883.320093] ieee80211 phy5: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 20:55:41 rainbow kernel: [ 2883.320104] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 20:55:41 rainbow kernel: [ 2883.320128] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:41 rainbow kernel: [ 2883.320169] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:41 rainbow kernel: [ 2883.520080] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 20:55:41 rainbow kernel: [ 2883.520098] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:41 rainbow kernel: [ 2883.520139] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:42 rainbow kernel: [ 2883.720075] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 20:55:42 rainbow kernel: [ 2883.720105] ieee80211 phy5: I iwl3945_mac_tx enter
Mar 16 20:55:42 rainbow kernel: [ 2883.720150] ieee80211 phy5: I iwl3945_mac_tx leave
Mar 16 20:55:42 rainbow kernel: [ 2883.920083] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 20:55:48 rainbow kernel: [ 2890.275375] ieee80211 phy5: U iwl3945_pci_remove *** UNLOAD DRIVER ***
Mar 16 20:55:48 rainbow kernel: [ 2890.285073] ieee80211 phy5: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:48 rainbow kernel: [ 2890.313059] ieee80211 phy5: U iwl3945_mac_remove_interface enter
Mar 16 20:55:48 rainbow kernel: [ 2890.313067] ieee80211 phy5: U iwl3945_mac_remove_interface leave
Mar 16 20:55:48 rainbow kernel: [ 2890.328858] ieee80211 phy5: U iwl3945_mac_stop enter
Mar 16 20:55:48 rainbow kernel: [ 2890.328867] ieee80211 phy5: U __iwl3945_down iwl3945 is going down
Mar 16 20:55:48 rainbow kernel: [ 2890.338354] ieee80211 phy5: U iwl3945_apm_stop_master stop master
Mar 16 20:55:48 rainbow kernel: [ 2890.338581] ieee80211 phy5: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Mar 16 20:55:48 rainbow kernel: [ 2890.338901] ieee80211 phy5: U iwl3945_mac_stop leave
Mar 16 20:55:54 rainbow kernel: [ 2895.970089] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
Mar 16 20:55:54 rainbow kernel: [ 2895.970096] iwl3945: Copyright(c) 2003-2008 Intel Corporation
Mar 16 20:55:54 rainbow kernel: [ 2895.970294] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar 16 20:55:54 rainbow kernel: [ 2895.970314] iwl3945 0000:03:00.0: setting latency timer to 64
Mar 16 20:55:54 rainbow kernel: [ 2895.970527] ieee80211 phy6: U iwl3945_pci_probe pci_resource_len = 0x00001000
Mar 16 20:55:54 rainbow kernel: [ 2895.970536] ieee80211 phy6: U iwl3945_pci_probe pci_resource_base = ffffc200052bc000
Mar 16 20:55:54 rainbow kernel: [ 2896.015415] ieee80211 phy6: U iwl3945_pci_probe MAC address: 00:1f:3c:20:a1:6e
Mar 16 20:55:54 rainbow kernel: [ 2896.015431] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 20:55:54 rainbow kernel: [ 2896.015436] ieee80211 phy6: U iwl3945_init_channel_map Initializing regulatory info from EEPROM
Mar 16 20:55:54 rainbow kernel: [ 2896.015442] ieee80211 phy6: U iwl3945_init_channel_map Parsing data for 56 channels.
Mar 16 20:55:54 rainbow kernel: [ 2896.015522] ieee80211 phy6: U iwl3945_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015533] ieee80211 phy6: U iwl3945_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015541] ieee80211 phy6: U iwl3945_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015548] ieee80211 phy6: U iwl3945_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015556] ieee80211 phy6: U iwl3945_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015563] ieee80211 phy6: U iwl3945_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015571] ieee80211 phy6: U iwl3945_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015578] ieee80211 phy6: U iwl3945_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015586] ieee80211 phy6: U iwl3945_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015593] ieee80211 phy6: U iwl3945_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015601] ieee80211 phy6: U iwl3945_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015608] ieee80211 phy6: U iwl3945_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015613] ieee80211 phy6: U iwl3945_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015619] ieee80211 phy6: U iwl3945_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015624] ieee80211 phy6: U iwl3945_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015630] ieee80211 phy6: U iwl3945_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015635] ieee80211 phy6: U iwl3945_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015640] ieee80211 phy6: U iwl3945_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015646] ieee80211 phy6: U iwl3945_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015651] ieee80211 phy6: U iwl3945_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015656] ieee80211 phy6: U iwl3945_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015662] ieee80211 phy6: U iwl3945_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015667] ieee80211 phy6: U iwl3945_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015672] ieee80211 phy6: U iwl3945_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015677] ieee80211 phy6: U iwl3945_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015683] ieee80211 phy6: U iwl3945_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015688] ieee80211 phy6: U iwl3945_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015693] ieee80211 phy6: U iwl3945_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015700] ieee80211 phy6: U iwl3945_init_channel_map Ch. 36 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015707] ieee80211 phy6: U iwl3945_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015713] ieee80211 phy6: U iwl3945_init_channel_map Ch. 40 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015719] ieee80211 phy6: U iwl3945_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015726] ieee80211 phy6: U iwl3945_init_channel_map Ch. 44 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015732] ieee80211 phy6: U iwl3945_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015739] ieee80211 phy6: U iwl3945_init_channel_map Ch. 48 [5.2GHz] VALID WIDE DFS (0xa1 14dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015746] ieee80211 phy6: U iwl3945_init_channel_map Ch. 52 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015754] ieee80211 phy6: U iwl3945_init_channel_map Ch. 56 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015762] ieee80211 phy6: U iwl3945_init_channel_map Ch. 60 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015769] ieee80211 phy6: U iwl3945_init_channel_map Ch. 64 [5.2GHz] VALID RADAR WIDE DFS (0xb1 14dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015776] ieee80211 phy6: U iwl3945_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015781] ieee80211 phy6: U iwl3945_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015786] ieee80211 phy6: U iwl3945_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015792] ieee80211 phy6: U iwl3945_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015797] ieee80211 phy6: U iwl3945_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015802] ieee80211 phy6: U iwl3945_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015807] ieee80211 phy6: U iwl3945_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015813] ieee80211 phy6: U iwl3945_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015818] ieee80211 phy6: U iwl3945_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015823] ieee80211 phy6: U iwl3945_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015829] ieee80211 phy6: U iwl3945_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015834] ieee80211 phy6: U iwl3945_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
Mar 16 20:55:54 rainbow kernel: [ 2896.015841] ieee80211 phy6: U iwl3945_init_channel_map Ch. 149 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015848] ieee80211 phy6: U iwl3945_init_channel_map Ch. 153 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015855] ieee80211 phy6: U iwl3945_init_channel_map Ch. 157 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015862] ieee80211 phy6: U iwl3945_init_channel_map Ch. 161 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015869] ieee80211 phy6: U iwl3945_init_channel_map Ch. 165 [5.2GHz] VALID WIDE (0x21 16dBm): Ad-Hoc not supported
Mar 16 20:55:54 rainbow kernel: [ 2896.015882] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 260
Mar 16 20:55:54 rainbow kernel: [ 2896.015913] ieee80211 phy6: U iwl3945_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015919] ieee80211 phy6: U iwl3945_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015925] ieee80211 phy6: U iwl3945_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015930] ieee80211 phy6: U iwl3945_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015936] ieee80211 phy6: U iwl3945_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015942] ieee80211 phy6: U iwl3945_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015947] ieee80211 phy6: U iwl3945_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015953] ieee80211 phy6: U iwl3945_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015959] ieee80211 phy6: U iwl3945_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015965] ieee80211 phy6: U iwl3945_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015970] ieee80211 phy6: U iwl3945_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=00
Mar 16 20:55:54 rainbow kernel: [ 2896.015977] ieee80211 phy6: U iwl3945_init_geos Channel 36 Freq=5180[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.015983] ieee80211 phy6: U iwl3945_init_geos Channel 40 Freq=5200[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.015989] ieee80211 phy6: U iwl3945_init_geos Channel 44 Freq=5220[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.015994] ieee80211 phy6: U iwl3945_init_geos Channel 48 Freq=5240[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.016000] ieee80211 phy6: U iwl3945_init_geos Channel 52 Freq=5260[5.2GHz] valid flag=0E
Mar 16 20:55:54 rainbow kernel: [ 2896.016029] ieee80211 phy6: U iwl3945_init_geos Channel 56 Freq=5280[5.2GHz] valid flag=0E
Mar 16 20:55:54 rainbow kernel: [ 2896.016035] ieee80211 phy6: U iwl3945_init_geos Channel 60 Freq=5300[5.2GHz] valid flag=0E
Mar 16 20:55:54 rainbow kernel: [ 2896.016041] ieee80211 phy6: U iwl3945_init_geos Channel 64 Freq=5320[5.2GHz] valid flag=0E
Mar 16 20:55:54 rainbow kernel: [ 2896.016047] ieee80211 phy6: U iwl3945_init_geos Channel 149 Freq=5745[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.016053] ieee80211 phy6: U iwl3945_init_geos Channel 153 Freq=5765[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.016059] ieee80211 phy6: U iwl3945_init_geos Channel 157 Freq=5785[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.016064] ieee80211 phy6: U iwl3945_init_geos Channel 161 Freq=5805[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.016070] ieee80211 phy6: U iwl3945_init_geos Channel 165 Freq=5825[5.2GHz] valid flag=06
Mar 16 20:55:54 rainbow kernel: [ 2896.016076] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
Mar 16 20:55:54 rainbow kernel: [ 2896.016081] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
Mar 16 20:55:54 rainbow kernel: [ 2896.017098] ieee80211 phy6: U iwl3945_set_rxon_channel Staging channel set to 6 [0]
Mar 16 20:55:54 rainbow kernel: [ 2896.018956] phy6: Selected rate control algorithm 'iwl-3945-rs'
Mar 16 20:55:58 rainbow kernel: [ 2900.083444] ieee80211 phy6: U iwl3945_mac_start enter
Mar 16 20:55:58 rainbow kernel: [ 2900.083471] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar 16 20:55:58 rainbow kernel: [ 2900.083829] iwl3945 0000:03:00.0: irq 2295 for MSI/MSI-X
Mar 16 20:55:58 rainbow kernel: [ 2900.083941] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
Mar 16 20:55:58 rainbow kernel: [ 2900.090821] ieee80211 phy6: U iwl3945_read_ucode Got firmware 'iwlwifi-3945-2.ucode' file (149816 bytes) from disk
Mar 16 20:55:58 rainbow kernel: [ 2900.090831] iwl3945 0000:03:00.0: loaded firmware version 15.28.2.8
Mar 16 20:55:58 rainbow kernel: [ 2900.090836] ieee80211 phy6: U iwl3945_read_ucode f/w package hdr ucode version raw = 0xf1c0208
Mar 16 20:55:58 rainbow kernel: [ 2900.090842] ieee80211 phy6: U iwl3945_read_ucode f/w package hdr runtime inst size = 80684
Mar 16 20:55:58 rainbow kernel: [ 2900.090847] ieee80211 phy6: U iwl3945_read_ucode f/w package hdr runtime data size = 32768
Mar 16 20:55:58 rainbow kernel: [ 2900.090853] ieee80211 phy6: U iwl3945_read_ucode f/w package hdr init inst size = 2672
Mar 16 20:55:58 rainbow kernel: [ 2900.090858] ieee80211 phy6: U iwl3945_read_ucode f/w package hdr init data size = 32768
Mar 16 20:55:58 rainbow kernel: [ 2900.090863] ieee80211 phy6: U iwl3945_read_ucode f/w package hdr boot inst size = 900
Mar 16 20:55:58 rainbow kernel: [ 2900.091005] ieee80211 phy6: U iwl3945_read_ucode Copying (but not loading) uCode instr len 80684
Mar 16 20:55:58 rainbow kernel: [ 2900.091047] ieee80211 phy6: U iwl3945_read_ucode uCode instr buf vaddr = 0xffff88008f080000, paddr = 0x8f080000
Mar 16 20:55:58 rainbow kernel: [ 2900.091053] ieee80211 phy6: U iwl3945_read_ucode Copying (but not loading) uCode data len 32768
Mar 16 20:55:58 rainbow kernel: [ 2900.091104] ieee80211 phy6: U iwl3945_read_ucode Copying (but not loading) init instr len 2672
Mar 16 20:55:58 rainbow kernel: [ 2900.091112] ieee80211 phy6: U iwl3945_read_ucode Copying (but not loading) init data len 32768
Mar 16 20:55:58 rainbow kernel: [ 2900.091140] ieee80211 phy6: U iwl3945_read_ucode Copying (but not loading) boot instr len 900
Mar 16 20:55:58 rainbow kernel: [ 2900.091275] ieee80211 phy6: U iwl3945_hw_nic_init HW Revision ID = 0x2
Mar 16 20:55:58 rainbow kernel: [ 2900.091325] ieee80211 phy6: U iwl3945_nic_config 3945 RADIO-MM type
Mar 16 20:55:58 rainbow kernel: [ 2900.091336] ieee80211 phy6: U iwl3945_nic_config SKU OP mode is basic
Mar 16 20:55:58 rainbow kernel: [ 2900.091341] ieee80211 phy6: U iwl3945_nic_config 3945ABG revision is 0xF1
Mar 16 20:55:58 rainbow kernel: [ 2900.091351] ieee80211 phy6: U iwl3945_nic_config Card M type B version is 0x3
Mar 16 20:55:58 rainbow kernel: [ 2900.092519] ieee80211 phy6: U iwl3945_load_bsm Begin load bsm
Mar 16 20:55:58 rainbow kernel: [ 2900.093779] ieee80211 phy6: U iwl3945_verify_bsm Begin verify bsm
Mar 16 20:55:58 rainbow kernel: [ 2900.095984] ieee80211 phy6: U iwl3945_verify_bsm BSM bootstrap uCode image OK
Mar 16 20:55:58 rainbow kernel: [ 2900.096065] ieee80211 phy6: U iwl3945_load_bsm BSM write complete, poll 1 iterations
Mar 16 20:55:58 rainbow kernel: [ 2900.096083] ieee80211 phy6: U __iwl3945_up iwl3945 is coming up
Mar 16 20:55:58 rainbow kernel: [ 2900.096088] ieee80211 phy6: U iwl3945_mac_start Start UP work.
Mar 16 20:55:58 rainbow kernel: [ 2900.107548] ieee80211 phy6: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
Mar 16 20:55:58 rainbow kernel: [ 2900.107557] ieee80211 phy6: I iwl3945_rx_reply_alive Initialization Alive received.
Mar 16 20:55:58 rainbow kernel: [ 2900.113078] ieee80211 phy6: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 16 20:55:58 rainbow kernel: [ 2900.113172] ieee80211 phy6: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 16 20:55:58 rainbow kernel: [ 2900.113455] ieee80211 phy6: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
Mar 16 20:55:58 rainbow kernel: [ 2900.113461] ieee80211 phy6: U iwl3945_init_alive_start Initialization Alive received.
Mar 16 20:55:58 rainbow kernel: [ 2900.113509] ieee80211 phy6: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
Mar 16 20:55:58 rainbow kernel: [ 2900.117886] ieee80211 phy6: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
Mar 16 20:55:58 rainbow kernel: [ 2900.117894] ieee80211 phy6: I iwl3945_rx_reply_alive Runtime Alive received.
Mar 16 20:55:58 rainbow kernel: [ 2900.117940] ieee80211 phy6: I iwl3945_disable_events Selected uCode log events may be disabled
Mar 16 20:55:58 rainbow kernel: [ 2900.117945] ieee80211 phy6: I iwl3945_disable_events   by writing "1"s into disable bitmap
Mar 16 20:55:58 rainbow kernel: [ 2900.117952] ieee80211 phy6: I iwl3945_disable_events   in SRAM at 0x8022c8, size 47 u32s
Mar 16 20:55:58 rainbow kernel: [ 2900.124092] ieee80211 phy6: U iwl3945_alive_start Runtime Alive received.
Mar 16 20:55:58 rainbow kernel: [ 2900.124098] ieee80211 phy6: U iwl3945_verify_inst_sparse ucode inst image size is 900
Mar 16 20:55:58 rainbow kernel: [ 2900.124183] ieee80211 phy6: U iwl3945_verify_inst_sparse ucode inst image size is 2672
Mar 16 20:55:58 rainbow kernel: [ 2900.124266] ieee80211 phy6: U iwl3945_verify_inst_sparse ucode inst image size is 80684
Mar 16 20:55:58 rainbow kernel: [ 2900.132024] ieee80211 phy6: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
Mar 16 20:55:58 rainbow kernel: [ 2900.132057] ieee80211 phy6: U iwl3945_alive_start RFKILL status: 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.132223] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.134092] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:58 rainbow kernel: [ 2900.134094] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:58 rainbow kernel: [ 2900.134096] * channel = 1
Mar 16 20:55:58 rainbow kernel: [ 2900.134097] * bssid = 00:00:00:00:00:00
Mar 16 20:55:58 rainbow kernel: [ 2900.134110] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.137237] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.140577] ieee80211 phy6: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:58 rainbow kernel: [ 2900.140590] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.143471] ieee80211 phy6: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:58 rainbow kernel: [ 2900.143486] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.146363] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.149741] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 80
Mar 16 20:55:58 rainbow kernel: [ 2900.149767] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.152758] Registered led device: iwl-phy6:radio
Mar 16 20:55:58 rainbow kernel: [ 2900.152772] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.152816] Registered led device: iwl-phy6:assoc
Mar 16 20:55:58 rainbow kernel: [ 2900.152851] Registered led device: iwl-phy6:RX
Mar 16 20:55:58 rainbow kernel: [ 2900.152885] Registered led device: iwl-phy6:TX
Mar 16 20:55:58 rainbow kernel: [ 2900.152889] ieee80211 phy6: U iwl3945_alive_start ALIVE processing complete.
Mar 16 20:55:58 rainbow kernel: [ 2900.152902] ieee80211 phy6: U iwl3945_mac_start leave
Mar 16 20:55:58 rainbow kernel: [ 2900.152915] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.152930] ieee80211 phy6: U iwl3945_mac_add_interface enter: type 2
Mar 16 20:55:58 rainbow kernel: [ 2900.152937] ieee80211 phy6: U iwl3945_mac_add_interface Set: 00:1f:3c:20:a1:6e
Mar 16 20:55:58 rainbow kernel: [ 2900.152949] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:58 rainbow kernel: [ 2900.152951] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:58 rainbow kernel: [ 2900.152953] * channel = 1
Mar 16 20:55:58 rainbow kernel: [ 2900.152954] * bssid = 00:00:00:00:00:00
Mar 16 20:55:58 rainbow kernel: [ 2900.152967] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.155663] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.158615] ieee80211 phy6: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:58 rainbow kernel: [ 2900.158631] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.161464] ieee80211 phy6: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:58 rainbow kernel: [ 2900.161481] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.164787] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.167640] ieee80211 phy6: U iwl3945_mac_add_interface leave
Mar 16 20:55:58 rainbow kernel: [ 2900.167648] ieee80211 phy6: U iwl3945_bss_info_changed changes = 0xE
Mar 16 20:55:58 rainbow kernel: [ 2900.167654] ieee80211 phy6: U iwl3945_bss_info_changed ERP_PREAMBLE 0
Mar 16 20:55:58 rainbow kernel: [ 2900.167658] ieee80211 phy6: U iwl3945_bss_info_changed ERP_CTS 0
Mar 16 20:55:58 rainbow kernel: [ 2900.180085] ieee80211 phy6: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:58 rainbow kernel: [ 2900.181990] ieee80211 phy6: U iwl3945_mac_config enter to channel 1
Mar 16 20:55:58 rainbow kernel: [ 2900.182004] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 20:55:58 rainbow kernel: [ 2900.182006] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:55:58 rainbow kernel: [ 2900.182008] * channel = 1
Mar 16 20:55:58 rainbow kernel: [ 2900.182009] * bssid = 00:00:00:00:00:00
Mar 16 20:55:58 rainbow kernel: [ 2900.182065] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.192831] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.195650] ieee80211 phy6: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:55:58 rainbow kernel: [ 2900.195665] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.198519] ieee80211 phy6: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:55:58 rainbow kernel: [ 2900.198539] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.201541] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.204334] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 20:55:58 rainbow kernel: [ 2900.204340] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 20:55:58 rainbow kernel: [ 2900.204344] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 20:55:58 rainbow kernel: [ 2900.204348] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 20:55:58 rainbow kernel: [ 2900.204352] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 20:55:58 rainbow kernel: [ 2900.204356] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 20:55:58 rainbow kernel: [ 2900.204360] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 20:55:58 rainbow kernel: [ 2900.204364] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 20:55:58 rainbow kernel: [ 2900.204368] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 20:55:58 rainbow kernel: [ 2900.204383] ieee80211 phy6: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:58 rainbow kernel: [ 2900.204410] ieee80211 phy6: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:58 rainbow kernel: [ 2900.206263] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar 16 20:55:58 rainbow kernel: [ 2900.206270] ieee80211 phy6: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 20:55:58 rainbow kernel: [ 2900.218135] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 20:55:58 rainbow kernel: [ 2900.218142] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 20:55:58 rainbow kernel: [ 2900.218151] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 20:55:58 rainbow kernel: [ 2900.218221] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:55:58 rainbow kernel: [ 2900.546600] ieee80211 phy6: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 328ms
Mar 16 20:56:00 rainbow kernel: [ 2902.025333] ieee80211 phy6: I iwl3945_rx_scan_complete_notif Scan pass on 5.2GHz took 1480ms
Mar 16 20:56:00 rainbow kernel: [ 2902.025343] ieee80211 phy6: I iwl3945_rx_scan_complete_notif Setting scan to off
Mar 16 20:56:00 rainbow kernel: [ 2902.025349] ieee80211 phy6: I iwl3945_rx_scan_complete_notif Scan took 1808ms
Mar 16 20:56:00 rainbow kernel: [ 2902.025373] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:56:00 rainbow kernel: [ 2902.025407] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.030313] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 20:56:00 rainbow kernel: [ 2902.030324] ieee80211 phy6: U iwl3945_set_rxon_channel Staging channel set to 11 [0]
Mar 16 20:56:00 rainbow kernel: [ 2902.030338] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 20:56:00 rainbow kernel: [ 2902.030340] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:56:00 rainbow kernel: [ 2902.030342] * channel = 11
Mar 16 20:56:00 rainbow kernel: [ 2902.030343] * bssid = 00:00:00:00:00:00
Mar 16 20:56:00 rainbow kernel: [ 2902.030399] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.042069] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.045293] ieee80211 phy6: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:56:00 rainbow kernel: [ 2902.045308] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.048901] ieee80211 phy6: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:56:00 rainbow kernel: [ 2902.048918] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.051278] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.054462] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 20:56:00 rainbow kernel: [ 2902.054473] ieee80211 phy6: U iwl3945_mac_config_interface bssid: 00:30:bd:c0:90:24
Mar 16 20:56:00 rainbow kernel: [ 2902.054482] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 20:56:00 rainbow kernel: [ 2902.054484] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:56:00 rainbow kernel: [ 2902.054486] * channel = 11
Mar 16 20:56:00 rainbow kernel: [ 2902.054487] * bssid = 00:30:bd:c0:90:24
Mar 16 20:56:00 rainbow kernel: [ 2902.054500] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.057857] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.060383] ieee80211 phy6: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:56:00 rainbow kernel: [ 2902.060400] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.063097] ieee80211 phy6: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:56:00 rainbow kernel: [ 2902.063114] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.066410] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.069391] ieee80211 phy6: U iwl3945_mac_config_interface leave
Mar 16 20:56:00 rainbow kernel: [ 2902.069399] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 20:56:00 rainbow kernel: [ 2902.069403] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 20:56:00 rainbow kernel: [ 2902.069407] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 20:56:00 rainbow kernel: [ 2902.069411] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 20:56:00 rainbow kernel: [ 2902.069415] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 20:56:00 rainbow kernel: [ 2902.069419] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 20:56:00 rainbow kernel: [ 2902.069423] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 20:56:00 rainbow kernel: [ 2902.069427] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 20:56:00 rainbow kernel: [ 2902.069431] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 20:56:00 rainbow kernel: [ 2902.069437] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 20:56:00 rainbow kernel: [ 2902.069446] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 20:56:00 rainbow kernel: [ 2902.069448] * without RXON_FILTER_ASSOC_MSK
Mar 16 20:56:00 rainbow kernel: [ 2902.069450] * channel = 11
Mar 16 20:56:00 rainbow kernel: [ 2902.069451] * bssid = 00:30:bd:c0:90:24
Mar 16 20:56:00 rainbow kernel: [ 2902.069464] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.072161] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.075877] ieee80211 phy6: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
Mar 16 20:56:00 rainbow kernel: [ 2902.075891] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.078275] ieee80211 phy6: U iwl3945_send_add_station REPLY_ADD_STA PASSED
Mar 16 20:56:00 rainbow kernel: [ 2902.078293] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.081539] ieee80211 phy6: U iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.083890] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 20:56:00 rainbow kernel: [ 2902.083899] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar 16 20:56:00 rainbow kernel: [ 2902.083918] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 20:56:00 rainbow kernel: [ 2902.083924] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(30 bytes) at rate 0x0a
Mar 16 20:56:00 rainbow kernel: [ 2902.083928] ieee80211 phy6: I iwl3945_tx_skb Sending AUTH frame
Mar 16 20:56:00 rainbow kernel: [ 2902.083937] iwl data: 00000000: 1e 00 00 00 08 20 00 00 0a 18 00 00 00 00 00 00  ..... ..........
Mar 16 20:56:00 rainbow kernel: [ 2902.083943] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 20:56:00 rainbow kernel: [ 2902.083949] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 20:56:00 rainbow kernel: [ 2902.083954] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 20:56:00 rainbow kernel: [ 2902.083960] iwl data: 00000000: b0 00 3a 01 00 30 bd c0 90 24 00 1f 3c 20 a1 6e  ..:..0...$..< .n
Mar 16 20:56:00 rainbow kernel: [ 2902.083965] iwl data: 00000010: 00 30 bd c0 90 24 00 00                          .0...$..
Mar 16 20:56:00 rainbow kernel: [ 2902.083978] ieee80211 phy6: I iwl3945_tx_queue_update_write_ptr Requesting wakeup, GP1 = 0x1
Mar 16 20:56:00 rainbow kernel: [ 2902.083989] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 20:56:00 rainbow kernel: [ 2902.088155] ieee80211 phy6: I iwl3945_rx_reply_tx Tx queue 0 Status SUCCESS (0x00000201) plcp rate 10 retries 0
Mar 16 20:56:00 rainbow kernel: [ 2902.088163] ieee80211 phy6: I iwl3945_rx_reply_tx Tx queue reclaim 0
Mar 16 20:56:00 rainbow kernel: [ 2902.089641] wlan0: authenticated
Mar 16 20:56:00 rainbow kernel: [ 2902.089648] wlan0: associate with AP 00:30:bd:c0:90:24
Mar 16 20:56:00 rainbow kernel: [ 2902.089663] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 20:56:00 rainbow kernel: [ 2902.089668] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(40 bytes) at rate 0x0a
Mar 16 20:56:00 rainbow kernel: [ 2902.089672] ieee80211 phy6: I iwl3945_tx_skb Sending ASSOC frame
Mar 16 20:56:00 rainbow kernel: [ 2902.089680] iwl data: 00000000: 28 00 00 00 08 20 00 00 0a 18 00 00 00 00 00 00  (.... ..........
Mar 16 20:56:00 rainbow kernel: [ 2902.089686] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 20:56:00 rainbow kernel: [ 2902.089691] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 20:56:00 rainbow kernel: [ 2902.089697] iwl data: 00000030: 03 00 00 00                                      ....
Mar 16 20:56:00 rainbow kernel: [ 2902.089703] iwl data: 00000000: 00 00 3a 01 00 30 bd c0 90 24 00 1f 3c 20 a1 6e  ..:..0...$..< .n
Mar 16 20:56:00 rainbow kernel: [ 2902.089708] iwl data: 00000010: 00 30 bd c0 90 24 10 00                          .0...$..
Mar 16 20:56:00 rainbow kernel: [ 2902.089744] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 20:56:00 rainbow kernel: [ 2902.284106] wlan0: associate with AP 00:30:bd:c0:90:24
Mar 16 20:56:00 rainbow kernel: [ 2902.284122] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 20:56:00 rainbow kernel: [ 2902.284128] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(40 bytes) at rate 0x0a
Mar 16 20:56:00 rainbow kernel: [ 2902.284133] ieee80211 phy6: I iwl3945_tx_skb Sending ASSOC frame
Mar 16 20:56:00 rainbow kernel: [ 2902.284140] iwl data: 00000000: 28 00 00 00 08 20 00 00 0a 18 00 00 00 00 00 00  (.... ..........
Mar 16 20:56:00 rainbow kernel: [ 2902.284146] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 20:56:00 rainbow kernel: [ 2902.284152] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 20:56:00 rainbow kernel: [ 2902.284157] iwl data: 00000030: 03 00 00 00                                      ....
Mar 16 20:56:00 rainbow kernel: [ 2902.284163] iwl data: 00000000: 00 00 3a 01 00 30 bd c0 90 24 00 1f 3c 20 a1 6e  ..:..0...$..< .n
Mar 16 20:56:00 rainbow kernel: [ 2902.284168] iwl data: 00000010: 00 30 bd c0 90 24 20 00                          .0...$ .
Mar 16 20:56:00 rainbow kernel: [ 2902.284204] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 20:56:00 rainbow kernel: [ 2902.484081] wlan0: associate with AP 00:30:bd:c0:90:24
Mar 16 20:56:00 rainbow kernel: [ 2902.484100] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 20:56:00 rainbow kernel: [ 2902.484107] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(40 bytes) at rate 0x0a
Mar 16 20:56:00 rainbow kernel: [ 2902.484112] ieee80211 phy6: I iwl3945_tx_skb Sending ASSOC frame
Mar 16 20:56:00 rainbow kernel: [ 2902.484120] iwl data: 00000000: 28 00 00 00 08 20 00 00 0a 18 00 00 00 00 00 00  (.... ..........
Mar 16 20:56:00 rainbow kernel: [ 2902.484126] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 20:56:00 rainbow kernel: [ 2902.484132] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 20:56:00 rainbow kernel: [ 2902.484137] iwl data: 00000030: 03 00 00 00                                      ....
Mar 16 20:56:00 rainbow kernel: [ 2902.484143] iwl data: 00000000: 00 00 3a 01 00 30 bd c0 90 24 00 1f 3c 20 a1 6e  ..:..0...$..< .n
Mar 16 20:56:00 rainbow kernel: [ 2902.484149] iwl data: 00000010: 00 30 bd c0 90 24 30 00                          .0...$0.
Mar 16 20:56:00 rainbow kernel: [ 2902.484185] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 20:56:00 rainbow kernel: [ 2902.684090] wlan0: association with AP 00:30:bd:c0:90:24 timed out
Mar 16 20:56:18 rainbow kernel: [ 2920.255052] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 20:56:18 rainbow kernel: [ 2920.255063] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 20:56:18 rainbow kernel: [ 2920.255071] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 20:56:19 rainbow kernel: [ 2920.752074] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 20:56:19 rainbow kernel: [ 2920.752085] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:56:19 rainbow kernel: [ 2921.254466] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 20:56:48 rainbow kernel: [ 2950.255258] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 20:56:48 rainbow kernel: [ 2950.255269] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 20:56:48 rainbow kernel: [ 2950.255279] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 20:56:49 rainbow kernel: [ 2950.752082] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 20:56:49 rainbow kernel: [ 2950.752094] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:56:49 rainbow kernel: [ 2951.252082] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 20:56:58 rainbow kernel: [ 2960.152115] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 105
Mar 16 20:56:58 rainbow kernel: [ 2960.652090] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 20:57:28 rainbow kernel: [ 2990.255004] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 20:57:28 rainbow kernel: [ 2990.255016] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 20:57:28 rainbow kernel: [ 2990.255025] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 20:57:29 rainbow kernel: [ 2990.752082] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 20:57:29 rainbow kernel: [ 2990.752096] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:57:29 rainbow kernel: [ 2991.253079] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 20:57:58 rainbow kernel: [ 3020.652090] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 109
Mar 16 20:58:18 rainbow kernel: [ 3040.254741] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 20:58:18 rainbow kernel: [ 3040.254751] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 20:58:18 rainbow kernel: [ 3040.254762] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 20:58:19 rainbow kernel: [ 3040.754503] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 20:58:19 rainbow kernel: [ 3040.754634] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:58:19 rainbow kernel: [ 3041.252084] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 20:58:58 rainbow kernel: [ 3080.652095] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 109
Mar 16 20:59:18 rainbow kernel: [ 3100.257117] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 20:59:18 rainbow kernel: [ 3100.257128] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 20:59:18 rainbow kernel: [ 3100.257138] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 20:59:19 rainbow kernel: [ 3100.756125] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 20:59:19 rainbow kernel: [ 3100.756140] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 20:59:19 rainbow kernel: [ 3101.256085] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 20:59:58 rainbow kernel: [ 3140.652115] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 109
Mar 16 21:00:18 rainbow kernel: [ 3160.258257] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:00:18 rainbow kernel: [ 3160.258269] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:00:18 rainbow kernel: [ 3160.258280] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:00:19 rainbow kernel: [ 3160.756107] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 21:00:19 rainbow kernel: [ 3160.756121] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:00:19 rainbow kernel: [ 3161.256106] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 21:00:48 rainbow kernel: [ 3189.685653] wlan1: authenticate with AP 00:30:bd:c0:90:24
Mar 16 21:00:48 rainbow kernel: [ 3189.745647] wlan1: authenticate with AP 00:30:bd:c0:90:24
Mar 16 21:00:48 rainbow kernel: [ 3189.746261] wlan1: authenticated
Mar 16 21:00:48 rainbow kernel: [ 3189.746269] wlan1: associate with AP 00:30:bd:c0:90:24
Mar 16 21:00:48 rainbow kernel: [ 3189.750374] wlan1: RX ReassocResp from 00:30:bd:c0:90:24 (capab=0x1 status=0 aid=7)
Mar 16 21:00:48 rainbow kernel: [ 3189.750380] wlan1: associated
Mar 16 21:00:58 rainbow kernel: [ 3200.652081] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 110
Mar 16 21:01:18 rainbow kernel: [ 3220.260077] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:01:18 rainbow kernel: [ 3220.260088] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:01:18 rainbow kernel: [ 3220.260096] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:01:19 rainbow kernel: [ 3220.760130] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 21:01:19 rainbow kernel: [ 3220.760227] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:01:19 rainbow kernel: [ 3221.260116] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 21:01:58 rainbow kernel: [ 3260.652083] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 109
Mar 16 21:02:18 rainbow kernel: [ 3280.262294] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:02:18 rainbow kernel: [ 3280.262307] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:02:18 rainbow kernel: [ 3280.262315] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:02:19 rainbow kernel: [ 3280.760090] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 21:02:19 rainbow kernel: [ 3280.760102] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:02:19 rainbow kernel: [ 3281.261034] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 21:02:24 rainbow kernel: [ 3285.761592] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:02:24 rainbow kernel: [ 3285.761605] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:02:24 rainbow kernel: [ 3285.761616] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:02:24 rainbow kernel: [ 3286.260095] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 21:02:24 rainbow kernel: [ 3286.260109] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:02:25 rainbow kernel: [ 3286.760477] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 21:02:25 rainbow kernel: [ 3286.760499] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:25 rainbow kernel: [ 3286.760508] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:25 rainbow kernel: [ 3286.760513] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:25 rainbow kernel: [ 3286.760723] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:25 rainbow kernel: [ 3286.760730] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:25 rainbow kernel: [ 3286.760735] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:25 rainbow kernel: [ 3286.760746] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3286.760751] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3286.760755] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3286.760759] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3286.760762] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3286.760766] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3286.760770] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3286.760774] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3286.760780] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:02:25 rainbow kernel: [ 3286.760785] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:02:25 rainbow kernel: [ 3286.760798] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:02:25 rainbow kernel: [ 3286.760800] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:02:25 rainbow kernel: [ 3286.760802] * channel = 11
Mar 16 21:02:25 rainbow kernel: [ 3286.760803] * bssid = 00:30:bd:c0:90:24
Mar 16 21:02:25 rainbow kernel: [ 3287.260277] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Mar 16 21:02:25 rainbow kernel: [ 3287.260288] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Mar 16 21:02:25 rainbow kernel: [ 3287.260295] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:02:25 rainbow kernel: [ 3287.260309] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:02:25 rainbow kernel: [ 3287.260335] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3287.260340] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:25 rainbow kernel: [ 3287.260352] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:25 rainbow kernel: [ 3287.260358] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:25 rainbow kernel: [ 3287.260363] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:25 rainbow kernel: [ 3287.260369] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:25 rainbow kernel: [ 3287.260375] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:25 rainbow kernel: [ 3287.260380] iwl data: 00000010: ff ff ff ff ff ff 40 00                          ......@.
Mar 16 21:02:25 rainbow kernel: [ 3287.260419] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3287.260469] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:25 rainbow kernel: [ 3287.260478] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:25 rainbow kernel: [ 3287.260482] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:25 rainbow kernel: [ 3287.260488] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3287.260492] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3287.260496] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3287.260500] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3287.260504] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3287.260508] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3287.260512] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:25 rainbow kernel: [ 3287.260516] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:25 rainbow kernel: [ 3287.260520] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:02:25 rainbow kernel: [ 3287.260526] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:02:25 rainbow kernel: [ 3287.260535] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:02:25 rainbow kernel: [ 3287.260537] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:02:25 rainbow kernel: [ 3287.260539] * channel = 11
Mar 16 21:02:25 rainbow kernel: [ 3287.260540] * bssid = 00:30:bd:c0:90:24
Mar 16 21:02:26 rainbow kernel: [ 3287.760140] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Mar 16 21:02:26 rainbow kernel: [ 3287.760151] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Mar 16 21:02:26 rainbow kernel: [ 3287.760158] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:02:26 rainbow kernel: [ 3287.760172] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:02:26 rainbow kernel: [ 3287.760193] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:26 rainbow kernel: [ 3287.760199] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:26 rainbow kernel: [ 3287.760210] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:26 rainbow kernel: [ 3287.760216] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:26 rainbow kernel: [ 3287.760221] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:26 rainbow kernel: [ 3287.760227] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:26 rainbow kernel: [ 3287.760232] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:26 rainbow kernel: [ 3287.760238] iwl data: 00000010: ff ff ff ff ff ff 50 00                          ......P.
Mar 16 21:02:26 rainbow kernel: [ 3287.760274] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:26 rainbow kernel: [ 3287.960086] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:02:26 rainbow kernel: [ 3287.960107] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:26 rainbow kernel: [ 3287.960114] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:26 rainbow kernel: [ 3287.960125] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:26 rainbow kernel: [ 3287.960131] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:26 rainbow kernel: [ 3287.960136] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:26 rainbow kernel: [ 3287.960142] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:26 rainbow kernel: [ 3287.960147] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:26 rainbow kernel: [ 3287.960153] iwl data: 00000010: ff ff ff ff ff ff 60 00                          ......`.
Mar 16 21:02:26 rainbow kernel: [ 3287.960189] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:26 rainbow kernel: [ 3288.160143] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:02:26 rainbow kernel: [ 3288.160168] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:26 rainbow kernel: [ 3288.160176] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:26 rainbow kernel: [ 3288.160187] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:26 rainbow kernel: [ 3288.160193] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:26 rainbow kernel: [ 3288.160199] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:26 rainbow kernel: [ 3288.160204] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:26 rainbow kernel: [ 3288.160210] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:26 rainbow kernel: [ 3288.160216] iwl data: 00000010: ff ff ff ff ff ff 70 00                          ......p.
Mar 16 21:02:26 rainbow kernel: [ 3288.160252] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:26 rainbow kernel: [ 3288.360099] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:02:35 rainbow kernel: [ 3296.761334] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:02:35 rainbow kernel: [ 3296.761345] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:02:35 rainbow kernel: [ 3296.761356] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:02:35 rainbow kernel: [ 3297.260071] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 21:02:35 rainbow kernel: [ 3297.260086] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:02:36 rainbow kernel: [ 3297.760068] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 21:02:36 rainbow kernel: [ 3297.760089] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:36 rainbow kernel: [ 3297.760098] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:36 rainbow kernel: [ 3297.760103] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:36 rainbow kernel: [ 3297.760261] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:36 rainbow kernel: [ 3297.760268] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:36 rainbow kernel: [ 3297.760273] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:36 rainbow kernel: [ 3297.760279] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3297.760284] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3297.760288] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3297.760292] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3297.760296] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3297.760300] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3297.760304] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3297.760308] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3297.760313] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:02:36 rainbow kernel: [ 3297.760319] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:02:36 rainbow kernel: [ 3297.760331] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:02:36 rainbow kernel: [ 3297.760333] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:02:36 rainbow kernel: [ 3297.760335] * channel = 11
Mar 16 21:02:36 rainbow kernel: [ 3297.760336] * bssid = 00:30:bd:c0:90:24
Mar 16 21:02:36 rainbow kernel: [ 3298.260082] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Mar 16 21:02:36 rainbow kernel: [ 3298.260094] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Mar 16 21:02:36 rainbow kernel: [ 3298.260102] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:02:36 rainbow kernel: [ 3298.260115] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:02:36 rainbow kernel: [ 3298.260137] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3298.260143] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:36 rainbow kernel: [ 3298.260155] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:36 rainbow kernel: [ 3298.260161] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:36 rainbow kernel: [ 3298.260166] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:36 rainbow kernel: [ 3298.260172] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:36 rainbow kernel: [ 3298.260177] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:36 rainbow kernel: [ 3298.260183] iwl data: 00000010: ff ff ff ff ff ff 80 00                          ........
Mar 16 21:02:36 rainbow kernel: [ 3298.260218] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3298.260261] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:36 rainbow kernel: [ 3298.260269] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:36 rainbow kernel: [ 3298.260274] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:36 rainbow kernel: [ 3298.260279] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3298.260284] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3298.260288] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3298.260292] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3298.260296] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3298.260300] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3298.260304] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:36 rainbow kernel: [ 3298.260308] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:36 rainbow kernel: [ 3298.260312] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:02:36 rainbow kernel: [ 3298.260317] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:02:36 rainbow kernel: [ 3298.260327] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:02:36 rainbow kernel: [ 3298.260329] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:02:36 rainbow kernel: [ 3298.260331] * channel = 11
Mar 16 21:02:36 rainbow kernel: [ 3298.260333] * bssid = 00:30:bd:c0:90:24
Mar 16 21:02:37 rainbow kernel: [ 3298.760087] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Mar 16 21:02:37 rainbow kernel: [ 3298.760096] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Mar 16 21:02:37 rainbow kernel: [ 3298.760102] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:02:37 rainbow kernel: [ 3298.760113] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:02:37 rainbow kernel: [ 3298.760127] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:37 rainbow kernel: [ 3298.760132] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:37 rainbow kernel: [ 3298.760142] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:37 rainbow kernel: [ 3298.760148] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:37 rainbow kernel: [ 3298.760153] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:37 rainbow kernel: [ 3298.760159] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:37 rainbow kernel: [ 3298.760165] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:37 rainbow kernel: [ 3298.760170] iwl data: 00000010: ff ff ff ff ff ff 90 00                          ........
Mar 16 21:02:37 rainbow kernel: [ 3298.760206] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:37 rainbow kernel: [ 3298.960901] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:02:37 rainbow kernel: [ 3298.960921] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:37 rainbow kernel: [ 3298.960929] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:37 rainbow kernel: [ 3298.960940] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:37 rainbow kernel: [ 3298.960946] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:37 rainbow kernel: [ 3298.960952] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:37 rainbow kernel: [ 3298.960957] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:37 rainbow kernel: [ 3298.960963] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:37 rainbow kernel: [ 3298.960969] iwl data: 00000010: ff ff ff ff ff ff a0 00                          ........
Mar 16 21:02:37 rainbow kernel: [ 3298.961030] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:37 rainbow kernel: [ 3299.161065] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:02:37 rainbow kernel: [ 3299.161078] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:37 rainbow kernel: [ 3299.161082] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:37 rainbow kernel: [ 3299.161088] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:37 rainbow kernel: [ 3299.161090] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:37 rainbow kernel: [ 3299.161092] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:37 rainbow kernel: [ 3299.161094] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:37 rainbow kernel: [ 3299.161096] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:37 rainbow kernel: [ 3299.161098] iwl data: 00000010: ff ff ff ff ff ff b0 00                          ........
Mar 16 21:02:37 rainbow kernel: [ 3299.161131] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:37 rainbow kernel: [ 3299.361808] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:02:46 rainbow kernel: [ 3307.767028] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:02:46 rainbow kernel: [ 3307.767041] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:02:46 rainbow kernel: [ 3307.767051] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:02:46 rainbow kernel: [ 3308.264739] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 21:02:46 rainbow kernel: [ 3308.264859] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:02:47 rainbow kernel: [ 3308.764100] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Mar 16 21:02:47 rainbow kernel: [ 3308.764121] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:47 rainbow kernel: [ 3308.764130] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:47 rainbow kernel: [ 3308.764135] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:47 rainbow kernel: [ 3308.764512] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:47 rainbow kernel: [ 3308.764520] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:47 rainbow kernel: [ 3308.764525] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:47 rainbow kernel: [ 3308.764531] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3308.764536] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3308.764540] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3308.764544] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3308.764548] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3308.764552] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3308.764556] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3308.764560] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3308.764565] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:02:47 rainbow kernel: [ 3308.764571] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:02:47 rainbow kernel: [ 3308.764582] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:02:47 rainbow kernel: [ 3308.764585] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:02:47 rainbow kernel: [ 3308.764586] * channel = 11
Mar 16 21:02:47 rainbow kernel: [ 3308.764588] * bssid = 00:30:bd:c0:90:24
Mar 16 21:02:47 rainbow kernel: [ 3309.264070] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Mar 16 21:02:47 rainbow kernel: [ 3309.264080] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Mar 16 21:02:47 rainbow kernel: [ 3309.264087] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:02:47 rainbow kernel: [ 3309.264101] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:02:47 rainbow kernel: [ 3309.264124] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3309.264130] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:47 rainbow kernel: [ 3309.264141] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:47 rainbow kernel: [ 3309.264147] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:47 rainbow kernel: [ 3309.264153] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:47 rainbow kernel: [ 3309.264158] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:47 rainbow kernel: [ 3309.264164] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:47 rainbow kernel: [ 3309.264170] iwl data: 00000010: ff ff ff ff ff ff c0 00                          ........
Mar 16 21:02:47 rainbow kernel: [ 3309.264206] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3309.264248] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:47 rainbow kernel: [ 3309.264257] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:47 rainbow kernel: [ 3309.264262] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:47 rainbow kernel: [ 3309.264267] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3309.264271] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3309.264276] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3309.264280] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3309.264283] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3309.264287] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3309.264291] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:47 rainbow kernel: [ 3309.264296] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:47 rainbow kernel: [ 3309.264300] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:02:47 rainbow kernel: [ 3309.264305] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:02:47 rainbow kernel: [ 3309.264315] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:02:47 rainbow kernel: [ 3309.264317] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:02:47 rainbow kernel: [ 3309.264319] * channel = 11
Mar 16 21:02:47 rainbow kernel: [ 3309.264320] * bssid = 00:30:bd:c0:90:24
Mar 16 21:02:48 rainbow kernel: [ 3309.765028] iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms
Mar 16 21:02:48 rainbow kernel: [ 3309.765038] iwl3945 0000:03:00.0: Error setting new configuration (-110).
Mar 16 21:02:48 rainbow kernel: [ 3309.765045] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:02:48 rainbow kernel: [ 3309.765055] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:02:48 rainbow kernel: [ 3309.765076] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:48 rainbow kernel: [ 3309.765081] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:48 rainbow kernel: [ 3309.765092] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:48 rainbow kernel: [ 3309.765098] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:48 rainbow kernel: [ 3309.765104] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:48 rainbow kernel: [ 3309.765110] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:48 rainbow kernel: [ 3309.765115] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:48 rainbow kernel: [ 3309.765121] iwl data: 00000010: ff ff ff ff ff ff d0 00                          ........
Mar 16 21:02:48 rainbow kernel: [ 3309.765159] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:48 rainbow kernel: [ 3309.964103] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:02:48 rainbow kernel: [ 3309.964128] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:48 rainbow kernel: [ 3309.964136] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:48 rainbow kernel: [ 3309.964147] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:48 rainbow kernel: [ 3309.964153] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:48 rainbow kernel: [ 3309.964159] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:48 rainbow kernel: [ 3309.964164] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:48 rainbow kernel: [ 3309.964170] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:48 rainbow kernel: [ 3309.964176] iwl data: 00000010: ff ff ff ff ff ff e0 00                          ........
Mar 16 21:02:48 rainbow kernel: [ 3309.964215] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:48 rainbow kernel: [ 3310.164124] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:02:48 rainbow kernel: [ 3310.164149] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:48 rainbow kernel: [ 3310.164157] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:48 rainbow kernel: [ 3310.164167] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:48 rainbow kernel: [ 3310.164173] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:48 rainbow kernel: [ 3310.164179] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:48 rainbow kernel: [ 3310.164184] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:48 rainbow kernel: [ 3310.164190] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:48 rainbow kernel: [ 3310.164196] iwl data: 00000010: ff ff ff ff ff ff f0 00                          ........
Mar 16 21:02:48 rainbow kernel: [ 3310.164235] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:48 rainbow kernel: [ 3310.364101] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:02:57 rainbow kernel: [ 3318.771399] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:02:57 rainbow kernel: [ 3318.771423] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:02:57 rainbow kernel: [ 3318.771432] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:02:57 rainbow kernel: [ 3319.268091] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms
Mar 16 21:02:57 rainbow kernel: [ 3319.268222] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:02:57 rainbow kernel: [ 3319.268246] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:02:57 rainbow kernel: [ 3319.268252] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:02:57 rainbow kernel: [ 3319.268791] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:57 rainbow kernel: [ 3319.268800] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:57 rainbow kernel: [ 3319.268805] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:57 rainbow kernel: [ 3319.269349] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:02:57 rainbow kernel: [ 3319.269357] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:02:57 rainbow kernel: [ 3319.269362] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:02:57 rainbow kernel: [ 3319.269367] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:57 rainbow kernel: [ 3319.269372] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:57 rainbow kernel: [ 3319.269376] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:57 rainbow kernel: [ 3319.269380] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:57 rainbow kernel: [ 3319.269383] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:57 rainbow kernel: [ 3319.269387] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:57 rainbow kernel: [ 3319.269391] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:02:57 rainbow kernel: [ 3319.269395] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:02:57 rainbow kernel: [ 3319.269400] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:02:57 rainbow kernel: [ 3319.269406] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:02:57 rainbow kernel: [ 3319.269418] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:02:57 rainbow kernel: [ 3319.269420] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:02:57 rainbow kernel: [ 3319.269422] * channel = 11
Mar 16 21:02:57 rainbow kernel: [ 3319.269423] * bssid = 00:30:bd:c0:90:24
Mar 16 21:02:57 rainbow kernel: [ 3319.269428] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:02:57 rainbow kernel: [ 3319.269434] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:02:57 rainbow kernel: [ 3319.269440] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:02:57 rainbow kernel: [ 3319.269445] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:02:57 rainbow kernel: [ 3319.269452] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:02:57 rainbow kernel: [ 3319.269471] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:57 rainbow kernel: [ 3319.269477] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:57 rainbow kernel: [ 3319.269487] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:57 rainbow kernel: [ 3319.269493] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:57 rainbow kernel: [ 3319.269499] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:57 rainbow kernel: [ 3319.269504] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:57 rainbow kernel: [ 3319.269510] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:57 rainbow kernel: [ 3319.269515] iwl data: 00000010: ff ff ff ff ff ff 00 01                          ........
Mar 16 21:02:57 rainbow kernel: [ 3319.269552] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:57 rainbow kernel: [ 3319.468121] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:02:57 rainbow kernel: [ 3319.468144] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:57 rainbow kernel: [ 3319.468152] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:57 rainbow kernel: [ 3319.468162] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:57 rainbow kernel: [ 3319.468168] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:57 rainbow kernel: [ 3319.468173] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:57 rainbow kernel: [ 3319.468179] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:57 rainbow kernel: [ 3319.468184] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:57 rainbow kernel: [ 3319.468190] iwl data: 00000010: ff ff ff ff ff ff 10 01                          ........
Mar 16 21:02:57 rainbow kernel: [ 3319.468228] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:57 rainbow kernel: [ 3319.668112] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:02:57 rainbow kernel: [ 3319.668132] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:02:57 rainbow kernel: [ 3319.668139] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:02:57 rainbow kernel: [ 3319.668148] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:02:57 rainbow kernel: [ 3319.668154] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:02:57 rainbow kernel: [ 3319.668160] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:02:57 rainbow kernel: [ 3319.668165] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:02:57 rainbow kernel: [ 3319.668171] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:02:57 rainbow kernel: [ 3319.668177] iwl data: 00000010: ff ff ff ff ff ff 20 01                          ...... .
Mar 16 21:02:57 rainbow kernel: [ 3319.668214] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:02:58 rainbow kernel: [ 3319.868071] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:02:58 rainbow kernel: [ 3320.652133] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 108
Mar 16 21:03:07 rainbow kernel: [ 3329.272346] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:03:07 rainbow kernel: [ 3329.272357] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:03:07 rainbow kernel: [ 3329.272368] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:03:07 rainbow kernel: [ 3329.272385] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:07 rainbow kernel: [ 3329.272391] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:07 rainbow kernel: [ 3329.272398] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:03:07 rainbow kernel: [ 3329.272415] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:07 rainbow kernel: [ 3329.272420] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:07 rainbow kernel: [ 3329.272812] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:07 rainbow kernel: [ 3329.272823] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:07 rainbow kernel: [ 3329.272828] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:07 rainbow kernel: [ 3329.273583] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:07 rainbow kernel: [ 3329.273592] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:07 rainbow kernel: [ 3329.273598] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:07 rainbow kernel: [ 3329.273603] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:07 rainbow kernel: [ 3329.273608] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:07 rainbow kernel: [ 3329.273613] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:07 rainbow kernel: [ 3329.273617] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:07 rainbow kernel: [ 3329.273622] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:07 rainbow kernel: [ 3329.273626] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:07 rainbow kernel: [ 3329.273630] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:07 rainbow kernel: [ 3329.273635] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:07 rainbow kernel: [ 3329.273640] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:07 rainbow kernel: [ 3329.273646] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:07 rainbow kernel: [ 3329.273658] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:07 rainbow kernel: [ 3329.273660] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:07 rainbow kernel: [ 3329.273662] * channel = 11
Mar 16 21:03:07 rainbow kernel: [ 3329.273663] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:07 rainbow kernel: [ 3329.273669] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:07 rainbow kernel: [ 3329.273675] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:07 rainbow kernel: [ 3329.273681] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:07 rainbow kernel: [ 3329.273686] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:07 rainbow kernel: [ 3329.273694] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:07 rainbow kernel: [ 3329.273714] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:07 rainbow kernel: [ 3329.273720] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:07 rainbow kernel: [ 3329.273731] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:07 rainbow kernel: [ 3329.273737] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:07 rainbow kernel: [ 3329.273744] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:07 rainbow kernel: [ 3329.273749] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:07 rainbow kernel: [ 3329.273756] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:07 rainbow kernel: [ 3329.273762] iwl data: 00000010: ff ff ff ff ff ff 30 01                          ......0.
Mar 16 21:03:07 rainbow kernel: [ 3329.273802] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:07 rainbow kernel: [ 3329.472101] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:03:07 rainbow kernel: [ 3329.472124] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:07 rainbow kernel: [ 3329.472132] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:07 rainbow kernel: [ 3329.472142] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:07 rainbow kernel: [ 3329.472148] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:07 rainbow kernel: [ 3329.472154] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:07 rainbow kernel: [ 3329.472159] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:07 rainbow kernel: [ 3329.472165] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:07 rainbow kernel: [ 3329.472171] iwl data: 00000010: ff ff ff ff ff ff 40 01                          ......@.
Mar 16 21:03:07 rainbow kernel: [ 3329.472208] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:07 rainbow kernel: [ 3329.673047] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:03:07 rainbow kernel: [ 3329.673075] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:07 rainbow kernel: [ 3329.673083] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:07 rainbow kernel: [ 3329.673095] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:07 rainbow kernel: [ 3329.673101] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:07 rainbow kernel: [ 3329.673107] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:07 rainbow kernel: [ 3329.673112] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:07 rainbow kernel: [ 3329.673118] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:07 rainbow kernel: [ 3329.673123] iwl data: 00000010: ff ff ff ff ff ff 50 01                          ......P.
Mar 16 21:03:07 rainbow kernel: [ 3329.673163] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:08 rainbow kernel: [ 3329.873069] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:03:17 rainbow kernel: [ 3339.274628] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:03:17 rainbow kernel: [ 3339.274640] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:03:17 rainbow kernel: [ 3339.274652] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:03:17 rainbow kernel: [ 3339.274670] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:17 rainbow kernel: [ 3339.274676] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:17 rainbow kernel: [ 3339.274683] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:03:17 rainbow kernel: [ 3339.274701] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:17 rainbow kernel: [ 3339.274706] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:17 rainbow kernel: [ 3339.275200] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:17 rainbow kernel: [ 3339.275212] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:17 rainbow kernel: [ 3339.275217] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:17 rainbow kernel: [ 3339.277111] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:17 rainbow kernel: [ 3339.277121] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:17 rainbow kernel: [ 3339.277127] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:17 rainbow kernel: [ 3339.277132] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:17 rainbow kernel: [ 3339.277138] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:17 rainbow kernel: [ 3339.277142] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:17 rainbow kernel: [ 3339.277147] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:17 rainbow kernel: [ 3339.277151] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:17 rainbow kernel: [ 3339.277156] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:17 rainbow kernel: [ 3339.277160] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:17 rainbow kernel: [ 3339.277165] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:17 rainbow kernel: [ 3339.277171] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:17 rainbow kernel: [ 3339.277177] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:17 rainbow kernel: [ 3339.277189] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:17 rainbow kernel: [ 3339.277191] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:17 rainbow kernel: [ 3339.277193] * channel = 11
Mar 16 21:03:17 rainbow kernel: [ 3339.277194] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:17 rainbow kernel: [ 3339.277200] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:17 rainbow kernel: [ 3339.277206] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:17 rainbow kernel: [ 3339.277211] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:17 rainbow kernel: [ 3339.277217] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:17 rainbow kernel: [ 3339.277224] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:17 rainbow kernel: [ 3339.277245] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:17 rainbow kernel: [ 3339.277251] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:17 rainbow kernel: [ 3339.277263] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:17 rainbow kernel: [ 3339.277269] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:17 rainbow kernel: [ 3339.277275] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:17 rainbow kernel: [ 3339.277281] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:17 rainbow kernel: [ 3339.277287] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:17 rainbow kernel: [ 3339.277293] iwl data: 00000010: ff ff ff ff ff ff 60 01                          ......`.
Mar 16 21:03:17 rainbow kernel: [ 3339.277333] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:17 rainbow kernel: [ 3339.476161] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:03:17 rainbow kernel: [ 3339.476182] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:17 rainbow kernel: [ 3339.476189] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:17 rainbow kernel: [ 3339.476198] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:17 rainbow kernel: [ 3339.476204] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:17 rainbow kernel: [ 3339.476210] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:17 rainbow kernel: [ 3339.476215] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:17 rainbow kernel: [ 3339.476221] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:17 rainbow kernel: [ 3339.476226] iwl data: 00000010: ff ff ff ff ff ff 70 01                          ......p.
Mar 16 21:03:17 rainbow kernel: [ 3339.476264] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:17 rainbow kernel: [ 3339.676093] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:03:17 rainbow kernel: [ 3339.676107] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:17 rainbow kernel: [ 3339.676113] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:17 rainbow kernel: [ 3339.676122] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:17 rainbow kernel: [ 3339.676128] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:17 rainbow kernel: [ 3339.676134] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:17 rainbow kernel: [ 3339.676139] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:17 rainbow kernel: [ 3339.676145] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:17 rainbow kernel: [ 3339.676150] iwl data: 00000010: ff ff ff ff ff ff 80 01                          ........
Mar 16 21:03:17 rainbow kernel: [ 3339.676187] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:18 rainbow kernel: [ 3339.877851] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:03:18 rainbow kernel: [ 3340.262321] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:03:18 rainbow kernel: [ 3340.262332] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:03:18 rainbow kernel: [ 3340.262342] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:03:18 rainbow kernel: [ 3340.262360] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:18 rainbow kernel: [ 3340.262366] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:18 rainbow kernel: [ 3340.262373] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:03:18 rainbow kernel: [ 3340.262768] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:18 rainbow kernel: [ 3340.262777] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:18 rainbow kernel: [ 3340.262782] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:18 rainbow kernel: [ 3340.263370] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:18 rainbow kernel: [ 3340.263379] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:18 rainbow kernel: [ 3340.263384] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:18 rainbow kernel: [ 3340.263389] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:18 rainbow kernel: [ 3340.263394] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:18 rainbow kernel: [ 3340.263398] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:18 rainbow kernel: [ 3340.263402] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:18 rainbow kernel: [ 3340.263406] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:18 rainbow kernel: [ 3340.263410] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:18 rainbow kernel: [ 3340.263414] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:18 rainbow kernel: [ 3340.263430] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:18 rainbow kernel: [ 3340.263436] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:18 rainbow kernel: [ 3340.263441] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:18 rainbow kernel: [ 3340.263453] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:18 rainbow kernel: [ 3340.263455] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:18 rainbow kernel: [ 3340.263457] * channel = 11
Mar 16 21:03:18 rainbow kernel: [ 3340.263458] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:18 rainbow kernel: [ 3340.263463] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:18 rainbow kernel: [ 3340.263469] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:18 rainbow kernel: [ 3340.263474] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:18 rainbow kernel: [ 3340.263479] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:18 rainbow kernel: [ 3340.263486] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:18 rainbow kernel: [ 3340.263507] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:18 rainbow kernel: [ 3340.263512] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:18 rainbow kernel: [ 3340.263523] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:18 rainbow kernel: [ 3340.263529] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:18 rainbow kernel: [ 3340.263535] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:18 rainbow kernel: [ 3340.263540] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:18 rainbow kernel: [ 3340.263546] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:18 rainbow kernel: [ 3340.263552] iwl data: 00000010: ff ff ff ff ff ff 90 01                          ........
Mar 16 21:03:18 rainbow kernel: [ 3340.263592] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:18 rainbow kernel: [ 3340.263683] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:18 rainbow kernel: [ 3340.263689] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:18 rainbow kernel: [ 3340.460101] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:03:18 rainbow kernel: [ 3340.460123] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:18 rainbow kernel: [ 3340.460131] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:18 rainbow kernel: [ 3340.460142] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:18 rainbow kernel: [ 3340.460148] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:18 rainbow kernel: [ 3340.460153] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:18 rainbow kernel: [ 3340.460159] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:18 rainbow kernel: [ 3340.460165] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:18 rainbow kernel: [ 3340.460170] iwl data: 00000010: ff ff ff ff ff ff a0 01                          ........
Mar 16 21:03:18 rainbow kernel: [ 3340.460208] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:18 rainbow kernel: [ 3340.660105] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:03:18 rainbow kernel: [ 3340.660127] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:18 rainbow kernel: [ 3340.660135] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:18 rainbow kernel: [ 3340.660145] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:18 rainbow kernel: [ 3340.660152] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:18 rainbow kernel: [ 3340.660157] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:18 rainbow kernel: [ 3340.660163] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:18 rainbow kernel: [ 3340.660168] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:18 rainbow kernel: [ 3340.660174] iwl data: 00000010: ff ff ff ff ff ff b0 01                          ........
Mar 16 21:03:18 rainbow kernel: [ 3340.660212] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:19 rainbow kernel: [ 3340.860131] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:03:23 rainbow kernel: [ 3344.769662] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:23 rainbow kernel: [ 3344.769670] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:23 rainbow kernel: [ 3344.769672] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:23 rainbow kernel: [ 3344.769675] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:23 rainbow kernel: [ 3344.769676] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:23 rainbow kernel: [ 3344.769678] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:23 rainbow kernel: [ 3344.769679] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:23 rainbow kernel: [ 3344.769681] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:23 rainbow kernel: [ 3344.769682] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:23 rainbow kernel: [ 3344.769684] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:23 rainbow kernel: [ 3344.769685] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:23 rainbow kernel: [ 3344.769688] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:23 rainbow kernel: [ 3344.769690] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:23 rainbow kernel: [ 3344.769696] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:23 rainbow kernel: [ 3344.769697] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:23 rainbow kernel: [ 3344.769697] * channel = 11
Mar 16 21:03:23 rainbow kernel: [ 3344.769698] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:23 rainbow kernel: [ 3344.769701] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:23 rainbow kernel: [ 3344.769704] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:23 rainbow kernel: [ 3344.769705] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:23 rainbow kernel: [ 3344.769707] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:23 rainbow kernel: [ 3344.769711] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:23 rainbow kernel: [ 3344.769719] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:23 rainbow kernel: [ 3344.769722] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:23 rainbow kernel: [ 3344.769727] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:23 rainbow kernel: [ 3344.769729] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:23 rainbow kernel: [ 3344.769731] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:23 rainbow kernel: [ 3344.769733] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:23 rainbow kernel: [ 3344.769735] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:23 rainbow kernel: [ 3344.769737] iwl data: 00000010: ff ff ff ff ff ff c0 01                          ........
Mar 16 21:03:23 rainbow kernel: [ 3344.769771] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:23 rainbow kernel: [ 3344.981078] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:03:23 rainbow kernel: [ 3344.981106] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:23 rainbow kernel: [ 3344.981114] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:23 rainbow kernel: [ 3344.981126] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:23 rainbow kernel: [ 3344.981132] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:23 rainbow kernel: [ 3344.981138] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:23 rainbow kernel: [ 3344.981143] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:23 rainbow kernel: [ 3344.981149] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:23 rainbow kernel: [ 3344.981155] iwl data: 00000010: ff ff ff ff ff ff d0 01                          ........
Mar 16 21:03:23 rainbow kernel: [ 3344.981194] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:23 rainbow kernel: [ 3345.180089] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:03:23 rainbow kernel: [ 3345.180115] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:23 rainbow kernel: [ 3345.180123] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:23 rainbow kernel: [ 3345.180134] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:23 rainbow kernel: [ 3345.180140] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:23 rainbow kernel: [ 3345.180146] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:23 rainbow kernel: [ 3345.180152] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:23 rainbow kernel: [ 3345.180157] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:23 rainbow kernel: [ 3345.180163] iwl data: 00000010: ff ff ff ff ff ff e0 01                          ........
Mar 16 21:03:23 rainbow kernel: [ 3345.180201] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:23 rainbow kernel: [ 3345.381031] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:03:28 rainbow kernel: [ 3350.264949] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:03:28 rainbow kernel: [ 3350.264961] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:03:28 rainbow kernel: [ 3350.264971] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:03:28 rainbow kernel: [ 3350.265034] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:28 rainbow kernel: [ 3350.265040] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:28 rainbow kernel: [ 3350.265047] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:03:28 rainbow kernel: [ 3350.265063] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:28 rainbow kernel: [ 3350.265068] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:28 rainbow kernel: [ 3350.265582] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:28 rainbow kernel: [ 3350.265592] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:28 rainbow kernel: [ 3350.265597] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:28 rainbow kernel: [ 3350.266446] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:28 rainbow kernel: [ 3350.266455] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:28 rainbow kernel: [ 3350.266460] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:28 rainbow kernel: [ 3350.266466] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:28 rainbow kernel: [ 3350.266470] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:28 rainbow kernel: [ 3350.266474] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:28 rainbow kernel: [ 3350.266478] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:28 rainbow kernel: [ 3350.266482] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:28 rainbow kernel: [ 3350.266486] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:28 rainbow kernel: [ 3350.266490] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:28 rainbow kernel: [ 3350.266494] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:28 rainbow kernel: [ 3350.266499] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:28 rainbow kernel: [ 3350.266505] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:28 rainbow kernel: [ 3350.266516] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:28 rainbow kernel: [ 3350.266518] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:28 rainbow kernel: [ 3350.266520] * channel = 11
Mar 16 21:03:28 rainbow kernel: [ 3350.266522] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:28 rainbow kernel: [ 3350.266527] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:28 rainbow kernel: [ 3350.266533] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:28 rainbow kernel: [ 3350.266538] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:28 rainbow kernel: [ 3350.266543] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:28 rainbow kernel: [ 3350.266550] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:28 rainbow kernel: [ 3350.266573] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:28 rainbow kernel: [ 3350.266579] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:28 rainbow kernel: [ 3350.266590] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:28 rainbow kernel: [ 3350.266596] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:28 rainbow kernel: [ 3350.266602] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:28 rainbow kernel: [ 3350.266607] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:28 rainbow kernel: [ 3350.266613] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:28 rainbow kernel: [ 3350.266618] iwl data: 00000010: ff ff ff ff ff ff f0 01                          ........
Mar 16 21:03:28 rainbow kernel: [ 3350.266656] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:28 rainbow kernel: [ 3350.464093] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:03:28 rainbow kernel: [ 3350.464115] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:28 rainbow kernel: [ 3350.464123] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:28 rainbow kernel: [ 3350.464134] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:28 rainbow kernel: [ 3350.464140] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:28 rainbow kernel: [ 3350.464146] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:28 rainbow kernel: [ 3350.464151] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:28 rainbow kernel: [ 3350.464157] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:28 rainbow kernel: [ 3350.464163] iwl data: 00000010: ff ff ff ff ff ff 00 02                          ........
Mar 16 21:03:28 rainbow kernel: [ 3350.464200] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:28 rainbow kernel: [ 3350.664095] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:03:28 rainbow kernel: [ 3350.664117] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:28 rainbow kernel: [ 3350.664125] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:28 rainbow kernel: [ 3350.664135] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:28 rainbow kernel: [ 3350.664141] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:28 rainbow kernel: [ 3350.664147] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:28 rainbow kernel: [ 3350.664152] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:28 rainbow kernel: [ 3350.664158] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:28 rainbow kernel: [ 3350.664163] iwl data: 00000010: ff ff ff ff ff ff 10 02                          ........
Mar 16 21:03:28 rainbow kernel: [ 3350.664203] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:29 rainbow kernel: [ 3350.866413] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:03:38 rainbow kernel: [ 3360.268292] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:03:38 rainbow kernel: [ 3360.268305] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:03:38 rainbow kernel: [ 3360.268314] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:03:38 rainbow kernel: [ 3360.268333] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:38 rainbow kernel: [ 3360.268340] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:38 rainbow kernel: [ 3360.268347] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:03:38 rainbow kernel: [ 3360.268364] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:38 rainbow kernel: [ 3360.268369] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:38 rainbow kernel: [ 3360.271349] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:38 rainbow kernel: [ 3360.271360] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:38 rainbow kernel: [ 3360.271365] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271381] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:38 rainbow kernel: [ 3360.271389] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:38 rainbow kernel: [ 3360.271394] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271400] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271404] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271408] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271412] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271416] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271420] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271424] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271465] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271471] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271476] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:38 rainbow kernel: [ 3360.271488] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:38 rainbow kernel: [ 3360.271490] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:38 rainbow kernel: [ 3360.271492] * channel = 11
Mar 16 21:03:38 rainbow kernel: [ 3360.271493] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:38 rainbow kernel: [ 3360.271499] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:38 rainbow kernel: [ 3360.271504] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:38 rainbow kernel: [ 3360.271509] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:38 rainbow kernel: [ 3360.271514] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:38 rainbow kernel: [ 3360.271522] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:38 rainbow kernel: [ 3360.271541] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271546] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:38 rainbow kernel: [ 3360.271557] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:38 rainbow kernel: [ 3360.271563] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:38 rainbow kernel: [ 3360.271569] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:38 rainbow kernel: [ 3360.271574] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:38 rainbow kernel: [ 3360.271580] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:38 rainbow kernel: [ 3360.271586] iwl data: 00000010: ff ff ff ff ff ff 20 02                          ...... .
Mar 16 21:03:38 rainbow kernel: [ 3360.271624] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271636] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:38 rainbow kernel: [ 3360.271642] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:38 rainbow kernel: [ 3360.271647] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271651] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271655] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271659] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271663] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271667] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271671] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271675] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271679] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.271683] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271687] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:38 rainbow kernel: [ 3360.271695] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:38 rainbow kernel: [ 3360.271697] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:38 rainbow kernel: [ 3360.271699] * channel = 11
Mar 16 21:03:38 rainbow kernel: [ 3360.271700] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:38 rainbow kernel: [ 3360.271705] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:38 rainbow kernel: [ 3360.271710] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:38 rainbow kernel: [ 3360.271715] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:38 rainbow kernel: [ 3360.271719] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:38 rainbow kernel: [ 3360.271726] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:38 rainbow kernel: [ 3360.271734] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.271739] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:38 rainbow kernel: [ 3360.271745] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:38 rainbow kernel: [ 3360.271751] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:38 rainbow kernel: [ 3360.271757] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:38 rainbow kernel: [ 3360.271762] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:38 rainbow kernel: [ 3360.271768] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:38 rainbow kernel: [ 3360.271773] iwl data: 00000010: ff ff ff ff ff ff 30 02                          ......0.
Mar 16 21:03:38 rainbow kernel: [ 3360.271808] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.468105] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:03:38 rainbow kernel: [ 3360.468132] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.468140] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:38 rainbow kernel: [ 3360.468151] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:38 rainbow kernel: [ 3360.468158] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:38 rainbow kernel: [ 3360.468163] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:38 rainbow kernel: [ 3360.468169] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:38 rainbow kernel: [ 3360.468174] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:38 rainbow kernel: [ 3360.468180] iwl data: 00000010: ff ff ff ff ff ff 40 02                          ......@.
Mar 16 21:03:38 rainbow kernel: [ 3360.468218] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:38 rainbow kernel: [ 3360.668088] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:03:38 rainbow kernel: [ 3360.668102] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:38 rainbow kernel: [ 3360.668106] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:38 rainbow kernel: [ 3360.668110] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:38 rainbow kernel: [ 3360.668113] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:38 rainbow kernel: [ 3360.668115] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:38 rainbow kernel: [ 3360.668117] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:38 rainbow kernel: [ 3360.668119] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:38 rainbow kernel: [ 3360.668121] iwl data: 00000010: ff ff ff ff ff ff 50 02                          ......P.
Mar 16 21:03:38 rainbow kernel: [ 3360.668152] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:39 rainbow kernel: [ 3360.869105] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:03:48 rainbow kernel: [ 3370.276641] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:03:48 rainbow kernel: [ 3370.276654] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:03:48 rainbow kernel: [ 3370.276663] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:03:48 rainbow kernel: [ 3370.276689] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:48 rainbow kernel: [ 3370.276695] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:48 rainbow kernel: [ 3370.276702] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:03:48 rainbow kernel: [ 3370.276720] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:48 rainbow kernel: [ 3370.276725] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:48 rainbow kernel: [ 3370.277125] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:48 rainbow kernel: [ 3370.277135] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:48 rainbow kernel: [ 3370.277140] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:48 rainbow kernel: [ 3370.280076] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:48 rainbow kernel: [ 3370.280085] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:48 rainbow kernel: [ 3370.280090] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:48 rainbow kernel: [ 3370.280095] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:48 rainbow kernel: [ 3370.280100] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:48 rainbow kernel: [ 3370.280104] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:48 rainbow kernel: [ 3370.280108] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:48 rainbow kernel: [ 3370.280112] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:48 rainbow kernel: [ 3370.280116] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:48 rainbow kernel: [ 3370.280120] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:48 rainbow kernel: [ 3370.280124] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:48 rainbow kernel: [ 3370.280129] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:48 rainbow kernel: [ 3370.280136] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:48 rainbow kernel: [ 3370.280147] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:48 rainbow kernel: [ 3370.280150] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:48 rainbow kernel: [ 3370.280151] * channel = 11
Mar 16 21:03:48 rainbow kernel: [ 3370.280153] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:48 rainbow kernel: [ 3370.280159] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:48 rainbow kernel: [ 3370.280164] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:48 rainbow kernel: [ 3370.280169] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:48 rainbow kernel: [ 3370.280174] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:48 rainbow kernel: [ 3370.280182] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:48 rainbow kernel: [ 3370.280202] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:48 rainbow kernel: [ 3370.280208] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:48 rainbow kernel: [ 3370.280219] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:48 rainbow kernel: [ 3370.280225] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:48 rainbow kernel: [ 3370.280231] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:48 rainbow kernel: [ 3370.280236] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:48 rainbow kernel: [ 3370.280242] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:48 rainbow kernel: [ 3370.280248] iwl data: 00000010: ff ff ff ff ff ff 60 02                          ......`.
Mar 16 21:03:48 rainbow kernel: [ 3370.280288] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:48 rainbow kernel: [ 3370.480080] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:03:48 rainbow kernel: [ 3370.480099] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:48 rainbow kernel: [ 3370.480107] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:48 rainbow kernel: [ 3370.480116] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:48 rainbow kernel: [ 3370.480122] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:48 rainbow kernel: [ 3370.480128] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:48 rainbow kernel: [ 3370.480133] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:48 rainbow kernel: [ 3370.480139] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:48 rainbow kernel: [ 3370.480145] iwl data: 00000010: ff ff ff ff ff ff 70 02                          ......p.
Mar 16 21:03:48 rainbow kernel: [ 3370.480183] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:48 rainbow kernel: [ 3370.680135] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:03:48 rainbow kernel: [ 3370.680157] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:48 rainbow kernel: [ 3370.680165] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:48 rainbow kernel: [ 3370.680175] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:48 rainbow kernel: [ 3370.680182] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:48 rainbow kernel: [ 3370.680187] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:48 rainbow kernel: [ 3370.680193] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:48 rainbow kernel: [ 3370.680199] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:48 rainbow kernel: [ 3370.680204] iwl data: 00000010: ff ff ff ff ff ff 80 02                          ........
Mar 16 21:03:48 rainbow kernel: [ 3370.680242] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:49 rainbow kernel: [ 3370.881073] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:03:58 rainbow kernel: [ 3380.280736] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:03:58 rainbow kernel: [ 3380.280749] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:03:58 rainbow kernel: [ 3380.280757] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:03:58 rainbow kernel: [ 3380.280776] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:58 rainbow kernel: [ 3380.280783] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:58 rainbow kernel: [ 3380.280790] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:03:58 rainbow kernel: [ 3380.281061] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:58 rainbow kernel: [ 3380.281071] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:58 rainbow kernel: [ 3380.281076] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:58 rainbow kernel: [ 3380.281864] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:03:58 rainbow kernel: [ 3380.281872] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:03:58 rainbow kernel: [ 3380.281877] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:03:58 rainbow kernel: [ 3380.281882] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:58 rainbow kernel: [ 3380.281887] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:58 rainbow kernel: [ 3380.281891] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:58 rainbow kernel: [ 3380.281895] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:58 rainbow kernel: [ 3380.281899] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:58 rainbow kernel: [ 3380.281903] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:58 rainbow kernel: [ 3380.281907] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:03:58 rainbow kernel: [ 3380.281911] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:03:58 rainbow kernel: [ 3380.281916] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:03:58 rainbow kernel: [ 3380.281921] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:03:58 rainbow kernel: [ 3380.281932] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:03:58 rainbow kernel: [ 3380.281935] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:03:58 rainbow kernel: [ 3380.281936] * channel = 11
Mar 16 21:03:58 rainbow kernel: [ 3380.281938] * bssid = 00:30:bd:c0:90:24
Mar 16 21:03:58 rainbow kernel: [ 3380.281943] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:58 rainbow kernel: [ 3380.281949] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:58 rainbow kernel: [ 3380.281954] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:03:58 rainbow kernel: [ 3380.281958] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:03:58 rainbow kernel: [ 3380.281966] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:03:58 rainbow kernel: [ 3380.281984] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:58 rainbow kernel: [ 3380.281989] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:58 rainbow kernel: [ 3380.281999] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:58 rainbow kernel: [ 3380.282005] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:58 rainbow kernel: [ 3380.282011] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:58 rainbow kernel: [ 3380.282017] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:58 rainbow kernel: [ 3380.282022] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:58 rainbow kernel: [ 3380.282028] iwl data: 00000010: ff ff ff ff ff ff 90 02                          ........
Mar 16 21:03:58 rainbow kernel: [ 3380.282065] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:58 rainbow kernel: [ 3380.282086] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:03:58 rainbow kernel: [ 3380.282091] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:03:58 rainbow kernel: [ 3380.480148] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:03:58 rainbow kernel: [ 3380.480166] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:58 rainbow kernel: [ 3380.480172] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:58 rainbow kernel: [ 3380.480182] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:58 rainbow kernel: [ 3380.480188] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:58 rainbow kernel: [ 3380.480194] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:58 rainbow kernel: [ 3380.480199] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:58 rainbow kernel: [ 3380.480205] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:58 rainbow kernel: [ 3380.480210] iwl data: 00000010: ff ff ff ff ff ff a0 02                          ........
Mar 16 21:03:58 rainbow kernel: [ 3380.480248] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:58 rainbow kernel: [ 3380.652085] ieee80211 phy6: U iwl3945_hw_reg_txpower_get_temperature Temperature: 109
Mar 16 21:03:58 rainbow kernel: [ 3380.680075] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:03:58 rainbow kernel: [ 3380.680088] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:03:58 rainbow kernel: [ 3380.680094] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:03:58 rainbow kernel: [ 3380.680102] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:03:58 rainbow kernel: [ 3380.680108] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:03:58 rainbow kernel: [ 3380.680113] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:03:58 rainbow kernel: [ 3380.680119] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:03:58 rainbow kernel: [ 3380.680124] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:03:58 rainbow kernel: [ 3380.680130] iwl data: 00000010: ff ff ff ff ff ff b0 02                          ........
Mar 16 21:03:58 rainbow kernel: [ 3380.680166] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:03:59 rainbow kernel: [ 3380.880058] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:04:08 rainbow kernel: [ 3390.287472] ieee80211 phy6: U iwl3945_mac_hw_scan enter
Mar 16 21:04:08 rainbow kernel: [ 3390.287483] ieee80211 phy6: U iwl3945_scan_initiate Starting scan...
Mar 16 21:04:08 rainbow kernel: [ 3390.287495] ieee80211 phy6: U iwl3945_mac_hw_scan leave
Mar 16 21:04:08 rainbow kernel: [ 3390.287512] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:04:08 rainbow kernel: [ 3390.287519] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:04:08 rainbow kernel: [ 3390.287526] ieee80211 phy6: U iwl3945_bg_scan_completed SCAN complete scan
Mar 16 21:04:08 rainbow kernel: [ 3390.287543] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:04:08 rainbow kernel: [ 3390.287547] iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:04:08 rainbow kernel: [ 3390.288053] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:04:08 rainbow kernel: [ 3390.288063] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:04:08 rainbow kernel: [ 3390.288069] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:04:08 rainbow kernel: [ 3390.291233] ieee80211 phy6: U iwl3945_mac_config enter to channel 11
Mar 16 21:04:08 rainbow kernel: [ 3390.291242] ieee80211 phy6: U iwl3945_mac_config No re-sending same RXON configuration.
Mar 16 21:04:08 rainbow kernel: [ 3390.291247] ieee80211 phy6: U iwl3945_mac_config leave
Mar 16 21:04:08 rainbow kernel: [ 3390.291252] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:04:08 rainbow kernel: [ 3390.291257] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:04:08 rainbow kernel: [ 3390.291261] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:04:08 rainbow kernel: [ 3390.291265] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:04:08 rainbow kernel: [ 3390.291269] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:04:08 rainbow kernel: [ 3390.291273] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:04:08 rainbow kernel: [ 3390.291277] ieee80211 phy6: U iwl3945_mac_conf_tx enter
Mar 16 21:04:08 rainbow kernel: [ 3390.291281] ieee80211 phy6: U iwl3945_mac_conf_tx leave
Mar 16 21:04:08 rainbow kernel: [ 3390.291286] ieee80211 phy6: U iwl3945_mac_reset_tsf enter
Mar 16 21:04:08 rainbow kernel: [ 3390.291291] ieee80211 phy6: U iwl_reset_qos set QoS to default 
Mar 16 21:04:08 rainbow kernel: [ 3390.291302] ieee80211 phy6: U iwl3945_commit_rxon Sending RXON
Mar 16 21:04:08 rainbow kernel: [ 3390.291305] * without RXON_FILTER_ASSOC_MSK
Mar 16 21:04:08 rainbow kernel: [ 3390.291306] * channel = 11
Mar 16 21:04:08 rainbow kernel: [ 3390.291308] * bssid = 00:30:bd:c0:90:24
Mar 16 21:04:08 rainbow kernel: [ 3390.291313] iwl3945 0000:03:00.0: No space for Tx
Mar 16 21:04:08 rainbow kernel: [ 3390.291319] iwl3945 0000:03:00.0: Error sending REPLY_RXON: iwl3945_enqueue_hcmd failed: -28
Mar 16 21:04:08 rainbow kernel: [ 3390.291324] iwl3945 0000:03:00.0: Error setting new configuration (-28).
Mar 16 21:04:08 rainbow kernel: [ 3390.291329] ieee80211 phy6: U iwl3945_mac_reset_tsf leave - not in IBSS
Mar 16 21:04:08 rainbow kernel: [ 3390.291337] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 1
Mar 16 21:04:08 rainbow kernel: [ 3390.291355] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:04:08 rainbow kernel: [ 3390.291361] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:04:08 rainbow kernel: [ 3390.291371] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:04:08 rainbow kernel: [ 3390.291377] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:04:08 rainbow kernel: [ 3390.291383] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:04:08 rainbow kernel: [ 3390.291388] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:04:08 rainbow kernel: [ 3390.291394] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:04:08 rainbow kernel: [ 3390.291399] iwl data: 00000010: ff ff ff ff ff ff c0 02                          ........
Mar 16 21:04:08 rainbow kernel: [ 3390.291438] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:04:08 rainbow kernel: [ 3390.488088] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 2
Mar 16 21:04:08 rainbow kernel: [ 3390.488105] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:04:08 rainbow kernel: [ 3390.488112] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:04:08 rainbow kernel: [ 3390.488120] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:04:08 rainbow kernel: [ 3390.488126] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:04:08 rainbow kernel: [ 3390.488132] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:04:08 rainbow kernel: [ 3390.488137] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:04:08 rainbow kernel: [ 3390.488143] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:04:08 rainbow kernel: [ 3390.488148] iwl data: 00000010: ff ff ff ff ff ff d0 02                          ........
Mar 16 21:04:08 rainbow kernel: [ 3390.488185] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:04:09 rainbow kernel: [ 3390.688134] wlan0: direct probe to AP 00:30:bd:c0:90:24 try 3
Mar 16 21:04:09 rainbow kernel: [ 3390.688154] ieee80211 phy6: I iwl3945_mac_tx enter
Mar 16 21:04:09 rainbow kernel: [ 3390.688161] ieee80211 phy6: I iwl3945_mac_tx dev->xmit(47 bytes) at rate 0x0a
Mar 16 21:04:09 rainbow kernel: [ 3390.688170] iwl data: 00000000: 2f 00 00 00 00 20 00 00 0a 18 00 00 00 00 00 00  /.... ..........
Mar 16 21:04:09 rainbow kernel: [ 3390.688176] iwl data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 16 21:04:09 rainbow kernel: [ 3390.688182] iwl data: 00000020: 00 00 00 00 00 00 00 00 ff ff ff ff ff 0f 07 0f  ................
Mar 16 21:04:09 rainbow kernel: [ 3390.688188] iwl data: 00000030: 02 00 00 00                                      ....
Mar 16 21:04:09 rainbow kernel: [ 3390.688193] iwl data: 00000000: 40 00 00 00 ff ff ff ff ff ff 00 1f 3c 20 a1 6e  @...........< .n
Mar 16 21:04:09 rainbow kernel: [ 3390.688199] iwl data: 00000010: ff ff ff ff ff ff e0 02                          ........
Mar 16 21:04:09 rainbow kernel: [ 3390.688236] ieee80211 phy6: I iwl3945_mac_tx leave
Mar 16 21:04:09 rainbow kernel: [ 3390.889078] wlan0: direct probe to AP 00:30:bd:c0:90:24 timed out
Mar 16 21:04:17 rainbow kernel: [ 3398.976731] ieee80211 phy6: U iwl3945_pci_remove *** UNLOAD DRIVER ***
Mar 16 21:04:17 rainbow kernel: [ 3398.988045] ieee80211 phy6: I iwl3945_configure_filter Enter: changed: 0x0, total: 0x80000000
Mar 16 21:04:17 rainbow kernel: [ 3399.012026] ieee80211 phy6: U iwl3945_mac_remove_interface enter
Mar 16 21:04:17 rainbow kernel: [ 3399.012035] ieee80211 phy6: U iwl3945_mac_remove_interface leave
Mar 16 21:04:17 rainbow kernel: [ 3399.027827] ieee80211 phy6: U iwl3945_mac_stop enter
Mar 16 21:04:17 rainbow kernel: [ 3399.027834] ieee80211 phy6: U __iwl3945_down iwl3945 is going down
Mar 16 21:04:17 rainbow kernel: [ 3399.032134] ieee80211 phy6: U iwl3945_apm_stop_master stop master
Mar 16 21:04:17 rainbow kernel: [ 3399.032356] ieee80211 phy6: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
Mar 16 21:04:17 rainbow kernel: [ 3399.032647] ieee80211 phy6: U iwl3945_mac_stop leave

--=-PgPRGYlUqEMLMbcJne3X
Content-Disposition: attachment; filename="iwl3945-rb_stts_and_BUG_to_WARN.patch"
Content-Type: text/x-patch; name="iwl3945-rb_stts_and_BUG_to_WARN.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4b4ed65..fbe527b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3131,7 +3131,14 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
 	int cmd_index;
 	struct iwl_cmd *cmd;
 
-	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
+	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
+		 "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
+		  txq_id, sequence,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
+		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
+		return;
+	}
 
 	cmd_index = get_cmd_index(&priv->txq39[IWL_CMD_QUEUE_NUM].q, index, huge);
 	cmd = &priv->txq39[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
@@ -3453,7 +3460,12 @@ int iwl3945_rx_queue_alloc(struct iwl_priv *priv)
 	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
 	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
 	if (!rxq->bd)
-		return -ENOMEM;
+		goto err_bd;
+
+        rxq->rb_stts = pci_alloc_consistent(dev, sizeof(struct iwl_rb_status),
+					&rxq->rb_stts_dma);
+        if (!rxq->rb_stts)
+		goto err_rb;
 
 	/* Fill the rx_used queue with _all_ of the Rx buffers */
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
@@ -3465,6 +3477,12 @@ int iwl3945_rx_queue_alloc(struct iwl_priv *priv)
 	rxq->free_count = 0;
 	rxq->need_update = 0;
 	return 0;
+
+err_rb:
+	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			    rxq->dma_addr);
+err_bd:
+        return -ENOMEM;
 }
 
 void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)

--=-PgPRGYlUqEMLMbcJne3X--

