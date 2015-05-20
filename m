Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58675 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbbETFgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 01:36:52 -0400
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <quozl@laptop.org>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2] mwifiex: reduce severity of debug messages for mgmt rx
Date: Wed, 20 May 2015 16:36:06 +0530
Message-ID: <1432119966-2275-1-git-send-email-patila@marvell.com> (sfid-20150520_073655_723301_061849AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This would ensure dmesg logs are not spammed with "unknown mgmt frame
subtype" messages.

Reviewed-by: James Cameron <quozl@laptop.org>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 3c0b3c1..370323a 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -350,8 +350,8 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 		}
 		break;
 	default:
-		mwifiex_dbg(priv->adapter, ERROR,
-			    "unknown mgmt frame subytpe %#x\n", stype);
+		mwifiex_dbg(priv->adapter, INFO,
+			    "unknown mgmt frame subtype %#x\n", stype);
 	}
 
 	return 0;
-- 
1.8.1.4

