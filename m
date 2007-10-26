Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:33272 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXJZUO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:14:26 -0400
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out0.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IlVZZ-0000AS-JY
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 22:14:25 +0200
Message-ID: <47224A9E.3050803@tiscali.nl> (sfid-20071026_211428_514073_340595B2)
Date: Fri, 26 Oct 2007 22:14:22 +0200
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH split 5/8] fix 'and' typo's wireless/prism54/isl_ioctl
 (first)
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl>
In-Reply-To: <472248AC.7080201@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

        Fix priority mistakes similar to '!x & y' wireless/prism54/isl_ioctl (first)
    
        Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 6d80ca4..b9d0073 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1118,7 +1118,7 @@ prism54_set_encode(struct net_device *ndev, struct iw_request_info *info,
 			    mgt_set_request(priv, DOT11_OID_DEFKEYID, 0,
 					    &index);
 		} else {
-			if (!dwrq->flags & IW_ENCODE_MODE) {
+			if (!(dwrq->flags & IW_ENCODE_MODE)) {
 				/* we cannot do anything. Complain. */
 				return -EINVAL;
 			}
