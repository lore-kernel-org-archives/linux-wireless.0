Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3947 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715AbXJZDKq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 23:10:46 -0400
Date: Thu, 25 Oct 2007 23:10:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Please pull 'fixes-davem' branch of wireless-2.6
Message-ID: <20071026031033.GC14080@tuxdriver.com> (sfid-20071026_041050_303325_6F71507C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

A few fixes for 2.6.24...also adds Johannes Berg as a mac80211
maintainer, since he probably wrote most of the newest bugs
there... :-)

Thanks,

John

---

Individual patches available here:

        http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/fixes-davem

---

The following changes since commit c9927c2bf4f45bb85e8b502ab3fb79ad6483c244:
  Linus Torvalds (1):
        Linux 2.6.24-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git fixes-davem

Jeff Garzik (1):
      mac80211: fix warning created by BIT()

Johannes Berg (1):
      add myself as mac80211 maintainer

Michael Wu (1):
      mac80211: Fix SSID matching in AP selection

 MAINTAINERS                  |    8 +++++---
 net/mac80211/ieee80211_sta.c |    5 +++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 76b8571..71badfb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2442,13 +2442,15 @@ W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
 
 MAC80211
-P:	Jiri Benc
-M:	jbenc@suse.cz
 P:	Michael Wu
 M:	flamingice@sourmilk.net
+P:	Johannes Berg
+M:	johannes@sipsolutions.net
+P:	Jiri Benc
+M:	jbenc@suse.cz
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/jbenc/mac80211.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 
 MACVLAN DRIVER
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f7ffeec..0d996aa 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
 
 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
-	       "status=%d aid=%d)\n",
+	       "status=%d aid=%ld)\n",
 	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
 	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
 
@@ -2096,7 +2096,8 @@ static int ieee80211_sta_match_ssid(struct ieee80211_if_sta *ifsta,
 {
 	int tmp, hidden_ssid;
 
-	if (!memcmp(ifsta->ssid, ssid, ssid_len))
+	if (ssid_len == ifsta->ssid_len &&
+	    !memcmp(ifsta->ssid, ssid, ssid_len))
 		return 1;
 
 	if (ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL)
-- 
John W. Linville
linville@tuxdriver.com
