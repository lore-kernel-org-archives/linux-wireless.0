Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.225]:33453 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbYHWSDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2008 14:03:37 -0400
Received: by qb-out-0506.google.com with SMTP id a16so1344483qbd.17
        for <linux-wireless@vger.kernel.org>; Sat, 23 Aug 2008 11:03:37 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH] orinoco: Multicast to the specified addresses
Date: Sat, 23 Aug 2008 19:03:34 +0100
Message-Id: <1219514614-19800-1-git-send-email-kilroyd@gmail.com> (sfid-20080823_200343_619070_EAE31CF5)
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When multicasting the driver sets the number of group addresses using
the count from the previous set multicast command. In general this means
you have to set the multicast addresses twice to get the behaviour you
want.

If we were multicasting, and reduce the number of addresses we are
multicasting to, then the driver would write uninitialised data from the
stack into the group addresses to multicast to.

Only write the multicast addresses we have specifically set.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---

I came across this while attempting to refactor orinoco.c. I haven't
tried to trigger it (I don't multicast, and don't know how to...).
This code has been untouched since before v2.6.12 but I can't find any
reports of problems. Appreciated if someone can confirm this.

---
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 6a196c3..ec0451c 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -2826,42 +2826,46 @@ __orinoco_set_multicast_list(struct net_device *dev)
 		err = hermes_write_wordrec(hw, USER_BAP,
 					   HERMES_RID_CNFPROMISCUOUSMODE,
 					   promisc);
 		if (err) {
 			printk(KERN_ERR "%s: Error %d setting PROMISCUOUSMODE to 1.\n",
 			       dev->name, err);
 		} else 
 			priv->promiscuous = promisc;
 	}
 
+	/* If we're not in promiscuous mode, then we need to set the
+	 * group address if either we want to multicast, or if we were
+	 * multicasting and want to stop */
 	if (! promisc && (mc_count || priv->mc_count) ) {
 		struct dev_mc_list *p = dev->mc_list;
 		struct hermes_multicast mclist;
 		int i;
 
 		for (i = 0; i < mc_count; i++) {
 			/* paranoia: is list shorter than mc_count? */
 			BUG_ON(! p);
 			/* paranoia: bad address size in list? */
 			BUG_ON(p->dmi_addrlen != ETH_ALEN);
 			
 			memcpy(mclist.addr[i], p->dmi_addr, ETH_ALEN);
 			p = p->next;
 		}
 		
 		if (p)
 			printk(KERN_WARNING "%s: Multicast list is "
 			       "longer than mc_count\n", dev->name);
 
-		err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFGROUPADDRESSES,
-				       HERMES_BYTES_TO_RECLEN(priv->mc_count * ETH_ALEN),
-				       &mclist);
+		err = hermes_write_ltv(hw, USER_BAP,
+				   HERMES_RID_CNFGROUPADDRESSES,
+				   HERMES_BYTES_TO_RECLEN(mc_count * ETH_ALEN),
+				   &mclist);
 		if (err)
 			printk(KERN_ERR "%s: Error %d setting multicast list.\n",
 			       dev->name, err);
 		else
 			priv->mc_count = mc_count;
 	}
 }
 
 /* This must be called from user context, without locks held - use
  * schedule_work() */
-- 
1.5.6.4

