Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:57769 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318Ab2BQJtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 04:49:13 -0500
Received: by mail-lpp01m010-f54.google.com with SMTP id z14so4392184lag.41
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 01:49:12 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com
Subject: [PATCH 1/2] compat-wireless: update bluetooth patch to latest wireless-testing
Date: Fri, 17 Feb 2012 11:49:00 +0200
Message-Id: <1329472141-28781-1-git-send-email-coelho@ti.com> (sfid-20120217_104917_321841_1D44745A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a small change in the bt_sock_unregister() function in
af_bluetooth (an extra if) that cause the patch not to apply anymore.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 patches/16-bluetooth.patch |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index da533cf..3f43307 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -63,9 +63,9 @@ here still, but for now we keep this here.
 +#else
 +		err = bt_proto[proto]->create(net, sock, proto);
 +#endif
- 		bt_sock_reclassify_lock(sock, proto);
+		if (!err)
+			bt_sock_reclassify_lock(sock->sk, proto);
  		module_put(bt_proto[proto]->owner);
- 	}
 @@ -475,7 +483,11 @@ int bt_sock_ioctl(struct socket *sock, u
  		if (sk->sk_state == BT_LISTEN)
  			return -EINVAL;
-- 
1.7.5.4

