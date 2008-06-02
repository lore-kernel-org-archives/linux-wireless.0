Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:35448 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYFBPnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 11:43:40 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/4] rndis_wlan: check if set_multicast_list work is already
	scheduled
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Date: Mon, 02 Jun 2008 18:35:36 +0300
Message-ID: <20080602153536.22793.40109.stgit@nanoha.lan> (sfid-20080602_174343_373941_E1109352)
In-Reply-To: <20080602153521.22793.4271.stgit@nanoha.lan>
References: <20080602153521.22793.4271.stgit@nanoha.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't queue set_multicast_list work if WORK_SET_MULTICAST_LIST 
flag already set.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c281c0b..ad46a0b 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2272,6 +2272,9 @@ static void rndis_wext_set_multicast_list(struct net_device *dev)
 	struct usbnet *usbdev = dev->priv;
 	struct rndis_wext_private *priv = get_rndis_wext_priv(usbdev);
 
+	if (test_bit(WORK_SET_MULTICAST_LIST, &priv->work_pending))
+		return;
+
 	set_bit(WORK_SET_MULTICAST_LIST, &priv->work_pending);
 	queue_work(priv->workqueue, &priv->work);
 }

