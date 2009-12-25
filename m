Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:63833 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751900AbZLYJUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Dec 2009 04:20:45 -0500
Date: Fri, 25 Dec 2009 17:22:25 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Compat-wireless-2.6: Updated to fix bluetooth patch error
Message-ID: <20091225092225.GA11049@owl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Compat-wireless-2.6: Updated to fix bluetooth patch error

Keep the patch in step with the linux-next tree after the following
patch merged.

    commit 971beb83aeb2a309175682cf5683d64fd4591841
    Author: Roel Kluin <roel.kluin@gmail.com>
    Date:   Mon Dec 7 14:23:21 2009 +0100

        Bluetooth: Fix PTR_ERR return of wrong pointer in hidp_setup_hid()

        Return the PTR_ERR of the correct pointer.
 
Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>

---
 patches/16-bluetooth.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 7382856..3a79f84 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -200,7 +200,7 @@ diff -Nur a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
 +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
  	hid = hid_allocate_device();
  	if (IS_ERR(hid))
- 		return PTR_ERR(session->hid);
+ 		return PTR_ERR(hid);
 +#endif
  
  	session->hid = hid;
-- 
1.6.3.3
