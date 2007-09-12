Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:53170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685AbXILVEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 17:04:30 -0400
Received: by ug-out-1314.google.com with SMTP id z38so303649ugc
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2007 14:04:29 -0700 (PDT)
Message-ID: <46E8558B.5000206@gmail.com>
Date: Wed, 12 Sep 2007 22:09:31 +0100
MIME-Version: 1.0
To: orinoco-devel@lists.sourceforge.net,
	orinoco-users@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, proski@gnu.org,
	hermes@gibson.dropbear.id.au
Subject: [PATCH 01/05] orinoco: Agere/Lucent firmware download
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specify all three parameters to every Hermes command.

hermes_issue_cmd and hermes_docmd_wait now take two
more parameters.

orinoco.c and spectrum_cs.c updated to specify the
extra parameters.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/hermes.c
index 29d3910..d655f3f 100644
--- a/drivers/net/wireless/hermes.c
+++ b/drivers/net/wireless/hermes.c
@@ -87,7 +87,8 @@ MODULE_LICENSE("Dual MPL/GPL");
 
    Callable from any context.
 */
-static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0)
+static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0,
+			    u16 param1, u16 param2)
 {
 	int k = CMD_BUSY_TIMEOUT;
 	u16 reg;
@@ -103,8 +104,8 @@ static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0)
 		return -EBUSY;
 	}
 
-	hermes_write_regn(hw, PARAM2, 0);
-	hermes_write_regn(hw, PARAM1, 0);
+	hermes_write_regn(hw, PARAM2, param2);
+	hermes_write_regn(hw, PARAM1, param1);
 	hermes_write_regn(hw, PARAM0, param0);
 	hermes_write_regn(hw, CMD, cmd);
 	
@@ -162,7 +163,7 @@ int hermes_init(hermes_t *hw)
 
 	/* We don't use hermes_docmd_wait here, because the reset wipes
 	   the magic constant in SWSUPPORT0 away, and it gets confused */
-	err = hermes_issue_cmd(hw, HERMES_CMD_INIT, 0);
+	err = hermes_issue_cmd(hw, HERMES_CMD_INIT, 0, 0, 0);
 	if (err)
 		return err;
 
@@ -208,7 +209,8 @@ int hermes_init(hermes_t *hw)
  * Returns: < 0 on internal error, 0 on success, > 0 on error returned by the firmware
  *
  * Callable from any context, but locking is your problem. */
-int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
+int hermes_docmd_wait(hermes_t *hw, u16 cmd,
+		      u16 parm0, u16 parm1, u16 parm2,
 		      struct hermes_response *resp)
 {
 	int err;
@@ -216,7 +218,7 @@ int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
 	u16 reg;
 	u16 status;
 
-	err = hermes_issue_cmd(hw, cmd, parm0);
+	err = hermes_issue_cmd(hw, cmd, parm0, parm1, parm2);
 	if (err) {
 		if (! hermes_present(hw)) {
 			if (net_ratelimit())
@@ -281,7 +283,7 @@ int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
 	if ( (size < HERMES_ALLOC_LEN_MIN) || (size > HERMES_ALLOC_LEN_MAX) )
 		return -EINVAL;
 
-	err = hermes_docmd_wait(hw, HERMES_CMD_ALLOC, size, NULL);
+	err = hermes_docmd_wait(hw, HERMES_CMD_ALLOC, size, 0, 0, NULL);
 	if (err) {
 		return err;
 	}
@@ -442,7 +444,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
 	if ( (bufsize < 0) || (bufsize % 2) )
 		return -EINVAL;
 
-	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS, rid, NULL);
+	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS, rid, 0, 0, NULL);
 	if (err)
 		return err;
 
@@ -497,8 +499,8 @@ int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 
 	hermes_write_bytes(hw, dreg, value, count << 1);
 
-	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS | HERMES_CMD_WRITE, 
-				rid, NULL);
+	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS | HERMES_CMD_WRITE,
+				rid, 0, 0, NULL);
 
 	return err;
 }
