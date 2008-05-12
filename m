Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:27226 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbYELJNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 05:13:53 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1730897fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 02:13:49 -0700 (PDT)
Message-ID: <8704f27d0805120213w197327b0r2fa490df1e5399d1@mail.gmail.com> (sfid-20080512_111356_839506_C9F50D76)
Date: Mon, 12 May 2008 12:13:49 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Volker Braun" <vbraun@physics.upenn.edu>
Subject: Re: dynamic wep with mulitple keys
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <8704f27d0805081149wa91072en32ce8912ba1a14ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2945_10250538.1210583629493"
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <1ba2fa240804231015r41e7d7f5ocf7d78af72fb4622@mail.gmail.com>
	 <8704f27d0805050735s647ac4aaq469630bde6bc341e@mail.gmail.com>
	 <1210003121.11809.10.camel@carrot.hep.upenn.edu>
	 <8704f27d0805052346u24954211l6f55513c78205586@mail.gmail.com>
	 <1210271472.30724.43.camel@carrot.hep.upenn.edu>
	 <8704f27d0805081149wa91072en32ce8912ba1a14ff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_2945_10250538.1210583629493
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

here is the patch I promised last week, can you please try it ?
You might have some trouble to apply since my code base slightly
differs from yours.

--------------------------------

>From 860fe4a63b1e9be8047f1b2f37c9072e92df5a5b Mon Sep 17 00:00:00 2001
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Mon, 12 May 2008 10:21:01 +0300
Subject: [PATCH] iwlwifi: code clean up in security

This patch cleans up code in security. This clean up uses the
new pointer to ieee80211_key_conf passed with the tx_control.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   24 +++++++--------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   43 +++++++++------------------
 2 files changed, 25 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c
b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c8e468f..ab3e223 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -324,7 +324,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	unsigned long flags;

 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = keyconf->keyidx;
+	keyconf->hw_key_idx = 1;
 	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;

 	spin_lock_irqsave(&priv->sta_lock, flags);
