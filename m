Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56337 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3KLABa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 19:01:30 -0500
Received: by mail-ee0-f54.google.com with SMTP id c50so2769646eek.41
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 16:01:28 -0800 (PST)
From: Michal Nazarewicz <mina86@mina86.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHv2.1] net: wireless: iwlwifi: remove minor dead code
In-Reply-To: <1384177312.14334.12.camel@jlt4.sipsolutions.net>
References: <1384110397-24386-1-git-send-email-mpn@google.com> <527FDB50.1050902@cogentembedded.com> <87iow080zv.fsf@mina86.com> <1384177312.14334.12.camel@jlt4.sipsolutions.net>
Date: Tue, 12 Nov 2013 01:01:26 +0100
Message-ID: <xa1tr4amwkrt.fsf@mina86.com> (sfid-20131112_010154_387966_98EACF60)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

inta is checked to be zero in a IRQ_NONE branch so afterwards it
cannot be zero as it is never modified.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

On Mon, Nov 11 2013, Johannes Berg wrote:
> no signed-off-by

Sorry, fixed.  Interestingly, I did not forget about it in my first patch.

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 3f237b4..7d0fdc0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1121,7 +1121,6 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	struct iwl_trans *trans = data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 inta, inta_mask;
-	irqreturn_t ret = IRQ_NONE;
 
 	lockdep_assert_held(&trans_pcie->irq_lock);
 
@@ -1150,7 +1149,14 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 	 * or due to sporadic interrupts thrown from our NIC. */
 	if (!inta) {
 		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
-		goto none;
+		/* re-enable interrupts here since we don't have anything to
+		 * service.  only Re-enable if disabled by irq and no
+		 * schedules tasklet.
+		 */
+		if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
+		    !trans_pcie->inta)
+			iwl_enable_interrupts(trans);
+		return IRQ_NONE;
 	}
 
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
@@ -1168,19 +1174,7 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
 
 	trans_pcie->inta |= inta;
 	/* the thread will service interrupts and re-enable them */
-	if (likely(inta))
-		return IRQ_WAKE_THREAD;
-
-	ret = IRQ_HANDLED;
-
-none:
-	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if disabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
-	    !trans_pcie->inta)
-		iwl_enable_interrupts(trans);
-
-	return ret;
+	return IRQ_WAKE_THREAD;
 }
 
 /* interrupt handler using ict table, with this interrupt driver will
-- 
1.8.3.2
