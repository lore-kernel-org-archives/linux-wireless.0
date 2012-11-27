Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab2K0GpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:16 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4054043wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:15 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/20] wlcore: allow ACX_BA_SESSION_RX_SETUP to fail
Date: Tue, 27 Nov 2012 08:44:46 +0200
Message-Id: <1353998701-18171-6-git-send-email-arik@wizery.com> (sfid-20121127_074614_741014_509D95E1)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Under some circumstances, that fw might be asked to
remove a rx ba sessions it doesn't know about. In
this case, instead of triggering a recovery, accept
the error code (CMD_STATUS_NO_RX_BA_SESSION) and
ignore it.

[Arik - indicate failure up when the BA session cannot be setup]

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/acx.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index ce108a7..9c32f0c 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -1433,13 +1433,22 @@ int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
 	acx->win_size = wl->conf.ht.rx_ba_win_size;
 	acx->ssn = ssn;
 
-	ret = wl1271_cmd_configure(wl, ACX_BA_SESSION_RX_SETUP, acx,
-				   sizeof(*acx));
+	ret = wlcore_cmd_configure_failsafe(wl, ACX_BA_SESSION_RX_SETUP, acx,
+					    sizeof(*acx),
+					    BIT(CMD_STATUS_NO_RX_BA_SESSION));
 	if (ret < 0) {
 		wl1271_warning("acx ba receiver session failed: %d", ret);
 		goto out;
 	}
 
+	/* sometimes we can't start the session */
+	if (ret == CMD_STATUS_NO_RX_BA_SESSION) {
+		wl1271_warning("no fw rx ba on tid %d", tid_index);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = 0;
 out:
 	kfree(acx);
 	return ret;
-- 
1.7.9.5

