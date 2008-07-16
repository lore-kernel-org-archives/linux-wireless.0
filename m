Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:32654 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbYGPNj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 09:39:58 -0400
Received: by ti-out-0910.google.com with SMTP id b6so2974878tic.23
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2008 06:39:57 -0700 (PDT)
Message-ID: <eb3ff54b0807160639u53e7c3cdoc9d4b0a999b4b3ca@mail.gmail.com> (sfid-20080716_154002_633973_CC1677B5)
Date: Wed, 16 Jul 2008 16:39:56 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/1] iwl-3945: add #ifdef CONFIG_IWL3945_LEDS to avoid compile warning.
Cc: linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_15298_9239141.1216215596338"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_15298_9239141.1216215596338
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

When building the wireless-next-2.6 tree with CONFIG_IWL3945 (for building
iwl-3945 driver) and where CONFIG_IWL3945_LEDS is not set,
we get this warning:
drivers/net/wireless/iwlwifi/iwl-3945.c: In function
'iwl3945_pass_packet_to_mac80211':
drivers/net/wireless/iwlwifi/iwl-3945.c:633: warning: unused variable 'hdr'

This patch adds #ifdef to iwl3945_pass_packet_to_mac80211() to avoid this
warning. (The variable 'hdr' is used only if CONFIG_IWL3945_LEDS is set)

(for wireless-next-2.6 tree)

Regards,
Rami Rosen

Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_15298_9239141.1216215596338
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fipzalcg0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTM5NDUuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLTM5NDUuYwppbmRleCBjMmE3Njc4Li5hNTFl
MGVhIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC0zOTQ1LmMK
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtMzk0NS5jCkBAIC02MzAsNyAr
NjMwLDkgQEAgc3RhdGljIHZvaWQgaXdsMzk0NV9wYXNzX3BhY2tldF90b19tYWM4MDIxMShzdHJ1
Y3QgaXdsMzk0NV9wcml2ICpwcml2LAogCQkJCSAgIHN0cnVjdCBpZWVlODAyMTFfcnhfc3RhdHVz
ICpzdGF0cykKIHsKIAlzdHJ1Y3QgaXdsMzk0NV9yeF9wYWNrZXQgKnBrdCA9IChzdHJ1Y3QgaXds
Mzk0NV9yeF9wYWNrZXQgKilyeGItPnNrYi0+ZGF0YTsKKyNpZmRlZiBDT05GSUdfSVdMMzk0NV9M
RURTCiAJc3RydWN0IGllZWU4MDIxMV9oZHIgKmhkciA9IChzdHJ1Y3QgaWVlZTgwMjExX2hkciAq
KUlXTF9SWF9EQVRBKHBrdCk7CisjZW5kaWYKIAlzdHJ1Y3QgaXdsMzk0NV9yeF9mcmFtZV9oZHIg
KnJ4X2hkciA9IElXTF9SWF9IRFIocGt0KTsKIAlzdHJ1Y3QgaXdsMzk0NV9yeF9mcmFtZV9lbmQg
KnJ4X2VuZCA9IElXTF9SWF9FTkQocGt0KTsKIAlzaG9ydCBsZW4gPSBsZTE2X3RvX2NwdShyeF9o
ZHItPmxlbik7Cg==
------=_Part_15298_9239141.1216215596338--
