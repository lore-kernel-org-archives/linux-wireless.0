Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47535 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab2KUG7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 01:59:42 -0500
Date: Wed, 21 Nov 2012 14:59:19 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [wireless-next:master 196/214]
 drivers/net/wireless/brcm80211/brcmsmac/main.c:308:10: sparse: symbol
 'wlc_prio2prec_map' was not declared. Should it be static?
Message-ID: <50ac7bc7.tSErItiXQxTyHiGi%fengguang.wu@intel.com> (sfid-20121121_075948_463272_FA7A07E0)
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_50ac7bc7.0XJsaaoV1v96ubTZGTTtXclor548SqIncR6xmXsUAkb7mowH"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--=_50ac7bc7.0XJsaaoV1v96ubTZGTTtXclor548SqIncR6xmXsUAkb7mowH
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   e2ff0498409af6f2023f91aba07b281e5e87ee15
commit: e041f65d5f00011049c7d6af0e31ce69ce9e2655 [196/214] brcmsmac: Remove internal tx queue


sparse warnings:

+ drivers/net/wireless/brcm80211/brcmsmac/main.c:308:10: sparse: symbol 'wlc_prio2prec_map' was not declared. Should it be static?
drivers/net/wireless/brcm80211/brcmsmac/main.c:6500:43:   also defined here

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation

--=_50ac7bc7.0XJsaaoV1v96ubTZGTTtXclor548SqIncR6xmXsUAkb7mowH
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-e041f65.diff"

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 5710dc0..1984b96 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -305,7 +305,7 @@ static const u8 wme_ac2fifo[] = {
 };
 
 /* 802.1D Priority to precedence queue mapping */
-const u8 wlc_prio2prec_map[] = {
+static const u8 wlc_prio2prec_map[] = {
 	_BRCMS_PREC_BE,		/* 0 BE - Best-effort */
 	_BRCMS_PREC_BK,		/* 1 BK - Background */
 	_BRCMS_PREC_NONE,		/* 2 None = - */

--=_50ac7bc7.0XJsaaoV1v96ubTZGTTtXclor548SqIncR6xmXsUAkb7mowH--
