Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaJAJ3m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 05:29:42 -0400
Date: Wed, 1 Oct 2014 11:27:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] cfg80211: allow to configure dynamic PS timeout
Message-ID: <20141001092710.GB2011@redhat.com> (sfid-20141001_112947_432194_22AE61B2)
References: <1412083114-8426-1-git-send-email-sgruszka@redhat.com>
 <542AB859.5080008@broadcom.com>
 <542AB893.9090201@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <542AB893.9090201@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dynamic power save timeout value is suppose to be configurable via
wext, but due to iwconfig bug is not possible to set using that tool.

Allow to configure PS timeout via nl80211 - add NL80211_ATTR_PS_TIMEOUT
attribute which become timeout stated in ms.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2 : add documentation.

 include/uapi/linux/nl80211.h |  5 +++++
 net/wireless/nl80211.c       | 21 +++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4b28dc0..66a9ba8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1638,6 +1638,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
  *	&enum nl80211_smps_mode.
  *
+ * @NL80211_ATTR_PS_TIMEOUT: Dynamic power save timeout value in miliseconds.
+ *	Special value -1 means driver default.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1990,6 +1993,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SMPS_MODE,
 
+	NL80211_ATTR_PS_TIMEOUT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cb9f5a4..39ee3c7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7991,7 +7991,7 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	u8 ps_state;
 	bool state;
-	int err;
+	int err, ps_timeout;
 
 	if (!info->attrs[NL80211_ATTR_PS_STATE])
 		return -EINVAL;
@@ -8003,17 +8003,27 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 
 	wdev = dev->ieee80211_ptr;
 
+	if (info->attrs[NL80211_ATTR_PS_TIMEOUT]) {
+		ps_timeout = nla_get_s32(info->attrs[NL80211_ATTR_PS_TIMEOUT]);
+		if (ps_timeout < 0 && ps_timeout != -1)
+			return -EINVAL;
+	} else {
+		ps_timeout = wdev->ps_timeout;
+	}
+
 	if (!rdev->ops->set_power_mgmt)
 		return -EOPNOTSUPP;
 
 	state = (ps_state == NL80211_PS_ENABLED) ? true : false;
 
-	if (state == wdev->ps)
+	if (state == wdev->ps && ps_timeout == wdev->ps_timeout)
 		return 0;
 
-	err = rdev_set_power_mgmt(rdev, dev, state, wdev->ps_timeout);
-	if (!err)
+	err = rdev_set_power_mgmt(rdev, dev, state, ps_timeout);
+	if (!err) {
 		wdev->ps = state;
+		wdev->ps_timeout = ps_timeout;
+	}
 	return err;
 }
 
@@ -8051,6 +8061,9 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 	if (nla_put_u32(msg, NL80211_ATTR_PS_STATE, ps_state))
 		goto nla_put_failure;
 
+	if (nla_put_s32(msg, NL80211_ATTR_PS_TIMEOUT, wdev->ps_timeout))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
 
-- 
1.8.3.1

