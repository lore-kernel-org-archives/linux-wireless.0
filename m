Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33010 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752695AbcLQWow (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 17:44:52 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, qca_merez@qca.qualcomm.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] net: wireless: ath: wil6210: constify cfg80211_ops structures
Date: Sun, 18 Dec 2016 04:14:27 +0530
Message-Id: <1482014667-27082-1-git-send-email-bhumirks@gmail.com> (sfid-20161217_234520_110976_DE25CB8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_ops structures are only passed as an argument to the function
wiphy_new. This argument is of type const, so cfg80211_ops strutures
having this property can be declared as const.
Done using Coccinelle

@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct cfg80211_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
@@
wiphy_new(&i@p,...)

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct cfg80211_ops i;

File size before:
   text	   data	    bss	    dec	    hex	filename
  18133	   6632	      0	  24765	   60bd wireless/ath/wil6210/cfg80211.o

File size after:
   text	   data	    bss	    dec	    hex	filename
  18933	   5832	      0	  24765	   60bd wireless/ath/wil6210/cfg80211.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6aa3ff4..54dd116 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1499,7 +1499,7 @@ static int wil_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	return rc;
 }
 
-static struct cfg80211_ops wil_cfg80211_ops = {
+static const struct cfg80211_ops wil_cfg80211_ops = {
 	.add_virtual_intf = wil_cfg80211_add_iface,
 	.del_virtual_intf = wil_cfg80211_del_iface,
 	.scan = wil_cfg80211_scan,
-- 
1.9.1
