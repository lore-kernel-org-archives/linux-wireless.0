Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:54278 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbeILMgL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 08:36:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] netlink: add NLA_REJECT policy type
Date: Wed, 12 Sep 2018 09:32:45 +0200
Message-Id: <20180912073245.8047-1-johannes@sipsolutions.net> (sfid-20180912_093302_352983_7B175D9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In some situations some netlink attributes may be used for output
only (kernel->userspace) or may be reserved for future use. It's
then helpful to be able to prevent userspace from using them in
messages sent to the kernel, since they'd otherwise be ignored and
any future will become impossible if this happens.

Add NLA_REJECT to the policy which does nothing but reject (with
EINVAL) validation of any messages containing this attribute.

The specific case I have in mind now is a shared nested attribute
containing request/response data, and it would be pointless and
potentially confusing to have userspace include response data in
the messages that actually contain a request.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 1 +
 lib/nlattr.c          | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 0c154f98e987..ea7e87564f59 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -180,6 +180,7 @@ enum {
 	NLA_S32,
 	NLA_S64,
 	NLA_BITFIELD32,
+	NLA_REJECT,
 	__NLA_TYPE_MAX,
 };
 
diff --git a/lib/nlattr.c b/lib/nlattr.c
index e335bcafa9e4..4644ae74bf63 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -87,6 +87,9 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	}
 
 	switch (pt->type) {
+	case NLA_REJECT:
+		return -EINVAL;
+
 	case NLA_FLAG:
 		if (attrlen > 0)
 			return -ERANGE;
-- 
2.14.4
