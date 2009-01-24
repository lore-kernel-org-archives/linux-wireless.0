Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55033 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbZAXOOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:14:51 -0500
Subject: [PATCH 6/7 v2] airo: clean up and clarify micinit()
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1232748914.447.2.camel@localhost.localdomain>
References: <1232748914.447.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 09:13:32 -0500
Message-Id: <1232806412.2870.10.camel@localhost.localdomain> (sfid-20090124_151454_040968_91B42F20)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some endian issues too.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 49872db..c047580 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1302,6 +1302,29 @@ static void emmh32_update(emmh32_context *context, u8 *pOctets, int len);
 static void emmh32_final(emmh32_context *context, u8 digest[4]);
 static int flashpchar(struct airo_info *ai,int byte,int dwelltime);
 
+static void age_mic_context(miccntx *cur, miccntx *old, u8 *key, int key_len,
+			    struct crypto_cipher *tfm)
+{
+	/* If the current MIC context is valid and its key is the same as
+	 * the MIC register, there's nothing to do.
+	 */
+	if (cur->valid && (memcmp(cur->key, key, key_len) == 0))
+		return;
+
+	/* Age current mic Context */
+	memcpy(old, cur, sizeof(*cur));
+
+	/* Initialize new context */
+	memcpy(cur->key, key, key_len);
+	cur->window  = 33; /* Window always points to the middle */
+	cur->rx      = 0;  /* Rx Sequence numbers */
+	cur->tx      = 0;  /* Tx sequence numbers */
+	cur->valid   = 1;  /* Key is now valid */
+
+	/* Give key to mic seed */
+	emmh32_setseed(&cur->seed, key, key_len, tfm);
+}
+
 /* micinit - Initialize mic seed */
 
 static void micinit(struct airo_info *ai)
@@ -1312,49 +1335,26 @@ static void micinit(struct airo_info *ai)
 	PC4500_readrid(ai, RID_MIC, &mic_rid, sizeof(mic_rid), 0);
 	up(&ai->sem);
 
-	ai->micstats.enabled = (mic_rid.state & 0x00FF) ? 1 : 0;
-
-	if (ai->micstats.enabled) {
-		/* Key must be valid and different */
-		if (mic_rid.multicastValid && (!ai->mod[0].mCtx.valid ||
-		    (memcmp (ai->mod[0].mCtx.key, mic_rid.multicast,
-			     sizeof(ai->mod[0].mCtx.key)) != 0))) {
-			/* Age current mic Context */
-			memcpy(&ai->mod[1].mCtx,&ai->mod[0].mCtx,sizeof(miccntx));
-			/* Initialize new context */
-			memcpy(&ai->mod[0].mCtx.key,mic_rid.multicast,sizeof(mic_rid.multicast));
-			ai->mod[0].mCtx.window  = 33; //Window always points to the middle
-			ai->mod[0].mCtx.rx      = 0;  //Rx Sequence numbers
-			ai->mod[0].mCtx.tx      = 0;  //Tx sequence numbers
-			ai->mod[0].mCtx.valid   = 1;  //Key is now valid
-  
-			/* Give key to mic seed */
-			emmh32_setseed(&ai->mod[0].mCtx.seed,mic_rid.multicast,sizeof(mic_rid.multicast), ai->tfm);
-		}
-
-		/* Key must be valid and different */
-		if (mic_rid.unicastValid && (!ai->mod[0].uCtx.valid || 
-		    (memcmp(ai->mod[0].uCtx.key, mic_rid.unicast,
-			    sizeof(ai->mod[0].uCtx.key)) != 0))) {
-			/* Age current mic Context */
-			memcpy(&ai->mod[1].uCtx,&ai->mod[0].uCtx,sizeof(miccntx));
-			/* Initialize new context */
-			memcpy(&ai->mod[0].uCtx.key,mic_rid.unicast,sizeof(mic_rid.unicast));
-	
-			ai->mod[0].uCtx.window  = 33; //Window always points to the middle
-			ai->mod[0].uCtx.rx      = 0;  //Rx Sequence numbers
-			ai->mod[0].uCtx.tx      = 0;  //Tx sequence numbers
-			ai->mod[0].uCtx.valid   = 1;  //Key is now valid
-	
-			//Give key to mic seed
-			emmh32_setseed(&ai->mod[0].uCtx.seed, mic_rid.unicast, sizeof(mic_rid.unicast), ai->tfm);
-		}
-	} else {
-      /* So next time we have a valid key and mic is enabled, we will update
-       * the sequence number if the key is the same as before.
-       */
+	ai->micstats.enabled = (le16_to_cpu(mic_rid.state) & 0x00FF) ? 1 : 0;
+	if (!ai->micstats.enabled) {
+		/* So next time we have a valid key and mic is enabled, we will
+		 * update the sequence number if the key is the same as before.
+		 */
 		ai->mod[0].uCtx.valid = 0;
 		ai->mod[0].mCtx.valid = 0;
+		return;
+	}
+
+	if (mic_rid.multicastValid) {
+		age_mic_context(&ai->mod[0].mCtx, &ai->mod[1].mCtx,
+		                mic_rid.multicast, sizeof(mic_rid.multicast),
+		                ai->tfm);
+	}
+
+	if (mic_rid.unicastValid) {
+		age_mic_context(&ai->mod[0].uCtx, &ai->mod[1].uCtx,
+				mic_rid.unicast, sizeof(mic_rid.unicast),
+				ai->tfm);
 	}
 }
 

