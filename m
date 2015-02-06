Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43317 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbbBFLsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 06:48:06 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Increase copy engine entries for rx wmi
Date: Fri, 6 Feb 2015 17:17:18 +0530
Message-ID: <1423223238-17530-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150206_124810_093513_D00F74B8)
In-Reply-To: <1423223238-17530-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1423223238-17530-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having lower number of copy engine entries for target to host
WMI ring is causing drops in receiving management frames. This
issue is observed during max clients (128 clients) stress testing.
While bursting deauthentication frames from simulated clients,
approx. 70% of frames are getting dropped due to lower ring entries.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index e6972b0..f3174a6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -113,7 +113,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
 		.flags = CE_ATTR_FLAGS,
 		.src_nentries = 0,
 		.src_sz_max = 2048,
-		.dest_nentries = 32,
+		.dest_nentries = 128,
 	},
 
 	/* CE3: host->target WMI */
@@ -183,7 +183,7 @@ static const struct ce_pipe_config target_ce_config_wlan[] = {
 	{
 		.pipenum = __cpu_to_le32(2),
 		.pipedir = __cpu_to_le32(PIPEDIR_IN),
-		.nentries = __cpu_to_le32(32),
+		.nentries = __cpu_to_le32(64),
 		.nbytes_max = __cpu_to_le32(2048),
 		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
 		.reserved = __cpu_to_le32(0),
-- 
2.2.2

