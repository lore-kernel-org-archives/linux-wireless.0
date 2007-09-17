Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35159 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbXIQWmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 18:42:31 -0400
Date: Tue, 18 Sep 2007 04:15:11 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH -mm][resend] net/wireless/sysfs.c: Shut up build warning
Message-ID: <alpine.LFD.0.999.0709180412490.8863@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-258678704-1190069114=:8863"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-258678704-1190069114=:8863
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


net/wireless/sysfs.c:108: warning: ‘wiphy_uevent’ defined but not used

when CONFIG_HOTPLUG=n is because the only usage site of this function
is #ifdef'ed as such, so let's #ifdef the definition also.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

---

 net/wireless/sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.23-rc4-mm1/net/wireless/sysfs.c~fix	2007-09-02 20:06:11.000000000 +0530
+++ linux-2.6.23-rc4-mm1/net/wireless/sysfs.c	2007-09-02 20:07:01.000000000 +0530
@@ -104,11 +104,13 @@ static void wiphy_dev_release(struct dev
 	cfg80211_dev_free(rdev);
 }
 
+#ifdef CONFIG_HOTPLUG
 static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	/* TODO, we probably need stuff here */
 	return 0;
 }
+#endif
 
 struct class ieee80211_class = {
 	.name = "ieee80211",
--464262402-258678704-1190069114=:8863--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
