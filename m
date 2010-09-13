Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29505 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab0IMHyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 03:54:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 00:53:59 -0700
Date: Mon, 13 Sep 2010 13:29:21 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <mcgrof@gmail.com>, Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/1] compat-wireless: fix scripts/driver-select for ath9k
Message-ID: <20100913075921.GA3370@kamboji.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As compat wireless now supports 2.6.24 or later, we don't need
to apply this special patch for ath9k.

This addresses a script error when ath9k alone is selected.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 scripts/driver-select |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index 5f7d422..131bf5f 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -302,7 +302,6 @@ case $1 in
 		disable_bt_usb_ethernet_var
 		select_driver		CONFIG_ATH_COMMON
 		select_ath9k_driver
-		patch -p1 < enable-older-kernels/enable-2.6.24.patch
 		;;
 	ar9170)
 		disable_bt_usb_ethernet_var
-- 
1.7.2.1

