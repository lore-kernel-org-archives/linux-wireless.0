Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:47704 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2FIPpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 11:45:23 -0400
Subject: [PATCH] rndis_wlan: fix matching bssid check in
 rndis_check_bssid_list()
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Date: Sat, 09 Jun 2012 18:45:20 +0300
Message-ID: <20120609154520.24357.35871.stgit@localhost6.localdomain6> (sfid-20120609_174604_066220_9EEADF84)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_check_bssid_list() originally tried to check if bssid->mac and
match_bssid are equal using compare_ether_addr() when it should use
!compare_ether_addr(). This check was added by commit
b5257c952dda24df7078c74b7b811b44c6e49206 as part of workaround for
hardware issue.

Commit 2e42e4747ea72943c21551d8a206b51a9893b1e0 that replaced
compare_ether_addr with ether_addr_equal relieved that this compare
to be inverse of what it should be.

Compare was added as response to hardware bug, where bssid-list does
not contain BSSID and other information of currently connected AP
(spec insists that device must provide this information in the list
when connected). Lack bssid-data on current connection then causes
WARN_ON somewhere in cfg80211. Workaround was to check if bssid-list
returns current bssid and if it does not, manually construct bssid
information in other ways. And this workaround worked, with inverse
check. Which must mean that when hardware is experiencing the problem,
it's actually returning empty bssid-list and this check didn't make
any difference for workaround.

However inverse check causes workaround be activated when bssid-list
returns only entry, currently connected BSSID. That does not cause
problems in itself, just slightly more inaccurate information in
scan-list.

Cc: Joe Perches <joe@perches.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/rndis_wlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 2e9e6af..dfcd02a 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2110,7 +2110,7 @@ resize_buf:
 	while (check_bssid_list_item(bssid, bssid_len, buf, len)) {
 		if (rndis_bss_info_update(usbdev, bssid) && match_bssid &&
 		    matched) {
-			if (!ether_addr_equal(bssid->mac, match_bssid))
+			if (ether_addr_equal(bssid->mac, match_bssid))
 				*matched = true;
 		}
 

