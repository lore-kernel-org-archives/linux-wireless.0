Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:13354 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbXEQBYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 21:24:00 -0400
Date: Wed, 16 May 2007 18:27:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
Message-Id: <20070516182700.912a21ed.randy.dunlap@oracle.com>
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
> ---
> 
> NOTE:  The patch is 597k and can be found at:
> 
> 	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch
> 
> Patch is against wireless-dev commit-id be8662897~


Some comments/review, mostly not-code-related:

1.  Indent Kconfig help text with one tab + 2 spaces (not 8 spaces).

2.  Convert function comment blocks into kernel-doc.  E.g., this one:

+/**
+ * Deallocate DMA queue.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ *
+ * @param dev
+ * @param q

(These param names are not correct.)

+ */

would be:

/**
 * iwl_tx_queue_free - Deallocate DMA queue
 * @priv:  describe this param
 * @txq:  describe this param
 *
 * Empty queue by removing and destroying all BD's.
 * Free all buffers.
 */

Preferably at least all non-static functions will be documented
with kernel-doc.

3.  Indent labels: with 0 or 1 space, not with 7 spaces.
Using 7 spaces hides them, makes them too difficult to see/find.

4.  Please don't use /** to begin comment blocks that are not
in kernel-doc format.

5.  Some inline functions may be too large.  E.g., this one:
+static inline int full_rxon_required(struct iwl_priv *priv)

6.  What does 0x40 mean here?  (don't use magic values)
+	if (res->hdr.flags & 0x40) {

7.  This test can be shortened (lots of instances):

+		if (is_broadcast_ether_addr(header->addr1) ||
+		    is_multicast_ether_addr(header->addr1))
+			return !compare_ether_addr(header->addr3, priv->bssid);

since (quoting include/linux/etherdevic.h):
 * By definition the broadcast address is also a multicast address.

8.  Multi-line comment format has a '*' on each line:
+/*
+  handle build REPLY_TX command notification.
+*/

so add '*' in lots of places.

9.  in is_duplicate_packet(), the
+	case IEEE80211_IF_TYPE_IBSS:{
block is indented one extra tab.

10. typo:
+ * When FW adwances 'R' index, all entries between old and
            advances

11. Don't indent #endif like this:

+#if IWL == 3945
+	u8 rate = beacon->beacon_notify_hdr.rate;
+#elif IWL == 4965
+	u8 rate = beacon->beacon_notify_hdr.rate.rate;
+	#endif

12.  36 lines end with trailing whitespace.  :(

13.  Need blank line before and after functions (several of these):

+#define ERROR_START_OFFSET  (1 * sizeof(u32))
+#define ERROR_ELEM_SIZE     (7 * sizeof(u32))
+static void iwl_dump_nic_error_log(struct iwl_priv *priv)
+{

14.  sysfs files should contain only 1 value.  Compare

+static ssize_t show_tune(struct device *d,
+			 struct device_attribute *attr, char *buf)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
+
+	return sprintf(buf, "%d %d\n",
+		       priv->phymode, priv->active_rxon.channel);
+}

and show_channels()  [probably others].

15.  Limit source lines to <= 80 columns (this patch contains
over 200 lines that are > 80 columns).

16.  Don't use such obfuscated wrappers like these:

+#define IWL_NOP {}
+#define IWL_NOP_RET(x) { return x; }

just open-code them.


OK, my eyes are glazing over.  I'll check the rest of it later.

I hope that some of the wireless developers also review it (since
I'm not one).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