diff --git a/drivers/net/wireless/hermes.h b/drivers/net/wireless/hermes.h
index 8e3f0e3..0d38bf6 100644
--- a/drivers/net/wireless/hermes.h
+++ b/drivers/net/wireless/hermes.h
@@ -351,7 +351,8 @@ typedef struct hermes {
 /* Function prototypes */
 void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing);
 int hermes_init(hermes_t *hw);
-int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
+int hermes_docmd_wait(hermes_t *hw, u16 cmd,
+		      u16 parm0, u16 parm1, u16 parm2,
 		      struct hermes_response *resp);
 int hermes_allocate(hermes_t *hw, u16 size, u16 *fid);
 
@@ -380,20 +381,20 @@ static inline void hermes_set_irqmask(hermes_t *hw, u16 events)
 static inline int hermes_enable_port(hermes_t *hw, int port)
 {
 	return hermes_docmd_wait(hw, HERMES_CMD_ENABLE | (port << 8),
-				 0, NULL);
+				 0, 0, 0, NULL);
 }
 
 static inline int hermes_disable_port(hermes_t *hw, int port)
 {
 	return hermes_docmd_wait(hw, HERMES_CMD_DISABLE | (port << 8), 
-				 0, NULL);
+				 0, 0, 0, NULL);
 }
 
 /* Initiate an INQUIRE command (tallies or scan).  The result will come as an
  * information frame in __orinoco_ev_info() */
 static inline int hermes_inquire(hermes_t *hw, u16 rid)
 {
-	return hermes_docmd_wait(hw, HERMES_CMD_INQUIRE, rid, NULL);
+	return hermes_docmd_wait(hw, HERMES_CMD_INQUIRE, rid, 0, 0, NULL);
 }
 
 #define HERMES_BYTES_TO_RECLEN(n) ( (((n)+1)/2) + 1 )
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 062286d..fccc57a 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -513,7 +513,7 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	netif_stop_queue(dev);
 
 	err = hermes_docmd_wait(hw, HERMES_CMD_TX | HERMES_CMD_RECL,
-				txfid, NULL);
+				txfid, 0, 0, NULL);
 	if (err) {
 		netif_start_queue(dev);
 		if (net_ratelimit())
@@ -1777,12 +1777,12 @@ static int __orinoco_program_rids(struct net_device *dev)
 		/* Enable monitor mode */
 		dev->type = ARPHRD_IEEE80211;
 		err = hermes_docmd_wait(hw, HERMES_CMD_TEST | 
-					    HERMES_TEST_MONITOR, 0, NULL);
+					    HERMES_TEST_MONITOR, 0, 0, 0, NULL);
 	} else {
 		/* Disable monitor mode */
 		dev->type = ARPHRD_ETHER;
 		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
-					    HERMES_TEST_STOP, 0, NULL);
+					    HERMES_TEST_STOP, 0, 0, 0, NULL);
 	}
 	if (err)
 		return err;
@@ -3133,7 +3133,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 		hermes_t *hw = &priv->hw;
 		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
 					    HERMES_TEST_SET_CHANNEL,
-					chan, NULL);
+					chan, 0, 0, NULL);
 	}
 	orinoco_unlock(priv, &flags);
 
diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/spectrum_cs.c
index af70460..b273362 100644
--- a/drivers/net/wireless/spectrum_cs.c
+++ b/drivers/net/wireless/spectrum_cs.c
@@ -354,7 +354,7 @@ spectrum_read_pda(hermes_t *hw, __le16 *pda, int pda_len)
 	int pda_size;
 
 	/* Issue command to read EEPROM */
-	ret = hermes_docmd_wait(hw, HERMES_CMD_READMIF, 0, NULL);
+	ret = hermes_docmd_wait(hw, HERMES_CMD_READMIF, 0, 0, 0, NULL);
 	if (ret)
 		return ret;
 