@@ -354,7 +354,6 @@ static int iwl_set_wep_dynamic_key_info(struct
iwl_priv *priv,
 	int ret;

 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = keyconf->keyidx;

 	key_flags |= (STA_KEY_FLG_WEP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
@@ -411,7 +410,6 @@ static int iwl_set_ccmp_dynamic_key_info(struct
iwl_priv *priv,
 		key_flags |= STA_KEY_MULTICAST_MSK;

 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = keyconf->keyidx;

 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
@@ -449,12 +447,10 @@ static int iwl_set_tkip_dynamic_key_info(struct
iwl_priv *priv,

 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-	keyconf->hw_key_idx = keyconf->keyidx;

 	spin_lock_irqsave(&priv->sta_lock, flags);

 	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
-	priv->stations[sta_id].keyinfo.conf = keyconf;
 	priv->stations[sta_id].keyinfo.keylen = 16;

 	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
@@ -483,7 +479,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	u16 key_flags;
 	u8 keyidx;

-	priv->key_mapping_key = 0;
+	priv->key_mapping_key--;

 	spin_lock_irqsave(&priv->sta_lock, flags);
 	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
@@ -521,24 +517,26 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_remove_dynamic_key);

 int iwl_set_dynamic_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key, u8 sta_id)
+				struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	int ret;

-	priv->key_mapping_key = 1;
+	priv->key_mapping_key++;
+	priv->stations[sta_id].keyinfo.conf = keyconf;
+	keyconf->hw_key_idx = 0;

-	switch (key->alg) {
+	switch (keyconf->alg) {
 	case ALG_CCMP:
-		ret = iwl_set_ccmp_dynamic_key_info(priv, key, sta_id);
+		ret = iwl_set_ccmp_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	case ALG_TKIP:
-		ret = iwl_set_tkip_dynamic_key_info(priv, key, sta_id);
+		ret = iwl_set_tkip_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	case ALG_WEP:
-		ret = iwl_set_wep_dynamic_key_info(priv, key, sta_id);
+		ret = iwl_set_wep_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	default:
-		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, key->alg);
+		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
 		ret = -EINVAL;
 	}

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 481e943..492fc63 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1466,16 +1466,13 @@ static void
iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct sk_buff *skb_frag,
 				      int sta_id)
 {
-	struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
-	struct iwl_wep_key *wepkey;
 	int keyidx = 0;
+	struct ieee80211_key_conf *keyconf = ctl->hw_key;

-	BUG_ON(ctl->hw_key->hw_key_idx > 3);
-
-	switch (keyinfo->alg) {
+	switch (keyconf->alg) {
 	case ALG_CCMP:
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_CCM;
-		memcpy(cmd->cmd.tx.key, keyinfo->key, keyinfo->keylen);
+		memcpy(cmd->cmd.tx.key, keyconf->key, keyconf->keylen);
 		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
 			cmd->cmd.tx.tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
 		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
@@ -1483,39 +1480,26 @@ static void
iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,

 	case ALG_TKIP:
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_TKIP;
-		ieee80211_get_tkip_key(keyinfo->conf, skb_frag,
+		ieee80211_get_tkip_key(keyconf, skb_frag,
 			IEEE80211_TKIP_P2_KEY, cmd->cmd.tx.key);
 		IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
 		break;

 	case ALG_WEP:
-		wepkey = &priv->wep_keys[ctl->hw_key->hw_key_idx];
-		cmd->cmd.tx.sec_ctl = 0;
-		if (priv->default_wep_key) {
-			/* the WEP key was sent as static */
-			keyidx = ctl->hw_key->hw_key_idx;
-			memcpy(&cmd->cmd.tx.key[3], wepkey->key,
-							wepkey->key_size);
-			if (wepkey->key_size == WEP_KEY_LEN_128)
-				cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
-		} else {
-			/* the WEP key was sent as dynamic */
-			keyidx = keyinfo->keyidx;
-			memcpy(&cmd->cmd.tx.key[3], keyinfo->key,
-							keyinfo->keylen);
-			if (keyinfo->keylen == WEP_KEY_LEN_128)
-				cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
-		}
+		cmd->cmd.tx.sec_ctl = (TX_CMD_SEC_WEP |
+			(keyconf->keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);

-		cmd->cmd.tx.sec_ctl |= (TX_CMD_SEC_WEP |
-			(keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
+		if (keyconf->keylen == WEP_KEY_LEN_128)
+			cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
+
+		memcpy(&cmd->cmd.tx.key[3], keyconf->key, keyconf->keylen);

 		IWL_DEBUG_TX("Configuring packet for WEP encryption "
 			     "with key %d\n", keyidx);
 		break;

 	default:
-		printk(KERN_ERR "Unknown encode alg %d\n", keyinfo->alg);
+		printk(KERN_ERR "Unknown encode alg %d\n", keyconf->alg);
 		break;
 	}
 }
@@ -5579,11 +5563,11 @@ static int iwl4965_mac_set_key(struct
ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (cmd == SET_KEY)
 			is_default_wep_key = !priv->key_mapping_key;
 		else
-			is_default_wep_key = priv->default_wep_key;
+			is_default_wep_key = key->hw_key_idx;
 	}
-
 	switch (cmd) {
 	case SET_KEY:
+		printk(KERN_ERR "Set key: static = %d, keyidx = %d sta = %d default
= %d\n", is_default_wep_key, key->keyidx, sta_id,
priv->key_mapping_key);
 		if (is_default_wep_key)
 			ret = iwl_set_default_wep_key(priv, key);
 		else
@@ -5592,6 +5576,7 @@ static int iwl4965_mac_set_key(struct
ieee80211_hw *hw, enum set_key_cmd cmd,
 		IWL_DEBUG_MAC80211("enable hwcrypto key\n");
 		break;
 	case DISABLE_KEY:
+		printk(KERN_ERR "Remove key: static = %d, keyidx = %d sta = %d
default = %d\n", is_default_wep_key, key->keyidx, sta_id,
priv->key_mapping_key);
 		if (is_default_wep_key)
 			ret = iwl_remove_default_wep_key(priv, key);
 		else
-- 
1.5.4.1



-- 
Emmanuel Grumbach
egrumbach@gmail.com

------=_Part_2945_10250538.1210583629493
Content-Type: text/x-patch;
 name=0001-iwlwifi-code-clean-up-in-security.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fg4u5xsk0
Content-Disposition: attachment;
 filename=0001-iwlwifi-code-clean-up-in-security.patch

RnJvbSA4NjBmZTRhNjNiMWU5YmU4MDQ3ZjFiMmYzN2M5MDcyZTkyZGY1YTViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hA
aW50ZWwuY29tPgpEYXRlOiBNb24sIDEyIE1heSAyMDA4IDEwOjIxOjAxICswMzAwClN1YmplY3Q6
IFtQQVRDSF0gaXdsd2lmaTogY29kZSBjbGVhbiB1cCBpbiBzZWN1cml0eQoKVGhpcyBwYXRjaCBj
bGVhbnMgdXAgY29kZSBpbiBzZWN1cml0eS4gVGhpcyBjbGVhbiB1cCB1c2VzIHRoZQpuZXcgcG9p
bnRlciB0byBpZWVlODAyMTFfa2V5X2NvbmYgcGFzc2VkIHdpdGggdGhlIHR4X2NvbnRyb2wuCgpT
aWduZWQtb2ZmLWJ5OiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hAaW50ZWwu
Y29tPgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXN0YS5jICAgICAgfCAg
IDI0ICsrKysrKystLS0tLS0tLQogZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2w0OTY1
LWJhc2UuYyB8ICAgNDMgKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5n
ZWQsIDI1IGluc2VydGlvbnMoKyksIDQyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXN0YS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aXdsd2lmaS9pd2wtc3RhLmMKaW5kZXggYzhlNDY4Zi4uYWIzZTIyMyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtc3RhLmMKKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvaXdsd2lmaS9pd2wtc3RhLmMKQEAgLTMyNCw3ICszMjQsNyBAQCBpbnQgaXdsX3NldF9k
ZWZhdWx0X3dlcF9rZXkoc3RydWN0IGl3bF9wcml2ICpwcml2LAogCXVuc2lnbmVkIGxvbmcgZmxh
Z3M7CiAKIAlrZXljb25mLT5mbGFncyAmPSB+SUVFRTgwMjExX0tFWV9GTEFHX0dFTkVSQVRFX0lW
OwotCWtleWNvbmYtPmh3X2tleV9pZHggPSBrZXljb25mLT5rZXlpZHg7CisJa2V5Y29uZi0+aHdf
a2V5X2lkeCA9IDE7CiAJcHJpdi0+c3RhdGlvbnNbSVdMX0FQX0lEXS5rZXlpbmZvLmFsZyA9IEFM
R19XRVA7CiAKIAlzcGluX2xvY2tfaXJxc2F2ZSgmcHJpdi0+c3RhX2xvY2ssIGZsYWdzKTsKQEAg
LTM1NCw3ICszNTQsNiBAQCBzdGF0aWMgaW50IGl3bF9zZXRfd2VwX2R5bmFtaWNfa2V5X2luZm8o
c3RydWN0IGl3bF9wcml2ICpwcml2LAogCWludCByZXQ7CiAKIAlrZXljb25mLT5mbGFncyAmPSB+
SUVFRTgwMjExX0tFWV9GTEFHX0dFTkVSQVRFX0lWOwotCWtleWNvbmYtPmh3X2tleV9pZHggPSBr
ZXljb25mLT5rZXlpZHg7CiAKIAlrZXlfZmxhZ3MgfD0gKFNUQV9LRVlfRkxHX1dFUCB8IFNUQV9L
RVlfRkxHX01BUF9LRVlfTVNLKTsKIAlrZXlfZmxhZ3MgfD0gY3B1X3RvX2xlMTYoa2V5Y29uZi0+
a2V5aWR4IDw8IFNUQV9LRVlfRkxHX0tFWUlEX1BPUyk7CkBAIC00MTEsNyArNDEwLDYgQEAgc3Rh
dGljIGludCBpd2xfc2V0X2NjbXBfZHluYW1pY19rZXlfaW5mbyhzdHJ1Y3QgaXdsX3ByaXYgKnBy
aXYsCiAJCWtleV9mbGFncyB8PSBTVEFfS0VZX01VTFRJQ0FTVF9NU0s7CiAKIAlrZXljb25mLT5m
bGFncyB8PSBJRUVFODAyMTFfS0VZX0ZMQUdfR0VORVJBVEVfSVY7Ci0Ja2V5Y29uZi0+aHdfa2V5
X2lkeCA9IGtleWNvbmYtPmtleWlkeDsKIAogCXNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5zdGFf
bG9jaywgZmxhZ3MpOwogCXByaXYtPnN0YXRpb25zW3N0YV9pZF0ua2V5aW5mby5hbGcgPSBrZXlj
b25mLT5hbGc7CkBAIC00NDksMTIgKzQ0NywxMCBAQCBzdGF0aWMgaW50IGl3bF9zZXRfdGtpcF9k
eW5hbWljX2tleV9pbmZvKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwKIAogCWtleWNvbmYtPmZsYWdz
IHw9IElFRUU4MDIxMV9LRVlfRkxBR19HRU5FUkFURV9JVjsKIAlrZXljb25mLT5mbGFncyB8PSBJ
RUVFODAyMTFfS0VZX0ZMQUdfR0VORVJBVEVfTU1JQzsKLQlrZXljb25mLT5od19rZXlfaWR4ID0g
a2V5Y29uZi0+a2V5aWR4OwogCiAJc3Bpbl9sb2NrX2lycXNhdmUoJnByaXYtPnN0YV9sb2NrLCBm
bGFncyk7CiAKIAlwcml2LT5zdGF0aW9uc1tzdGFfaWRdLmtleWluZm8uYWxnID0ga2V5Y29uZi0+
YWxnOwotCXByaXYtPnN0YXRpb25zW3N0YV9pZF0ua2V5aW5mby5jb25mID0ga2V5Y29uZjsKIAlw
cml2LT5zdGF0aW9uc1tzdGFfaWRdLmtleWluZm8ua2V5bGVuID0gMTY7CiAKIAlpZiAoKHByaXYt
PnN0YXRpb25zW3N0YV9pZF0uc3RhLmtleS5rZXlfZmxhZ3MgJiBTVEFfS0VZX0ZMR19FTkNSWVBU
X01TSykKQEAgLTQ4Myw3ICs0NzksNyBAQCBpbnQgaXdsX3JlbW92ZV9keW5hbWljX2tleShzdHJ1
Y3QgaXdsX3ByaXYgKnByaXYsCiAJdTE2IGtleV9mbGFnczsKIAl1OCBrZXlpZHg7CiAKLQlwcml2
LT5rZXlfbWFwcGluZ19rZXkgPSAwOworCXByaXYtPmtleV9tYXBwaW5nX2tleS0tOwogCiAJc3Bp
bl9sb2NrX2lycXNhdmUoJnByaXYtPnN0YV9sb2NrLCBmbGFncyk7CiAJa2V5X2ZsYWdzID0gbGUx
Nl90b19jcHUocHJpdi0+c3RhdGlvbnNbc3RhX2lkXS5zdGEua2V5LmtleV9mbGFncyk7CkBAIC01
MjEsMjQgKzUxNywyNiBAQCBpbnQgaXdsX3JlbW92ZV9keW5hbWljX2tleShzdHJ1Y3QgaXdsX3By
aXYgKnByaXYsCiBFWFBPUlRfU1lNQk9MKGl3bF9yZW1vdmVfZHluYW1pY19rZXkpOwogCiBpbnQg
aXdsX3NldF9keW5hbWljX2tleShzdHJ1Y3QgaXdsX3ByaXYgKnByaXYsCi0JCQkJc3RydWN0IGll
ZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCBzdGFfaWQpCisJCQkJc3RydWN0IGllZWU4MDIxMV9r
ZXlfY29uZiAqa2V5Y29uZiwgdTggc3RhX2lkKQogewogCWludCByZXQ7CiAKLQlwcml2LT5rZXlf
bWFwcGluZ19rZXkgPSAxOworCXByaXYtPmtleV9tYXBwaW5nX2tleSsrOworCXByaXYtPnN0YXRp
b25zW3N0YV9pZF0ua2V5aW5mby5jb25mID0ga2V5Y29uZjsKKwlrZXljb25mLT5od19rZXlfaWR4
ID0gMDsKIAotCXN3aXRjaCAoa2V5LT5hbGcpIHsKKwlzd2l0Y2ggKGtleWNvbmYtPmFsZykgewog
CWNhc2UgQUxHX0NDTVA6Ci0JCXJldCA9IGl3bF9zZXRfY2NtcF9keW5hbWljX2tleV9pbmZvKHBy
aXYsIGtleSwgc3RhX2lkKTsKKwkJcmV0ID0gaXdsX3NldF9jY21wX2R5bmFtaWNfa2V5X2luZm8o
cHJpdiwga2V5Y29uZiwgc3RhX2lkKTsKIAkJYnJlYWs7CiAJY2FzZSBBTEdfVEtJUDoKLQkJcmV0
ID0gaXdsX3NldF90a2lwX2R5bmFtaWNfa2V5X2luZm8ocHJpdiwga2V5LCBzdGFfaWQpOworCQly
ZXQgPSBpd2xfc2V0X3RraXBfZHluYW1pY19rZXlfaW5mbyhwcml2LCBrZXljb25mLCBzdGFfaWQp
OwogCQlicmVhazsKIAljYXNlIEFMR19XRVA6Ci0JCXJldCA9IGl3bF9zZXRfd2VwX2R5bmFtaWNf
a2V5X2luZm8ocHJpdiwga2V5LCBzdGFfaWQpOworCQlyZXQgPSBpd2xfc2V0X3dlcF9keW5hbWlj
X2tleV9pbmZvKHByaXYsIGtleWNvbmYsIHN0YV9pZCk7CiAJCWJyZWFrOwogCWRlZmF1bHQ6Ci0J
CUlXTF9FUlJPUigiVW5rbm93biBhbGc6ICVzIGFsZyA9ICVkXG4iLCBfX2Z1bmNfXywga2V5LT5h
bGcpOworCQlJV0xfRVJST1IoIlVua25vd24gYWxnOiAlcyBhbGcgPSAlZFxuIiwgX19mdW5jX18s
IGtleWNvbmYtPmFsZyk7CiAJCXJldCA9IC1FSU5WQUw7CiAJfQogCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDQ5NjUtYmFzZS5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvaXdsd2lmaS9pd2w0OTY1LWJhc2UuYwppbmRleCA0ODFlOTQzLi40OTJmYzYzIDEwMDY0
NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDQ5NjUtYmFzZS5jCisrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsNDk2NS1iYXNlLmMKQEAgLTE0NjYsMTYg
KzE0NjYsMTMgQEAgc3RhdGljIHZvaWQgaXdsNDk2NV9idWlsZF90eF9jbWRfaHdjcnlwdG8oc3Ry
dWN0IGl3bF9wcml2ICpwcml2LAogCQkJCSAgICAgIHN0cnVjdCBza19idWZmICpza2JfZnJhZywK
IAkJCQkgICAgICBpbnQgc3RhX2lkKQogewotCXN0cnVjdCBpd2xfaHdfa2V5ICprZXlpbmZvID0g
JnByaXYtPnN0YXRpb25zW3N0YV9pZF0ua2V5aW5mbzsKLQlzdHJ1Y3QgaXdsX3dlcF9rZXkgKndl
cGtleTsKIAlpbnQga2V5aWR4ID0gMDsKKwlzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXlj
b25mID0gY3RsLT5od19rZXk7CiAKLQlCVUdfT04oY3RsLT5od19rZXktPmh3X2tleV9pZHggPiAz
KTsKLQotCXN3aXRjaCAoa2V5aW5mby0+YWxnKSB7CisJc3dpdGNoIChrZXljb25mLT5hbGcpIHsK
IAljYXNlIEFMR19DQ01QOgogCQljbWQtPmNtZC50eC5zZWNfY3RsID0gVFhfQ01EX1NFQ19DQ007
Ci0JCW1lbWNweShjbWQtPmNtZC50eC5rZXksIGtleWluZm8tPmtleSwga2V5aW5mby0+a2V5bGVu
KTsKKwkJbWVtY3B5KGNtZC0+Y21kLnR4LmtleSwga2V5Y29uZi0+a2V5LCBrZXljb25mLT5rZXls
ZW4pOwogCQlpZiAoY3RsLT5mbGFncyAmIElFRUU4MDIxMV9UWENUTF9BTVBEVSkKIAkJCWNtZC0+
Y21kLnR4LnR4X2ZsYWdzIHw9IFRYX0NNRF9GTEdfQUdHX0NDTVBfTVNLOwogCQlJV0xfREVCVUdf
VFgoInR4X2NtZCB3aXRoIGFlcyBod2NyeXB0b1xuIik7CkBAIC0xNDgzLDM5ICsxNDgwLDI2IEBA
IHN0YXRpYyB2b2lkIGl3bDQ5NjVfYnVpbGRfdHhfY21kX2h3Y3J5cHRvKHN0cnVjdCBpd2xfcHJp
diAqcHJpdiwKIAogCWNhc2UgQUxHX1RLSVA6CiAJCWNtZC0+Y21kLnR4LnNlY19jdGwgPSBUWF9D
TURfU0VDX1RLSVA7Ci0JCWllZWU4MDIxMV9nZXRfdGtpcF9rZXkoa2V5aW5mby0+Y29uZiwgc2ti
X2ZyYWcsCisJCWllZWU4MDIxMV9nZXRfdGtpcF9rZXkoa2V5Y29uZiwgc2tiX2ZyYWcsCiAJCQlJ
RUVFODAyMTFfVEtJUF9QMl9LRVksIGNtZC0+Y21kLnR4LmtleSk7CiAJCUlXTF9ERUJVR19UWCgi
dHhfY21kIHdpdGggdGtpcCBod2NyeXB0b1xuIik7CiAJCWJyZWFrOwogCiAJY2FzZSBBTEdfV0VQ
OgotCQl3ZXBrZXkgPSAmcHJpdi0+d2VwX2tleXNbY3RsLT5od19rZXktPmh3X2tleV9pZHhdOwot
CQljbWQtPmNtZC50eC5zZWNfY3RsID0gMDsKLQkJaWYgKHByaXYtPmRlZmF1bHRfd2VwX2tleSkg
ewotCQkJLyogdGhlIFdFUCBrZXkgd2FzIHNlbnQgYXMgc3RhdGljICovCi0JCQlrZXlpZHggPSBj
dGwtPmh3X2tleS0+aHdfa2V5X2lkeDsKLQkJCW1lbWNweSgmY21kLT5jbWQudHgua2V5WzNdLCB3
ZXBrZXktPmtleSwKLQkJCQkJCQl3ZXBrZXktPmtleV9zaXplKTsKLQkJCWlmICh3ZXBrZXktPmtl
eV9zaXplID09IFdFUF9LRVlfTEVOXzEyOCkKLQkJCQljbWQtPmNtZC50eC5zZWNfY3RsIHw9IFRY
X0NNRF9TRUNfS0VZMTI4OwotCQl9IGVsc2UgewotCQkJLyogdGhlIFdFUCBrZXkgd2FzIHNlbnQg
YXMgZHluYW1pYyAqLwotCQkJa2V5aWR4ID0ga2V5aW5mby0+a2V5aWR4OwotCQkJbWVtY3B5KCZj
bWQtPmNtZC50eC5rZXlbM10sIGtleWluZm8tPmtleSwKLQkJCQkJCQlrZXlpbmZvLT5rZXlsZW4p
OwotCQkJaWYgKGtleWluZm8tPmtleWxlbiA9PSBXRVBfS0VZX0xFTl8xMjgpCi0JCQkJY21kLT5j
bWQudHguc2VjX2N0bCB8PSBUWF9DTURfU0VDX0tFWTEyODsKLQkJfQorCQljbWQtPmNtZC50eC5z
ZWNfY3RsID0gKFRYX0NNRF9TRUNfV0VQIHwKKwkJCShrZXljb25mLT5rZXlpZHggJiBUWF9DTURf
U0VDX01TSykgPDwgVFhfQ01EX1NFQ19TSElGVCk7CiAKLQkJY21kLT5jbWQudHguc2VjX2N0bCB8
PSAoVFhfQ01EX1NFQ19XRVAgfAotCQkJKGtleWlkeCAmIFRYX0NNRF9TRUNfTVNLKSA8PCBUWF9D
TURfU0VDX1NISUZUKTsKKwkJaWYgKGtleWNvbmYtPmtleWxlbiA9PSBXRVBfS0VZX0xFTl8xMjgp
CisJCQljbWQtPmNtZC50eC5zZWNfY3RsIHw9IFRYX0NNRF9TRUNfS0VZMTI4OworCisJCW1lbWNw
eSgmY21kLT5jbWQudHgua2V5WzNdLCBrZXljb25mLT5rZXksIGtleWNvbmYtPmtleWxlbik7CiAK
IAkJSVdMX0RFQlVHX1RYKCJDb25maWd1cmluZyBwYWNrZXQgZm9yIFdFUCBlbmNyeXB0aW9uICIK
IAkJCSAgICAgIndpdGgga2V5ICVkXG4iLCBrZXlpZHgpOwogCQlicmVhazsKIAogCWRlZmF1bHQ6
Ci0JCXByaW50ayhLRVJOX0VSUiAiVW5rbm93biBlbmNvZGUgYWxnICVkXG4iLCBrZXlpbmZvLT5h
bGcpOworCQlwcmludGsoS0VSTl9FUlIgIlVua25vd24gZW5jb2RlIGFsZyAlZFxuIiwga2V5Y29u
Zi0+YWxnKTsKIAkJYnJlYWs7CiAJfQogfQpAQCAtNTU3OSwxMSArNTU2MywxMSBAQCBzdGF0aWMg
aW50IGl3bDQ5NjVfbWFjX3NldF9rZXkoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIGVudW0gc2V0
X2tleV9jbWQgY21kLAogCQlpZiAoY21kID09IFNFVF9LRVkpCiAJCQlpc19kZWZhdWx0X3dlcF9r
ZXkgPSAhcHJpdi0+a2V5X21hcHBpbmdfa2V5OwogCQllbHNlCi0JCQlpc19kZWZhdWx0X3dlcF9r
ZXkgPSBwcml2LT5kZWZhdWx0X3dlcF9rZXk7CisJCQlpc19kZWZhdWx0X3dlcF9rZXkgPSBrZXkt
Pmh3X2tleV9pZHg7CiAJfQotCiAJc3dpdGNoIChjbWQpIHsKIAljYXNlIFNFVF9LRVk6CisJCXBy
aW50ayhLRVJOX0VSUiAiU2V0IGtleTogc3RhdGljID0gJWQsIGtleWlkeCA9ICVkIHN0YSA9ICVk
IGRlZmF1bHQgPSAlZFxuIiwgaXNfZGVmYXVsdF93ZXBfa2V5LCBrZXktPmtleWlkeCwgc3RhX2lk
LCBwcml2LT5rZXlfbWFwcGluZ19rZXkpOwogCQlpZiAoaXNfZGVmYXVsdF93ZXBfa2V5KQogCQkJ
cmV0ID0gaXdsX3NldF9kZWZhdWx0X3dlcF9rZXkocHJpdiwga2V5KTsKIAkJZWxzZQpAQCAtNTU5
Miw2ICs1NTc2LDcgQEAgc3RhdGljIGludCBpd2w0OTY1X21hY19zZXRfa2V5KHN0cnVjdCBpZWVl
ODAyMTFfaHcgKmh3LCBlbnVtIHNldF9rZXlfY21kIGNtZCwKIAkJSVdMX0RFQlVHX01BQzgwMjEx
KCJlbmFibGUgaHdjcnlwdG8ga2V5XG4iKTsKIAkJYnJlYWs7CiAJY2FzZSBESVNBQkxFX0tFWToK
KwkJcHJpbnRrKEtFUk5fRVJSICJSZW1vdmUga2V5OiBzdGF0aWMgPSAlZCwga2V5aWR4ID0gJWQg
c3RhID0gJWQgZGVmYXVsdCA9ICVkXG4iLCBpc19kZWZhdWx0X3dlcF9rZXksIGtleS0+a2V5aWR4
LCBzdGFfaWQsIHByaXYtPmtleV9tYXBwaW5nX2tleSk7CiAJCWlmIChpc19kZWZhdWx0X3dlcF9r
ZXkpCiAJCQlyZXQgPSBpd2xfcmVtb3ZlX2RlZmF1bHRfd2VwX2tleShwcml2LCBrZXkpOwogCQll
bHNlCi0tIAoxLjUuNC4xCgo=
------=_Part_2945_10250538.1210583629493--
