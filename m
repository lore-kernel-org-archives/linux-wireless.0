Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:60752 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305Ab0JZKSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:18 -0400
From: Julia Lawall <julia@diku.dk>
To: Brett Rudley <brudley@broadcom.com>
Cc: kernel-janitors@vger.kernel.org,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/14] drivers/staging/brcm80211/brcmfmac/dhd_linux.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:33 +0200
Message-Id: <1288088743-3725-5-git-send-email-julia@diku.dk>
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.  dhd_ops_virt contains
a subset of the definitions of dhd_ops_pri.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index e535787..30b8e9b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2222,8 +2222,6 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 	ASSERT(net);
 
 	ASSERT(!net->netdev_ops);
-	net->netdev_ops = &dhd_ops_virt;
-
 	net->netdev_ops = &dhd_ops_pri;
 
 	/*

