Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636AbZDHOOZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 10:14:25 -0400
Subject: [PATCH] airo: queue SIOCSIWAUTH-requested auth mode change for
	next commit
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Carpenter <error27@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20090408134504.GA24452@tuxdriver.com>
References: <alpine.DEB.2.00.0904072049540.8684@bicker>
	 <20090408134504.GA24452@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 10:15:17 -0400
Message-Id: <1239200117.14879.2.camel@localhost.localdomain> (sfid-20090408_161436_350062_9E1164F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code was clearly wrong, plus callers expect the mode change to happen as
soon as possible, not dropped on the floor until the next time some
other config value changes and a commit happens.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index fc4322c..0bf2779 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -6574,11 +6574,11 @@ static int airo_set_auth(struct net_device *dev,
 				local->config.authType = AUTH_ENCRYPT;
 			} else
 				return -EINVAL;
-			break;
 
 			/* Commit the changes to flags if needed */
 			if (local->config.authType != currentAuthType)
 				set_bit (FLAG_COMMIT, &local->flags);
+			break;
 		}
 
 	case IW_AUTH_WPA_ENABLED:


