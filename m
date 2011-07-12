Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr12.hinet.net ([168.95.4.112]:32886 "EHLO msr12.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1GLPNH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 11:13:07 -0400
From: Ali Bahar <ali@internetdog.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Ali Bahar <ali@internetdog.org>
Subject: [PATCH 2/2] staging: r8712u: Interface-state not fully tracked.
Date: Tue, 12 Jul 2011 23:10:56 +0800
Message-Id: <1310483456-10543-3-git-send-email-ali@internetDog.org> (sfid-20110712_171315_676975_2BCE2224)
In-Reply-To: <1310483456-10543-1-git-send-email-ali@internetDog.org>
References: <1310483456-10543-1-git-send-email-ali@internetDog.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

padapter->bup is True when the interface has been
brought Up. But it was not being reset when the
interface is taken Down.
This has not caused a known problem, as other
state variables may be compensating for it. Never
the less, it is now properly tracked.

Signed-off-by: Ali Bahar <ali@internetDog.org>
---
 drivers/staging/rtl8712/os_intfs.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 3f38e8e..6697941 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -375,6 +375,12 @@ static void enable_video_mode(struct _adapter *padapter, int cbw40_value)
 	r8712_fw_cmd(padapter, intcmd);
 }
 
+/**
+ *
+ * This function intends to handle the activation of an interface
+ * i.e. when it is brought Up/Active from a Down state.
+ *
+ */
 static int netdev_open(struct net_device *pnetdev)
 {
 	struct _adapter *padapter = (struct _adapter *)_netdev_priv(pnetdev);
@@ -434,6 +440,12 @@ netdev_open_error:
 	return -1;
 }
 
+/**
+ *
+ * This function intends to handle the shutdown of an interface
+ * i.e. when it is brought Down from an Up/Active state.
+ *
+ */
 static int netdev_close(struct net_device *pnetdev)
 {
 	struct _adapter *padapter = (struct _adapter *) _netdev_priv(pnetdev);
@@ -458,6 +470,8 @@ static int netdev_close(struct net_device *pnetdev)
 	r8712_free_network_queue(padapter);
 	/*Stop driver mlme relation timer*/
 	stop_drv_timers(padapter);
+	/* The interface is no longer Up: */
+	padapter->bup = false;
 	return 0;
 }
 
-- 
1.7.6

