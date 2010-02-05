Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab0BEHHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 02:07:43 -0500
Subject: [PATCH] airo: fix WEP key clearing after
 c0380693520b1a1e4f756799a0edc379378b462a
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <1265353178.11066.5.camel@localhost.localdomain>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
	 <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com>
	 <1265353178.11066.5.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 23:06:54 -0800
Message-ID: <1265353614.11066.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware apparently needs the WEP key RID touched when turning WEP
off, otherwise it gets angry and refuses to return scan results.  The
firmware doesn't handle zero-length WEP keys so quite the warning
message that was inadvertently printed when disabling WEP, which
wpa_supplicant could trigger repeatedly.

Signed-off-by: Dan Williams <dcbw@redhat.com>

---

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 4331d67..38902c7 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5254,11 +5254,8 @@ static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
 	WepKeyRid wkr;
 	int rc;
 
-	if (keylen == 0) {
-		airo_print_err(ai->dev->name, "%s: key length to set was zero",
-			       __func__);
+	if (WARN_ON (keylen == 0))
 		return -1;
-	}
 
 	memset(&wkr, 0, sizeof(wkr));
 	wkr.len = cpu_to_le16(sizeof(wkr));
@@ -6532,7 +6529,7 @@ static int airo_set_encodeext(struct net_device *dev,
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int perm = ( encoding->flags & IW_ENCODE_TEMP ? 0 : 1 );
 	__le16 currentAuthType = local->config.authType;
-	int idx, key_len, alg = ext->alg, set_key = 1, rc;
+	int idx, key_len, alg = ext->alg, rc;
 	wep_key_t key;
 
 	if (!local->wep_capable)
@@ -6566,10 +6563,9 @@ static int airo_set_encodeext(struct net_device *dev,
 			               idx, rc);
 			return rc;
 		}
-		set_key = ext->key_len > 0 ? 1 : 0;
 	}
 
-	if (set_key) {
+	if (ext->key_len > 0) {
 		/* Set the requested key first */
 		memset(key.key, 0, MAX_KEY_SIZE);
 		switch (alg) {
@@ -6600,12 +6596,20 @@ static int airo_set_encodeext(struct net_device *dev,
 	}
 
 	/* Read the flags */
-	if(encoding->flags & IW_ENCODE_DISABLED)
+	if (encoding->flags & IW_ENCODE_DISABLED) {
+		/* The firmware seems to need the WEP key RID touched when
+		 * setting WEP disabled; resetting the transmit key index to 0
+		 * is good enough.  Otherwise it gets confused and stops
+		 * delivering scan results (!).
+		 */
+		if (!(ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY))
+			set_wep_tx_idx(local, 0, 0, 1);
 		local->config.authType = AUTH_OPEN;	// disable encryption
-	if(encoding->flags & IW_ENCODE_RESTRICTED)
+	} else if (encoding->flags & IW_ENCODE_RESTRICTED)
 		local->config.authType = AUTH_SHAREDKEY;	// Only Both
-	if(encoding->flags & IW_ENCODE_OPEN)
+	else if (encoding->flags & IW_ENCODE_OPEN)
 		local->config.authType = AUTH_ENCRYPT;	// Only Wep
+
 	/* Commit the changes to flags if needed */
 	if (local->config.authType != currentAuthType)
 		set_bit (FLAG_COMMIT, &local->flags);


