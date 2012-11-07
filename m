Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:32838 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2KGM7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 07:59:52 -0500
From: Girish Bn <Girish.BN@lnties.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Patch file to fix wl12xx driver compilation
Date: Wed, 7 Nov 2012 12:49:38 +0000
Message-ID: <45566970CF58C74CB52107862E0541CD1D1BBAC2@POCITMSEXMB02.LntUniverse.com> (sfid-20121107_140005_477190_8B1520C6)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I propose the following patch to compat wireless to compile the wl12xx driver

diff -Naur a/scripts/driver-select b/scripts/driver-select
--- a/scripts/driver-select     2012-07-05 07:19:22.000000000 +0530
+++ b/scripts/driver-select     2012-08-21 10:46:47.318860018 +0530
@@ -363,7 +363,8 @@
                disable_lib80211
                ;;
        ti)
-               select_drivers          CONFIG_WL1251 \
+               select_drivers          CONFIG_WL_TI  \
+                                       CONFIG_WL1251 \
                                        CONFIG_WL12XX
                disable_staging
                disable_var_01
@@ -444,12 +445,12 @@
                disable_var_02
                ;;
        wl1251)
-               select_drivers          CONFIG_WL1251
+               select_drivers          CONFIG_WL_TI CONFIG_WL1251
                disable_staging
                disable_var_01
                ;;
        wl12xx)
-               select_drivers          CONFIG_WL12XX
+               select_drivers          CONFIG_WL_TI CONFIG_WL12XX
                disable_staging
                disable_var_01
                ;;


Thanks & Regards,
Girish
L&T IES,
KIADB Industrial Area,
Hebbal-Hootagalli, Mysore - 570 018
Telephone :  DID+91-821-2405552
Mobile: +91-9741206402
E-mail ID :Girish.BN@lnties.com
www.lnties.com

This mail is classified as :
(  ) L&T IES Proprietary
(  ) L&T IES Confidential
(X) L&T IES Internal Use
( ) L&T IES General Business

Larsen & Toubro Limited

www.larsentoubro.com

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
