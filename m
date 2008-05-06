Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:13276 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbYEFGqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 02:46:32 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1032701fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 23:46:29 -0700 (PDT)
Message-ID: <8704f27d0805052346u24954211l6f55513c78205586@mail.gmail.com> (sfid-20080506_084548_394968_E5215407)
Date: Tue, 6 May 2008 09:46:28 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Volker Braun" <vbraun@physics.upenn.edu>
Subject: Re: dynamic wep with mulitple keys
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1210003121.11809.10.camel@carrot.hep.upenn.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_5997_31546840.1210056388919"
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <1ba2fa240804231015r41e7d7f5ocf7d78af72fb4622@mail.gmail.com>
	 <8704f27d0805050735s647ac4aaq469630bde6bc341e@mail.gmail.com>
	 <1210003121.11809.10.camel@carrot.hep.upenn.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_5997_31546840.1210056388919
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>  I just tried compat-wireless-2008-05-05, which does contain
>  03dcb07e74a62eec2badb9f6a091790c484f4a6c. No difference:
>

Thanks for trying this.
Can you try to load the module with swcrypto=1 and try again ?
This disables the HW encryption acceleration. Trying this will allow
to make 100% sure that the bug is in iwlwifi. The bug is likely to be
there, but I think it is worth to make this 100% sure.

Do you have a sniffer ? a capture might help.

Please, try with HW acceleration (without swcrypto=1) and with the
attached patch. This will give us some more info.

0001-iwlwifi-DEBUG-print-data-about-keys-installation.patch
---------------------------------
>From 66b6ea7e885e2f6d76c3f6af822100185d9c56f6 Mon Sep 17 00:00:00 2001
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 6 May 2008 09:37:14 +0300
Subject: [PATCH 1/1] iwlwifi-DEBUG: print data about keys installation

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f93503e..04d195b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5702,7 +5702,9 @@ static int iwl4965_mac_set_key(struct
ieee80211_hw *hw, enum set_key_cmd cmd,
 		else
 			ret = iwl_set_dynamic_key(priv, key, sta_id);

-		IWL_DEBUG_MAC80211("enable hwcrypto key\n");
+		IWL_ERROR("enable hwcrypto key sta=%d alg=%d,
+			keyid=%d static_key=%d\n",
+			sta_id, key->alg, key->keyidx, is_default_wep_key);
 		break;
 	case DISABLE_KEY:
 		if (is_default_wep_key)
@@ -5710,7 +5712,9 @@ static int iwl4965_mac_set_key(struct
ieee80211_hw *hw, enum set_key_cmd cmd,
 		else
 			ret = iwl_remove_dynamic_key(priv, key, sta_id);

-		IWL_DEBUG_MAC80211("disable hwcrypto key\n");
+		IWL_ERROR("disable hwcrypto key sta=%d alg=%d,
+			keyid=%d static_key=%d\n",
+			sta_id, key->alg, key->keyidx, is_default_wep_key);
 		break;
 	default:
 		ret = -EINVAL;
-- 
1.5.4.1


Thanks

-- 
Emmanuel Grumbach
egrumbach@gmail.com

------=_Part_5997_31546840.1210056388919
Content-Type: text/x-patch;
 name=0001-iwlwifi-DEBUG-print-data-about-keys-installation.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffw497wu0
Content-Disposition: attachment;
 filename=0001-iwlwifi-DEBUG-print-data-about-keys-installation.patch

RnJvbSA2NmI2ZWE3ZTg4NWUyZjZkNzZjM2Y2YWY4MjIxMDAxODVkOWM1NmY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hA
aW50ZWwuY29tPgpEYXRlOiBUdWUsIDYgTWF5IDIwMDggMDk6Mzc6MTQgKzAzMDAKU3ViamVjdDog
W1BBVENIIDEvMV0gaXdsd2lmaS1ERUJVRzogcHJpbnQgZGF0YSBhYm91dCBrZXlzIGluc3RhbGxh
dGlvbgoKU2lnbmVkLW9mZi1ieTogRW1tYW51ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNo
QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDQ5NjUtYmFz
ZS5jIHwgICAgOCArKysrKystLQogMSBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2w0OTY1LWJhc2UuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsNDk2NS1iYXNl
LmMKaW5kZXggZjkzNTAzZS4uMDRkMTk1YiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaXdsd2lmaS9pd2w0OTY1LWJhc2UuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3
aWZpL2l3bDQ5NjUtYmFzZS5jCkBAIC01NzAyLDcgKzU3MDIsOSBAQCBzdGF0aWMgaW50IGl3bDQ5
NjVfbWFjX3NldF9rZXkoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIGVudW0gc2V0X2tleV9jbWQg
Y21kLAogCQllbHNlCiAJCQlyZXQgPSBpd2xfc2V0X2R5bmFtaWNfa2V5KHByaXYsIGtleSwgc3Rh
X2lkKTsKIAotCQlJV0xfREVCVUdfTUFDODAyMTEoImVuYWJsZSBod2NyeXB0byBrZXlcbiIpOwor
CQlJV0xfRVJST1IoImVuYWJsZSBod2NyeXB0byBrZXkgc3RhPSVkIGFsZz0lZCwKKwkJCWtleWlk
PSVkIHN0YXRpY19rZXk9JWRcbiIsCisJCQlzdGFfaWQsIGtleS0+YWxnLCBrZXktPmtleWlkeCwg
aXNfZGVmYXVsdF93ZXBfa2V5KTsKIAkJYnJlYWs7CiAJY2FzZSBESVNBQkxFX0tFWToKIAkJaWYg
KGlzX2RlZmF1bHRfd2VwX2tleSkKQEAgLTU3MTAsNyArNTcxMiw5IEBAIHN0YXRpYyBpbnQgaXds
NDk2NV9tYWNfc2V0X2tleShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgZW51bSBzZXRfa2V5X2Nt
ZCBjbWQsCiAJCWVsc2UKIAkJCXJldCA9IGl3bF9yZW1vdmVfZHluYW1pY19rZXkocHJpdiwga2V5
LCBzdGFfaWQpOwogCi0JCUlXTF9ERUJVR19NQUM4MDIxMSgiZGlzYWJsZSBod2NyeXB0byBrZXlc
biIpOworCQlJV0xfRVJST1IoImRpc2FibGUgaHdjcnlwdG8ga2V5IHN0YT0lZCBhbGc9JWQsCisJ
CQlrZXlpZD0lZCBzdGF0aWNfa2V5PSVkXG4iLAorCQkJc3RhX2lkLCBrZXktPmFsZywga2V5LT5r
ZXlpZHgsIGlzX2RlZmF1bHRfd2VwX2tleSk7CiAJCWJyZWFrOwogCWRlZmF1bHQ6CiAJCXJldCA9
IC1FSU5WQUw7Ci0tIAoxLjUuNC4xCgo=
------=_Part_5997_31546840.1210056388919--
