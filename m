Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37862 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbbFWOxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 10:53:30 -0400
From: Antonio Borneo <borneo.antonio@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Antonio Borneo <borneo.antonio@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] wireless: cw1200: Remove redundant spi driver bus initialization
Date: Tue, 23 Jun 2015 22:53:05 +0800
Message-Id: <1435071185-24586-1-git-send-email-borneo.antonio@gmail.com> (sfid-20150623_165417_611957_B6136EC2)
In-Reply-To: <1435070714-24174-1-git-send-email-borneo.antonio@gmail.com>
References: <1435070714-24174-1-git-send-email-borneo.antonio@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ancient times it was necessary to manually initialize the bus
field of an spi_driver to spi_bus_type. These days this is done in
spi_register_driver(), so we can drop the manual assignment.

Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
To: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/wireless/cw1200/cw1200_spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 7603546..29185ae 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -467,7 +467,6 @@ static struct spi_driver spi_driver = {
 	.remove		= cw1200_spi_disconnect,
 	.driver = {
 		.name		= "cw1200_wlan_spi",
-		.bus            = &spi_bus_type,
 		.owner          = THIS_MODULE,
 #ifdef CONFIG_PM
 		.pm		= &cw1200_pm_ops,
-- 
2.4.4

