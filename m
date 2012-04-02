Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2DBIwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 04:52:01 -0400
Message-ID: <1333356715.3498.0.camel@jlt3.sipsolutions.net> (sfid-20120402_105217_394550_4E95F0E1)
Subject: [PATCH 3.4] nl80211: ensure interface is up in various APIs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Date: Mon, 02 Apr 2012 10:51:55 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The nl80211 handling code should ensure as much as
it can that the interface is in a valid state, it
can certainly ensure the interface is running.

Not doing so can cause calls through mac80211 into
the driver that result in warnings and unspecified
behaviour in the driver.

Cc: stable@vger.kernel.org
Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/net/wireless/nl80211.c	2012-03-30 16:58:41.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-04-02 10:48:26.000000000 +0200
@@ -1294,6 +1294,11 @@ static int nl80211_set_wiphy(struct sk_b
 			goto bad_res;
 		}
 
+		if (!netif_running(netdev)) {
+			result = -ENETDOWN;
+			goto bad_res;
+		}
+
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
@@ -6384,7 +6389,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_get_key,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6416,7 +6421,7 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.doit = nl80211_set_beacon,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6424,7 +6429,7 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.doit = nl80211_start_ap,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6432,7 +6437,7 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.doit = nl80211_stop_ap,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6448,7 +6453,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_set_station,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6464,7 +6469,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_del_station,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6497,7 +6502,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_del_mpath,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6505,7 +6510,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_set_bss,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6531,7 +6536,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_get_mesh_config,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6664,7 +6669,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_setdel_pmksa,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6672,7 +6677,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_setdel_pmksa,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6680,7 +6685,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_flush_pmksa,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6840,7 +6845,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_probe_client,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{


