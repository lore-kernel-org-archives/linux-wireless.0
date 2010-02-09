Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab0BIIaV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 03:30:21 -0500
Date: Tue, 9 Feb 2010 09:27:19 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] airo: return from set_wep_key() when key length is zero
Message-ID: <20100209082718.GA2588@dhcp-lab-161.englab.brq.redhat.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com> <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com> <20100208205358.GA3852@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100208205358.GA3852@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even if keylen == 0 is a bug and should not really happen, better avoid
possibility of passing bad value to firmware.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/airo.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 2a9f029..01bffc2 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5254,7 +5254,8 @@ static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
 	WepKeyRid wkr;
 	int rc;
 
-	WARN_ON(keylen == 0);
+	if (WARN_ON(keylen == 0))
+		return -1;
 
 	memset(&wkr, 0, sizeof(wkr));
 	wkr.len = cpu_to_le16(sizeof(wkr));
-- 
1.6.2.5

