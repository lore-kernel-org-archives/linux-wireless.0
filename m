Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759234AbXF0VSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 17:18:45 -0400
Message-ID: <4682D415.2060100@redhat.com>
Date: Wed, 27 Jun 2007 23:18:13 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Subject: [PATCH 4/4] airo: start with radio off
References: <4682D323.2010605@redhat.com>
In-Reply-To: <4682D323.2010605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't turn the radio on until the interface is up. This saves some power in
case the driver is loaded but the card is not used.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

---
 drivers/net/wireless/airo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index d46d27a..eb3c675 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2833,7 +2833,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 
 	ai = dev->priv;
 	ai->wifidev = NULL;
-	ai->flags = 0;
+	ai->flags = 1 << FLAG_RADIO_DOWN;
 	ai->jobs = 0;
 	ai->dev = dev;
 	if (pci && (pci->device == 0x5000 || pci->device == 0xa504)) {


