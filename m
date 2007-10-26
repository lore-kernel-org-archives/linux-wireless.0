Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:53110 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbXJZUNC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:13:02 -0400
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out1.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IlVYD-0006nM-6D
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 22:13:01 +0200
Message-ID: <47224A4A.1010901@tiscali.nl> (sfid-20071026_211309_125039_89804667)
Date: Fri, 26 Oct 2007 22:12:58 +0200
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH split 3/8] fix 'and' typo's in wireless/libertas/wext
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl>
In-Reply-To: <472248AC.7080201@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

        Fix priority mistakes similar to '!x & y' in wireless/libertas/wext
    
        Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index c6f5aa3..d93438c 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1380,7 +1380,7 @@ static int wlan_get_encodeext(struct net_device *dev,
 		index = adapter->wep_tx_keyidx;
 	}
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP) {
 		if (index != 0 || adapter->mode != IW_MODE_INFRA)
 			goto out;
