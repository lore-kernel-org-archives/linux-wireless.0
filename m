Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asia.telenet-ops.be ([195.130.137.74]:44760 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXICOG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 10:06:59 -0400
Message-ID: <46DC1500.7090808@telenet.be>
Date: Mon, 03 Sep 2007 16:06:56 +0200
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: letting drivers choose their preferred rate scale
References: <46CF95F9.6090802@telenet.be>	 <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be>	 <1188211749.6756.11.camel@johannes.berg>	 <20070831180933.GB3352@tuxdriver.com>  <46DB537E.8030801@telenet.be> <1188808692.14564.24.camel@johannes.berg>
In-Reply-To: <1188808692.14564.24.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
> On Mon, 2007-09-03 at 02:21 +0200, ian wrote:
> 
>> we could additionally remove the module_alias from rc80211_simple
> 
> indeed, please roll into this patch
> 
I don't know enough from debugfs yet, to do that part, but I'll read up.

---
Make rc80211_simple the default rate scaling algorithm

Signed-of-by: Ian Schram <ischram@telenet.be>
--- a/net/mac80211/ieee80211_rate.c	2007-09-03 01:26:18.000000000 +0200
+++ b/net/mac80211/ieee80211_rate.c	2007-09-03 01:46:54.000000000 +0200
@@ -62,7 +62,7 @@ ieee80211_try_rate_control_ops_get(const

 	mutex_lock(&rate_ctrl_mutex);
 	list_for_each_entry(alg, &rate_ctrl_algs, list) {
-		if (!name || !strcmp(alg->ops->name, name))
+		if (!strcmp(alg->ops->name, name))
 			if (try_module_get(alg->ops->module)) {
 				ops = alg->ops;
 				break;
@@ -78,11 +78,12 @@ static struct rate_control_ops *
 ieee80211_rate_control_ops_get(const char *name)
 {
 	struct rate_control_ops *ops;
+	const char *try_name = name ? name : "simple";

-	ops = ieee80211_try_rate_control_ops_get(name);
+	ops = ieee80211_try_rate_control_ops_get(try_name);
 	if (!ops) {
-		request_module("rc80211_%s", name ? name : "default");
-		ops = ieee80211_try_rate_control_ops_get(name);
+		request_module("rc80211_%s", try_name);
+		ops = ieee80211_try_rate_control_ops_get(try_name);
 	}
 	return ops;
 }
--- a/net/mac80211/rc80211_simple.c	2007-09-03 15:53:42.000000000 +0200
+++ b/net/mac80211/rc80211_simple.c	2007-09-03 15:54:40.000000000 +0200
@@ -29,7 +29,6 @@
 #define RATE_CONTROL_INTERVAL (HZ / 20)
 #define RATE_CONTROL_MIN_TX 10

-MODULE_ALIAS("rc80211_default");

 static void rate_control_rate_inc(struct ieee80211_local *local,
 				  struct sta_info *sta)


> johannes

