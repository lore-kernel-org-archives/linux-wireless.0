Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45412 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZK3RcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:32:07 -0500
Date: Mon, 30 Nov 2009 18:32:13 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] mwl8k: initialize the mwl8k_info_tbl table using the MWL* enums
Message-ID: <20091130173213.GU20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index df26414..c1ce985 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3268,14 +3268,14 @@ enum {
 };
 
 static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
-	{
+	[MWL8687] = {
 		.part_name	= "88w8687",
 		.helper_image	= "mwl8k/helper_8687.fw",
 		.fw_image	= "mwl8k/fmimage_8687.fw",
 		.rxd_ops	= &rxd_8687_ops,
 		.modes		= BIT(NL80211_IFTYPE_STATION),
 	},
-	{
+	[MWL8366] = {
 		.part_name	= "88w8366",
 		.helper_image	= "mwl8k/helper_8366.fw",
 		.fw_image	= "mwl8k/fmimage_8366.fw",
-- 
1.5.6.4
