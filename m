Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764210AbXF2Nfz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 09:35:55 -0400
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH 5/5] airo: start with radio off
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Date: Fri, 29 Jun 2007 15:33:52 +0200
Message-ID: <20070629133352.6658.89289.stgit@localhost.localdomain>
In-Reply-To: <20070629131841.6658.76381.stgit@localhost.localdomain>
References: <20070629131841.6658.76381.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't turn the radio on until the interface is up. This saves some power in
case the driver is loaded but the card is not used.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---

 drivers/net/wireless/airo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index ea79772..c7f23f1 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2831,7 +2831,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 
 	ai = dev->priv;
 	ai->wifidev = NULL;
-	ai->flags = 0;
+	ai->flags = 1 << FLAG_RADIO_DOWN;
 	ai->jobs = 0;
 	ai->dev = dev;
 	if (pci && (pci->device == 0x5000 || pci->device == 0xa504)) {

