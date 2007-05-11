Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbXEKDFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:05:22 -0400
Subject: [PATCH 17/19] libertas: fix missing unlock in TX error path
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:08:54 -0400
Message-Id: <1178852934.8607.50.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/if_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 54853d8..f2d37d9 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -626,6 +626,7 @@ static void if_usb_receive(struct urb *urb)
 			    cardp->usb_event_cause);
 		if (cardp->usb_event_cause & 0xffff0000) {
 			libertas_send_tx_feedback(priv);
+			spin_unlock(&priv->adapter->driver_lock);
 			break;
 		}
 		cardp->usb_event_cause = le32_to_cpu(cardp->usb_event_cause) << 3;
-- 
1.5.0.6



